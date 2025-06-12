import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        "Hello Pi Pi! 👋",
        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
      ),
      leading: IconButton(
        icon: Icon(Icons.calendar_month, size: 28),
        onPressed: () => Navigator.pushNamed(context, '/calendar'),
      ),
      actions: [
        TextButton(
          style: TextButton.styleFrom(
            backgroundColor: Colors.amberAccent,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          onPressed: () {
            Navigator.pushNamed(context, '/premium');
          },
          child: Text(
            'Upgrade',
            style: TextStyle(
              color: Colors.black87,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        IconButton(
          icon: Icon(
            Icons.local_fire_department,
            size: 28,
            color: Colors.lightBlue,
          ),
          onPressed: () => Navigator.pushNamed(context, '/streaks'),
        ),
      ],
    );
  }
}
