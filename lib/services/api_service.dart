import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/employee.dart';
import '../models/product.dart';
import '../models/expense.dart';
import '../models/material.dart';

class ApiService {
  // ==================== SINGLETON ====================
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal();

  static const String baseUrl = "http://192.168.0.101:5000";

  String currentBranch = "surabaya";

  // ==================== BRANCH MANAGEMENT ====================
  void setBranch(String branch) {
    currentBranch = branch.toLowerCase();
    print("🔄 Branch diubah menjadi: $currentBranch");
  }

  String get currentBranchName => currentBranch;

  Uri _buildUri(String endpoint) {
    return Uri.parse("$baseUrl/api/$endpoint?branch=$currentBranch");
  }

  // ==================== EMPLOYEES ====================
  Future<List<Employee>> getEmployees() async {
    final res = await http.get(_buildUri("employees"), headers: {'x-branch': currentBranch});
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      return (data['data'] as List).map((e) => Employee.fromJson(e)).toList();
    }
    throw Exception("Gagal mengambil karyawan");
  }

  Future<bool> createEmployee(Employee emp) async {
    final body = emp.toJson();
    body['branch'] = currentBranch;
    final res = await http.post(_buildUri("employees"),
        headers: {"Content-Type": "application/json", 'x-branch': currentBranch},
        body: json.encode(body));
    return res.statusCode == 201 || res.statusCode == 200;
  }

  Future<bool> updateEmployee(String id, Employee emp) async {
    final res = await http.put(_buildUri("employees/$id"),
        headers: {"Content-Type": "application/json", 'x-branch': currentBranch},
        body: json.encode(emp.toJson()));
    return res.statusCode == 200;
  }

  Future<bool> deleteEmployee(String id) async {
    final res = await http.delete(_buildUri("employees/$id"),
        headers: {'x-branch': currentBranch});
    return res.statusCode == 200;
  }

  // ==================== PRODUCTS ====================
  Future<List<Product>> getProducts() async {
    final res = await http.get(_buildUri("products"), headers: {'x-branch': currentBranch});
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      return (data['data'] as List).map((e) => Product.fromJson(e)).toList();
    }
    throw Exception("Gagal mengambil produk");
  }

  Future<bool> createProduct(Product product) async {
    final body = product.toJson();
    body['branch'] = currentBranch;
    final res = await http.post(_buildUri("products"),
        headers: {"Content-Type": "application/json", 'x-branch': currentBranch},
        body: json.encode(body));
    return res.statusCode == 201 || res.statusCode == 200;
  }

  Future<bool> updateProduct(String id, Product product) async {
    final res = await http.put(_buildUri("products/$id"),
        headers: {"Content-Type": "application/json", 'x-branch': currentBranch},
        body: json.encode(product.toJson()));
    return res.statusCode == 200;
  }

  Future<bool> deleteProduct(String id) async {
    final res = await http.delete(_buildUri("products/$id"),
        headers: {'x-branch': currentBranch});
    return res.statusCode == 200;
  }

  // ==================== EXPENSES ====================
  Future<List<Expense>> getExpenses() async {
    final res = await http.get(_buildUri("expenses"), headers: {'x-branch': currentBranch});
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      return (data['data'] as List).map((e) => Expense.fromJson(e)).toList();
    }
    throw Exception("Gagal mengambil pengeluaran");
  }

  Future<bool> createExpense(Expense expense) async {
    final body = expense.toJson();
    body['branch'] = currentBranch;
    final res = await http.post(_buildUri("expenses"),
        headers: {"Content-Type": "application/json", 'x-branch': currentBranch},
        body: json.encode(body));
    return res.statusCode == 201 || res.statusCode == 200;
  }

  Future<bool> deleteExpense(String id) async {
    final res = await http.delete(_buildUri("expenses/$id"),
        headers: {'x-branch': currentBranch});
    return res.statusCode == 200;
  }

  // ==================== MATERIALS ====================
  Future<List<MaterialModel>> getMaterials() async {
    final res = await http.get(_buildUri("materials"), headers: {'x-branch': currentBranch});
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      return (data['data'] as List).map((e) => MaterialModel.fromJson(e)).toList();
    }
    throw Exception("Gagal mengambil material");
  }

  Future<bool> createMaterial(MaterialModel material) async {
    final body = material.toJson();
    body['branch'] = currentBranch;
    final res = await http.post(_buildUri("materials"),
        headers: {"Content-Type": "application/json", 'x-branch': currentBranch},
        body: json.encode(body));
    return res.statusCode == 201 || res.statusCode == 200;
  }

  Future<bool> updateMaterial(String id, MaterialModel material) async {
    final res = await http.put(_buildUri("materials/$id"),
        headers: {"Content-Type": "application/json", 'x-branch': currentBranch},
        body: json.encode(material.toJson()));
    return res.statusCode == 200;
  }

  Future<bool> deleteMaterial(String id) async {
    final res = await http.delete(_buildUri("materials/$id"),
        headers: {'x-branch': currentBranch});
    return res.statusCode == 200;
  }
}