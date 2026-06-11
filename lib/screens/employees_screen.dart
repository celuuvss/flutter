import 'package:flutter/material.dart';
import '../models/employee.dart';
import '../services/api_service.dart';
import 'employee_form_screen.dart';

class EmployeesScreen extends StatefulWidget {
  const EmployeesScreen({super.key});

  @override
  State<EmployeesScreen> createState() => _EmployeesScreenState();
}

class _EmployeesScreenState extends State<EmployeesScreen> {
  final ApiService _api = ApiService();
  
  List<Employee> employees = [];
  bool isLoading = false;
  String? searchQuery;
  String? selectedShift;

  // Daftar Cabang
  final List<String> branches = [
    'surabaya', 'jakarta', 'bandung', 'semarang', 'bekasi'
  ];

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    setState(() => isLoading = true);
    try {
      employees = await _api.getEmployees();
      
      // Filter di client-side
      if (searchQuery != null && searchQuery!.isNotEmpty) {
        final query = searchQuery!.toLowerCase();
        employees = employees.where((emp) =>
          (emp.name.toLowerCase().contains(query)) ||
          (emp.employeeId.toLowerCase().contains(query))
        ).toList();
      }

      if (selectedShift != null) {
        employees = employees.where((emp) => emp.shift == selectedShift).toList();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Gagal memuat data: $e")),
        );
      }
    } finally {
      if (mounted) {
        setState(() => isLoading = false);
      }
    }
  }

  // Ganti Cabang
  void _changeBranch(String newBranch) {
    setState(() {
      _api.setBranch(newBranch);
    });
    _loadEmployees();
  }

  Future<void> _showForm([Employee? employee]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EmployeeFormScreen(employee: employee)),
    );
    if (result == true && mounted) {
      _loadEmployees();
    }
  }

  Future<void> _deleteEmployee(Employee emp) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Karyawan?"),
        content: Text("Yakin menghapus ${emp.name}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true && mounted) {
      final success = await _api.deleteEmployee(emp.id);
      if (success && mounted) {
        _loadEmployees();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Karyawan dihapus"))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Karyawan"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          // Branch Selector
          PopupMenuButton<String>(
            icon: const Icon(Icons.location_city),
            tooltip: "Pilih Cabang",
            onSelected: _changeBranch,
            itemBuilder: (context) {
              return branches.map((branch) {
                final isSelected = _api.currentBranchName == branch;
                return PopupMenuItem(
                  value: branch,
                  child: Row(
                    children: [
                      Text(
                        branch.toUpperCase(),
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      if (isSelected) const Icon(Icons.check, size: 18, color: Colors.green),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadEmployees,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: "Cari nama atau ID...",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() => searchQuery = value.isEmpty ? null : value);
                        _loadEmployees();
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: DropdownButton<String?>(
                      value: selectedShift,
                      hint: const Text("Shift"),
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(value: null, child: Text("Semua")),
                        DropdownMenuItem(value: "pagi", child: Text("Pagi")),
                        DropdownMenuItem(value: "siang", child: Text("Siang")),
                        DropdownMenuItem(value: "malam", child: Text("Malam")),
                        DropdownMenuItem(value: "full_day", child: Text("Full Day")),
                      ],
                      onChanged: (value) {
                        setState(() => selectedShift = value);
                        _loadEmployees();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : employees.isEmpty
                      ? const Center(child: Text("Belum ada data karyawan"))
                      : ListView.builder(
                          itemCount: employees.length,
                          itemBuilder: (context, index) {
                            final emp = employees[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              child: ListTile(
                                leading: CircleAvatar(
                                  backgroundColor: Colors.blue.shade100,
                                  child: Text(
                                    emp.employeeId.length >= 3 
                                        ? emp.employeeId.substring(0, 3) 
                                        : emp.employeeId,
                                  ),
                                ),
                                title: Text(emp.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                                subtitle: Text("${emp.role} • ${emp.shift.toUpperCase()}"),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.blue),
                                      onPressed: () => _showForm(emp),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _deleteEmployee(emp),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}