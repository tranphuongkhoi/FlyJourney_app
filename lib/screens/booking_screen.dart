import 'package:flutter/material.dart';
import '../widgets/header.dart';
import '../widgets/footer.dart';

class BookingScreen extends StatelessWidget {
  const BookingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const Header(),
      body: const Center(child: Text("Booking Page Content")),
      bottomNavigationBar: const Footer(),
    );
  }
}
