import 'package:advanced_mobile_app/components/page_wapper.dart';
import 'package:advanced_mobile_app/pages/home/_home_layout.dart';
import 'package:flutter/material.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context) {
    return PageWrapper(
      children: [
        Text(
          'Calendar Page',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),

        ElevatedButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (_) => HomeLayout(initialPageIndex: 3),
              ),
            );
          },
          child: Text('Go to Budgets'),
        ),
      ],
    );
  }
}
