import 'package:advanced_mobile_app/components/page_wapper.dart';
import 'package:flutter/material.dart';

class StreaksPage extends StatelessWidget {
  const StreaksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      children: [
        const Text(
          'Streaks Page',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
