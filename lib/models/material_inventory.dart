class MaterialInventory {
  final String? id;
  final String materialId;
  final String materialName;
  final String unit;
  final int stockQuantity;
  final int minStock;
  final int maxStock;
  final String supplier;
  final DateTime createdAt;
  final DateTime? updatedAt;

  MaterialInventory({
    this.id,
    required this.materialId,
    required this.materialName,
    required this.unit,
    required this.stockQuantity,
    required this.minStock,
    required this.maxStock,
    required this.supplier,
    required this.createdAt,
    this.updatedAt,
  });

  factory MaterialInventory.fromJson(Map<String, dynamic> json) {
    return MaterialInventory(
      id: json['_id'] as String?,
      materialId: json['material_id'] as String? ?? '',
      materialName: json['material_name'] as String? ?? '',
      unit: json['unit'] as String? ?? '',
      stockQuantity: json['stock_quantity'] as int? ?? 0,
      minStock: json['min_stock'] as int? ?? 0,
      maxStock: json['max_stock'] as int? ?? 0,
      supplier: json['supplier'] as String? ?? '',
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
      'material_id': materialId,
      'material_name': materialName,
      'unit': unit,
      'stock_quantity': stockQuantity,
      'min_stock': minStock,
      'max_stock': maxStock,
      'supplier': supplier,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
