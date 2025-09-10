import 'package:flutter/material.dart';
import 'package:fly_journey/src/core/widgets/header.dart';
import 'package:fly_journey/src/core/widgets/footer.dart';

class SearchScreen extends StatelessWidget {
  final String? from;
  final String? to;
  final DateTime? date;

  const SearchScreen({super.key, this.from, this.to, this.date});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      body: Center(
        child: Text("Search Page\nfrom: $from → to: $to\non: ${date ?? 'any'}"),
      ),
      bottomNavigationBar: const Footer(),
    );
  }
}
