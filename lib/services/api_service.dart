import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/employee.dart';
import '../models/product.dart';
import '../models/expense.dart';
import '../models/material.dart';

class ApiService {
  static const String baseUrl = "http://localhost:5000";

  // ==================== EMPLOYEES ====================
  Future<List<Employee>> getEmployees() async {
    final res = await http.get(Uri.parse("$baseUrl/api/employees"));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      return (data['data'] as List).map((e) => Employee.fromJson(e)).toList();
    }
    throw Exception("Gagal mengambil karyawan");
  }

  Future<bool> createEmployee(Employee emp) async {
    final res = await http.post(Uri.parse("$baseUrl/api/employees"),
        headers: {"Content-Type": "application/json"}, body: json.encode(emp.toJson()));
    return res.statusCode == 201 || res.statusCode == 200;
  }

  Future<bool> updateEmployee(String id, Employee emp) async {
    final res = await http.put(Uri.parse("$baseUrl/api/employees/$id"),
        headers: {"Content-Type": "application/json"}, body: json.encode(emp.toJson()));
    return res.statusCode == 200;
  }

  Future<bool> deleteEmployee(String id) async {
    final res = await http.delete(Uri.parse("$baseUrl/api/employees/$id"));
    return res.statusCode == 200;
  }

  // ==================== PRODUCTS ====================
  Future<List<Product>> getProducts() async {
    final res = await http.get(Uri.parse("$baseUrl/api/products"));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      return (data['data'] as List).map((e) => Product.fromJson(e)).toList();
    }
    throw Exception("Gagal mengambil produk");
  }

  Future<bool> createProduct(Product product) async {
    final res = await http.post(Uri.parse("$baseUrl/api/products"),
        headers: {"Content-Type": "application/json"}, body: json.encode(product.toJson()));
    return res.statusCode == 201 || res.statusCode == 200;
  }

  Future<bool> updateProduct(String id, Product product) async {
    final res = await http.put(Uri.parse("$baseUrl/api/products/$id"),
        headers: {"Content-Type": "application/json"}, body: json.encode(product.toJson()));
    return res.statusCode == 200;
  }

  Future<bool> deleteProduct(String id) async {
    final res = await http.delete(Uri.parse("$baseUrl/api/products/$id"));
    return res.statusCode == 200;
  }

  // ==================== EXPENSES ====================
  Future<List<Expense>> getExpenses() async {
    final res = await http.get(Uri.parse("$baseUrl/api/expenses"));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      return (data['data'] as List).map((e) => Expense.fromJson(e)).toList();
    }
    throw Exception("Gagal mengambil pengeluaran");
  }

  Future<bool> createExpense(Expense expense) async {
    final res = await http.post(Uri.parse("$baseUrl/api/expenses"),
        headers: {"Content-Type": "application/json"}, body: json.encode(expense.toJson()));
    return res.statusCode == 201 || res.statusCode == 200;
  }

  Future<bool> deleteExpense(String id) async {
    final res = await http.delete(Uri.parse("$baseUrl/api/expenses/$id"));
    return res.statusCode == 200;
  }

  // ==================== MATERIALS ====================
  Future<List<MaterialModel>> getMaterials() async {
    final res = await http.get(Uri.parse("$baseUrl/api/materials"));
    if (res.statusCode == 200) {
      final data = json.decode(res.body);
      return (data['data'] as List).map((e) => MaterialModel.fromJson(e)).toList();
    }
    throw Exception("Gagal mengambil material");
  }

  Future<bool> createMaterial(MaterialModel material) async {
    final res = await http.post(Uri.parse("$baseUrl/api/materials"),
        headers: {"Content-Type": "application/json"}, body: json.encode(material.toJson()));
    return res.statusCode == 201 || res.statusCode == 200;
  }

  // ← INI YANG KURANG
  Future<bool> updateMaterial(String id, MaterialModel material) async {
    final res = await http.put(Uri.parse("$baseUrl/api/materials/$id"),
        headers: {"Content-Type": "application/json"}, body: json.encode(material.toJson()));
    return res.statusCode == 200;
  }

  Future<bool> deleteMaterial(String id) async {
    final res = await http.delete(Uri.parse("$baseUrl/api/materials/$id"));
    return res.statusCode == 200;
  }
}