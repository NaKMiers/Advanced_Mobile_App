import 'package:advanced_mobile_app/components/date_range_segments.dart';
import 'package:advanced_mobile_app/components/no_item_found.dart';
import 'package:advanced_mobile_app/components/providers/load_provider.dart';
import 'package:advanced_mobile_app/components/search_input.dart';
import 'package:advanced_mobile_app/components/transaction_type_group.dart';
import 'package:advanced_mobile_app/components/wallet_picker.dart';
import 'package:advanced_mobile_app/models/category_group.dart';
import 'package:advanced_mobile_app/models/transaction_model.dart';
import 'package:advanced_mobile_app/models/wallet_model.dart';
import 'package:advanced_mobile_app/requests/index.dart';
import 'package:advanced_mobile_app/utils/time.dart';
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

  bool isIncludeTransfer = false;
  String search = "";
  String timeSegment = 'month'; // 'week', 'month', 'year'

  DateTimeRange dateRange = DateTimeRange(
    start: DateTime(
      DateTime.now().year,
      DateTime.now().month,
      1,
    ), // start of month
    end: DateTime(
      DateTime.now().year,
      DateTime.now().month + 1,
      0,
      23,
      59,
      59,
    ), // end of month
  );

  DateTime? oldestDate;
  Wallet? selectedWallet;
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
      String query =
          "?from=${toUTC(dateRange.start)}&to=${toUTC(dateRange.end)}";
      if (selectedWallet != null) query += "&wallet=${selectedWallet!.id}";

      final res = await getMyTransactionsApi(query);
      List<Transaction> txs = res['transactions'] != null
          ? (res['transactions'] as List)
                .map((json) => Transaction.fromJson(json))
                .toList()
          : [];

      print("awdddw" + res['transactions'].length.toString());

      setState(() {
        transactions = txs;
      });
      groupTransactions();
    } catch (e) {
      print("Error fetching transactions: $e");
    } finally {
      setState(() => loading = false);
    }
  }

  void groupTransactions() {
    final grouped = <String, Map<String, CategoryGroup>>{};

    final filteredTxs = transactions.where((tx) {
      final key =
          '${tx.category.name}${tx.category.icon}${tx.name}${tx.type}${tx.amount}'
              .toLowerCase();
      return key.contains(search.toLowerCase().trim());
    }).toList();

    print(filteredTxs.length);

    for (var tx in filteredTxs) {
      grouped.putIfAbsent(tx.type, () => {});
      final catMap = grouped[tx.type]!;

      final catId = tx.category.id;
      catMap.putIfAbsent(
        catId,
        () => CategoryGroup(category: tx.category, transactions: []),
      );
      catMap[catId]!.transactions.add(tx);
    }

    setState(() {
      groups = grouped.entries
          .map((entry) => MapEntry(entry.key, entry.value.values.toList()))
          .toList();
    });
  }

  void onSearchChanged(String value) {
    print(value);
    setState(() {
      search = value.trim();
    });
    groupTransactions();
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
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // MARK: Wallet Picker
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
                    Expanded(
                      child: WalletPicker(
                        onSelectWallet: (Wallet? wallet) {
                          setState(() {
                            selectedWallet = wallet;
                          });
                          fetchTransactions();
                        },
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 8),

                // MARK: Date Range Segments
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

                // MARK: Search
                Row(
                  children: [
                    Expanded(
                      child: SearchInput(
                        value: search,
                        onChanged: onSearchChanged,
                        placeholder: "Search...",
                      ),
                    ),
                    const SizedBox(width: 8),
                    IconButton(
                      onPressed: () =>
                          Navigator.pushNamed(context, '/calendar'),
                      icon: const Icon(Icons.calendar_month),
                    ),
                  ],
                ),

                // MARK: Include transfers
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  spacing: 12,
                  children: [
                    const Text(
                      "Include transfers",
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                    Switch(
                      value: isIncludeTransfer,
                      onChanged: (val) {
                        setState(() {
                          isIncludeTransfer = val;
                        });
                        groupTransactions();
                      },
                    ),
                  ],
                ),

                // MARK: Transaction Groups
                ...groups.map(
                  (group) => TransactionTypeGroup(
                    type: group.key,
                    categoryGroups: group.value,
                    includeTransfers: isIncludeTransfer,
                  ),
                ),

                if (groups.isEmpty)
                  const Center(
                    child: NoItemsFound(text: "No transactions found"),
                  ),

                const SizedBox(height: 200), // padding bottom
              ],
            ),
          ),
        ),
      ),

      // Floating Add Button
      floatingActionButton: FloatingActionButton.extended(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
        onPressed: () => Navigator.pushNamed(context, '/create-transaction'),
        icon: const Icon(Icons.add),
        label: const Text("Add Transaction"),
      ),
    );
  }
}
