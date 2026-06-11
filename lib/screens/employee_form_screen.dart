import 'package:flutter/material.dart';
import '../models/employee.dart';
import '../services/api_service.dart';

class EmployeeFormScreen extends StatefulWidget {
  final Employee? employee; // null jika tambah baru

  const EmployeeFormScreen({super.key, this.employee});

  @override
  State<EmployeeFormScreen> createState() => _EmployeeFormScreenState();
}

class _EmployeeFormScreenState extends State<EmployeeFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _api = ApiService();

  late TextEditingController _employeeIdController;
  late TextEditingController _nameController;
  late TextEditingController _roleController;
  late TextEditingController _salaryController;

  String _selectedShift = "full_day";

  @override
  void initState() {
    super.initState();
    _employeeIdController = TextEditingController(text: widget.employee?.employeeId);
    _nameController = TextEditingController(text: widget.employee?.name);
    _roleController = TextEditingController(text: widget.employee?.role);
    _salaryController = TextEditingController(text: widget.employee?.salary.toString());
    _selectedShift = widget.employee?.shift ?? "full_day";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.employee == null ? "Tambah Karyawan" : "Edit Karyawan"),
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
                backgroundColor: Colors.blue.shade100,
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
                color: Colors.blue.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.location_city, color: Colors.blue),
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
                controller: _employeeIdController,
                decoration: const InputDecoration(
                  labelText: "Employee ID (contoh: EMP008)",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Employee ID wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nama Lengkap",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Nama wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _roleController,
                decoration: const InputDecoration(
                  labelText: "Jabatan / Role",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Role wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                value: _selectedShift,
                decoration: const InputDecoration(
                  labelText: "Shift",
                  border: OutlineInputBorder(),
                ),
                items: const [
                  DropdownMenuItem(value: "pagi", child: Text("Pagi")),
                  DropdownMenuItem(value: "siang", child: Text("Siang")),
                  DropdownMenuItem(value: "malam", child: Text("Malam")),
                  DropdownMenuItem(value: "full_day", child: Text("Full Day")),
                ],
                onChanged: (value) {
                  setState(() => _selectedShift = value!);
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _salaryController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Gaji (Rp)",
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value!.isEmpty ? "Gaji wajib diisi" : null,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final employee = Employee(
                      id: widget.employee?.id ?? '',
                      employeeId: _employeeIdController.text.trim(),
                      name: _nameController.text.trim(),
                      role: _roleController.text.trim(),
                      shift: _selectedShift,
                      salary: int.parse(_salaryController.text),
                      createdAt: DateTime.now(),
                    );

                    bool success = widget.employee == null
                        ? await _api.createEmployee(employee)
                        : await _api.updateEmployee(widget.employee!.id, employee);

                    if (success) {
                      Navigator.pop(context, true);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("✅ Berhasil disimpan")),
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("❌ Gagal menyimpan data")),
                      );
                    }
                  }
                },
                child: Text(widget.employee == null ? "Tambahkan Karyawan" : "Simpan Perubahan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}