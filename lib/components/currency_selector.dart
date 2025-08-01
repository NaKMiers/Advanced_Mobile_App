import 'package:advanced_mobile_app/components/providers/init_provider.dart';
import 'package:advanced_mobile_app/components/providers/settings_provider.dart';
import 'package:advanced_mobile_app/constants/settings.dart';
import 'package:advanced_mobile_app/requests/index.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CurrencySelector extends StatefulWidget {
  const CurrencySelector({super.key});

  @override
  State<CurrencySelector> createState() => _CurrencySelectorState();
}

class _CurrencySelectorState extends State<CurrencySelector> {
  Future<void> handleUpdateCurrency(BuildContext context, String value) async {
    if (value.isEmpty) return;

    // Start loading
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      await updateMySettingsApi({'currency': value});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Update currency successfully'),
          backgroundColor: Colors.green,
        ),
      );

      context.read<InitProvider>().refreshSettings();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update currency: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: context.watch<SettingsProvider>().settings?.currency ?? 'USD',
      decoration: InputDecoration(
        labelText: 'Currency',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 10,
        ),
      ),
      items: (currencies.toList()..sort((a, b) => a.label.compareTo(b.label)))
          .map((currency) {
            return DropdownMenuItem<String>(
              value: currency.value,
              child: Text(currency.label),
            );
          })
          .toList(),
      onChanged: (value) {
        if (value != null) {
          handleUpdateCurrency(context, value);
        }
      },
    );
  }
}
