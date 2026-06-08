import 'package:flutter/material.dart';
import 'screens/employees_screen.dart';
import 'screens/products_screen.dart';
import 'screens/expenses_screen.dart';
import 'screens/materials_screen.dart';

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
      theme: ThemeData(
        primarySwatch: Colors.brown,
        useMaterial3: true,
      ),
      home: const BranchSelectionScreen(),
    );
  }
}

// ==================== HALAMAN PILIH CABANG ====================
class BranchSelectionScreen extends StatelessWidget {
  const BranchSelectionScreen({super.key});

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
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              "Silakan pilih cabang yang akan dikelola",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 24),

            // Daftar Cabang
            Expanded(
              child: ListView(
                children: [
                  _buildBranchCard(
                    context,
                    "Cabang Surabaya",
                    "Surabaya, Jawa Timur",
                    Icons.location_city,
                    Colors.blue,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const MainBranchScreen()),
                    ),
                  ),
                  _buildBranchCard(
                    context,
                    "Cabang Jakarta",
                    "Jakarta Pusat",
                    Icons.location_city,
                    Colors.green,
                    () => _showComingSoon(context),
                  ),
                  _buildBranchCard(
                    context,
                    "Cabang Bandung",
                    "Bandung, Jawa Barat",
                    Icons.location_city,
                    Colors.orange,
                    () => _showComingSoon(context),
                  ),
                  _buildBranchCard(
                    context,
                    "Cabang Semarang",
                    "Semarang, Jawa Tengah",
                    Icons.location_city,
                    Colors.purple,
                    () => _showComingSoon(context),
                  ),
                  _buildBranchCard(
                    context,
                    "Cabang Bekasi",
                    "Bekasi, Jawa Barat",
                    Icons.location_city,
                    Colors.teal,
                    () => _showComingSoon(context),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBranchCard(BuildContext context, String title, String subtitle,
      IconData icon, Color color, VoidCallback onTap) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.1),
          child: Icon(icon, color: color, size: 30),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        subtitle: Text(subtitle),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: onTap,
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Fitur Cabang ini sedang dalam pengembangan")),
    );
  }
}

// ==================== MAIN BRANCH SCREEN (Surabaya) ====================
class MainBranchScreen extends StatelessWidget {
  const MainBranchScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cabang Surabaya"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: const Center(
        child: Text(
          "Selamat datang di\nCabang Surabaya",
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 22),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: 0,
        onTap: (index) {
          // Navigasi antar screen
          if (index == 0) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const EmployeesScreen()));
          } else if (index == 1) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ProductsScreen()));
          } else if (index == 2) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const ExpensesScreen()));
          } else if (index == 3) {
            Navigator.push(context, MaterialPageRoute(builder: (_) => const MaterialsScreen()));
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Karyawan"),
          BottomNavigationBarItem(icon: Icon(Icons.inventory), label: "Produk"),
          BottomNavigationBarItem(icon: Icon(Icons.money_off), label: "Pengeluaran"),
          BottomNavigationBarItem(icon: Icon(Icons.warehouse), label: "Material"),
        ],
      ),
    );
  }
}