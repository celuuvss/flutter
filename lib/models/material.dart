// lib/models/material.dart
class MaterialModel {
  final String id;
  final String materialId;
  final String name;
  final String unit;
  final int costPerUnit;
  final bool isActive;
  final DateTime? createdAt;

  MaterialModel({
    required this.id,
    required this.materialId,
    required this.name,
    required this.unit,
    required this.costPerUnit,
    required this.isActive,
    this.createdAt,
  });

  factory MaterialModel.fromJson(Map<String, dynamic> json) {
    return MaterialModel(
      id: json['_id']?.toString() ?? '',
      materialId: json['material_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      unit: json['unit']?.toString() ?? '',
      costPerUnit: int.tryParse(json['cost_per_unit'].toString()) ?? 0,
      isActive: json['is_active'] ?? true,
      createdAt: DateTime.tryParse(
        json['created_at']?.toString() ?? 
        json['createdAt']?.toString() ?? ''
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "material_id": materialId,
      "name": name,
      "unit": unit,
      "cost_per_unit": costPerUnit,
      "is_active": isActive,
      // "branch" akan ditambahkan otomatis oleh ApiService
    };
  }
}