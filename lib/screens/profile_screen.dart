import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Hồ sơ',
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
          'Thông tin cá nhân',
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
