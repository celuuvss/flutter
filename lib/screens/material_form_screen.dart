import 'package:flutter/material.dart';
import '../models/material.dart';
import '../services/api_service.dart';

class MaterialFormScreen extends StatefulWidget {
  final MaterialModel? material;

  const MaterialFormScreen({super.key, this.material});

  @override
  State<MaterialFormScreen> createState() => _MaterialFormScreenState();
}

class _MaterialFormScreenState extends State<MaterialFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _api = ApiService();

  late TextEditingController _materialIdController;
  late TextEditingController _nameController;
  late TextEditingController _unitController;
  late TextEditingController _costController;

  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _materialIdController = TextEditingController(text: widget.material?.materialId);
    _nameController = TextEditingController(text: widget.material?.name);
    _unitController = TextEditingController(text: widget.material?.unit);
    _costController = TextEditingController(text: widget.material?.costPerUnit.toString());
    _isActive = widget.material?.isActive ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.material == null ? "Tambah Material" : "Edit Material"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _materialIdController,
                decoration: const InputDecoration(labelText: "Material ID"),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nama Material"),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: _unitController,
                decoration: const InputDecoration(labelText: "Satuan (kg, pcs, liter, dll)"),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: _costController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Harga per Unit (Rp)"),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              SwitchListTile(
                title: const Text("Status Aktif"),
                value: _isActive,
                onChanged: (val) => setState(() => _isActive = val),
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final material = MaterialModel(
                      id: widget.material?.id ?? '',
                      materialId: _materialIdController.text.trim(),
                      name: _nameController.text.trim(),
                      unit: _unitController.text.trim(),
                      costPerUnit: int.parse(_costController.text),
                      isActive: _isActive,
                      createdAt: DateTime.now(),
                    );

                    bool success;

                    if (widget.material == null) {
                      // Tambah baru
                      success = await _api.createMaterial(material);
                    } else {
                      // Edit
                      success = await _api.updateMaterial(widget.material!.id, material);
                    }

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
                child: Text(widget.material == null ? "Tambahkan Material" : "Simpan Perubahan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}