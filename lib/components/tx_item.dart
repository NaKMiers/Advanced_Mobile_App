// tx_item.dart
import 'package:advanced_mobile_app/components/providers/load_provider.dart';
import 'package:advanced_mobile_app/models/transaction_model.dart';
import 'package:advanced_mobile_app/requests/index.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class TxItem extends StatefulWidget {
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
  State<TxItem> createState() => _TxItemState();
}

class _TxItemState extends State<TxItem> {
  bool deleting = false;
  bool duplicating = false;

  // delete transaction
  void deleteTransaction(BuildContext context) async {
    setState(() => deleting = true);

    try {
      await deleteTransactionApi(widget.transaction.id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Transaction deleted successfully!')),
      );

      context.read<LoadProvider>().refresh();
    } catch (err) {
      print("Error deleting transaction: $err");
    } finally {
      setState(() => deleting = false);
    }
  }

  // duplicate transaction
  void duplicateTransaction() async {
    setState(() => duplicating = true);

    try {
      await createTransactionApi({
        "name": widget.transaction.name,
        "amount": widget.transaction.amount,
        "type": widget.transaction.type,
        "walletId": widget.transaction.wallet.id,
        "categoryId": widget.transaction.category.id,
        "date": DateTime.now().toUtc().toIso8601String(),
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Transaction duplicated")));

      context.read<LoadProvider>().refresh();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to duplicate transaction")),
      );
    } finally {
      setState(() => duplicating = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final amountStr = NumberFormat.simpleCurrency(
      name: widget.currency,
    ).format(widget.transaction.amount);
    final isExpense = widget.transaction.type == 'expense';

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          spacing: 14,
          children: [
            Container(
              width: 2,
              height: 40,
              decoration: BoxDecoration(
                color: isExpense ? Colors.red : Colors.green,
                borderRadius: BorderRadius.circular(4),
              ),
            ),
            Text(widget.transaction.name, overflow: TextOverflow.ellipsis),
          ],
        ),
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  DateFormat.yMMMd().format(widget.transaction.date),
                  style: TextStyle(fontSize: 13),
                ),
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
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
                          case 'duplicate':
                            duplicateTransaction();
                            break;

                          case 'delete':
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                  side: const BorderSide(width: 1.5),
                                ),
                                backgroundColor: Theme.of(
                                  context,
                                ).colorScheme.secondary,
                                title: Text(
                                  "Delete Transaction",
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSecondary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                content: Text(
                                  "Are you sure you want to delete this transaction?",
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSecondary,
                                  ),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("Cancel"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      deleteTransaction(context);
                                    },
                                    child: const Text(
                                      "Delete",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            );
                            break;
                          case 'edit':
                            // handle edit
                            Navigator.pushNamed(
                              context,
                              '/update-transaction',
                              arguments: widget.transaction,
                            );
                            break;
                        }
                      },
                      itemBuilder: (context) => [
                        const PopupMenuItem(
                          value: 'duplicate',
                          child: Text("Duplicate"),
                        ),
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
