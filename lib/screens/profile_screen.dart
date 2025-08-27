import 'package:flutter/material.dart';
import 'package:cnh_n/services/auth_service.dart';
import 'package:cnh_n/screens/login_screen.dart';
import 'package:cnh_n/constants/colors.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();

  void _navigateToLogin() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const LoginScreen()),
    );
    setState(() {}); // Refresh UI after returning from login
  }

  void _logout() {
    _authService.logout();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: _authService.isLoggedIn
            ? _buildLoggedInProfile()
            : _buildLoginPrompt(),
      ),
    );
  }

  Widget _buildLoggedInProfile() {
    final user = _authService.currentUser!;
    
    return Column(
      children: [
        // Top bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Hồ sơ',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              IconButton(
                onPressed: _logout,
                icon: const Icon(
                  Icons.logout,
                  color: Color(0xFF6B7280),
                ),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                // Profile card
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Avatar
                      Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      // Name
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontFamily: 'BalooBhaijaan2',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      
                      // Email
                      Text(
                        user.email,
                        style: const TextStyle(
                          fontFamily: 'BalooBhaijaan2',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                
                // Menu items
                _buildMenuItem(Icons.person_outline, 'Thông tin cá nhân', () {}),
                _buildMenuItem(Icons.bookmark_outline, 'Vé đã đặt', () {}),
                _buildMenuItem(Icons.notifications_none, 'Thông báo', () {}),
                _buildMenuItem(Icons.help_outline, 'Hỗ trợ', () {}),
                _buildMenuItem(Icons.settings, 'Cài đặt', () {}),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoginPrompt() {
    return Column(
      children: [
        // Top bar
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
          child: Row(
            children: [
              const Text(
                'Hồ sơ',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 24,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ),
        
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(40.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Icon
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: const Icon(
                        Icons.person_outline,
                        color: AppColors.primaryBlue,
                        size: 40,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Title
                    const Text(
                      'Đăng nhập để tiếp tục',
                      style: TextStyle(
                        fontFamily: 'BalooBhaijaan2',
                        fontSize: 24,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 8),
                    
                    // Description
                    const Text(
                      'Đăng nhập để xem thông tin cá nhân, vé đã đặt và nhiều tính năng khác',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'BalooBhaijaan2',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Login button
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _navigateToLogin,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryBlue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: const Text(
                          'Đăng nhập',
                          style: TextStyle(
                            fontFamily: 'BalooBhaijaan2',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMenuItem(IconData icon, String title, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.03),
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: AppColors.primaryBlue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: Color(0xFF9CA3AF),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
