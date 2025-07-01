import 'package:advanced_mobile_app/models/category_model.dart';
import 'package:advanced_mobile_app/models/transaction_model.dart';

class CategoryGroup {
  final Category category;
  final List<Transaction> transactions;

  CategoryGroup({required this.category, required this.transactions});
}
