import 'package:advanced_mobile_app/utils/string.dart';
import 'package:flutter/material.dart';

class HistoryFooter extends StatelessWidget {
  final List<String> transactionTypes;
  final String selectedTransactionType;
  final Function(String) onChangeTransactionType;

  const HistoryFooter({
    super.key,
    required this.transactionTypes,
    required this.selectedTransactionType,
    required this.onChangeTransactionType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).colorScheme;

    return Row(
      spacing: 4,
      children: transactionTypes
          .map(
            (type) => Expanded(
              child: GestureDetector(
                onTap: () => onChangeTransactionType(type),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8,
                    horizontal: 8,
                  ),
                  decoration: BoxDecoration(
                    color: selectedTransactionType == type
                        ? theme.primary
                        : theme.primary.withAlpha(70),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    capitalize(type),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: selectedTransactionType == type
                          ? theme.onPrimary
                          : theme.primary,
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
