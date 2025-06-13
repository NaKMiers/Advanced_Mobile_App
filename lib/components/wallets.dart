import 'package:advanced_mobile_app/components/wallet_card.dart';
import 'package:advanced_mobile_app/models/wallet_model.dart';
import 'package:flutter/material.dart';

class Wallets extends StatelessWidget {
  final List<Wallet> wallets;

  const Wallets({super.key, required this.wallets});

  @override
  Widget build(BuildContext context) {
    if (wallets.isEmpty) {
      return const Center(
        child: Text('No wallets found.', style: TextStyle(fontSize: 16)),
      );
    }

    return Expanded(
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: wallets.length,
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          return SizedBox(
            width: MediaQuery.of(context).size.width,
            child: WalletCard(wallet: wallets[index]),
          );
        },
      ),
    );
  }
}
