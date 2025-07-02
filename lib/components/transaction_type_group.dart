import 'package:advanced_mobile_app/components/transaction_category_group.dart';
import 'package:advanced_mobile_app/models/category_group.dart';
import 'package:advanced_mobile_app/utils/string.dart';
import 'package:flutter/material.dart';

class TransactionTypeGroup extends StatefulWidget {
  final String type;
  final List<CategoryGroup> categoryGroups;
  final bool includeTransfers;

  const TransactionTypeGroup({
    Key? key,
    required this.type,
    required this.categoryGroups,
    this.includeTransfers = false,
  }) : super(key: key);

  @override
  State<TransactionTypeGroup> createState() => _TransactionTypeGroupState();
}

class _TransactionTypeGroupState extends State<TransactionTypeGroup> {
  bool collapsed = true;

  @override
  void initState() {
    super.initState();
    collapsed = true;
  }

  @override
  Widget build(BuildContext context) {
    final typeStyle = checkTranType(widget.type);
    final currency = "USD";
    final totalAmount = widget.categoryGroups.fold<double>(
      0,
      (total, group) =>
          total +
          group.transactions
              .where((tx) => !tx.exclude || widget.includeTransfers)
              .fold(0, (sum, tx) => sum + tx.amount),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        GestureDetector(
          onTap: () {
            setState(() {
              collapsed = !collapsed;
            });
          },
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: typeStyle['color'], width: 3),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    color: typeStyle['color'],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Center(
                    child: Icon(
                      typeStyle['icon'],
                      color: Colors.white,
                      size: 18,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        capitalize(widget.type) + 's',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      const Text(
                        'Sorted by date',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  ),
                ),
                Text(
                  formatCurrency(currency, totalAmount),
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: typeStyle['color'],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  height: 40,
                  width: 24,
                  margin: const EdgeInsets.only(left: 8),
                  child: PopupMenuButton<String>(
                    onSelected: (value) {
                      if (value == 'add') {
                        Navigator.pushNamed(
                          context,
                          '/create-transaction',
                          arguments: {'type': widget.type},
                        );
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem<String>(
                        value: 'add',
                        child: TextButton(
                          onPressed: () {
                            Navigator.pushNamed(
                              context,
                              '/create-transaction',
                              arguments: {'type': widget.type},
                            );
                          },
                          child: const Text('Add Transaction'),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),

        // Collapsible content
        AnimatedCrossFade(
          firstChild: Container(),
          secondChild: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              children: widget.categoryGroups
                  .map(
                    (group) => TransactionCategoryGroup(
                      category: group.category,
                      transactions: group.transactions,
                      includeTransfers: widget.includeTransfers,
                    ),
                  )
                  .toList(),
            ),
          ),
          crossFadeState: !collapsed
              ? CrossFadeState.showFirst
              : CrossFadeState.showSecond,
          duration: const Duration(milliseconds: 200),
        ),
      ],
    );
  }
}
