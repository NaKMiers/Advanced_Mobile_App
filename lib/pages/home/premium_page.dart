import 'package:advanced_mobile_app/components/page_wapper.dart';
import 'package:flutter/material.dart';

class PremiumPage extends StatelessWidget {
  const PremiumPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      children: [
        const Text(
          'Premium Page',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
