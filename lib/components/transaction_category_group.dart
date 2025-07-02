import 'package:advanced_mobile_app/components/providers/settings_provider.dart';
import 'package:advanced_mobile_app/components/tx_item.dart';
import 'package:advanced_mobile_app/models/category_model.dart';
import 'package:advanced_mobile_app/models/transaction_model.dart';
import 'package:advanced_mobile_app/utils/string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionCategoryGroup extends StatelessWidget {
  final Category category;
  final List<Transaction> transactions;
  final bool includeTransfers;

  const TransactionCategoryGroup({
    Key? key,
    required this.category,
    required this.transactions,
    this.includeTransfers = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currency =
        context.watch<SettingsProvider>().settings?.currency ?? 'USD';
    final typeStyle = checkTranType(category.type);

    final filteredTransactions = transactions
        .where((tx) => !tx.exclude || includeTransfers)
        .toList();

    final totalAmount = filteredTransactions.fold<double>(
      0,
      (sum, tx) => sum + tx.amount,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header Row
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(category.icon, style: const TextStyle(fontSize: 20)),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        category.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        formatCurrency(currency, totalAmount),
                        style: TextStyle(color: typeStyle['color']),
                      ),
                    ],
                  ),
                ],
              ),
              // Add Transaction Button
              OutlinedButton(
                onPressed: () {
                  // Dispatch setSelectedCategory and navigate
                  Navigator.pushNamed(
                    context,
                    '/create-transaction',
                    arguments: {'category': category},
                  );
                },
                child: const Text("Add Transaction"),
              ),
            ],
          ),
        ),

        // Transactions List
        Padding(
          padding: const EdgeInsets.only(left: 8.0),
          child: Column(
            children: filteredTransactions
                .map(
                  (tx) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: TxItem(
                      transaction: tx,
                      currency: currency,
                      onEdit: () {},
                      onDelete: () {},
                      onDuplicate: () {},
                    ),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}
