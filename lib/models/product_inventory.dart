class ProductInventory {
  final String? id;
  final String productId;
  final String productName;
  final String category;
  final int stockQuantity;
  final int sellingPrice;
  final int minStock;
  final int maxStock;
  final DateTime createdAt;
  final DateTime? updatedAt;

  ProductInventory({
    this.id,
    required this.productId,
    required this.productName,
    required this.category,
    required this.stockQuantity,
    required this.sellingPrice,
    required this.minStock,
    required this.maxStock,
    required this.createdAt,
    this.updatedAt,
  });

  factory ProductInventory.fromJson(Map<String, dynamic> json) {
    return ProductInventory(
      id: json['_id'] as String?,
      productId: json['product_id'] as String? ?? '',
      productName: json['product_name'] as String? ?? '',
      category: json['category'] as String? ?? '',
      stockQuantity: json['stock_quantity'] as int? ?? 0,
      sellingPrice: json['selling_price'] as int? ?? 0,
      minStock: json['min_stock'] as int? ?? 0,
      maxStock: json['max_stock'] as int? ?? 0,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'product_id': productId,
      'product_name': productName,
      'category': category,
      'stock_quantity': stockQuantity,
      'selling_price': sellingPrice,
      'min_stock': minStock,
      'max_stock': maxStock,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
