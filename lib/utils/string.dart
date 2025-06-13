import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

// Currencies constant (adjust based on your constants/settings)
const List<Map<String, String>> currencies = [
  {'value': 'USD', 'symbol': '\$', 'locale': 'en-US'},
  {'value': 'EUR', 'symbol': '€', 'locale': 'fr-FR'},
  {'value': 'GBP', 'symbol': '£', 'locale': 'en-GB'},
  {'value': 'VND', 'symbol': '₫', 'locale': 'vi-VN'},
];

// Get short name from user (name, username, or email prefix)
String shortName(dynamic user, {String defaultValue = ''}) {
  if (user == null) return defaultValue;
  if (user.name != null && user.name.isNotEmpty) return user.name;
  if (user.username != null && user.username.isNotEmpty) return user.username;
  if (user.email != null && user.email.isNotEmpty) {
    return user.email.split('@')[0];
  }
  return defaultValue;
}

// Get currency symbol
String formatSymbol(String currency) {
  return currencies.firstWhere(
    (c) => c['value'] == currency,
    orElse: () => {'symbol': ''},
  )['symbol']!;
}

// Format amount as currency
String formatCurrency(String currency, double amount) {
  final locale = currencies.firstWhere(
    (c) => c['value'] == currency,
    orElse: () => {'locale': 'en-US'},
  )['locale']!;
  return NumberFormat.currency(
    locale: locale,
    symbol: formatSymbol(currency),
    decimalDigits: amount % 1 == 0 ? 0 : 2,
  ).format(amount);
}

// Parse currency string to number
double parseCurrency(String currency) {
  return double.parse(currency.replaceAll(RegExp(r'\D+'), ''));
}

// Format price with locale and currency code
String formatPrice({
  double price = 0,
  String locale = 'en-US',
  String currencyCode = 'USD',
}) {
  return NumberFormat.currency(
    locale: locale,
    symbol: formatSymbol(currencyCode),
  ).format(price);
}

// Format number in compact form (e.g., 1000 -> 1k, 1500 -> 1.5k)
String formatCompactNumber(double num) {
  if (num.abs() >= 1e6) {
    return '${(num / 1e6).toStringAsFixed(1)}M';
  } else if (num.abs() >= 1e3) {
    return '${(num / 1e3).toStringAsFixed(num % 100 == 0 ? 0 : 1)}k';
  }
  return num.toStringAsFixed(num % 1 == 0 ? 0 : 1);
}

// Capitalize first letter of string
String capitalize(String str) {
  if (str.isEmpty) return str;
  return str[0].toUpperCase() + str.substring(1);
}

// Decode emoji from unified code
String decodeEmoji(String unified) {
  return String.fromCharCodes(
    unified.split('-').map((code) => int.parse(code, radix: 16)),
  );
}

// Transaction display options
const Map<String, Map<String, dynamic>> tranOptions = {
  'income': {
    'icon': Icons.trending_up,
    'color': Colors.green,
    'background': Color(0xFF064E3B), // Emerald-950
    'border': Colors.green,
    'hex': '0xFF10B981',
  },
  'expense': {
    'icon': Icons.trending_down,
    'color': Colors.red,
    'background': Color(0xFF4C0519), // Rose-900
    'border': Colors.red,
    'hex': '0xFFF43F5E',
  },
  'saving': {
    'icon': Icons.savings,
    'color': Colors.yellow,
    'background': Color(0xFF422006), // Yellow-950
    'border': Colors.yellow,
    'hex': '0xFFEAB308',
  },
  'invest': {
    'icon': Icons.bar_chart,
    'color': Colors.purple,
    'background': Color(0xFF2E1065), // Violet-950
    'border': Colors.purple,
    'hex': '0xFF8B5CF6',
  },
  'balance': {
    'icon': Icons.account_balance_wallet,
    'color': Colors.blue,
    'background': Color(0xFF082F49), // Sky-950
    'border': Colors.blue,
    'hex': '0xFF0EA5E9',
  },
  'transfer': {
    'icon': Icons.swap_horiz,
    'color': Colors.indigo,
    'background': Color(0xFF1E1B4B), // Indigo-950
    'border': Colors.indigo,
    'hex': '0xFF6366F1',
  },
};

// Check transaction type
Map<String, dynamic> checkTranType(String type) {
  return tranOptions[type] ?? tranOptions['balance']!;
}

// Level colors
const Map<String, Map<String, dynamic>> levelColors = {
  'hard': {'text': Colors.red, 'background': Colors.red, 'hex': '0xFFF43F5E'},
  'medium': {
    'text': Colors.yellow,
    'background': Colors.yellow,
    'hex': '0xFFEAB308',
  },
  'easy': {
    'text': Colors.green,
    'background': Colors.green,
    'hex': '0xFF10B981',
  },
};

// Check level based on thresholds
Map<String, dynamic> checkLevel(
  double level, {
  List<double> levels = const [50, 80, 100],
}) {
  if (level <= levels[0]) return levelColors['easy']!;
  if (level <= levels[1]) return levelColors['medium']!;
  return levelColors['hard']!;
}

// Adjust currency input (add thousand separators)
String adjustCurrency(String input, String locale) {
  final numericValue = input.replaceAll(RegExp(r'\D'), '');
  return NumberFormat(
    '#,##0',
    locale,
  ).format(int.parse(numericValue.isEmpty ? '0' : numericValue));
}

// Revert adjusted currency to number
double revertAdjustedCurrency(String input, String locale) {
  final formatter = NumberFormat('#,##0', locale);
  final groupSeparator = formatter.symbols.GROUP_SEP;
  final decimalSeparator = formatter.symbols.DECIMAL_SEP;

  final cleaned = input
      .replaceAll(groupSeparator, '')
      .replaceAll(decimalSeparator, '.');
  return double.tryParse(cleaned) ?? 0;
}

// Truncate text with ellipsis
String ellipsis(String text, {int length = 100}) {
  if (text.length <= length) return text;
  return '${text.substring(0, length)}...';
}
