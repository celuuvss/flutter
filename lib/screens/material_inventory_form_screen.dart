import 'package:flutter/material.dart';
import '../models/material_inventory.dart';
import '../services/api_service.dart';

class MaterialInventoryFormScreen extends StatefulWidget {
  final MaterialInventory? inventory;

  const MaterialInventoryFormScreen({super.key, this.inventory});

  @override
  State<MaterialInventoryFormScreen> createState() =>
      _MaterialInventoryFormScreenState();
}

class _MaterialInventoryFormScreenState
    extends State<MaterialInventoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _api = ApiService();

  late TextEditingController _materialIdController;
  late TextEditingController _materialNameController;
  late TextEditingController _unitController;
  late TextEditingController _stockQuantityController;
  late TextEditingController _minStockController;
  late TextEditingController _maxStockController;
  late TextEditingController _supplierController;

  @override
  void initState() {
    super.initState();
    _materialIdController = TextEditingController(
      text: widget.inventory?.materialId,
    );
    _materialNameController = TextEditingController(
      text: widget.inventory?.materialName,
    );
    _unitController = TextEditingController(text: widget.inventory?.unit);
    _stockQuantityController = TextEditingController(
      text: widget.inventory?.stockQuantity.toString(),
    );
    _minStockController = TextEditingController(
      text: widget.inventory?.minStock.toString(),
    );
    _maxStockController = TextEditingController(
      text: widget.inventory?.maxStock.toString(),
    );
    _supplierController = TextEditingController(
      text: widget.inventory?.supplier,
    );
  }

  @override
  void dispose() {
    _materialIdController.dispose();
    _materialNameController.dispose();
    _unitController.dispose();
    _stockQuantityController.dispose();
    _minStockController.dispose();
    _maxStockController.dispose();
    _supplierController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.inventory == null
              ? "Tambah Inventori Material"
              : "Edit Inventori Material",
        ),
        actions: [
          // Tampilkan cabang saat ini
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Chip(
                label: Text(
                  _api.currentBranchName.toUpperCase(),
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                backgroundColor: Colors.green.shade100,
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
                color: Colors.green.shade50,
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Icon(Icons.location_city, color: Colors.green),
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

              // Material ID
              TextFormField(
                controller: _materialIdController,
                decoration: const InputDecoration(
                  labelText: "Material ID",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.tag),
                ),
                validator: (v) => v!.isEmpty ? "Material ID wajib diisi" : null,
              ),
              const SizedBox(height: 12),

              // Nama Material
              TextFormField(
                controller: _materialNameController,
                decoration: const InputDecoration(
                  labelText: "Nama Material",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.archive),
                ),
                validator: (v) =>
                    v!.isEmpty ? "Nama Material wajib diisi" : null,
              ),
              const SizedBox(height: 12),

              // Unit
              TextFormField(
                controller: _unitController,
                decoration: const InputDecoration(
                  labelText: "Unit (kg, liter, pcs, dll)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.scale),
                ),
                validator: (v) => v!.isEmpty ? "Unit wajib diisi" : null,
              ),
              const SizedBox(height: 12),

              // Stok Saat Ini
              TextFormField(
                controller: _stockQuantityController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Stok Saat Ini",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.inventory),
                ),
                validator: (v) => v!.isEmpty
                    ? "Stok Saat Ini wajib diisi"
                    : (int.tryParse(v) == null ? "Harus angka" : null),
              ),
              const SizedBox(height: 12),

              // Minimum Stok
              TextFormField(
                controller: _minStockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Minimum Stok",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.warning),
                ),
                validator: (v) => v!.isEmpty
                    ? "Minimum Stok wajib diisi"
                    : (int.tryParse(v) == null ? "Harus angka" : null),
              ),
              const SizedBox(height: 12),

              // Maksimum Stok
              TextFormField(
                controller: _maxStockController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Maksimum Stok",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.check_circle),
                ),
                validator: (v) => v!.isEmpty
                    ? "Maksimum Stok wajib diisi"
                    : (int.tryParse(v) == null ? "Harus angka" : null),
              ),
              const SizedBox(height: 12),

              // Supplier
              TextFormField(
                controller: _supplierController,
                decoration: const InputDecoration(
                  labelText: "Supplier",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.local_shipping),
                ),
                validator: (v) => v!.isEmpty ? "Supplier wajib diisi" : null,
              ),
              const SizedBox(height: 30),

              // Tombol Simpan
              ElevatedButton.icon(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final inventory = MaterialInventory(
                      id: widget.inventory?.id,
                      materialId: _materialIdController.text.trim(),
                      materialName: _materialNameController.text.trim(),
                      unit: _unitController.text.trim(),
                      stockQuantity: int.parse(_stockQuantityController.text),
                      minStock: int.parse(_minStockController.text),
                      maxStock: int.parse(_maxStockController.text),
                      supplier: _supplierController.text.trim(),
                      createdAt: widget.inventory?.createdAt ?? DateTime.now(),
                      updatedAt: DateTime.now(),
                    );

                    bool success = widget.inventory == null
                        ? await _api.createMaterialInventory(inventory)
                        : await _api.updateMaterialInventory(
                            widget.inventory!.id ?? '',
                            inventory,
                          );

                    if (mounted) {
                      if (success) {
                        Navigator.pop(context, true);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "✅ Inventori Material berhasil disimpan",
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "❌ Gagal menyimpan inventori material",
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  }
                },
                icon: const Icon(Icons.save),
                label: Text(
                  widget.inventory == null
                      ? "Tambahkan Inventori"
                      : "Simpan Perubahan",
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
