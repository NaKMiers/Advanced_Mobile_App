import 'package:advanced_mobile_app/components/date_range_segments.dart';
import 'package:advanced_mobile_app/components/history_footer.dart';
import 'package:advanced_mobile_app/components/providers/load_provider.dart';
import 'package:advanced_mobile_app/components/providers/settings_provider.dart';
import 'package:advanced_mobile_app/models/transaction_model.dart';
import 'package:advanced_mobile_app/requests/index.dart';
import 'package:advanced_mobile_app/utils/string.dart';
import 'package:advanced_mobile_app/utils/time.dart';
import 'package:flutter/material.dart';
import 'package:moment_dart/moment_dart.dart';
import 'package:provider/provider.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  // states
  List<Transaction> transactions = [];
  DateTime from = DateTime.now();
  DateTime to = DateTime.now();
  String period = 'month';
  String chartType = 'bar';
  String transactionType = 'expense';
  bool includeTransfers = false;
  bool loading = false;

  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    from = DateTime(now.year, now.month, 1);
    to = DateTime(now.year, now.month + 1, 0);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getHistory();
      context.read<LoadProvider>().addListener(_onRefreshPointChanged);
    });
  }

  void _onRefreshPointChanged() {
    getHistory();
  }

  Future<void> getHistory() async {
    // start loading
    setState(() => loading = true);

    try {
      String query =
          '?from=${from.toUtc().toIso8601String()}&to=${to.toUtc().toIso8601String()}';
      final res = await getHistoryApi(query);

      List<Transaction> txs = res['transactions'] != null
          ? (res['transactions'] as List)
                .map((json) => Transaction.fromJson(json))
                .toList()
          : [];

      setState(() => transactions = txs);

      print('getHistory: ${transactions.length} transactions');

      loadChartData();
    } catch (err) {
      debugPrint('getHistory error: $err');
    } finally {
      setState(() => loading = false);
    }
  }

  // MARK: Build chart data
  void loadChartData() {
    List<Transaction> tsx = includeTransfers
        ? transactions
        : transactions.where((t) => !t.exclude).toList();

    if (tsx.isEmpty) {
      setState(() => data = []);
      return;
    }

    List<Transaction> filteredTransactions =
        (transactionType == 'balance' || chartType == 'pie')
        ? tsx
        : tsx.where((t) => t.type == transactionType).toList();

    DateTime start = DateTime(from.year, from.month, from.day);
    DateTime end = DateTime(to.year, to.month, to.day, 23, 59, 59);

    List<Map<String, dynamic>> groupedData = [];

    Duration stepUnit;
    String dateFormat;
    int totalSteps;

    switch (period) {
      case 'week':
        stepUnit = const Duration(days: 1);
        dateFormat = 'EEE';
        totalSteps = 7;
        break;
      case 'month':
        stepUnit = const Duration(days: 1);
        dateFormat = 'dd';
        totalSteps = end.difference(start).inDays + 1;
        break;
      case 'year':
        stepUnit = const Duration(days: 30);
        dateFormat = 'MMM';
        totalSteps = 12;
        break;
      default:
        return;
    }

    if (chartType == 'pie') {
      double totalIncome = filteredTransactions
          .where((t) => t.type == 'income')
          .fold(0, (sum, t) => sum + t.amount);
      double totalExpense = filteredTransactions
          .where((t) => t.type == 'expense')
          .fold(0, (sum, t) => sum + t.amount);
      double totalSaving = filteredTransactions
          .where((t) => t.type == 'saving')
          .fold(0, (sum, t) => sum + t.amount);
      double totalInvest = filteredTransactions
          .where((t) => t.type == 'invest')
          .fold(0, (sum, t) => sum + t.amount);

      setState(() {
        data = [
          {'label': 'Income', 'value': totalIncome, 'type': 'income'},
          {'label': 'Expense', 'value': -totalExpense, 'type': 'expense'},
          {'label': 'Saving', 'value': totalSaving, 'type': 'saving'},
          {'label': 'Invest', 'value': totalInvest, 'type': 'invest'},
        ];
      });
    } else {
      DateTime iterator = start;
      int steps = 0;

      while (iterator.isBefore(end) && steps < totalSteps) {
        final colStart = iterator;
        DateTime colEnd;

        if (period == 'year') {
          colEnd = DateTime(iterator.year, iterator.month + 1, 0, 23, 59, 59);
        } else {
          colEnd = iterator.add(stepUnit);
        }

        final chunkTransactions = filteredTransactions.where((t) {
          final date = t.date.toUtc();
          return date.isAfter(colStart.subtract(const Duration(seconds: 1))) &&
              date.isBefore(colEnd.add(const Duration(seconds: 1)));
        }).toList();

        double totalValue;
        if (transactionType == 'balance') {
          final income = chunkTransactions
              .where((t) => t.type == 'income')
              .fold(0.0, (sum, t) => sum + t.amount);
          final expense = chunkTransactions
              .where((t) => t.type == 'expense')
              .fold(0.0, (sum, t) => sum + t.amount);
          totalValue = income - expense;
        } else {
          totalValue = chunkTransactions.fold(0.0, (sum, t) => sum + t.amount);
        }

        groupedData.add({
          'label': formatDate(colStart, dateFormat: dateFormat),
          'value': totalValue,
          'type': transactionType,
        });

        iterator = colEnd.add(const Duration(days: 1));
        steps++;
      }

      setState(() => data = groupedData);
    }
  }

  // MARK: Change period
  void changePeriod(String newPeriod) {
    if (newPeriod == period) return;

    setState(() {
      period = newPeriod;
      final now = Moment.now();
      from = Moment(
        now,
      ).startOf(DurationUnit.values.firstWhere((u) => u.name == newPeriod));
      to = Moment(
        now,
      ).endOf(DurationUnit.values.firstWhere((u) => u.name == newPeriod));
    });

    getHistory();
  }

  // MARK: Next period
  void nextPeriod() {
    Duration unit;

    switch (period) {
      case 'week':
        unit = const Duration(days: 7);
        break;
      case 'month':
        unit = Duration(days: DateTime(from.year, from.month + 1, 0).day);
        break;
      case 'year':
        unit = const Duration(days: 365);
        break;
      default:
        unit = const Duration(days: 30);
    }

    final nextFrom = Moment(from).add(unit);
    final nextTo = Moment(to).add(unit);

    if (nextFrom.isAfter(DateTime.now())) return;

    setState(() {
      from = nextFrom;
      to = nextTo;
    });

    getHistory();
  }

  // MARK: Previous period
  void previousPeriod() {
    Duration unit;

    switch (period) {
      case 'week':
        unit = const Duration(days: 7);
        break;
      case 'month':
        unit = Duration(days: DateTime(from.year, from.month, 0).day);
        break;
      case 'year':
        unit = const Duration(days: 365);
        break;
      default:
        unit = const Duration(days: 30);
    }

    final prevFrom = Moment(from).subtract(unit);
    final prevTo = Moment(to).subtract(unit);

    setState(() {
      from = prevFrom;
      to = prevTo;
    });

    getHistory();
  }

  // MARK: Reset period
  void resetPeriod() {
    final now = DateTime.now();

    setState(() {
      switch (period) {
        case 'week':
          from = Moment(now).startOf(DurationUnit.week);
          to = Moment(now).endOf(DurationUnit.week);
          break;
        case 'month':
          from = Moment(now).startOf(DurationUnit.month);
          to = Moment(now).endOf(DurationUnit.month);
          break;
        case 'year':
          from = Moment(now).startOf(DurationUnit.year);
          to = Moment(now).endOf(DurationUnit.year);
          break;
      }
    });

    getHistory();
  }

  @override
  Widget build(BuildContext context) {
    double total = data.fold(0, (sum, item) => sum + (item['value']));
    final currencyCode =
        context.read<SettingsProvider>().settings?.currency ?? 'USD';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 21 / 2),
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 12),
              Text(
                "History",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSecondary,
                ),
              ),
              const SizedBox(height: 8),

              // MARK: Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: DateRangeSegments(
                      segment: period,
                      segments: ['week', 'month', 'year'],
                      onChangeSegment: changePeriod,
                      next: nextPeriod,
                      prev: previousPeriod,
                      reset: resetPeriod,
                      from: from,
                      to: to,
                    ),
                  ),
                ],
              ),

              // MARK: Total + Include Transfer
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total $transactionType',
                        style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).colorScheme.onSecondary,
                        ),
                      ),
                      Text(
                        formatCurrency(currencyCode, total),
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: checkTranType(transactionType)['color'],
                        ),
                      ),
                    ],
                  ),
                  Row(
                    spacing: 8,
                    children: [
                      const Text('Include\ntransfers'),
                      Switch(
                        value: includeTransfers,
                        onChanged: (v) => setState(() {
                          includeTransfers = v;
                          loadChartData();
                        }),
                      ),
                    ],
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // MARK: Chart
              if (chartType == 'bar')
                SfCartesianChart(
                  primaryXAxis: CategoryAxis(),
                  series: <CartesianSeries>[
                    ColumnSeries<Map<String, dynamic>, String>(
                      dataSource: data,
                      xValueMapper: (d, _) => d['label'] as String,
                      yValueMapper: (d, _) => d['value'],
                      color: checkTranType(transactionType)['color'],
                    ),
                  ],
                ),

              const SizedBox(height: 16),

              // MARK: Footer
              HistoryFooter(
                transactionTypes: ['expense', 'income', 'saving', 'invest'],
                selectedTransactionType: transactionType,
                onChangeTransactionType: (String type) {
                  setState(() {
                    transactionType = type;
                    loadChartData();
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
