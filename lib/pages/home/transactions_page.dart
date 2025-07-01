import 'package:advanced_mobile_app/components/date_range_segments.dart';
import 'package:advanced_mobile_app/components/providers/load_provider.dart';
import 'package:advanced_mobile_app/components/transaction_type_group.dart';
import 'package:advanced_mobile_app/components/wallet_picker.dart';
import 'package:advanced_mobile_app/models/category_group.dart';
import 'package:advanced_mobile_app/models/transaction_model.dart';
import 'package:advanced_mobile_app/requests/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class TransactionsPage extends StatefulWidget {
  const TransactionsPage({Key? key}) : super(key: key);

  @override
  State<TransactionsPage> createState() => _TransactionsPageState();
}

class _TransactionsPageState extends State<TransactionsPage> {
  List<Transaction> transactions = [];
  List<MapEntry<String, List<CategoryGroup>>> groups = [];

  bool isFirstRender = true;
  bool isIncludeTransfer = false;
  String search = "";
  String timeSegment = 'month'; // 'week', 'month', 'year'

  DateTimeRange dateRange = DateTimeRange(
    start: DateTime.now().subtract(const Duration(days: 30)),
    end: DateTime.now(),
  );

  DateTime? oldestDate;

  @override
  void initState() {
    super.initState();
    fetchTransactions();
  }

  Future<void> fetchTransactions() async {
    try {
      String query = "";

      final res = await getMyTransactionsApi(query);
      List<Transaction> txs = res['transactions'] != null
          ? (res['transactions'] as List)
                .map((json) => Transaction.fromJson(json))
                .toList()
          : [];

      print(transactions.length);

      setState(() {
        transactions = txs;
        // oldestDate = res.oldestDate;
        // isFirstRender = false;
      });
      groupTransactions(txs);
    } catch (e) {
      debugPrint('Failed to fetch: $e');
      // Show toast/snackbar
    } finally {
      // _refreshController.refreshCompleted();
    }
  }

  void groupTransactions(List<Transaction> transactions) {
    final grouped = <String, Map<String, CategoryGroup>>{};

    // final filtered = transactions.where((tx) {
    //   final key =
    //       '${tx.category.name}${tx.category.icon}${tx.name}${tx.type}${tx.amount}'
    //           .toLowerCase();
    //   return key.contains(search.toLowerCase().trim());
    // }).toList();

    // print(filtered.length);

    for (var tx in transactions) {
      grouped.putIfAbsent(tx.type, () => {});
      final catMap = grouped[tx.type]!;

      final catId = tx.category.id;
      catMap.putIfAbsent(
        catId,
        () => CategoryGroup(category: tx.category, transactions: []),
      );
      catMap[catId]!.transactions.add(tx);
    }

    print("Grouped transactions: ${grouped.entries.toList()}");

    setState(() {
      groups = grouped.entries
          .map((entry) => MapEntry(entry.key, entry.value.values.toList()))
          .toList();
    });
  }

  void onSearchChanged(String value) {
    // setState(() {
    //   search = value;
    // });
    // groupTransactions();
  }

  void handlePrevTimeUnit() {
    // setState(() {
    //   dateRange = DateTimeRange(
    //     start: subtractByUnit(dateRange.start, timeSegment),
    //     end: subtractByUnit(dateRange.end, timeSegment),
    //   );
    // });
    // fetchTransactions();
  }

  void handleNextTimeUnit() {
    // setState(() {
    //   dateRange = DateTimeRange(
    //     start: addByUnit(dateRange.start, timeSegment),
    //     end: addByUnit(dateRange.end, timeSegment),
    //   );
    // });
    // fetchTransactions();
  }

  void handleResetTimeUnit() {
    // final now = DateTime.now();
    // setState(() {
    //   dateRange = getTimeRange(now, timeSegment);
    // });
    // fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
    final loadProvider = Provider.of<LoadProvider>(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => loadProvider.refresh(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // Wallet Picker
              Row(
                children: [
                  Expanded(
                    child: Text(
                      "Transactions of",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // Wallet picker button here if needed
                  Expanded(child: WalletPicker()),
                ],
              ),

              const SizedBox(height: 8),

              // Date Range Segments
              DateRangeSegments(
                segment: timeSegment,
                segments: ['week', 'month', 'year'],
                onChangeSegment: (newSegment) {
                  setState(() {
                    timeSegment = newSegment;
                    handleResetTimeUnit();
                  });
                },
                from: dateRange.start,
                to: dateRange.end,
                // dateRange: dateRange,
                next: handleNextTimeUnit,
                prev: handlePrevTimeUnit,
                reset: handleResetTimeUnit,
                // disabledNext: dateRange.start
                //     .add(unitDuration(timeSegment))
                //     .isAfter(DateTime.now()),
                // disabledPrev:
                //     oldestDate != null &&
                //     dateRange.start
                //         .subtract(unitDuration(timeSegment))
                //         .isBefore(oldestDate!),
              ),
              const SizedBox(height: 12),

              // Search & Toggle
              // Row(
              //   children: [
              //     Expanded(
              //       child: SearchInput(
              //         value: search,
              //         onChanged: onSearchChanged,
              //         placeholder: "Search...",
              //       ),
              //     ),
              //     const SizedBox(width: 8),
              //     IconButton(
              //       onPressed: () => Navigator.pushNamed(context, '/calendar'),
              //       icon: const Icon(Icons.calendar_month),
              //     ),
              //   ],
              // ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text("Include transfers"),
                  Switch(
                    value: isIncludeTransfer,
                    onChanged: (val) {
                      setState(() {
                        isIncludeTransfer = val;
                      });
                      groupTransactions(transactions);
                    },
                  ),
                ],
              ),

              const SizedBox(height: 12),

              Expanded(
                child: groups.isNotEmpty
                    ? ListView.builder(
                        itemCount: groups.length,
                        itemBuilder: (context, index) {
                          final group = groups[index];
                          return TransactionTypeGroup(
                            type: group.key,
                            categoryGroups: group.value,
                            includeTransfers: isIncludeTransfer,
                          );
                        },
                      )
                    : const Center(child: Text("No transactions found")),
              ),
            ],
          ),
        ),
      ),

      // Floating Add Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, '/create-transaction'),
        icon: const Icon(Icons.add),
        label: const Text("Add Transaction"),
      ),
    );
  }
}
