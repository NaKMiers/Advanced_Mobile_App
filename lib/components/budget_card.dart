// budget_card.dart
import 'package:advanced_mobile_app/components/providers/settings_provider.dart';
import 'package:advanced_mobile_app/utils/string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BudgetCard extends StatelessWidget {
  final dynamic budget;
  final DateTime begin;
  final DateTime end;

  const BudgetCard({
    required this.budget,
    required this.begin,
    required this.end,
  });

  @override
  Widget build(BuildContext context) {
    final currency =
        context.read<SettingsProvider>().settings?.currency ?? 'USD';
    final progress = (budget.amount / budget.total) * 100;
    final leftAmount = budget.total - budget.amount;
    final totalDays = end.difference(begin).inDays;
    final spentDays = DateTime.now().difference(begin).inDays;
    final todayPercent = totalDays > 0 ? (spentDays / totalDays) * 100 : 0.0;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Text(budget.category.icon),
                const SizedBox(width: 8),
                Text(budget.category.name),
                const Spacer(),
                Text(formatCurrency(currency, budget.total)),
              ],
            ),
            const SizedBox(height: 12),
            Stack(
              children: [
                Container(
                  height: 8,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
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
                Positioned(
                  left:
                      (todayPercent.clamp(0.0, 100.0) / 100) *
                      MediaQuery.of(context).size.width *
                      0.9,
                  top: -8,
                  child: Column(
                    children: const [
                      Text("Today", style: TextStyle(fontSize: 10)),
                      Icon(Icons.arrow_drop_down, size: 20),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Align(
              alignment: Alignment.center,
              child: Text("Left: ${formatCurrency(currency, leftAmount)}"),
            ),
          ],
        ),
      ),
    );
  }
}
