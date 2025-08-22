import 'package:flutter/material.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Khám phá',
          style: TextStyle(
            fontFamily: 'NataSans',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: const Center(
        child: Text(
          'Khám phá các địa điểm du lịch',
          style: TextStyle(
            fontFamily: 'NataSans',
            fontSize: 16,
            color: Color(0xFF64748B),
          ),
        ),
      ),
    );
  }
}
