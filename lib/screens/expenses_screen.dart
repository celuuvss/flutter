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

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  Future<void> _loadExpenses() async {
    setState(() => isLoading = true);
    try {
      expenses = await _api.getExpenses();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Gagal: $e")));
    }
    setState(() => isLoading = false);
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
      if (success) _loadExpenses();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pengeluaran"),
        leading: IconButton(icon: const Icon(Icons.arrow_back), onPressed: () => Navigator.pop(context)),
      ),
      body: RefreshIndicator(
        onRefresh: _loadExpenses,
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
                          leading: const CircleAvatar(backgroundColor: Colors.red, child: Icon(Icons.money_off, color: Colors.white)),
                          title: Text(exp.description),
                          subtitle: Text("${exp.type} • ${exp.reference ?? '-'}"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(icon: const Icon(Icons.edit, color: Colors.blue), onPressed: () => _showForm(exp)),
                              IconButton(icon: const Icon(Icons.delete, color: Colors.red), onPressed: () => _deleteExpense(exp)),
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