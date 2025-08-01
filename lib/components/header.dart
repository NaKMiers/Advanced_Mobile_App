import 'package:advanced_mobile_app/components/providers/auth_provider.dart';
import 'package:advanced_mobile_app/utils/string.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;

    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      automaticallyImplyLeading: false,
      titleSpacing: 0,
      title: LayoutBuilder(
        builder: (context, constraints) {
          return Align(
            alignment: Alignment.center,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 980),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.calendar_month,
                      size: 28,
                      color: Theme.of(context).colorScheme.onPrimary,
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/calendar'),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      "Hello ${shortName(user)} 👋",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                    ),
                  ),
                  if (!authProvider.isPremium)
                    TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: Colors.amberAccent,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 8,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        Navigator.pushNamed(context, '/premium');
                      },
                      child: const Text(
                        'Upgrade',
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  IconButton(
                    icon: const Icon(
                      Icons.local_fire_department,
                      size: 28,
                      color: Colors.lightBlue,
                    ),
                    onPressed: () => Navigator.pushNamed(context, '/streaks'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
