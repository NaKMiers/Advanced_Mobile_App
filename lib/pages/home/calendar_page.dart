import 'package:advanced_mobile_app/components/no_item_found.dart';
import 'package:advanced_mobile_app/components/providers/load_provider.dart';
import 'package:advanced_mobile_app/components/providers/settings_provider.dart';
import 'package:advanced_mobile_app/components/transaction.dart';
import 'package:advanced_mobile_app/constants/settings.dart';
import 'package:advanced_mobile_app/models/transaction_model.dart';
import 'package:advanced_mobile_app/requests/index.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime currentMonth = DateTime.now();
  DateTime selectedDate = DateTime.now();
  List<Transaction> transactions = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      fetchTransactions();
      context.read<LoadProvider>().addListener(_onRefreshPointChanged);
    });
  }

  void _onRefreshPointChanged() {
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    setState(() => loading = true);

    try {
      final res = await getMyTransactionsApi();
      final txs = (res['transactions'] as List)
          .map((e) => Transaction.fromJson(e))
          .toList();

      setState(() => transactions = txs);

      print(txs.length);
    } catch (e) {
      print("Error fetching transactions: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  List<DateTime> getMonthDays() {
    final lastDay = DateTime(currentMonth.year, currentMonth.month + 1, 0);
    return List.generate(
      lastDay.day,
      (index) => DateTime(currentMonth.year, currentMonth.month, index + 1),
    );
  }

  List<Transaction> transactionsOfDay(DateTime date) {
    return transactions
        .where((tx) => DateUtils.isSameDay(tx.date, date))
        .toList();
  }

  int getTotalOfDay(DateTime date) {
    final dayTxs = transactionsOfDay(date);
    return dayTxs.fold(0, (total, tx) {
      return tx.type == 'expense'
          ? total - tx.amount.toInt()
          : total + tx.amount.toInt();
    });
  }

  @override
  Widget build(BuildContext context) {
    final currencyCode =
        context.read<SettingsProvider>().settings?.currency ?? "USD";
    final locale = currencies
        .where((c) => c.value == currencyCode)
        .first
        .locale;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Calendar',
          style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () => fetchTransactions(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              // Month selector
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    onPressed: () {
                      setState(() {
                        currentMonth = DateTime(
                          currentMonth.year,
                          currentMonth.month - 1,
                        );
                      });
                    },
                  ),
                  Text(
                    DateFormat.yMMM(locale).format(currentMonth),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right),
                    onPressed: () {
                      setState(() {
                        currentMonth = DateTime(
                          currentMonth.year,
                          currentMonth.month + 1,
                        );
                      });
                    },
                  ),
                ],
              ),

              // Days of week
              Row(
                children: List.generate(7, (index) {
                  final weekday = DateFormat.E(
                    locale,
                  ).format(DateTime(2025, 1, index + 5));
                  return Expanded(
                    child: Center(
                      child: Text(
                        weekday,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  );
                }),
              ),

              const SizedBox(height: 8),

              // Calendar grid
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: getMonthDays().length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  crossAxisSpacing: 4,
                  mainAxisSpacing: 4,
                  childAspectRatio: 1,
                ),
                itemBuilder: (_, index) {
                  final day = getMonthDays()[index];
                  final total = getTotalOfDay(day);
                  final isSelected = DateUtils.isSameDay(day, selectedDate);
                  final dayTxs = transactionsOfDay(day);

                  return GestureDetector(
                    onTap: () {
                      setState(() => selectedDate = day);
                    },
                    onLongPress: () {
                      Navigator.pushNamed(
                        context,
                        "/create-transaction",
                        arguments: {"initDate": day.toIso8601String()},
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(
                                context,
                              ).colorScheme.primary.withValues(alpha: 0.2)
                            : null,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "${day.day}",
                            style: TextStyle(
                              color: isSelected
                                  ? Theme.of(context).colorScheme.primary
                                  : null,
                            ),
                          ),
                          if (dayTxs.isNotEmpty)
                            Text(
                              NumberFormat.compact(
                                locale: locale,
                                explicitSign: true,
                              ).format(total),
                              style: TextStyle(
                                fontSize: 10,
                                color: total < 0 ? Colors.red : Colors.green,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              ),

              // MARK: Transactions
              Container(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    if (transactionsOfDay(selectedDate).isNotEmpty) ...[
                      Text(
                        "Transactions for ${DateFormat.yMMMd(locale).format(selectedDate)}",
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Column(
                        children: transactionsOfDay(selectedDate)
                            .map(
                              (tx) => Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: TransactionCard(transaction: tx),
                              ),
                            )
                            .toList(),
                      ),
                    ] else
                      const NoItemsFound(text: "No transactions for this day"),
                  ],
                ),
              ),

              const SizedBox(height: 180),
            ],
          ),
        ),
      ),
    );
  }
}
