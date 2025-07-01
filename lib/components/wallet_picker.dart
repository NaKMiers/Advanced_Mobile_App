import 'package:advanced_mobile_app/components/providers/wallet_provider.dart';
import 'package:advanced_mobile_app/models/wallet_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WalletPicker extends StatefulWidget {
  @override
  State<WalletPicker> createState() => _WalletPickerState();
}

class _WalletPickerState extends State<WalletPicker> {
  Wallet? selectedWallet;

  @override
  Widget build(BuildContext context) {
    final wallets = context.watch<WalletProvider>().wallets;

    return DropdownButtonFormField<Wallet>(
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),
      value: selectedWallet,
      onChanged: (value) {
        setState(() {
          selectedWallet = value;
        });
      },
      items: wallets.map((wallet) {
        return DropdownMenuItem(
          value: wallet,
          child: Row(
            children: [
              Text(wallet.icon ?? '💰'),
              const SizedBox(width: 8),
              Text(wallet.name),
            ],
          ),
        );
      }).toList(),
    );
  }
}
