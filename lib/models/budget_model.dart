import 'package:advanced_mobile_app/models/category_model.dart';

class Budget {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  final String user;
  final Category category;

  final double amount;
  final String begin;
  final String end;

  Budget({
    required this.id,
    required this.createdAt,
    required this.updatedAt,

    required this.user,
    required this.category,

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
      amount: (json['amount'] ?? 0).toDouble(),
      begin: json['begin'] ?? '',
      end: json['end'] ?? '',
    );
  }
}
