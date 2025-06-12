import 'package:flutter/material.dart';

class Slide3 extends StatefulWidget {
  final void Function(Map<String, dynamic>) onChange;

  const Slide3({super.key, required this.onChange});

  @override
  State<Slide3> createState() => _Slide3State();
}

class _Slide3State extends State<Slide3> {
  final List<String> selected = [];

  @override
  Widget build(BuildContext context) {
    final options = [
      "Myself",
      "My partner",
      "Other family members",
      "My friends",
      "My kids",
      "My pets",
    ];

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          children: [
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'Who do you spend money on 🤔?',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                itemCount: options.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = options[index];
                  final isSelected = selected.contains(item);

                  return InkWell(
                    onTap: () {
                      setState(() {
                        isSelected ? selected.remove(item) : selected.add(item);
                      });
                    },
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            item,
                            style: Theme.of(context).textTheme.bodyLarge
                                ?.copyWith(
                                  color: isSelected
                                      ? Theme.of(context).colorScheme.onPrimary
                                      : Theme.of(context).colorScheme.onSurface,
                                ),
                          ),
                          if (isSelected)
                            const Icon(
                              Icons.check_circle,
                              color: Colors.green,
                              size: 20,
                            ),
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
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(56),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                  disabledBackgroundColor: Colors.grey[400],
                ),
                onPressed: selected.isEmpty
                    ? null
                    : () => widget.onChange({
                        'question': 'Who do you spend money on 🤔?',
                        'answer': selected,
                      }),
                child: Text(
                  'Continue',
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
