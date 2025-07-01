import 'package:advanced_mobile_app/components/chart.dart';
import 'package:advanced_mobile_app/components/history_footer.dart';
import 'package:advanced_mobile_app/components/history_header.dart';
import 'package:advanced_mobile_app/models/transaction_model.dart';
import 'package:advanced_mobile_app/requests/transaction_requests.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  // equivalent state
  DateTime fromDate = DateTime.now();
  DateTime toDate = DateTime.now();
  String selectedTransactionType = 'expense';
  String selectedChartType = 'bar';
  String chartPeriod = 'month';
  bool loading = false;
  bool isIncludeTransfer = false;

  List<dynamic> data = [];
  List<dynamic> transactions = [];

  @override
  void initState() {
    super.initState();

    DateTime startOfMonth = DateTime(fromDate.year, fromDate.month, 1);
    DateTime endOfMonth = DateTime(toDate.year, toDate.month + 1, 0);
    fetchHistory(startOfMonth, endOfMonth);
  }

  Future<void> fetchHistory(DateTime fromDate, DateTime toDate) async {
    final from = fromDate.toUtc().toIso8601String();
    final to = toDate.toUtc().toIso8601String();

    try {
      final res = await getHistoryApi("?from=$from&to=$to");
      List<Transaction> txs = res['transactions'] != null
          ? (res['transactions'] as List)
                .map((json) => Transaction.fromJson(json))
                .toList()
          : [];

      setState(() {
        transactions = txs;
      });

      print("Fetched transactions: ${txs.length}");
    } catch (e) {
      print('Fetch failed: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // MARK: HistoryHeader
          HistoryHeader(
            selectedChartType: selectedChartType,
            onSelectChartType: (chart) =>
                setState(() => selectedChartType = chart),
            segment: chartPeriod,
            onChangeSegment: (period) => setState(() => chartPeriod = period),
          ),

          // MARK: Total + Include Transfer
          Row(
            children: [
              Text('Total: \$1000'), // placeholder
              const Spacer(),
              Row(
                children: [
                  const Text("Include transfers"),
                  Switch(
                    value: isIncludeTransfer,
                    onChanged: (v) => setState(() => isIncludeTransfer = v),
                  ),
                ],
              ),
            ],
          ),

          // MARK: Chart
          loading
              ? const CircularProgressIndicator()
              : SizedBox(
                  height: 300,
                  child: Chart(
                    data: data
                        .map(
                          (e) => {
                            'label': e['label'],
                            'value': e['value'],
                            'type': e['type'] ?? '',
                          },
                        )
                        .toList(),
                    chartType: selectedChartType,
                    transactionType: selectedTransactionType,
                  ),
                ),

          // MARK: HistoryFooter
          HistoryFooter(
            transactionTypes: ['income', 'expense', 'saving', 'invest'],
            selectedTransactionType: selectedTransactionType,
            onChangeTransactionType: (t) =>
                setState(() => selectedTransactionType = t),
            onNext: () {
              // move date forward
            },
            onPrev: () {
              // move date backward
            },
          ),
        ],
      ),
    );
  }
}
