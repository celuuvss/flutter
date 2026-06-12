import 'package:flutter/material.dart';
import '../models/material.dart';
import '../services/api_service.dart';
import 'material_form_screen.dart';

class MaterialsScreen extends StatefulWidget {
  const MaterialsScreen({super.key});

  @override
  State<MaterialsScreen> createState() => _MaterialsScreenState();
}

class _MaterialsScreenState extends State<MaterialsScreen> {
  final ApiService _api = ApiService();
  List<MaterialModel> materials = [];
  bool isLoading = false;

  // Daftar Cabang
  final List<String> branches = [
    'surabaya', 'jakarta', 'bandung', 'semarang', 'bekasi'
  ];

  @override
  void initState() {
    super.initState();
    _loadMaterials();
  }

  Future<void> _loadMaterials() async {
    setState(() => isLoading = true);
    try {
      materials = await _api.getMaterials();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal memuat data: $e"))
      );
    }
    setState(() => isLoading = false);
  }

  // Ganti Cabang
  void _changeBranch(String newBranch) {
    setState(() {
      _api.setBranch(newBranch);
    });
    _loadMaterials(); // Refresh data sesuai cabang
  }

  Future<void> _showForm([MaterialModel? material]) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => MaterialFormScreen(material: material)),
    );
    if (result == true) _loadMaterials();
  }

  Future<void> _deleteMaterial(MaterialModel material) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Hapus Material?"),
        content: Text("Yakin menghapus ${material.name}?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context, false), child: const Text("Batal")),
          TextButton(onPressed: () => Navigator.pop(context, true), child: const Text("Hapus", style: TextStyle(color: Colors.red))),
        ],
      ),
    );

    if (confirm == true) {
      final success = await _api.deleteMaterial(material.id);
      if (success) {
        _loadMaterials();
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("✅ Material dihapus"))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Material"),
        
        actions: [
          // Branch Selector
          PopupMenuButton<String>(
            icon: const Icon(Icons.location_city),
            tooltip: "Pilih Cabang",
            onSelected: _changeBranch,
            itemBuilder: (context) {
              return branches.map((branch) {
                final isSelected = _api.currentBranchName == branch;
                return PopupMenuItem(
                  value: branch,
                  child: Row(
                    children: [
                      Text(
                        branch.toUpperCase(),
                        style: TextStyle(
                          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                      ),
                      if (isSelected) const Icon(Icons.check, size: 18, color: Colors.green),
                    ],
                  ),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _loadMaterials,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : materials.isEmpty
                ? const Center(child: Text("Belum ada data material"))
                : ListView.builder(
                    itemCount: materials.length,
                    itemBuilder: (context, index) {
                      final mat = materials[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        child: ListTile(
                          leading: const CircleAvatar(
                            backgroundColor: Colors.purple,
                            child: Icon(Icons.inventory_2, color: Colors.white)
                          ),
                          title: Text(mat.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text("${mat.unit} • Rp ${mat.costPerUnit}/unit"),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.edit, color: Colors.blue),
                                onPressed: () => _showForm(mat)
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _deleteMaterial(mat)
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