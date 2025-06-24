import 'package:advanced_mobile_app/components/providers/auth_provider.dart';
import 'package:advanced_mobile_app/themes/light_theme.dart';
import 'package:advanced_mobile_app/themes/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final user = authProvider.user;
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isLightTheme = themeProvider.themeData == lightTheme;

    if (authProvider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (user == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Account')),
        body: const Center(child: Text('No user data found.')),
      );
    }

    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () => authProvider.refreshToken(),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Container(
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary,
                  width: 1,
                ),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: user.avatar != null
                      ? NetworkImage(user.avatar!)
                      : null,
                  child: user.avatar == null ? const Icon(Icons.person) : null,
                ),
                title: Text(user.name ?? user.username ?? 'Unnamed'),
                subtitle: Text(user.email),
              ),
            ),
            const SizedBox(height: 16),
            ListTile(
              title: const Text('Premium Status'),
              trailing: Text(
                authProvider.isPremium ? 'Premium' : 'Free',
                style: TextStyle(
                  color: authProvider.isPremium ? Colors.green : Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.wallet),
              title: const Text('Wallets'),
              onTap: () => Navigator.pushNamed(context, '/wallets'),
            ),
            ListTile(
              leading: const Icon(Icons.category),
              title: const Text('Categories'),
              onTap: () => Navigator.pushNamed(context, '/categories'),
            ),
            ListTile(
              leading: Icon(
                isLightTheme ? Icons.wb_sunny : Icons.nightlight_round,
              ),
              title: const Text('Theme'),
              trailing: Switch(
                value: isLightTheme,
                onChanged: (_) => themeProvider.toggleTheme(),
              ),
            ),

            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('About'),
              onTap: () => Navigator.pushNamed(context, '/more/about'),
            ),
            ListTile(
              leading: const Icon(Icons.support),
              title: const Text('Help & Support'),
              onTap: () =>
                  Navigator.pushNamed(context, '/more/help-and-support'),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.delete_forever, color: Colors.red),
              title: const Text('Delete All Data'),
              onTap: () async => _confirmDelete(context, authProvider),
            ),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: const Text('Log Out'),
              onTap: () async => _confirmLogout(context, authProvider),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(width: 1.5),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,

        title: Text(
          'Delete All Data',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.onSecondary,
          ),
        ),
        content: Text(
          'Are you sure you want to delete all your data? This action is irreversible.',
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
            },
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context, AuthProvider authProvider) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(width: 1.5),
        ),
        backgroundColor: Theme.of(context).colorScheme.secondary,

        title: Text(
          'Log Out',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onSecondary,
            fontWeight: FontWeight.bold,
          ),
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: TextStyle(color: Theme.of(context).colorScheme.onSecondary),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await authProvider.logout();
              Navigator.pushReplacementNamed(context, '/auth/sign-in');
            },
            child: const Text('Log Out', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
