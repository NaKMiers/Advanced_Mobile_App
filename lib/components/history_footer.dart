import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HistoryFooter extends StatelessWidget {
  final List<String> transactionTypes;
  final String selectedTransactionType;
  final Function(String) onChangeTransactionType;
  final VoidCallback onNext;
  final VoidCallback onPrev;

  const HistoryFooter({
    super.key,
    required this.transactionTypes,
    required this.selectedTransactionType,
    required this.onChangeTransactionType,
    required this.onNext,
    required this.onPrev,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            ElevatedButton(
              onPressed: onPrev,
              child: const Icon(Icons.arrow_left),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: onNext,
              child: const Icon(Icons.arrow_right),
            ),
          ],
        ),
        CupertinoSegmentedControl<String>(
          children: {for (final t in transactionTypes) t: Text(t)},
          groupValue: selectedTransactionType,
          onValueChanged: onChangeTransactionType,
        ),
      ],
    );
  }
}
