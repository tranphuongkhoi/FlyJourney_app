import 'package:flutter/material.dart';
import 'package:cnh_n/src/core/widgets/expandable_destination_card.dart';

class ExploreScreen extends StatelessWidget {
  const ExploreScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA), // Homepage background color
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Khám phá',
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Điểm đến nổi bật',
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 20),
            _buildDestinationCard(
              'Kuala Lumpur',
              'Malaysia',
              'Thủ đô sôi động với những tòa tháp đôi Petronas biểu tượng, khu phố ẩm thực đa dạng và trung tâm mua sắm hiện đại. Khám phá sự pha trộn độc đáo giữa văn hóa Mã Lai, Trung Hoa và Ấn Độ.',
              '🏙️ Thành phố • 🌟 4.5/5 • 🌡️ Nhiệt đới nóng ẩm',
              [Colors.red.shade200, Colors.red.shade400],
              Icons.location_city,
            ),
            const SizedBox(height: 16),
            _buildDestinationCard(
              'Phú Quốc',
              'Việt Nam',
              'Đảo ngọc xinh đẹp với bãi biển cát trắng mịn màng, nước biển trong xanh và những resort sang trọng. Nổi tiếng với chợ đêm hải sản tươi ngon và cáp treo Hòn Thơm dài nhất thế giới.',
              '🏝️ Đảo • 🌟 4.7/5 • 🌡️ Nhiệt đới gió mùa',
              [Colors.teal.shade200, Colors.teal.shade400],
              Icons.beach_access,
            ),
            const SizedBox(height: 16),
            _buildDestinationCard(
              'Đà Nẵng',
              'Việt Nam',
              'Thành phố biển năng động với cầu Vàng nổi tiếng thế giới, Bà Nà Hills huyền ảo và bãi biển Mỹ Khê tuyệt đẹp. Điểm dừng chân lý tưởng để khám phá Hội An và Huế cổ kính.',
              '🌊 Biển • 🌟 4.6/5 • 🌡️ Cận nhiệt đới ôn hòa',
              [Colors.orange.shade200, Colors.orange.shade400],
              Icons.waves,
            ),
            const SizedBox(height: 16),
            _buildDestinationCard(
              'Đà Lạt',
              'Việt Nam',
              'Thành phố ngàn hoa với khí hậu mát mẻ quanh năm, những đồi chè xanh mướt và hồ Xuân Hương thơ mộng. Lý tưởng cho những ai yêu thích không khí trong lành và cảnh sắc lãng mạn.',
              '🌸 Cao nguyên • 🌟 4.8/5 • 🌡️ Ôn đới mát mẻ',
              [Colors.green.shade200, Colors.green.shade400],
              Icons.local_florist,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildDestinationCard(
    String name,
    String country,
    String description,
    String info,
    List<Color> gradientColors,
    IconData icon,
  ) {
    return ExpandableDestinationCard(
      name: name,
      country: country,
      description: description,
      info: info,
      gradientColors: gradientColors,
      icon: icon,
    );
  }
}
