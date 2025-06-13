import 'package:advanced_mobile_app/components/overview_item.dart';
import 'package:advanced_mobile_app/components/providers/settings_provider.dart';
import 'package:advanced_mobile_app/components/providers/wallet_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Overview extends StatefulWidget {
  const Overview({super.key});

  @override
  State<Overview> createState() => _OverviewState();
}

class _OverviewState extends State<Overview> {
  bool collapsed = true;
  bool showValue = true;

  @override
  Widget build(BuildContext context) {
    final wallets = context
        .watch<WalletProvider>()
        .wallets
        .where((w) => !w.exclude)
        .toList();
    final currency =
        context.watch<SettingsProvider>().settings?.currency ?? 'USD';

    final totalIncome = wallets.fold(0.0, (a, b) => a + b.income);
    final totalExpense = wallets.fold(0.0, (a, b) => a + b.expense);
    final totalSaving = wallets.fold(0.0, (a, b) => a + b.saving);
    final totalInvest = wallets.fold(0.0, (a, b) => a + b.invest);
    final totalBalance = totalIncome + totalSaving + totalInvest - totalExpense;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: GestureDetector(
          onTap: () => setState(() {
            collapsed = !collapsed;
          }),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  children: [
                    OverviewItem(
                      title: "Total Balance",
                      value: totalBalance,
                      type: 'balance',
                      showValue: showValue,
                      toggle: () => setState(() {
                        showValue = !showValue;
                      }),
                      currency: currency,
                      isEye: true,
                    ),
                    AnimatedCrossFade(
                      firstChild: const SizedBox.shrink(),
                      secondChild: Column(
                        children: [
                          OverviewItem(
                            title: "Income",
                            value: totalIncome,
                            type: 'income',
                            showValue: showValue,
                            currency: currency,
                          ),
                          OverviewItem(
                            title: "Expense",
                            value: totalExpense,
                            type: 'expense',
                            showValue: showValue,
                            currency: currency,
                          ),
                          OverviewItem(
                            title: "Saving",
                            value: totalSaving,
                            type: 'saving',
                            showValue: showValue,
                            currency: currency,
                          ),
                          OverviewItem(
                            title: "Invest",
                            value: totalInvest,
                            type: 'invest',
                            showValue: showValue,
                            currency: currency,
                          ),
                        ],
                      ),
                      crossFadeState: collapsed
                          ? CrossFadeState.showSecond
                          : CrossFadeState.showFirst,
                      duration: const Duration(milliseconds: 100),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationX(collapsed ? 3.1416 : 0),
                  child: Icon(Icons.expand_more, size: 24, color: Colors.grey),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
