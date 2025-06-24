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
        child: Text(
          'No wallets found.',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
      );
    }

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 21 / 2),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Wallets",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onSurface,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),

                TextButton(
                  onPressed: () {},
                  style: TextButton.styleFrom(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: const BorderSide(color: Colors.white, width: 2),
                    ),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                  ),
                  child: const Text(
                    "New Wallet",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                children: wallets
                    .map(
                      (wallet) => Container(
                        width: MediaQuery.of(context).size.width - 21,
                        margin: const EdgeInsets.only(right: 12),
                        child: WalletCard(wallet: wallet),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
