import 'package:advanced_mobile_app/components/budget_card.dart';
import 'package:advanced_mobile_app/components/category.dart';
import 'package:advanced_mobile_app/components/transaction.dart';
import 'package:advanced_mobile_app/components/wallet_card.dart';
import 'package:advanced_mobile_app/models/budget_model.dart';
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
    final toolInvocation = parts != null && parts.length > 1
        ? parts[1]['toolInvocation']
        : null;
    final result = toolInvocation?['result'];
    final toolName = toolInvocation?['toolName'];
    final message = result?['message'] ?? '';
    final errorCode = result?['errorCode'];

    Widget messageWidget(String text) {
      return Container(
        padding: const EdgeInsets.all(12),
        margin: EdgeInsets.only(
          top: 8,
          bottom: 12,
          left: role == 'assistant' ? 0 : 48,
          right: role == 'user' ? 0 : 48,
        ),
        decoration: BoxDecoration(
          color: role == 'assistant'
              ? Colors.grey.shade100
              : Theme.of(context).colorScheme.secondary.withValues(alpha: 0.3),
          borderRadius: BorderRadius.circular(18),
        ),
        child: MarkdownBody(data: text),
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
        final wallets = result['wallets'] ?? [];
        if (wallets.isEmpty) return messageWidget('No wallets found');
        return Column(
          crossAxisAlignment: role == 'assistant'
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            if (message.isNotEmpty) messageWidget(message),
            ...wallets.map<Widget>((w) => WalletCard(wallet: w)).toList(),
          ],
        );

      case 'get_wallet':
      case 'create_wallet':
      case 'update_wallet':
        final wallet = result['wallet'];
        if (wallet == null) return messageWidget('No wallet found');
        return Column(
          crossAxisAlignment: role == 'assistant'
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            if (message.isNotEmpty) messageWidget(message),
            WalletCard(wallet: wallet),
          ],
        );

      case 'delete_wallet':
        final wallet = result['wallet'];
        return messageWidget(
          'Wallet "${wallet?['name']}" deleted successfully!',
        );

      case 'get_all_categories':
        final categories = result['categories'] ?? [];
        if (categories.isEmpty) return messageWidget('No categories found');
        return Column(
          crossAxisAlignment: role == 'assistant'
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            if (message.isNotEmpty) messageWidget(message),
            ...categories
                .map<Widget>((c) => CategoryItem(category: c))
                .toList(),
          ],
        );

      case 'get_category':
      case 'create_category':
      case 'update_category':
        final category = result['category'];
        if (category == null) return messageWidget('No category found');
        return Column(
          crossAxisAlignment: role == 'assistant'
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            if (message.isNotEmpty) messageWidget(message),
            CategoryItem(category: category),
          ],
        );

      case 'delete_category':
        final category = result['category'];
        return messageWidget(
          'Category "${category?['name']}" deleted successfully!',
        );

      case 'get_all_budgets':
        List<Budget> budgets = result['budgets'] ?? [];
        if (budgets.isEmpty) return messageWidget('No budgets found');
        return Column(
          crossAxisAlignment: role == 'assistant'
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            if (message.isNotEmpty) messageWidget(message),
            ...budgets
                .map<Widget>(
                  (b) => BudgetCard(budget: b, begin: b.begin, end: b.end),
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
            BudgetCard(budget: budget, begin: budget.begin, end: budget.end),
          ],
        );

      case 'delete_budget':
        final budget = result['budget'];
        return messageWidget(
          'Budget for category ${budget?['category']?['name']} with total ${budget?['total']} deleted successfully!',
        );

      case 'get_all_transactions':
        final transactions = result['transactions'] ?? [];
        if (transactions.isEmpty) return messageWidget('No transactions found');
        return Column(
          crossAxisAlignment: role == 'assistant'
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            if (message.isNotEmpty) messageWidget(message),
            ...transactions
                .map<Widget>((t) => TransactionCard(transaction: t))
                .toList(),
          ],
        );

      case 'get_transaction':
      case 'get_most_transaction':
      case 'create_transaction':
      case 'update_transaction':
        final transaction = result['transaction'];
        if (transaction == null) return messageWidget('No transaction found');
        return Column(
          crossAxisAlignment: role == 'assistant'
              ? CrossAxisAlignment.start
              : CrossAxisAlignment.end,
          children: [
            if (message.isNotEmpty) messageWidget(message),
            TransactionCard(transaction: transaction),
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
