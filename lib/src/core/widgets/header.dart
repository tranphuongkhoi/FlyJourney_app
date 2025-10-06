import 'package:flutter/material.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('FlyJourney'),
      actions: [
        TextButton(
            onPressed: () => Navigator.pushNamed(context, '/'),
            child: const Text("Home")),
        TextButton(
            onPressed: () => Navigator.pushNamed(context, '/search'),
            child: const Text("Search")),
        TextButton(
            onPressed: () => Navigator.pushNamed(context, '/booking'),
            child: const Text("Booking")),
        TextButton(
            onPressed: () => Navigator.pushNamed(context, '/news'),
            child: const Text("News")),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
