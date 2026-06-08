import 'package:flutter/material.dart';
import '../models/expense.dart';
import '../services/api_service.dart';

class ExpenseFormScreen extends StatefulWidget {
  final Expense? expense;

  const ExpenseFormScreen({super.key, this.expense});

  @override
  State<ExpenseFormScreen> createState() => _ExpenseFormScreenState();
}

class _ExpenseFormScreenState extends State<ExpenseFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _api = ApiService();

  late TextEditingController _expenseIdController;
  late TextEditingController _typeController;
  late TextEditingController _amountController;
  late TextEditingController _descriptionController;
  late TextEditingController _referenceController;

  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();
    _expenseIdController = TextEditingController(text: widget.expense?.expenseId);
    _typeController = TextEditingController(text: widget.expense?.type);
    _amountController = TextEditingController(text: widget.expense?.amount.toString());
    _descriptionController = TextEditingController(text: widget.expense?.description);
    _referenceController = TextEditingController(text: widget.expense?.reference);
    _selectedDate = widget.expense?.date ?? DateTime.now();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.expense == null ? "Tambah Pengeluaran" : "Edit Pengeluaran"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _expenseIdController,
                decoration: const InputDecoration(labelText: "Expense ID"),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(labelText: "Jenis Pengeluaran (listrik, gaji, dll)"),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Jumlah (Rp)"),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(labelText: "Deskripsi"),
                maxLines: 2,
              ),
              TextFormField(
                controller: _referenceController,
                decoration: const InputDecoration(labelText: "Reference (opsional)"),
              ),
              ListTile(
                title: const Text("Tanggal"),
                subtitle: Text("${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}"),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: _selectedDate,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );
                  if (picked != null) setState(() => _selectedDate = picked);
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final expense = Expense(
                      id: widget.expense?.id ?? '',
                      expenseId: _expenseIdController.text,
                      type: _typeController.text,
                      amount: int.parse(_amountController.text),
                      date: _selectedDate,
                      description: _descriptionController.text,
                      reference: _referenceController.text,
                    );

                    bool success = widget.expense == null
                        ? await _api.createExpense(expense)
                        : true; // update nanti

                    if (success) {
                      Navigator.pop(context, true);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal menyimpan")));
                    }
                  }
                },
                child: Text(widget.expense == null ? "Tambahkan Pengeluaran" : "Simpan Perubahan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}