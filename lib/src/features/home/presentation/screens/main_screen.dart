import 'package:flutter/material.dart';
import 'package:fly_journey/src/features/home/presentation/screens/home_screen.dart';
import 'package:fly_journey/src/features/home/presentation/screens/explore_screen.dart';
import 'package:fly_journey/src/features/booking/presentation/screens/my_bookings_screen.dart';
import 'package:fly_journey/src/features/checkin/presentation/screens/checkin_screen.dart';
import 'package:fly_journey/src/features/auth/presentation/screens/profile_screen.dart';
import 'package:fly_journey/src/core/constants/colors.dart';

class MainScreen extends StatefulWidget {
  final int initialIndex;
  final String?
      initialBookingId; // optional: open specific booking in MyBookings

  const MainScreen({super.key, this.initialIndex = 0, this.initialBookingId});

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
        const CheckinScreen(),
        MyBookingsScreen(
          initialOpenBookingId: widget.initialBookingId,
          onNavigateToSearch: () {
            setState(() {
              _currentIndex = 0; // Navigate to Home tab
              _selectedDestination = null; // Reset selected destination
            });
          },
        ),
        ProfileScreen(
          onNavigateToBookings: () {
            setState(() {
              _currentIndex = 3; // Navigate to MyBookings tab
            });
          },
        ),
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
        child: Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 8.0,
            bottom: MediaQuery.of(context).padding.bottom > 0 ? 16.0 : 20.0,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavItem(0, Icons.home_outlined, Icons.home, 'Trang chủ'),
              _buildNavItem(
                  1, Icons.explore_outlined, Icons.explore, 'Khám phá'),
              _buildNavItem(2, Icons.airplane_ticket_outlined,
                  Icons.airplane_ticket, 'Check-in'),
              _buildNavItem(
                  3, Icons.bookmark_outline, Icons.bookmark, 'Vé của tôi'),
              _buildNavItem(4, Icons.person_outline, Icons.person, 'Hồ sơ'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(
      int index, IconData outlineIcon, IconData filledIcon, String label) {
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
          color: isSelected
              ? AppColors.primaryBlue.withOpacity(0.1)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSelected ? filledIcon : outlineIcon,
              color:
                  isSelected ? AppColors.primaryBlue : const Color(0xFF6B7280),
              size: 24,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: isSelected
                    ? AppColors.primaryBlue
                    : const Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
