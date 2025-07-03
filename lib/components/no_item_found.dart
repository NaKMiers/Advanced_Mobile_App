import 'package:flutter/material.dart';

class NoItemsFound extends StatelessWidget {
  final String text;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? borderColor;
  final Color? textColor;
  final double? borderRadius;

  const NoItemsFound({
    super.key,
    required this.text,
    this.padding,
    this.margin,
    this.borderColor,
    this.textColor,
    this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin ?? const EdgeInsets.symmetric(vertical: 16),
      padding:
          padding ?? const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
      decoration: BoxDecoration(
        border: Border.all(
          color:
              borderColor ??
              Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
        ),
        borderRadius: BorderRadius.circular(borderRadius ?? 8),
      ),
      child: Center(
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color:
                textColor ??
                Theme.of(context).textTheme.bodyMedium?.color?.withOpacity(0.6),
          ),
        ),
      ),
    );
  }
}
