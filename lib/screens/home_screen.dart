import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';
import '../widgets/hero_section.dart';
import '../widgets/search_form.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      body: ListView(
        children: const [
          HeroSection(),
          SearchForm(), // chỉ nhúng component, không truy cập state bên trong
        ],
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}
