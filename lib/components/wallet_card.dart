import 'package:advanced_mobile_app/models/wallet_model.dart';
import 'package:advanced_mobile_app/utils/string.dart';
import 'package:flutter/material.dart';

class WalletCard extends StatefulWidget {
  final Wallet wallet;
  final bool hideMenu;

  const WalletCard({Key? key, required this.wallet, this.hideMenu = false})
    : super(key: key);

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
  }

  void deleteWallet() async {
    setState(() => deleting = true);
    await Future.delayed(const Duration(seconds: 1));
    setState(() => deleting = false);
  }

  @override
  Widget build(BuildContext context) {
    final wallet = widget.wallet;
    final spentRate = wallet.income > 0
        ? (wallet.expense / wallet.income).clamp(0, 1)
        : 0.0;
    final balance =
        wallet.income + wallet.saving + wallet.invest - wallet.expense;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Column(
        children: [
          ListTile(
            leading: wallet.icon != null
                ? Text(wallet.icon!, style: const TextStyle(fontSize: 24))
                : null,
            title: Text(
              wallet.name,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            trailing: widget.hideMenu
                ? null
                : deleting
                ? const SizedBox(
                    height: 24,
                    width: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : PopupMenuButton<String>(
                    onSelected: (value) {
                      switch (value) {
                        case 'exclude':
                          toggleExclude(!exclude);
                          break;
                        case 'delete':
                          deleteWallet();
                          break;
                        case 'edit':
                          // TODO: Navigate to update screen
                          break;
                      }
                    },
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: 'exclude',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("Exclude"),
                            Switch(value: exclude, onChanged: toggleExclude),
                          ],
                        ),
                      ),
                      const PopupMenuItem(value: 'edit', child: Text("Edit")),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text("Delete"),
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
    final currency = 'USD';

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
