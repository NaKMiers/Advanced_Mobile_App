import 'package:flutter/material.dart';

class PageWrapper extends StatelessWidget {
  final List<Widget> children;
  const PageWrapper({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: children,
        ),
      ),
    );
  }
}
