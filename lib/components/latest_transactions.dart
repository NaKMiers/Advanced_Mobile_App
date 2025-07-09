import 'package:advanced_mobile_app/components/providers/load_provider.dart';
import 'package:advanced_mobile_app/components/transaction.dart';
import 'package:advanced_mobile_app/models/transaction_model.dart';
import 'package:advanced_mobile_app/requests/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LatestTransactions extends StatefulWidget {
  const LatestTransactions({super.key});

  @override
  State<LatestTransactions> createState() => _LatestTransactionsState();
}

class _LatestTransactionsState extends State<LatestTransactions> {
  List<Transaction> transactions = [];
  int limit = 10;
  bool loading = false;

  Future<void> fetchTransactions() async {
    setState(() => loading = true);
    try {
      final res = await getMyTransactionsApi(
        "?sort=date|-1&sort=createdAt|-1&limit=$limit",
      );
      List<Transaction> txs = res['transactions'] != null
          ? (res['transactions'] as List)
                .map((json) => Transaction.fromJson(json))
                .toList()
          : [];

      setState(() {
        transactions = txs;
      });
    } catch (e) {
      debugPrint('Error fetching transactions: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to fetch transactions")),
      );
    } finally {
      setState(() => loading = false);
    }
  }

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

  @override
  Widget build(BuildContext context) {
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
              // Top Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Latest Transactions",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                  DropdownButton<int>(
                    value: limit,
                    items: [5, 10, 20, 30, 50, 100]
                        .map(
                          (e) => DropdownMenuItem(
                            value: e,
                            child: Text('$e', style: TextStyle(fontSize: 15)),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        setState(() => limit = value);
                        fetchTransactions();
                      }
                    },
                  ),
                ],
              ),

              transactions.isEmpty
                  ? const Center(child: Text("No transactions found"))
                  : Column(
                      spacing: 8,
                      children: transactions
                          .map((tx) => TransactionCard(transaction: tx))
                          .toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
