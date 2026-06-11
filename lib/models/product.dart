// lib/models/product.dart
class Product {
  final String id;
  final String productId;
  final String name;
  final String category;
  final int price;
  final int cost;
  final bool isActive;
  final DateTime? createdAt;

  Product({
    required this.id,
    required this.productId,
    required this.name,
    required this.category,
    required this.price,
    required this.cost,
    required this.isActive,
    this.createdAt,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id']?.toString() ?? '',
      productId: json['product_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      price: int.tryParse(json['price'].toString()) ?? 0,
      cost: int.tryParse(json['cost'].toString()) ?? 0,
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.tryParse(
        json['created_at']?.toString() ?? 
        json['createdAt']?.toString() ?? ''
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "product_id": productId,
      "name": name,
      "category": category,
      "price": price,
      "cost": cost,
      "is_active": isActive,
      // "branch" akan ditambahkan otomatis oleh ApiService
    };
  }
}