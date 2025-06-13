import 'package:advanced_mobile_app/utils/string.dart';
import 'package:flutter/material.dart';

class OverviewItem extends StatelessWidget {
  final String title;
  final double value;
  final String type;
  final bool showValue;
  final bool isEye;
  final String currency;
  final VoidCallback? toggle;

  const OverviewItem({
    super.key,
    required this.title,
    required this.value,
    required this.type,
    required this.currency,
    this.showValue = false,
    this.isEye = false,
    this.toggle,
  });

  @override
  Widget build(BuildContext context) {
    final iconData = checkTranType(type)['icon'];
    final color = checkTranType(type)['color'];

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(iconData, color: color, size: 24),
              const SizedBox(width: 8),
              if (showValue)
                Text(
                  formatCurrency(currency, value),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                )
              else
                Row(
                  children: List.generate(
                    6,
                    (index) => const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 2),
                      child: Icon(Icons.star, size: 16),
                    ),
                  ),
                ),
              if (isEye)
                IconButton(
                  onPressed: toggle,
                  icon: Icon(
                    showValue ? Icons.remove_red_eye : Icons.visibility_off,
                  ),
                  iconSize: 20,
                ),
            ],
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              color: Colors.grey,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
