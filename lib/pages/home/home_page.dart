import 'package:advanced_mobile_app/components/history.dart';
import 'package:advanced_mobile_app/components/latest_transactions.dart';
import 'package:advanced_mobile_app/components/overview.dart';
import 'package:advanced_mobile_app/components/providers/load_provider.dart';
import 'package:advanced_mobile_app/components/providers/wallet_provider.dart';
import 'package:advanced_mobile_app/components/wallets.dart';
import 'package:advanced_mobile_app/components/wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final loadProvider = Provider.of<LoadProvider>(context);
    final wallets = Provider.of<WalletProvider>(context).wallets;

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async => loadProvider.refresh(),
        child: Wrapper(
          child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            children: [
              const SizedBox(height: 21 / 2),
              Overview(),
              const SizedBox(height: 21 / 2),
              Wallets(wallets: wallets),
              const SizedBox(height: 21),
              History(),
              const SizedBox(height: 21),
              LatestTransactions(),
              const SizedBox(height: 200),
            ],
          ),
        ),
      ),
    );
  }
}
