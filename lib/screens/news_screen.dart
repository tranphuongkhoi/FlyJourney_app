import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';

class NewsScreen extends StatelessWidget {
  const NewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      body: const Center(child: Text("News Page Content")),
      bottomNavigationBar: const Footer(),
    );
  }
}
