import 'package:advanced_mobile_app/components/budget_card.dart';
import 'package:advanced_mobile_app/components/category.dart';
import 'package:advanced_mobile_app/components/transaction.dart';
import 'package:advanced_mobile_app/components/wallet_card.dart';
import 'package:advanced_mobile_app/models/budget_model.dart';
import 'package:advanced_mobile_app/models/category_model.dart';
import 'package:advanced_mobile_app/models/transaction_model.dart';
import 'package:advanced_mobile_app/models/wallet_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class MessageItem extends StatelessWidget {
  final String role;
  final String content;
  final dynamic parts;
  final dynamic error;

  const MessageItem({
    super.key,
    required this.role,
    required this.content,
    this.parts,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    final result = parts?['result'];
    final toolName = parts?['toolName'];
    final message = parts?['message'] ?? '';
    final errorCode = parts?['errorCode'];

    Widget messageWidget(String text) {
      final theme = Theme.of(context).colorScheme;

      return Align(
        alignment: role == 'assistant'
            ? Alignment.centerLeft
            : Alignment.centerRight,
        child: Container(
          constraints: const BoxConstraints(maxWidth: double.infinity),
          padding: const EdgeInsets.all(12),
          margin: const EdgeInsets.only(top: 8),
          decoration: BoxDecoration(
            color: theme.secondary,
            borderRadius: BorderRadius.circular(18),
          ),
          child: MarkdownBody(data: text),
        ),
      );
    }

    if (errorCode != null) {
      return Column(
        crossAxisAlignment: role == 'assistant'
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          messageWidget("⚠️ $errorCode"),
          if (errorCode.contains('LIMIT'))
            TextButton(
              onPressed: () {
                // Navigate to premium screen
              },
              child: const Text('Upgrade Now'),
            ),
        ],
      );
    }

    // 🧠 Render tool result
    switch (toolName) {
      case 'get_all_wallets':
        List<Wallet> wallets = result['wallets'] != null
            ? (result['wallets'] as List)
                  .map((json) => Wallet.fromJson(json))
                  .toList()
            : [];
        if (wallets.isEmpty) return messageWidget('No wallets found');
        return Column(
          spacing: 8,
          crossAxisAlignment: role == 'assistant'
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            if (message.isNotEmpty) messageWidget(message),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: wallets
                    .map(
                      (wallet) => Container(
                        width: MediaQuery.of(context).size.width - 24,
                        margin: const EdgeInsets.only(right: 12),
                        child: WalletCard(wallet: wallet, hideMenu: true),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        );
      case 'get_wallet':
      case 'create_wallet':
      case 'update_wallet':
        Wallet? wallet = result['wallet'] != null
            ? Wallet.fromJson(result['wallet'])
            : null;

        if (wallet == null) return messageWidget('No wallet found');
        return Column(
          crossAxisAlignment: role == 'assistant'
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            if (message.isNotEmpty) messageWidget(message),
            WalletCard(wallet: wallet, hideMenu: true),
          ],
        );
      case 'delete_wallet':
        Wallet? wallet = result['wallet'] != null
            ? Wallet.fromJson(result['wallet'])
            : null;

        return messageWidget('Wallet "${wallet?.name}" deleted successfully!');

      case 'get_all_categories':
        List<Category> categories = result['categories'] != null
            ? (result['categories'] as List)
                  .map((json) => Category.fromJson(json))
                  .toList()
            : [];
        if (categories.isEmpty) return messageWidget('No categories found');
        return Column(
          crossAxisAlignment: role == 'assistant'
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            if (message.isNotEmpty) messageWidget(message),
            ...categories
                .map<Widget>((c) => CategoryItem(category: c, hideMenu: true))
                .toList(),
          ],
        );
      case 'get_category':
      case 'create_category':
      case 'update_category':
        Category? category = result['category'] != null
            ? Category.fromJson(result['category'])
            : null;
        if (category == null) return messageWidget('No category found');
        return Column(
          crossAxisAlignment: role == 'assistant'
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            if (message.isNotEmpty) messageWidget(message),
            CategoryItem(category: category, hideMenu: true),
          ],
        );
      case 'delete_category':
        Category? category = result['category'] != null
            ? Category.fromJson(result['category'])
            : null;
        return messageWidget(
          'Category "${category?.name}" deleted successfully!',
        );

      case 'get_all_budgets':
        List<Budget> budgets = result['budgets'] != null
            ? (result['budgets'] as List)
                  .map((json) => Budget.fromJson(json))
                  .toList()
            : [];
        if (budgets.isEmpty) return messageWidget('No budgets found');
        return Column(
          spacing: 6,
          crossAxisAlignment: role == 'assistant'
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            if (message.isNotEmpty) messageWidget(message),
            ...budgets
                .map<Widget>(
                  (b) => BudgetCard(
                    budget: b,
                    begin: b.begin,
                    end: b.end,
                    hideMenu: true,
                  ),
                )
                .toList(),
          ],
        );
      case 'create_budget':
      case 'update_budget':
        Budget? budget = result['budget'];
        if (budget == null) return messageWidget('No budget found');
        return Column(
          crossAxisAlignment: role == 'assistant'
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            if (message.isNotEmpty) messageWidget(message),
            BudgetCard(
              budget: budget,
              begin: budget.begin,
              end: budget.end,
              hideMenu: true,
            ),
          ],
        );
      case 'delete_budget':
        Budget? budget = result['budget'] != null
            ? Budget.fromJson(result['budget'])
            : null;
        return messageWidget(
          'Budget for category ${budget?.category.name} with total ${budget?.total} deleted successfully!',
        );

      case 'get_all_transactions':
        List<Transaction> transactions = result['transactions'] != null
            ? (result['transactions'] as List)
                  .map((json) => Transaction.fromJson(json))
                  .toList()
            : [];
        if (transactions.isEmpty) return messageWidget('No transactions found');
        return Column(
          spacing: 6,
          crossAxisAlignment: role == 'assistant'
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            if (message.isNotEmpty) messageWidget(message),
            ...transactions
                .map<Widget>(
                  (t) => TransactionCard(transaction: t, hideMenu: true),
                )
                .toList(),
          ],
        );
      case 'get_transaction':
      case 'get_most_transaction':
      case 'create_transaction':
      case 'update_transaction':
        Transaction? transaction = result['transaction'] != null
            ? Transaction.fromJson(result['transaction'])
            : null;
        if (transaction == null) return messageWidget('No transaction found');
        return Column(
          crossAxisAlignment: role == 'assistant'
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            if (message.isNotEmpty) messageWidget(message),
            TransactionCard(transaction: transaction, hideMenu: true),
          ],
        );
      case 'delete_transaction':
        final transaction = result['transaction'];
        return messageWidget(
          'Transaction "${transaction?['name']}" deleted successfully!',
        );
    }

    // Default: basic message
    return messageWidget(content);
  }
}
