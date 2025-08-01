import 'package:advanced_mobile_app/components/providers/load_provider.dart';
import 'package:advanced_mobile_app/components/providers/settings_provider.dart';
import 'package:advanced_mobile_app/components/providers/wallet_provider.dart';
import 'package:advanced_mobile_app/models/wallet_model.dart';
import 'package:advanced_mobile_app/requests/index.dart';
import 'package:advanced_mobile_app/utils/string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class WalletCard extends StatefulWidget {
  final Wallet wallet;
  final bool hideMenu;

  const WalletCard({super.key, required this.wallet, this.hideMenu = false});

  @override
  State<WalletCard> createState() => _WalletCardState();
}

class _WalletCardState extends State<WalletCard> {
  bool collapsed = false;
  bool deleting = false;
  late bool exclude;

  @override
  void initState() {
    super.initState();
    exclude = widget.wallet.exclude;
  }

  void toggleExclude(bool value) async {
    setState(() => exclude = value);
    try {
      final res = await updateWalletApi(widget.wallet.id, {
        ...widget.wallet.toJson(),
        'exclude': value,
      });

      final updatedWallet = Wallet.fromJson(res['wallet']);
      setState(() {
        exclude = updatedWallet.exclude;
      });

      Provider.of<WalletProvider>(
        context,
        listen: false,
      ).updateWallet(updatedWallet);
    } catch (err) {
      print(err);
    }
  }

  void deleteWallet(BuildContext context) async {
    setState(() => deleting = true);

    try {
      await deleteWalletApi(widget.wallet.id);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Wallet deleted successfully!')),
      );

      context.read<LoadProvider>().refresh();
    } catch (err) {
      print("Error deleting wallet: $err");
    } finally {
      setState(() => deleting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final wallet = widget.wallet;
    final spentRate = wallet.income > 0
        ? (wallet.expense / wallet.income).clamp(0, 1)
        : 0.0;
    final balance =
        wallet.income + wallet.saving + wallet.invest - wallet.expense;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    // Wallet Icon
                    ?wallet.icon != null
                        ? Text(
                            wallet.icon!,
                            style: const TextStyle(fontSize: 24),
                          )
                        : null,
                    const SizedBox(width: 16),
                    // Wallet Name
                    Text(
                      wallet.name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
                if (!widget.hideMenu)
                  Row(
                    children: [
                      // Exclude
                      Switch(value: exclude, onChanged: toggleExclude),
                      Container(
                        height: 24,
                        width: 24,
                        margin: const EdgeInsets.only(left: 8),
                        child: deleting
                            ? CircularProgressIndicator(strokeWidth: 2)
                            : PopupMenuButton<String>(
                                icon: const Icon(Icons.more_vert),
                                padding: EdgeInsets.zero,
                                onSelected: (value) {
                                  switch (value) {
                                    case 'delete':
                                      showDialog(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              16,
                                            ),
                                            side: const BorderSide(width: 1.5),
                                          ),
                                          backgroundColor: Theme.of(
                                            context,
                                          ).colorScheme.secondary,
                                          title: Text(
                                            "Delete wallet",
                                            style: TextStyle(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSecondary,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          content: Text(
                                            "Are you sure you want to delete this wallet?",
                                            style: TextStyle(
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.onSecondary,
                                            ),
                                          ),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context),
                                              child: const Text("Cancel"),
                                            ),
                                            TextButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                                deleteWallet(context);
                                              },
                                              child: const Text(
                                                "Delete",
                                                style: TextStyle(
                                                  color: Colors.red,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                      break;
                                    case 'edit':
                                      // handle edit
                                      Navigator.pushNamed(
                                        context,
                                        '/update-wallet',
                                        arguments: wallet,
                                      );
                                      break;
                                  }
                                },
                                itemBuilder: (context) => [
                                  const PopupMenuItem(
                                    value: 'edit',
                                    child: Text("Edit"),
                                  ),
                                  const PopupMenuItem(
                                    value: 'delete',
                                    child: Text("Delete"),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
              ],
            ),
          ),

          _buildItem("Balance", balance, 'balance'),
          if (collapsed) ...[
            _buildItem("Income", wallet.income, 'income'),
            _buildItem("Expense", wallet.expense, 'expense'),
            _buildItem("Saving", wallet.saving, 'saving'),
            _buildItem("Invest", wallet.invest, 'invest'),
          ],
          GestureDetector(
            onTap: () => setState(() => collapsed = !collapsed),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: LinearProgressIndicator(
                      value: spentRate.toDouble(),
                      minHeight: 5,
                      backgroundColor: Colors.grey.shade300,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        checkLevel(spentRate.toDouble())['background'],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(
                    collapsed ? Icons.expand_less : Icons.expand_more,
                    size: 24,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem(String title, double value, String type) {
    final iconData = checkTranType(type)['icon'];
    final color = checkTranType(type)['color'];
    final currency =
        context.watch<SettingsProvider>().settings?.currency ?? 'USD';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color,
            child: Icon(iconData, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title),
              Text(
                formatCurrency(currency, value),
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
