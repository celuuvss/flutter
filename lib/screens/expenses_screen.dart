import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/api_service.dart';
import 'expense_form_screen.dart';

class ExpensesScreen extends StatefulWidget {
  const ExpensesScreen({super.key});

  @override
  State<ExpensesScreen> createState() => _ExpensesScreenState();
}

class _ExpensesScreenState extends State<ExpensesScreen> {
  final ApiService _api = ApiService();
  List<Expense> expenses = [];
  bool isLoading = false;
  String? searchQuery;
  String? selectedType;

  // Daftar Cabang
  final List<String> branches = [
    'surabaya', 'jakarta', 'bandung', 'semarang', 'bekasi'
  ];

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    setState(() => isLoading = true);
    try {
      expenses = await _api.getExpenses();

      // Client-side filtering: search by description or expenseId
      if (searchQuery != null && searchQuery!.isNotEmpty) {
        final q = searchQuery!.toLowerCase();
        expenses = expenses.where((e) =>
          e.description.toLowerCase().contains(q) ||
          e.expenseId.toLowerCase().contains(q)
        ).toList();
      }

      // Filter by type if selected
      if (selectedType != null) {
        expenses = expenses.where((e) => e.type == selectedType).toList();
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat data: $e"))
      );
    }
    setState(() => isLoading = false);
  }

  // Ganti Cabang
  void _changeBranch(String newBranch) {
    setState(() {
      _api.setBranch(newBranch);
    });
    _loadExpenses(); // Refresh data
  }

  Future<void> _showForm([Expense? expense]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ExpenseFormScreen(expense: expense)),
    );
    if (result == true) _loadExpenses();
  }

  Future<void> _deleteExpense(Expense expense) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Pengeluaran?"),
        content: Text("Yakin menghapus ${expense.description}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Hapus", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      final success = await _api.deleteExpense(expense.id);
      if (success) {
        _loadExpenses();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Pengeluaran dihapus"))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengeluaran"),
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
        onRefresh: _loadExpenses,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        hintText: "Cari deskripsi atau ID...",
                        prefixIcon: Icon(Icons.search),
                        border: OutlineInputBorder(),
                      ),
                      onChanged: (value) {
                        setState(() => searchQuery = value.isEmpty ? null : value);
                        _loadExpenses();
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
                      value: selectedType,
                      hint: const Text("Tipe"),
                      underline: const SizedBox(),
                      items: const [
                        DropdownMenuItem(value: null, child: Text("Semua")),
                        DropdownMenuItem(value: "pembelian", child: Text("Pembelian")),
                        DropdownMenuItem(value: "operasional", child: Text("Operasional")),
                        DropdownMenuItem(value: "gaji", child: Text("Gaji")),
                        DropdownMenuItem(value: "lainnya", child: Text("Lainnya")),
                      ],
                      onChanged: (value) {
                        setState(() => selectedType = value);
                        _loadExpenses();
                      },
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : expenses.isEmpty
                      ? const Center(child: Text("Belum ada data pengeluaran"))
                      : ListView.builder(
                          itemCount: expenses.length,
                          itemBuilder: (context, index) {
                            final exp = expenses[index];
                            return Card(
                              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                              child: ListTile(
                                leading: const CircleAvatar(
                                    backgroundColor: Colors.red,
                                    child: Icon(Icons.money_off, color: Colors.white)
                                ),
                                title: Text(exp.description),
                                subtitle: Text("${exp.type} • ${exp.reference ?? '-'}"),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                        icon: const Icon(Icons.edit, color: Colors.blue),
                                        onPressed: () => _showForm(exp)
                                    ),
                                    IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red),
                                        onPressed: () => _deleteExpense(exp)
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