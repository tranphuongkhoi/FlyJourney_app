import 'package:flutter/material.dart';
import 'package:cnh_n/screens/flight_search_step1_screen.dart';
import 'package:cnh_n/screens/notifications_screen.dart';
import 'package:cnh_n/constants/colors.dart';
import 'package:cnh_n/widgets/hero_slider.dart';
import 'package:cnh_n/config/api_config.dart';

class HomePage extends StatefulWidget {
  final Function(String)? onNavigateToExplore;
  
  const HomePage({super.key, this.onNavigateToExplore});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            // Dev Mode Info Banner
            if (ApiConfig.isDevMode) _buildDevInfoBanner(),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // Hero Slider
                    const HeroSlider(),
                    
                    // Search Section
                    Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 24),
                          _buildSearchButton(),
                          const SizedBox(height: 32),
                          _buildQuickActions(),
                          const SizedBox(height: 32),
                          _buildDestinationSection(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Hero(
            tag: 'fly_journey_logo',
            child: Material(
              color: Colors.transparent,
              child: const Text(
                'Fly Journey',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: const Icon(
                Icons.notifications_outlined,
                color: Color(0xFF6B7280),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchButton() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.primaryBlue, AppColors.primaryBlueLight],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.flight_takeoff,
              color: Colors.white,
              size: 40,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Tìm kiếm chuyến bay',
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Khám phá vẻ đẹp Việt Nam với những chuyến bay giá rẻ nhất',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FlightSearchStep1Screen(),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, size: 20),
                  SizedBox(width: 12),
                  Text(
                    'Bắt đầu tìm kiếm',
                    style: TextStyle(
                      fontFamily: 'BalooBhaijaan2',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Dịch vụ tiện ích',
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildQuickActionCard(
                Icons.airplane_ticket,
                'Check-in\nOnline',
                'Thực hiện check-in\nnhanh chóng',
                AppColors.primaryBlue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                Icons.luggage,
                'Hành lý\nThêm',
                'Mua thêm hành lý\nký gửi',
                AppColors.primaryBlue,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildQuickActionCard(
                Icons.support_agent,
                'Hỗ trợ\n24/7',
                'Liên hệ hỗ trợ\nkhách hàng',
                AppColors.primaryBlue,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickActionCard(IconData icon, String title, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: color.withOpacity(0.2),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: color,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 10,
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }


  Widget _buildDestinationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Điểm đến ',
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const Text(
              'tuyệt vời',
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryBlue,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          'Khám phá vẻ đẹp thiên nhiên và văn hóa phong phú của đất nước Việt Nam',
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 20),
        // 2x2 Grid
        Column(
          children: [
            // Row 1: Kuala Lumpur and Phú Quốc
            Row(
              children: [
                Expanded(
                  child: _buildDestinationCard(
                    'Kuala Lumpur',
                    'assets/images/kuala_lumpur.jpg',
                    [Colors.red.shade200, Colors.red.shade400], // Màu đỏ nhạt - Malaysia
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDestinationCard(
                    'Phú Quốc',
                    'assets/images/phu_quoc.jpg',
                    [Colors.teal.shade200, Colors.teal.shade400], // Màu xanh ngọc - biển đảo
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            // Row 2: Đà Nẵng and Đà Lạt
            Row(
              children: [
                Expanded(
                  child: _buildDestinationCard(
                    'Đà Nẵng',
                    'assets/images/da_nang.jpg',
                    [Colors.orange.shade200, Colors.orange.shade400], // Màu cam nhạt - miền Trung
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildDestinationCard(
                    'Đà Lạt',
                    'assets/images/da_lat.jpg',
                    [Colors.green.shade200, Colors.green.shade400], // Màu xanh lá - cao nguyên
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDestinationCard(String name, String imagePath, List<Color> gradientColors) {
    return GestureDetector(
      onTap: () {
        if (widget.onNavigateToExplore != null) {
          widget.onNavigateToExplore!(name);
        }
      },
      child: Container(
        width: (MediaQuery.of(context).size.width - 64) / 2, // Dynamic width for 2 cards per row
        height: 100, // Much shorter height for rectangular shape
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12), // Slightly rounded corners
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              gradientColors[1], // Đậm hơn ở trên
              gradientColors[0], // Nhạt hơn ở dưới
            ],
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Stack(
        children: [
          Positioned(
            bottom: 12,
            left: 16,
            child: Text(
              name,
              style: const TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      ),
    );
  }

  Widget _buildDevInfoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.orange.shade100,
      child: Row(
        children: [
          Icon(
            Icons.developer_mode,
            color: Colors.orange.shade800,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'DEV MODE: ${ApiConfig.currentDevPreset} | ${ApiConfig.currentDevInfo}',
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.orange.shade800,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Dev Mode Info'),
                  content: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Current Preset: ${ApiConfig.currentDevPreset}'),
                      const SizedBox(height: 8),
                      Text('Data Info: ${ApiConfig.currentDevInfo}'),
                      const SizedBox(height: 8),
                      Text('Dates: ${ApiConfig.currentDevDates.join(' → ')}'),
                      const SizedBox(height: 8),
                      const Text('Available Presets:'),
                      ...ApiConfig.devDataDates.entries.map((entry) => 
                        Text('• ${entry.key}: ${entry.value.join(' → ')}')
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('OK'),
                    ),
                  ],
                ),
              );
            },
            child: Icon(
              Icons.info_outline,
              color: Colors.orange.shade800,
              size: 16,
            ),
          ),
        ],
      ),
    );
  }
}
