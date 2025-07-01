import 'package:advanced_mobile_app/components/header.dart';
import 'package:advanced_mobile_app/components/no_item_found.dart';
import 'package:advanced_mobile_app/components/providers/load_provider.dart';
import 'package:advanced_mobile_app/components/providers/wallet_provider.dart';
import 'package:advanced_mobile_app/components/wallet_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WalletsPage extends StatefulWidget {
  const WalletsPage({Key? key}) : super(key: key);

  @override
  State<WalletsPage> createState() => _WalletsPageState();
}

class _WalletsPageState extends State<WalletsPage> {
  @override
  Widget build(BuildContext context) {
    final walletProvider = Provider.of<WalletProvider>(context);
    final loadProvider = Provider.of<LoadProvider>(context);
    final wallets = walletProvider.wallets;

    return Scaffold(
      appBar: Header(),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => loadProvider.refresh(),
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.pushNamed(context, "/account"),
                    icon: Icon(Icons.arrow_back),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Wallets",
                    style: TextStyle(fontWeight: FontWeight.w500, fontSize: 20),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              if (wallets.isEmpty)
                Column(
                  children: List.generate(
                    5,
                    (index) => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                    ),
                  ),
                )
              else if (wallets.isNotEmpty)
                Column(
                  children: wallets
                      .map(
                        (wallet) => Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: WalletCard(wallet: wallet),
                        ),
                      )
                      .toList(),
                )
              else
                Padding(
                  padding: const EdgeInsets.only(top: 40),
                  child: NoItemsFound(
                    text: "You don't have any wallets yet, create one now!",
                  ),
                ),
              const SizedBox(height: 200),
            ],
          ),
        ),
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            onPressed: () => Navigator.pushNamed(context, '/create-wallet'),
            label: Text(
              "Create Wallet",
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            icon: const Icon(Icons.add),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
