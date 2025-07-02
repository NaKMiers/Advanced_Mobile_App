import 'package:advanced_mobile_app/models/category_model.dart';

class Budget {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  final String user;
  final Category category;

  final double total;
  final double amount;
  final DateTime begin;
  final DateTime end;

  Budget({
    required this.id,
    required this.createdAt,
    required this.updatedAt,

    required this.user,
    required this.category,

    required this.total,
    required this.amount,
    required this.begin,
    required this.end,
  });

  factory Budget.fromJson(Map<String, dynamic> json) {
    return Budget(
      id: json['_id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),

      user: json['user'],
      category: Category.fromJson(json['category']),

      total: (json['total'] ?? 0).toDouble(),
      amount: (json['amount'] ?? 0).toDouble(),
      begin: DateTime.parse(json['begin'] ?? ''),
      end: DateTime.parse(json['end'] ?? ''),
    );
  }
}
