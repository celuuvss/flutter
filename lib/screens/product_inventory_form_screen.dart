import 'package:flutter/material.dart';
import '../models/product_inventory.dart';
import '../services/api_service.dart';

class ProductInventoryFormScreen extends StatefulWidget {
  final ProductInventory? inventory;

  const ProductInventoryFormScreen({super.key, this.inventory});

  @override
  State<ProductInventoryFormScreen> createState() =>
      _ProductInventoryFormScreenState();
}

class _ProductInventoryFormScreenState
    extends State<ProductInventoryFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final ApiService _api = ApiService();

  late TextEditingController _productIdController;
  late TextEditingController _productNameController;
  late TextEditingController _categoryController;
  late TextEditingController _stockQuantityController;
  late TextEditingController _sellingPriceController;
  late TextEditingController _minStockController;
  late TextEditingController _maxStockController;

  @override
  void initState() {
    super.initState();
    _productIdController = TextEditingController(
      text: widget.inventory?.productId,
    );
    _productNameController = TextEditingController(
      text: widget.inventory?.productName,
    );
    _categoryController = TextEditingController(
      text: widget.inventory?.category,
    );
    _stockQuantityController = TextEditingController(
      text: widget.inventory?.stockQuantity.toString(),
    );
    _sellingPriceController = TextEditingController(
      text: widget.inventory?.sellingPrice.toString(),
    );
    _minStockController = TextEditingController(
      text: widget.inventory?.minStock.toString(),
    );
    _maxStockController = TextEditingController(
      text: widget.inventory?.maxStock.toString(),
    );
  }

  @override
  void dispose() {
    _productIdController.dispose();
    _productNameController.dispose();
    _categoryController.dispose();
    _stockQuantityController.dispose();
    _sellingPriceController.dispose();
    _minStockController.dispose();
    _maxStockController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.inventory == null
              ? "Tambah Inventori Produk"
              : "Edit Inventori Produk",
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

              // Product ID
              TextFormField(
                controller: _productIdController,
                decoration: const InputDecoration(
                  labelText: "Product ID",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.tag),
                ),
                validator: (v) => v!.isEmpty ? "Product ID wajib diisi" : null,
              ),
              const SizedBox(height: 12),

              // Nama Produk
              TextFormField(
                controller: _productNameController,
                decoration: const InputDecoration(
                  labelText: "Nama Produk",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.shopping_bag),
                ),
                validator: (v) => v!.isEmpty ? "Nama Produk wajib diisi" : null,
              ),
              const SizedBox(height: 12),

              // Kategori
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(
                  labelText: "Kategori",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                validator: (v) => v!.isEmpty ? "Kategori wajib diisi" : null,
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

              // Harga Jual
              TextFormField(
                controller: _sellingPriceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: "Harga Jual (Rp)",
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.money),
                ),
                validator: (v) => v!.isEmpty
                    ? "Harga Jual wajib diisi"
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
              const SizedBox(height: 30),

              // Tombol Simpan
              ElevatedButton.icon(
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    final inventory = ProductInventory(
                      id: widget.inventory?.id,
                      productId: _productIdController.text.trim(),
                      productName: _productNameController.text.trim(),
                      category: _categoryController.text.trim(),
                      stockQuantity: int.parse(_stockQuantityController.text),
                      sellingPrice: int.parse(_sellingPriceController.text),
                      minStock: int.parse(_minStockController.text),
                      maxStock: int.parse(_maxStockController.text),
                      createdAt: widget.inventory?.createdAt ?? DateTime.now(),
                      updatedAt: DateTime.now(),
                    );

                    bool success = widget.inventory == null
                        ? await _api.createProductInventory(inventory)
                        : await _api.updateProductInventory(
                            widget.inventory!.id ?? '',
                            inventory,
                          );

                    if (mounted) {
                      if (success) {
                        Navigator.pop(context, true);
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              "✅ Inventori Produk berhasil disimpan",
                            ),
                            backgroundColor: Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text("❌ Gagal menyimpan inventori produk"),
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
