import 'package:advanced_mobile_app/components/overview.dart';
import 'package:advanced_mobile_app/components/page_wapper.dart';
import 'package:advanced_mobile_app/components/providers/wallet_provider.dart';
import 'package:advanced_mobile_app/components/wallets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final wallets = Provider.of<WalletProvider>(context).wallets;

    return PageWrapper(
      children: [
        Overview(),

        const SizedBox(height: 20),

        Wallets(wallets: wallets),
      ],
    );
  }
}
