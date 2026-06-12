import 'package:flutter/material.dart';
import 'screens/employees_screen.dart';
import 'screens/products_screen.dart';
import 'screens/product_inventory_screen.dart';
import 'screens/material_inventory_screen.dart';
import 'screens/materials_screen.dart';
import 'services/api_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Sistem Roti Kuasong',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.brown, useMaterial3: true),
      home: const BranchSelectionScreen(),
    );
  }
}

// ==================== PILIH CABANG ====================
class BranchSelectionScreen extends StatefulWidget {
  const BranchSelectionScreen({super.key});

  @override
  State<BranchSelectionScreen> createState() => _BranchSelectionScreenState();
}

class _BranchSelectionScreenState extends State<BranchSelectionScreen> {
  final ApiService api = ApiService();

  final List<Map<String, dynamic>> branches = [
    {
      "name": "Surabaya",
      "location": "Surabaya, Jawa Timur",
      "color": Colors.blue,
    },
    {"name": "Jakarta", "location": "Jakarta Pusat", "color": Colors.green},
    {
      "name": "Bandung",
      "location": "Bandung, Jawa Barat",
      "color": Colors.orange,
    },
    {
      "name": "Semarang",
      "location": "Semarang, Jawa Tengah",
      "color": Colors.purple,
    },
    {"name": "Bekasi", "location": "Bekasi, Jawa Barat", "color": Colors.teal},
  ];

  void _selectBranch(String branchName) {
    api.setBranch(branchName);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sistem Roti Kuasong'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Pilih Cabang",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Silakan pilih cabang yang akan dikelola",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.builder(
                itemCount: branches.length,
                itemBuilder: (context, index) {
                  final b = branches[index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      leading: CircleAvatar(
                        backgroundColor: (b['color'] as Color).withOpacity(0.1),
                        child: Icon(
                          Icons.location_city,
                          color: b['color'] as Color,
                          size: 32,
                        ),
                      ),
                      title: Text(
                        "Cabang ${b['name']}",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(b['location']),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => _selectBranch(b['name']),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ==================== HOME SCREEN ====================
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  final ApiService _api = ApiService();

  final List<Widget> _screens = [
    const EmployeesScreen(),
    const ProductsScreen(),
    const ProductInventoryScreen(),
    const MaterialInventoryScreen(),
    const MaterialsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Cabang ${_api.currentBranchName.toUpperCase()}"),

        leadingWidth: 110,
        leading: Center(
          child: InkWell(
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => const BranchSelectionScreen(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.brown),
                borderRadius: BorderRadius.circular(6),
                color: Colors.white,
              ),
              child: const Text(
                "Ganti Cabang",
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.brown,
                ),
              ),
            ),
          ),
        ),
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Colors.brown,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Karyawan"),
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: "Produk",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.inventory),
            label: "Inv. Produk",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.archive),
            label: "Inv. Material",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.warehouse),
            label: "Material",
          ),
        ],
      ),
    );
  }
}
