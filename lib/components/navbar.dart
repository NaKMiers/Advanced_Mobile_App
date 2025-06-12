import 'package:flutter/material.dart';

class Navbar extends StatelessWidget {
  final int selectedPageIndex;
  final void Function(int) onChangePage;

  const Navbar({
    super.key,
    required this.selectedPageIndex,
    required this.onChangePage,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: selectedPageIndex,
      selectedItemColor: Theme.of(context).colorScheme.primary,
      unselectedItemColor: Colors.grey,
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      onTap: onChangePage,
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home_outlined),
          activeIcon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.swap_horiz_outlined),
          activeIcon: Icon(Icons.swap_horiz),
          label: 'Transactions',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.smart_toy_outlined),
          activeIcon: Icon(Icons.smart_toy),
          label: 'AI',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pie_chart_outline),
          activeIcon: Icon(Icons.pie_chart),
          label: 'Budgets',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person_outline),
          activeIcon: Icon(Icons.person),
          label: 'Account',
        ),
      ],
    );
  }
}
