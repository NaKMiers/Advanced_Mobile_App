// budget_tab.dart
import 'package:advanced_mobile_app/components/budget_card.dart';
import 'package:advanced_mobile_app/components/providers/settings_provider.dart';
import 'package:advanced_mobile_app/utils/string.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/flutter_percent_indicator.dart';
import 'package:provider/provider.dart';

class BudgetTab extends StatelessWidget {
  final String value;
  final DateTime begin;
  final DateTime end;
  final List budgets;

  const BudgetTab({
    required this.value,
    required this.begin,
    required this.end,
    required this.budgets,
  });

  @override
  Widget build(BuildContext context) {
    final currency =
        context.read<SettingsProvider>().settings?.currency ?? 'USD';
    final total = budgets.fold(0.0, (a, b) => a + b.total);
    final amount = budgets.fold(0.0, (a, b) => a + b.amount);
    final daysLeft = end.difference(DateTime.now()).inDays;
    final dailyLimit = daysLeft > 0 ? (total - amount) / daysLeft : 0.0;

    return Column(
      children: [
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          color: Theme.of(context).colorScheme.primary,
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(21),
            child: Column(
              children: [
                Text(
                  "Amount you can spend",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  formatCurrency(currency, total - amount),
                  style: const TextStyle(
                    fontSize: 28,
                    color: Colors.lightGreen,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 12),
                LinearPercentIndicator(
                  lineHeight: 8,
                  percent: (amount / total).clamp(0.0, 1.0),
                  progressColor: Colors.green,
                  backgroundColor: Colors.grey[400],
                  barRadius: const Radius.circular(16),
                ),
                const SizedBox(height: 21),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          formatCurrency(currency, total),
                          style: TextStyle(
                            color: Colors.purple[300],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Total budgets",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          formatCurrency(currency, amount),
                          style: TextStyle(
                            color: Colors.purple[300],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Total spent",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 21),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(
                          "$daysLeft day${daysLeft == 1 ? '' : 's'}",
                          style: TextStyle(
                            color: Colors.purple[300],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "End of month",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    Column(
                      children: [
                        Text(
                          formatCurrency(currency, dailyLimit) + "/day",
                          style: TextStyle(
                            color: Colors.purple[300],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "Daily limit",
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.onPrimary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 21),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(
                      context,
                      '/create-budget',
                      arguments: {'begin': begin, 'end': end},
                    );
                  },
                  child: Text(
                    "Create Budget",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        ...budgets
            .map<Widget>((b) => BudgetCard(budget: b, begin: begin, end: end))
            .toList(),
        const SizedBox(height: 200),
      ],
    );
  }
}
