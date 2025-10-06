import 'package:flutter/material.dart';
import 'package:fly_journey/src/core/constants/colors.dart';

class HeroSlider extends StatefulWidget {
  const HeroSlider({super.key});

  @override
  State<HeroSlider> createState() => _HeroSliderState();
}

class _HeroSliderState extends State<HeroSlider> {
  final PageController _pageController = PageController();
  int _currentIndex = 0;

  final List<SlideData> _slides = [
    SlideData(
      title: 'Bay Khắp Việt Nam',
      subtitle: 'Giá Rẻ - Chon Ngay\nHôm Nay',
      description: 'Khám phá vẻ đẹp Việt Nam với những chuyến bay giá rẻ nhất. Đặt vé dễ dàng, bay thoải mái!',
      location: 'Đà Nẵng • Đà Nẵng Hiện Đại',
      colors: [Color(0xFF1E3A8A), Color(0xFF3B82F6)], // Blue gradient
      imagePath: 'assets/images/danang_hero.jpg', // Placeholder
    ),
    SlideData(
      title: 'Khám Phá Phú Quốc',
      subtitle: 'Thiên Đường\nBiển Đảo',
      description: 'Trải nghiệm kỳ nghỉ tuyệt vời tại đảo ngọc Phú Quốc với những bãi biển xanh trong.',
      location: 'Phú Quốc • Kiên Giang',
      colors: [Color(0xFF059669), Color(0xFF10B981)], // Green gradient
      imagePath: 'assets/images/phuquoc_hero.jpg', // Placeholder
    ),
    SlideData(
      title: 'Hà Nội Cổ Kính',
      subtitle: 'Nghìn Năm\nVăn Hiến',
      description: 'Khám phá thủ đô với những di tích lịch sử và văn hóa độc đáo của Việt Nam.',
      location: 'Hà Nội • Thủ Đô',
      colors: [Color(0xFFB45309), Color(0xFFF59E0B)], // Orange gradient
      imagePath: 'assets/images/hanoi_hero.jpg', // Placeholder
    ),
  ];

  @override
  void initState() {
    super.initState();
    _startAutoSlide();
  }

  void _startAutoSlide() {
    Future.delayed(const Duration(seconds: 5), () {
      if (mounted) {
        _nextSlide();
        _startAutoSlide();
      }
    });
  }

  void _nextSlide() {
    if (_currentIndex < _slides.length - 1) {
      _currentIndex++;
    } else {
      _currentIndex = 0;
    }
    _pageController.animateToPage(
      _currentIndex,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 380,
      child: Stack(
        children: [
          // Slider Pages
          PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            itemCount: _slides.length,
            itemBuilder: (context, index) {
              return _buildSlide(_slides[index]);
            },
          ),

          // Dots Indicator
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(_slides.length, (index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: _currentIndex == index ? 24 : 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: _currentIndex == index 
                        ? Colors.white 
                        : Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                );
              }),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSlide(SlideData slide) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: slide.colors,
        ),
      ),
      child: Stack(
        children: [
          // Background Pattern
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withOpacity(0.3),
                    Colors.black.withOpacity(0.6),
                  ],
                ),
              ),
            ),
          ),

          // Content
          Positioned.fill(
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Spacer(),
                    
                    // Main Title
                    Text(
                      slide.title,
                      style: const TextStyle(
                        fontFamily: 'BalooBhaijaan2',
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        height: 1.1,
                      ),
                    ),
                    
                    // Subtitle with highlight
                    RichText(
                      text: TextSpan(
                        children: [
                          TextSpan(
                            text: slide.subtitle.split('\n')[0],
                            style: const TextStyle(
                              fontFamily: 'BalooBhaijaan2',
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFFBBF24), // Yellow highlight
                              height: 1.1,
                            ),
                          ),
                          TextSpan(
                            text: '\n${slide.subtitle.split('\n')[1]}',
                            style: const TextStyle(
                              fontFamily: 'BalooBhaijaan2',
                              fontSize: 26,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFFFBBF24), // Yellow highlight
                              height: 1.1,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 16),
                    
                    // Description
                    Container(
                      constraints: const BoxConstraints(maxWidth: 360),
                      child: Text(
                        slide.description,
                        style: const TextStyle(
                          fontFamily: 'BalooBhaijaan2',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: Colors.white,
                          height: 1.5,
                        ),
                      ),
                    ),
                    
                    const SizedBox(height: 24),
                    
                    // Location
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Colors.white,
                          size: 18,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          slide.location,
                          style: const TextStyle(
                            fontFamily: 'BalooBhaijaan2',
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                    
                    const Spacer(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class SlideData {
  final String title;
  final String subtitle;
  final String description;
  final String location;
  final List<Color> colors;
  final String imagePath;

  SlideData({
    required this.title,
    required this.subtitle,
    required this.description,
    required this.location,
    required this.colors,
    required this.imagePath,
  });
}
