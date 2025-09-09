import 'package:flutter/material.dart';
import 'package:cnh_n/screens/home_screen.dart';
import 'package:cnh_n/screens/explore_screen.dart';
import 'package:cnh_n/screens/my_bookings_screen.dart';
import 'package:cnh_n/screens/profile_screen.dart';
import 'package:cnh_n/constants/colors.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  
  const MainScreen({super.key, this.initialIndex = 0});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late int _currentIndex;
  String? _selectedDestination;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  List<Widget> get _screens => [
    HomePage(onNavigateToExplore: (destination) {
      setState(() {
        _selectedDestination = destination;
        _currentIndex = 1;
      });
    }),
    ExploreScreen(selectedDestination: _selectedDestination),
    MyBookingsScreen(onNavigateToSearch: () {
      setState(() {
        _currentIndex = 0; // Navigate to Home tab
        _selectedDestination = null; // Reset selected destination
      });
    }),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildNavItem(0, Icons.home_outlined, Icons.home, 'Trang chủ'),
                _buildNavItem(1, Icons.explore_outlined, Icons.explore, 'Khám phá'),
                _buildNavItem(2, Icons.bookmark_outline, Icons.bookmark, 'Vé của tôi'),
                _buildNavItem(3, Icons.person_outline, Icons.person, 'Hồ sơ'),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index, IconData outlineIcon, IconData filledIcon, String label) {
    final isSelected = _currentIndex == index;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _currentIndex = index;
          // Reset selected destination when navigating to explore directly
          if (index == 1) {
            _selectedDestination = null;
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? filledIcon : outlineIcon,
              color: isSelected ? AppColors.primaryBlue : const Color(0xFF6B7280),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected ? AppColors.primaryBlue : const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
