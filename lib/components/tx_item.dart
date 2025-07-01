// tx_item.dart
import 'package:advanced_mobile_app/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class TxItem extends StatelessWidget {
  final Transaction transaction;
  final String currency;
  final Function onEdit;
  final Function onDelete;
  final Function onDuplicate;

  const TxItem({
    super.key,
    required this.transaction,
    required this.currency,
    required this.onEdit,
    required this.onDelete,
    required this.onDuplicate,
  });

  @override
  Widget build(BuildContext context) {
    final amountStr = NumberFormat.simpleCurrency(
      name: currency,
    ).format(transaction.amount);
    final isExpense = transaction.type == 'expense';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(transaction.name, overflow: TextOverflow.ellipsis),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(DateFormat.yMMMd().format(transaction.date)),
                Row(
                  children: [
                    Icon(
                      isExpense ? Icons.arrow_downward : Icons.arrow_upward,
                      color: isExpense ? Colors.red : Colors.green,
                      size: 16,
                    ),
                    Text(
                      amountStr,
                      style: TextStyle(
                        color: isExpense ? Colors.red : Colors.green,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Container(
              margin: const EdgeInsets.only(left: 8),
              width: 16,
              child: PopupMenuButton<String>(
                padding: EdgeInsets.zero,
                icon: Icon(Icons.more_vert, color: Colors.white),
                onSelected: (value) {
                  if (value == 'edit') onEdit();
                  if (value == 'delete') onDelete();
                  if (value == 'duplicate') onDuplicate();
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(
                    value: 'duplicate',
                    child: Text('Duplicate'),
                  ),
                  const PopupMenuItem(value: 'edit', child: Text('Edit')),
                  const PopupMenuItem(value: 'delete', child: Text('Delete')),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
