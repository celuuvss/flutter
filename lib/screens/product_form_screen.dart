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
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _productIdController,
                decoration: const InputDecoration(labelText: "Product ID"),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: "Nama Produk"),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: _categoryController,
                decoration: const InputDecoration(labelText: "Kategori"),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: _priceController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Harga Jual"),
                validator: (v) => v!.isEmpty ? "Wajib diisi" : null,
              ),
              TextFormField(
                controller: _costController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: "Harga Modal"),
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
                    final product = Product(
                      id: widget.product?.id ?? '',
                      productId: _productIdController.text,
                      name: _nameController.text,
                      category: _categoryController.text,
                      price: int.parse(_priceController.text),
                      cost: int.parse(_costController.text),
                      isActive: _isActive,
                      createdAt: DateTime.now(),
                    );

                    bool success = widget.product == null
                        ? await _api.createProduct(product)  // nanti ditambahkan di api_service
                        : await _api.updateProduct(widget.product!.id, product);

                    if (success) {
                      Navigator.pop(context, true);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Gagal menyimpan")));
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