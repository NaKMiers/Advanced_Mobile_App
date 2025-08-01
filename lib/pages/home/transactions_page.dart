import 'package:advanced_mobile_app/components/date_range_segments.dart';
import 'package:advanced_mobile_app/components/no_item_found.dart';
import 'package:advanced_mobile_app/components/providers/load_provider.dart';
import 'package:advanced_mobile_app/components/search_input.dart';
import 'package:advanced_mobile_app/components/transaction_type_group.dart';
import 'package:advanced_mobile_app/components/wallet_picker.dart';
import 'package:advanced_mobile_app/components/wrapper.dart';
import 'package:advanced_mobile_app/models/category_group.dart';
import 'package:advanced_mobile_app/models/transaction_model.dart';
import 'package:advanced_mobile_app/models/wallet_model.dart';
import 'package:advanced_mobile_app/requests/index.dart';
import 'package:flutter/material.dart';
import 'package:moment_dart/moment_dart.dart';
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
  String period = 'month';
  bool loading = false;

  DateTime from = DateTime.now();
  DateTime to = DateTime.now();

  Wallet? selectedWallet;

  // states

  String chartType = 'bar';

  List<Map<String, dynamic>> data = [];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    from = DateTime(now.year, now.month, 1);
    to = DateTime(now.year, now.month + 1, 0);
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
          '?from=${from.toUtc().toIso8601String()}&to=${to.toUtc().toIso8601String()}';
      if (selectedWallet != null) query += "&wallet=${selectedWallet!.id}";

      final res = await getMyTransactionsApi(query);
      List<Transaction> txs = res['transactions'] != null
          ? (res['transactions'] as List)
                .map((json) => Transaction.fromJson(json))
                .toList()
          : [];

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
    setState(() {
      search = value.trim();
    });
    groupTransactions();
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

    fetchTransactions();
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

    fetchTransactions();
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

    fetchTransactions();
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

    fetchTransactions();
  }

  @override
  Widget build(BuildContext context) {
    final loadProvider = Provider.of<LoadProvider>(context);

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => loadProvider.refresh(),
        child: Wrapper(
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
