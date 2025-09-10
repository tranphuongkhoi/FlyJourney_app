import 'package:flutter/material.dart';
import 'package:fly_journey/src/core/widgets/header.dart';
import 'package:fly_journey/src/core/widgets/footer.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA), // Homepage background color
      appBar: const Header(),
      body: const Center(child: Text("News Page Content")),
      bottomNavigationBar: const Footer(),
    );
  }
}
