import 'package:advanced_mobile_app/components/page_wapper.dart';
import 'package:flutter/material.dart';

class AIPage extends StatelessWidget {
  const AIPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      children: [
        const Text(
          'AI Page',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }
}
