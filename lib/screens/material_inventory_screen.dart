import 'package:flutter/material.dart';
import '../models/material_inventory.dart';
import '../services/api_service.dart';
import 'material_inventory_form_screen.dart';

class MaterialInventoryScreen extends StatefulWidget {
  const MaterialInventoryScreen({super.key});

  @override
  State<MaterialInventoryScreen> createState() =>
      _MaterialInventoryScreenState();
}

class _MaterialInventoryScreenState extends State<MaterialInventoryScreen> {
  final ApiService _api = ApiService();
  List<MaterialInventory> inventories = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _loadInventories();
  }

  Future<void> _loadInventories() async {
    setState(() => isLoading = true);
    try {
      inventories = await _api.getMaterialInventories();
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Gagal memuat data: $e")));
    }
    setState(() => isLoading = false);
  }

  Future<void> _showForm([MaterialInventory? inventory]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MaterialInventoryFormScreen(inventory: inventory),
      ),
    );
    if (result == true) _loadInventories();
  }

  Future<void> _deleteInventory(MaterialInventory inventory) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Inventori Material?"),
        content: Text("Yakin menghapus inventori ${inventory.materialName}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Batal"),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Hapus", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      final success = await _api.deleteMaterialInventory(inventory.id ?? '');
      if (success) {
        _loadInventories();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Inventori Material dihapus")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Inventori Material"),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: _loadInventories,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : inventories.isEmpty
            ? const Center(child: Text("Belum ada data inventori material"))
            : ListView.builder(
                itemCount: inventories.length,
                itemBuilder: (context, index) {
                  final inv = inventories[index];
                  final isLowStock = inv.stockQuantity <= inv.minStock;

                  return Card(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    color: isLowStock ? Colors.red.shade50 : null,
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: isLowStock ? Colors.red : Colors.green,
                        child: Icon(
                          isLowStock ? Icons.warning : Icons.archive,
                          color: Colors.white,
                        ),
                      ),
                      title: Text(
                        inv.materialName,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("${inv.unit} • ${inv.supplier}"),
                          Text(
                            "Stok: ${inv.stockQuantity} (Min: ${inv.minStock})",
                            style: TextStyle(
                              color: isLowStock ? Colors.red : Colors.grey,
                              fontWeight: isLowStock
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () => _showForm(inv),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteInventory(inv),
                          ),
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
