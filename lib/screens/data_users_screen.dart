// lib/screens/data_users_screen.dart
import 'package:flutter/material.dart';
import '../models/employee.dart';
import '../services/api_service.dart';
import 'employee_form_screen.dart';

class DataUsersScreen extends StatefulWidget {
  const DataUsersScreen({super.key});

  @override
  State<DataUsersScreen> createState() => _DataUsersScreenState();
}

class _DataUsersScreenState extends State<DataUsersScreen> {
  final ApiService _api = ApiService();
  List<Employee> employees = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadEmployees();
  }

  Future<void> _loadEmployees() async {
    setState(() => isLoading = true);
    try {
      final data = await _api.getEmployees();
      setState(() {
        employees = data;
      });
      print("✅ Berhasil load ${data.length} karyawan");
    } catch (e) {
      print("❌ Error load: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat data: $e")),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  // Fungsi untuk tambah/edit/delete
  Future<void> _showForm([Employee? employee]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => EmployeeFormScreen(employee: employee),
      ),
    );

    if (result == true) {
      _loadEmployees();   // Refresh otomatis setelah tambah/edit
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
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Hapus", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      final success = await _api.deleteEmployee(emp.id);
      if (success) {
        _loadEmployees();
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Karyawan dihapus")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Users"),
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: _loadEmployees),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadEmployees,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : employees.isEmpty
                ? const Center(child: Text("Belum ada data"))
                : ListView.builder(
                    itemCount: employees.length,
                    itemBuilder: (context, index) {
                      final emp = employees[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                        child: ListTile(
                          leading: CircleAvatar(child: Text(emp.employeeId)),
                          title: Text(emp.name),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showForm(),
        child: const Icon(Icons.add),
      ),
    );
  }
}