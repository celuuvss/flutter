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
        actions: [
          // Tampilkan cabang saat ini
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Chip(
                label: Text(
                  _api.currentBranchName.toUpperCase(),
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                ),
                backgroundColor: Colors.orange.shade100,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // Info Cabang
              Card(
                color: Colors.orange.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.location_city, color: Colors.orange),
                      const SizedBox(width: 8),
                      Text(
                        "Cabang: ${_api.currentBranchName.toUpperCase()}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _expenseIdController,
                decoration: const InputDecoration(
                  labelText: "Expense ID",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _typeController,
                decoration: const InputDecoration(
                  labelText: "Jenis Pengeluaran (listrik, gaji, dll)",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Jumlah (Rp)",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _descriptionController,
                decoration: const InputDecoration(
                  labelText: "Deskripsi",
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _referenceController,
                decoration: const InputDecoration(
                  labelText: "Reference (opsional)",
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
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
                  if (picked != null) {
                    setState(() => _selectedDate = picked);
                  }
                },
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final expense = Expense(
                      id: widget.expense?.id ?? '',
                      expenseId: _expenseIdController.text.trim(),
                      type: _typeController.text.trim(),
                      amount: int.parse(_amountController.text),
                      date: _selectedDate,
                      description: _descriptionController.text.trim(),
                      reference: _referenceController.text.trim(),
                    );

                    bool success = widget.expense == null
                        ? await _api.createExpense(expense)
                        : true; // TODO: Tambahkan updateExpense nanti di ApiService

                    if (success) {
                      Navigator.pop(context, true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("✅ Berhasil disimpan")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("❌ Gagal menyimpan")),
                      );
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