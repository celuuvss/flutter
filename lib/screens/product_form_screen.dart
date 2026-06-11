import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductFormScreen extends StatefulWidget {
  final Product? product;

  const ProductFormScreen({super.key, this.product});

  @override
  State<ProductFormScreen> createState() => _ProductFormScreenState();
}

class _ProductFormScreenState extends State<ProductFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _api = ApiService();

  late TextEditingController _productIdController;
  late TextEditingController _nameController;
  late TextEditingController _categoryController;
  late TextEditingController _priceController;
  late TextEditingController _costController;

  bool _isActive = true;

  @override
  void initState() {
    super.initState();
    _productIdController = TextEditingController(text: widget.product?.productId);
    _nameController = TextEditingController(text: widget.product?.name);
    _categoryController = TextEditingController(text: widget.product?.category);
    _priceController = TextEditingController(text: widget.product?.price.toString());
    _costController = TextEditingController(text: widget.product?.cost.toString());
    _isActive = widget.product?.isActive ?? true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.product == null ? "Tambah Produk" : "Edit Produk"),
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
                controller: _productIdController,
                decoration: const InputDecoration(
                  labelText: "Product ID",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: "Nama Produk",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: "Kategori",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Harga Jual (Rp)",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _costController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Harga Modal (Rp)",
                  border: OutlineInputBorder(),
                ),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              const SizedBox(height: 12),
              SwitchListTile(
                title: const Text("Status Aktif"),
                value: _isActive,
                onChanged: (val) => setState(() => _isActive = val),
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final product = Product(
                      id: widget.product?.id ?? '',
                      productId: _productIdController.text.trim(),
                      name: _nameController.text.trim(),
                      category: _categoryController.text.trim(),
                      price: int.parse(_priceController.text),
                      cost: int.parse(_costController.text),
                      isActive: _isActive,
                      createdAt: DateTime.now(),
                    );

                    bool success = widget.product == null
                        ? await _api.createProduct(product)
                        : await _api.updateProduct(widget.product!.id, product);

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
                child: Text(widget.product == null ? "Tambahkan Produk" : "Simpan Perubahan"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}