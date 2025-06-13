import 'package:advanced_mobile_app/models/category_model.dart';
import 'package:advanced_mobile_app/models/wallet_model.dart';

class Transaction {
  final String id;
  final DateTime createdAt;
  final DateTime updatedAt;

  final String user;
  final Wallet wallet;
  final Category category;
  final String type;
  final String name;
  final double amount;
  final DateTime date;
  final bool exclude;

  Transaction({
    required this.id,
    required this.createdAt,
    required this.updatedAt,

    required this.user,
    required this.name,
    required this.wallet,
    required this.category,
    required this.type,
    required this.amount,
    required this.date,
    required this.exclude,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['_id'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),

      user: json['user'],
      name: json['name'],
      wallet: Wallet.fromJson(json['wallet']),
      category: Category.fromJson(json['category']),
      type: json['type'],
      amount: (json['amount'] ?? 0).toDouble(),
      date: DateTime.parse(json['date']),
      exclude: json['exclude'] ?? false,
    );
  }
}
