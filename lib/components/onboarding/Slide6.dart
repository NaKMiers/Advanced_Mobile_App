import 'package:flutter/material.dart';

class Slide6 extends StatelessWidget {
  final VoidCallback onPress;

  const Slide6({Key? key, required this.onPress}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String t(String key) {
      const translations = {
        'Welcome to the family!': 'Welcome to the family!',
        'We\'re excited to have you here. Let\'s get started on your financial journey together!':
            'We\'re excited to have you here. Let\'s get started on your financial journey together!',
        'Get started now': 'Get started now',
      };
      return translations[key] ?? key;
    }

    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Image Section
            Container(
              height: 200,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              clipBehavior: Clip.hardEdge,
              child: Image.asset(
                'assets/images/onboarding_welcome.png', // Make sure this path is correct
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              t('Welcome to the family!'),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${t("We\'re excited to have you here. Let\'s get started on your financial journey together!")} 🚀',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                onPress();
                Navigator.pushNamed(context, '/auth/sign-up');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).colorScheme.primary,
                foregroundColor: Theme.of(context).colorScheme.onPrimary,
                shape: const StadiumBorder(),
                minimumSize: const Size.fromHeight(56),
                padding: const EdgeInsets.symmetric(horizontal: 24),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    t('Get started now'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.onPrimary,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.arrow_forward,
                      size: 18,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
