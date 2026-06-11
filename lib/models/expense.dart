// lib/models/expense.dart
class Expense {
  final String id;
  final String expenseId;
  final String type;
  final int amount;
  final DateTime date;
  final String description;
  final String? reference;
  final DateTime? createdAt;

  Expense({
    required this.id,
    required this.expenseId,
    required this.type,
    required this.amount,
    required this.date,
    required this.description,
    this.reference,
    this.createdAt,
  });

  factory Expense.fromJson(Map<String, dynamic> json) {
    return Expense(
      id: json['_id']?.toString() ?? '',
      expenseId: json['expense_id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      amount: int.tryParse(json['amount'].toString()) ?? 0,
      date: DateTime.tryParse(json['date']?.toString() ?? '') ?? DateTime.now(),
      description: json['description']?.toString() ?? '',
      reference: json['reference']?.toString(),
      createdAt: DateTime.tryParse(
        json['created_at']?.toString() ?? 
        json['createdAt']?.toString() ?? ''
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "expense_id": expenseId,
      "type": type,
      "amount": amount,
      "date": date.toIso8601String(),
      "description": description,
      if (reference != null) "reference": reference,
      // "branch" akan ditambahkan otomatis oleh ApiService
    };
  }
}