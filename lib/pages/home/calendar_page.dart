import 'dart:ui';

import 'package:advanced_mobile_app/components/page_wapper.dart';
import 'package:advanced_mobile_app/components/providers/init_provider.dart';
import 'package:advanced_mobile_app/components/providers/load_provider.dart';
import 'package:advanced_mobile_app/components/providers/settings_provider.dart';
import 'package:advanced_mobile_app/components/providers/tranasction_provider.dart';
import 'package:advanced_mobile_app/models/transaction_model.dart';
import 'package:advanced_mobile_app/requests/index.dart';
import 'package:advanced_mobile_app/utils/string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  _CalendarPageState createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  List<Transaction> _transactions = [];
  DateTime _currentMonth = DateTime.now();
  DateTime _selectedDate = DateTime.now();
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _getTransactions();
  }

  Future<void> _getTransactions() async {
    setState(() {
      _loading = true;
    });
    try {
      final result = await getMyTransactionsApi();
      List<Transaction> transactions = result['transactions'] != null
          ? (result['transactions'] as List)
                .map((json) => Transaction.fromJson(json))
                .toList()
          : [];

      Provider.of<TransactionProvider>(context).setTransactions(transactions);
    } catch (e) {
      print('Error fetching transactions: $e');
    } finally {
      setState(() {
        _loading = false;
      });
      Provider.of<LoadProvider>(context, listen: false).setRefreshing(false);
    }
  }

  List<Transaction> _getTransactionsForDate(DateTime date) {
    return _transactions.where((tx) => isSameDay(tx.date, date)).toList();
  }

  double _getTotalForDate(DateTime date) {
    final dateTransactions = _getTransactionsForDate(date);
    return dateTransactions.fold(0.0, (total, tx) {
      if (tx.exclude) return total;
      return tx.type == 'expense' ? total - tx.amount : total + tx.amount;
    });
  }

  @override
  Widget build(BuildContext context) {
    final loadProvider = Provider.of<LoadProvider>(context);
    final initProvider = Provider.of<InitProvider>(context);
    final settingsProvider = Provider.of<SettingsProvider>(context);
    final theme = Theme.of(context);
    final currency = settingsProvider.settings?.currency ?? 'USD';

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          loadProvider.refresh();
          await initProvider.refreshInit();
          await _getTransactions();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.5,
              vertical: 10.5,
            ),
            child: PageWrapper(
              children: [
                Text(
                  'Calendar',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge!.color,
                  ),
                ),

                const SizedBox(height: 21),
                if (!_loading) ...[
                  _buildCalendar(context, theme, currency),
                  const SizedBox(height: 10.5),
                  _buildTransactionsList(context, theme, currency),
                ] else ...[
                  _buildSkeleton(theme),
                ],
                const SizedBox(height: 64),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCalendar(
    BuildContext context,
    ThemeData theme,
    String currency,
  ) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.primary),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${_currentMonth.month}/${_currentMonth.year}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _currentMonth = DateTime(
                                _currentMonth.year,
                                _currentMonth.month - 1,
                              );
                            });
                          },
                          icon: const Icon(Icons.chevron_left, size: 20),
                          style: IconButton.styleFrom(
                            backgroundColor: theme.colorScheme.surface,
                            side: BorderSide(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                        const SizedBox(width: 4),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _currentMonth = DateTime(
                                _currentMonth.year,
                                _currentMonth.month + 1,
                              );
                            });
                          },
                          icon: const Icon(Icons.chevron_right, size: 20),
                          style: IconButton.styleFrom(
                            backgroundColor: theme.colorScheme.surface,
                            side: BorderSide(
                              color: theme.colorScheme.onSurface,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                TableCalendar(
                  firstDay: DateTime(2000),
                  lastDay: DateTime(2100),
                  focusedDay: _currentMonth,
                  selectedDayPredicate: (day) => isSameDay(day, _selectedDate),
                  onDaySelected: (selectedDay, focusedDay) {
                    setState(() {
                      _selectedDate = selectedDay;
                      _currentMonth = focusedDay;
                    });
                  },
                  onPageChanged: (focusedDay) {
                    setState(() {
                      _currentMonth = focusedDay;
                    });
                  },
                  calendarStyle: CalendarStyle(
                    outsideDaysVisible: false,
                    defaultTextStyle: const TextStyle(fontSize: 14),
                    selectedDecoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                    todayDecoration: BoxDecoration(
                      color: theme.colorScheme.secondary,
                      shape: BoxShape.circle,
                    ),
                    outsideTextStyle: TextStyle(color: Colors.grey.shade400),
                  ),
                  daysOfWeekStyle: DaysOfWeekStyle(
                    weekdayStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                    weekendStyle: TextStyle(
                      color: Colors.grey.shade500,
                      fontSize: 12,
                    ),
                  ),
                  headerVisible: false,
                  calendarBuilders: CalendarBuilders(
                    defaultBuilder: (context, day, focusedDay) {
                      final total = _getTotalForDate(day);
                      final hasTransactions = _getTransactionsForDate(
                        day,
                      ).isNotEmpty;
                      final isSelected = isSameDay(day, _selectedDate);
                      final isCurrentMonth = day.month == _currentMonth.month;

                      return GestureDetector(
                        child: Container(
                          margin: const EdgeInsets.all(4),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? theme.colorScheme.secondary
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                day.day.toString(),
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                  color: isSelected
                                      ? theme.colorScheme.onPrimary
                                      : isCurrentMonth
                                      ? theme.textTheme.bodyMedium!.color
                                      : Colors.grey.shade400,
                                ),
                              ),
                              if (hasTransactions) ...[
                                const Spacer(),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (total != 0)
                                      Text(
                                        total > 0
                                            ? '+'
                                            : total < 0
                                            ? '-'
                                            : '',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: total < 0
                                              ? Colors.red
                                              : Colors.green,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    Text(
                                      formatCompactNumber(total.abs()),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: total < 0
                                            ? Colors.red
                                            : Colors.green,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 2),
                                Container(
                                  height: 2,
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                    color: total != 0
                                        ? (total < 0
                                              ? Colors.red
                                              : Colors.green)
                                        : Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTransactionsList(
    BuildContext context,
    ThemeData theme,
    String currency,
  ) {
    final transactions = _getTransactionsForDate(_selectedDate);
    final total = _getTotalForDate(_selectedDate);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: theme.colorScheme.primary),
        boxShadow: [
          BoxShadow(
            color: Colors.black,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Transactions for ${_selectedDate.day} ${_selectedDate.month} ${_selectedDate.year}',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  constraints: const BoxConstraints(maxHeight: 500),
                  child: transactions.isNotEmpty
                      ? ListView.builder(
                          itemCount: transactions.length,
                          itemBuilder: (context, index) {
                            final tx = transactions[index];
                            return ListTile(
                              title: Text('Transaction ${tx.id}'),
                              subtitle: Text(
                                '${tx.type.toUpperCase()}: ${formatCurrency(currency, tx.amount)}',
                              ),
                              trailing: Text(
                                tx.date.toIso8601String().split('T')[0],
                                style: TextStyle(color: Colors.grey.shade600),
                              ),
                              onTap: () {},
                            );
                          },
                        )
                      : const Center(
                          child: Text('No transactions for this day'),
                        ),
                ),
                if (total != 0) ...[
                  const Divider(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        formatCurrency(currency, total),
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: total < 0 ? Colors.red : Colors.green,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSkeleton(ThemeData theme) {
    return Column(
      children: [
        Container(
          height: 500,
          margin: const EdgeInsets.all(10.5),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        Container(
          height: 500,
          margin: const EdgeInsets.all(10.5),
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ],
    );
  }
}
