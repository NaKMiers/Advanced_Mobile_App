import 'package:flutter/material.dart';

class Slide1 extends StatelessWidget {
  final void Function(Map<String, String>) onChange;

  const Slide1({super.key, required this.onChange});

  @override
  Widget build(BuildContext context) {
    final answers = [
      'YouTube',
      'TikTok',
      'App Store',
      'Online Search',
      'Friend, Family, or Colleague',
      'Influencer',
      'News Article',
      'Podcast',
    ];

    return Column(
      children: [
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Text(
            'How did you hear about us?',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              color: Theme.of(context).colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
            itemCount: answers.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final item = answers[index];
              return InkWell(
                onTap: () => onChange({
                  'question': 'How did you hear about us?',
                  'answer': item,
                }),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).colorScheme.primary,
                    ),
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
    );
  }
}
