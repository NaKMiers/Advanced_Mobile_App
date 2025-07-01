import 'package:advanced_mobile_app/components/providers/settings_provider.dart';
import 'package:advanced_mobile_app/models/transaction_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TransactionCard extends StatefulWidget {
  final Transaction transaction;

  const TransactionCard({super.key, required this.transaction});

  @override
  State<TransactionCard> createState() => _TransactionCardState();
}

class _TransactionCardState extends State<TransactionCard> {
  bool deleting = false;

  @override
  Widget build(BuildContext context) {
    final currency =
        context.watch<SettingsProvider>().settings?.currency ?? 'USD';

    final amountStr = NumberFormat.simpleCurrency(
      name: currency,
    ).format(widget.transaction.amount);
    final isExpense = widget.transaction.type == 'expense';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Category Icon & Name
        Row(
          children: [
            // Icon
            Text(
              widget.transaction.category.icon,
              style: const TextStyle(fontSize: 20),
            ),
            const SizedBox(width: 8),
            // Category & Name
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Category
                Text(
                  widget.transaction.category.name,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                  ),
                ),
                // Name
                ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 150),
                  child: Text(
                    widget.transaction.name,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ],
        ),

        Row(
          children: [
            // Date & Amount
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  DateFormat.yMMMd().format(widget.transaction.date),
                  style: TextStyle(fontSize: 12),
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      isExpense ? Icons.arrow_downward : Icons.arrow_upward,
                      color: isExpense ? Colors.red : Colors.green,
                      size: 16,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      amountStr,
                      style: TextStyle(
                        color: isExpense ? Colors.red : Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),

            // Menu Button
            Container(
              height: 24,
              width: 24,
              margin: const EdgeInsets.only(left: 8),
              child: deleting
                  ? CircularProgressIndicator(strokeWidth: 2)
                  : PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert),
                      padding: EdgeInsets.zero,
                      onSelected: (value) {
                        switch (value) {
                          case 'delete':
                            break;
                          case 'edit':
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(value: 'edit', child: Text("Edit")),
                        const PopupMenuItem(
                          value: 'delete',
                          child: Text("Delete"),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ],
    );
  }
}
