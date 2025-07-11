import 'package:advanced_mobile_app/components/providers/load_provider.dart';
import 'package:advanced_mobile_app/components/providers/settings_provider.dart';
import 'package:advanced_mobile_app/requests/budget_requests.dart';
import 'package:advanced_mobile_app/utils/string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BudgetCard extends StatefulWidget {
  final dynamic budget;
  final DateTime begin;
  final DateTime end;
  final bool hideMenu;

  const BudgetCard({
    required this.budget,
    required this.begin,
    required this.end,
    this.hideMenu = false,
  });

  @override
  State<BudgetCard> createState() => _BudgetCardState();
}

class _BudgetCardState extends State<BudgetCard> {
  bool deleting = false;

  void deleteBudget(BuildContext context) async {
    setState(() => deleting = true);

    try {
      await deleteBudgetApi(widget.budget.id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Budget deleted successfully!')),
      );

      context.read<LoadProvider>().refresh();
    } catch (err) {
      print("Error deleting budget: $err");
    } finally {
      setState(() => deleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency =
        context.read<SettingsProvider>().settings?.currency ?? 'USD';
    final progress = (widget.budget.amount / widget.budget.total) * 100;
    final leftAmount = widget.budget.total - widget.budget.amount;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Text(widget.budget.category.icon),
                const SizedBox(width: 8),
                Text(widget.budget.category.name),
                const SizedBox(width: 8),
                Text("|", style: TextStyle(color: Colors.grey[600])),
                const SizedBox(width: 8),
                Text(
                  formatCurrency(currency, widget.budget.amount),
                  style: TextStyle(
                    color: Colors.green[300],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 2),
                Text("/"),
                const SizedBox(width: 2),
                Text(
                  formatCurrency(currency, widget.budget.total),
                  style: TextStyle(
                    color: Colors.green[300],
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),

                if (!widget.hideMenu)
                  Container(
                    height: 24,
                    width: 24,
                    margin: const EdgeInsets.only(left: 8),
                    child: deleting
                        ? CircularProgressIndicator(strokeWidth: 2)
                        : PopupMenuButton<String>(
                            icon: const Icon(Icons.more_horiz),
                            padding: EdgeInsets.zero,
                            onSelected: (value) {
                              switch (value) {
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
                                        "Delete wallet",
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSecondary,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      content: Text(
                                        "Are you sure you want to delete this wallet?",
                                        style: TextStyle(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onSecondary,
                                        ),
                                      ),
                                      actions: [
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: const Text("Cancel"),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                            deleteBudget(context);
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
                                    '/update-budget',
                                    arguments: widget.budget,
                                  );
                                  break;
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'edit',
                                child: Text("Edit"),
                              ),
                              const PopupMenuItem(
                                value: 'delete',
                                child: Text("Delete"),
                              ),
                            ],
                          ),
                  ),
              ],
            ),
            const SizedBox(height: 12),
            Stack(
              children: [
                Container(
                  height: 28,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(32),
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      "Left: ${formatCurrency(currency, leftAmount)}",
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Container(
                  height: 8,
                  width:
                      (progress.clamp(0.0, 100.0) / 100) *
                      MediaQuery.of(context).size.width *
                      0.9,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
