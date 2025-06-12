import 'package:advanced_mobile_app/components/page_wapper.dart';
import 'package:flutter/material.dart';

class TransactionsPage extends StatelessWidget {
  const TransactionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      children: [
        const Text(
          'Transactions Page',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
