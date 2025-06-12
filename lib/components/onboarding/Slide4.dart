import 'package:flutter/material.dart';

class CurrencyType {
  final String label;
  final String value;
  final String symbol;
  final String locale;

  const CurrencyType({
    required this.label,
    required this.value,
    required this.symbol,
    required this.locale,
  });
}

// Replace this with your actual currency data
const defaultCurrency = CurrencyType(
  label: 'United States Dollar',
  value: 'USD',
  symbol: '\$',
  locale: 'en-US',
);

const List<CurrencyType> currencies = [
  CurrencyType(
    label: 'United States Dollar',
    value: 'USD',
    symbol: '\$',
    locale: 'en-US',
  ),
  CurrencyType(label: 'Euro', value: 'EUR', symbol: '€', locale: 'fr-FR'),
  CurrencyType(
    label: 'Japanese Yen',
    value: 'JPY',
    symbol: '¥',
    locale: 'ja-JP',
  ),
  CurrencyType(
    label: 'British Pound',
    value: 'GBP',
    symbol: '£',
    locale: 'en-GB',
  ),
  CurrencyType(
    label: 'Indian Rupee',
    value: 'INR',
    symbol: '₹',
    locale: 'hi-IN',
  ),
];

class Slide4 extends StatefulWidget {
  final void Function(String) onChange;

  const Slide4({super.key, required this.onChange});

  @override
  State<Slide4> createState() => _Slide4State();
}

class _Slide4State extends State<Slide4> {
  CurrencyType selected = defaultCurrency;
  String search = '';

  @override
  Widget build(BuildContext context) {
    final filtered =
        currencies
            .where(
              (c) => (c.label + c.value + c.symbol + c.locale)
                  .toLowerCase()
                  .contains(search.toLowerCase()),
            )
            .toList()
          ..sort((a, b) => a.label.compareTo(b.label));

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          children: [
            const SizedBox(height: 32),
            Text(
              '💸 Which currency do you usually use?',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                onPressed: () {}, // optional toggle logic
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  minimumSize: const Size.fromHeight(48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  selected.label,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: TextField(
                onChanged: (val) => setState(() => search = val),
                decoration: InputDecoration(
                  hintText: 'Find a currency...',
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  filled: true,
                  fillColor: Theme.of(context).colorScheme.surface,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final currency = filtered[index];
                  final isSelected = selected.value == currency.value;

                  return InkWell(
                    onTap: () => setState(() => selected = currency),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      padding: const EdgeInsets.symmetric(
                        vertical: 12,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            currency.label,
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          if (isSelected)
                            const Icon(Icons.check_circle, color: Colors.green),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: ElevatedButton(
                onPressed: selected.value.isEmpty
                    ? null
                    : () => widget.onChange(selected.value),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  minimumSize: const Size.fromHeight(56),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: Text(
                  'Continue',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
