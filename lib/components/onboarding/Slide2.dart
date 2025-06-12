import 'package:flutter/material.dart';

class Slide2 extends StatelessWidget {
  final void Function(Map<String, String>) onChange;

  const Slide2({super.key, required this.onChange});

  @override
  Widget build(BuildContext context) {
    final answers = [
      "It's pretty complicated 😶‍🌫️",
      "I'm a bit stressed 😓",
      "Not sure yet 🤔",
      "I want to improve 😉",
      "I feel confident 😊",
    ];

    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          children: [
            const SizedBox(height: 32),
            Container(
              height: 150,
              width: double.infinity,
              clipBehavior: Clip.hardEdge,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 12,
                    color: Colors.black12,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Image.asset(
                'assets/images/onboarding2.png',
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Text(
                'How do you feel about your finances?',
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
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                itemCount: answers.length,
                separatorBuilder: (_, __) => const SizedBox(height: 12),
                itemBuilder: (context, index) {
                  final item = answers[index];
                  return InkWell(
                    onTap: () => onChange({
                      'question': 'How do you feel about your finances?',
                      'answer': item,
                    }),
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      height: 56,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item,
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
