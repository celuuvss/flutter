// lib/models/employee.dart
class Employee {
  final String id;
  final String employeeId;
  final String name;
  final String role;
  final String shift;
  final int salary;
  final DateTime createdAt;

  Employee({
    required this.id,
    required this.employeeId,
    required this.name,
    required this.role,
    required this.shift,
    required this.salary,
    required this.createdAt,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      id: json['_id']?.toString() ?? '',
      employeeId: json['employee_id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      role: json['role']?.toString() ?? '',
      shift: json['shift']?.toString() ?? 'full_day',
      salary: int.tryParse(json['salary'].toString()) ?? 0,
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? json['createdAt']?.toString() ?? '') ?? DateTime.now(),
    );
  }

  // ← TAMBAHKAN INI
  Map<String, dynamic> toJson() {
    return {
      "employee_id": employeeId,
      "name": name,
      "role": role,
      "shift": shift,
      "salary": salary,
    };
  }
}