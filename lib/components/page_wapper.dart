import 'package:flutter/material.dart';

class PageWrapper extends StatelessWidget {
  final List<Widget> children;
  final EdgeInsetsGeometry padding;
  const PageWrapper({
    super.key,
    required this.children,
    this.padding = const EdgeInsets.all(0),
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Padding(
          padding: padding,
          child: Column(children: children),
        ),
      ),
    );
  }
}
