// budget_tab.dart
import 'package:advanced_mobile_app/components/budget_card.dart';
import 'package:advanced_mobile_app/components/providers/settings_provider.dart';
import 'package:advanced_mobile_app/utils/string.dart';
import 'package:flutter/material.dart';
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
          margin: const EdgeInsets.all(16),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Text("Amount you can spend"),
                Text(
                  formatCurrency(currency, total - amount),
                  style: const TextStyle(fontSize: 28, color: Colors.green),
                ),
                // LinearPercentIndicator(
                //   lineHeight: 8,
                //   percent: (amount / total).clamp(0.0, 1.0),
                //   progressColor: Colors.green,
                //   backgroundColor: Colors.grey[300],
                // ),
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text(formatCurrency(currency, total)),
                        const Text("Total budgets"),
                      ],
                    ),
                    Column(
                      children: [
                        Text(formatCurrency(currency, amount)),
                        const Text("Total spent"),
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text("$daysLeft day${daysLeft == 1 ? '' : 's'}"),
                        const Text("End of month"),
                      ],
                    ),
                    Column(
                      children: [
                        Text(formatCurrency(currency, dailyLimit) + "/day"),
                        const Text("Daily limit"),
                      ],
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/create-budget');
                  },
                  child: const Text("Create Budget"),
                ),
              ],
            ),
          ),
        ),
        ...budgets
            .map<Widget>((b) => BudgetCard(budget: b, begin: begin, end: end))
            .toList(),
      ],
    );
  }
}
