import 'package:flutter/material.dart';
import 'package:fly_journey/src/core/widgets/expandable_destination_card.dart';

class ExploreScreen extends StatefulWidget {
  final String? selectedDestination;
  
  const ExploreScreen({super.key, this.selectedDestination});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  String? _currentExpandedCard;

  @override
  void initState() {
    super.initState();
    // If a destination is selected from homepage, expand it initially
    _currentExpandedCard = widget.selectedDestination;
  }

  void _onCardTapped(String cardName) {
    setState(() {
      // If the same card is tapped, collapse it. Otherwise, expand the new one
      _currentExpandedCard = _currentExpandedCard == cardName ? null : cardName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Same as MyBookingsScreen
      body: SafeArea(
        top: false,
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Điểm đến nổi bật',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 28, // Increased from 24 to 28
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 20),
              ..._buildDestinationCards(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildDestinationCards() {
    // Define all destinations
    final destinations = [
      {
        'name': 'Kuala Lumpur',
        'country': 'Malaysia',
        'description': 'Thủ đô sôi động với những tòa tháp đôi Petronas biểu tượng, khu phố ẩm thực đa dạng và trung tâm mua sắm hiện đại. Khám phá sự pha trộn độc đáo giữa văn hóa Mã Lai, Trung Hoa và Ấn Độ.',
        'info': '🏙️ Thành phố • 🌟 4.5/5 • 🌡️ Nhiệt đới nóng ẩm',
        'colors': [Colors.red.shade200, Colors.red.shade400],
        'icon': Icons.location_city,
      },
      {
        'name': 'Phú Quốc',
        'country': 'Việt Nam',
        'description': 'Đảo ngọc xinh đẹp với bãi biển cát trắng mịn màng, nước biển trong xanh và những resort sang trọng. Nổi tiếng với chợ đêm hải sản tươi ngon và cáp treo Hòn Thơm dài nhất thế giới.',
        'info': '🏝️ Đảo • 🌟 4.7/5 • 🌡️ Nhiệt đới gió mùa',
        'colors': [Colors.teal.shade200, Colors.teal.shade400],
        'icon': Icons.beach_access,
      },
      {
        'name': 'Đà Nẵng',
        'country': 'Việt Nam',
        'description': 'Thành phố biển năng động với cầu Vàng nổi tiếng thế giới, Bà Nà Hills huyền ảo và bãi biển Mỹ Khê tuyệt đẹp. Điểm dừng chân lý tưởng để khám phá Hội An và Huế cổ kính.',
        'info': '🌊 Biển • 🌟 4.6/5 • 🌡️ Cận nhiệt đới ôn hòa',
        'colors': [Colors.orange.shade200, Colors.orange.shade400],
        'icon': Icons.waves,
      },
      {
        'name': 'Đà Lạt',
        'country': 'Việt Nam',
        'description': 'Thành phố ngàn hoa với khí hậu mát mẻ quanh năm, những đồi chè xanh mướt và hồ Xuân Hương thơ mộng. Lý tưởng cho những ai yêu thích không khí trong lành và cảnh sắc lãng mạn.',
        'info': '🌸 Cao nguyên • 🌟 4.8/5 • 🌡️ Ôn đới mát mẻ',
        'colors': [Colors.green.shade200, Colors.green.shade400],
        'icon': Icons.local_florist,
      },
      {
        'name': 'Hà Nội',
        'country': 'Việt Nam',
        'description': 'Thủ đô nghìn năm văn hiến với Hồ Gươm thơ mộng, phố cổ với 36 phố phường đặc trưng và những di tích lịch sử như Văn Miếu, Lăng Bác. Nổi tiếng với ẩm thực đường phố phong phú như phở, bún chả, bánh mì và café vỉa hè đậm chất Hà Nội.',
        'info': '🏛️ Thủ đô • 🌟 4.6/5 • 🌡️ Cận nhiệt đới gió mùa',
        'colors': [Colors.amber.shade200, Colors.amber.shade500],
        'icon': Icons.account_balance,
      },
      {
        'name': 'Bangkok',
        'country': 'Thái Lan',
        'description': 'Thành phố thiên thần với những ngôi chùa vàng óng ả như Wat Pho, Wat Arun và cung điện hoàng gia lộng lẫy. Trải nghiệm chợ nổi Damnoen Saduak, thưởng thức món tom yum, pad thai authentic và tận hưởng massage Thái truyền thống. Khu phố Khao San và Chatuchak mang đến trải nghiệm mua sắm độc đáo.',
        'info': '🛕 Văn hóa • 🌟 4.4/5 • 🌡️ Nhiệt đới nóng ẩm',
        'colors': [Colors.deepOrange.shade200, Colors.deepOrange.shade400],
        'icon': Icons.temple_buddhist,
      },
      {
        'name': 'Đài Bắc',
        'country': 'Đài Loan',
        'description': 'Thành phố hiện đại với tòa nhà Taipei 101 biểu tượng và những khu chợ đêm sầm uất như Shilin, Raohe. Khám phá bảo tàng cung đình quốc gia với kho tàng nghệ thuật Trung Hoa, tắm suối nước nóng Beitou và thưởng thức trà sữa trân châu chính gốc cùng với dimsum, xiaolongbao tuyệt hậu.',
        'info': '🌃 Hiện đại • 🌟 4.7/5 • 🌡️ Cận nhiệt đới ẩm',
        'colors': [Colors.purple.shade200, Colors.purple.shade400],
        'icon': Icons.business,
      },
      {
        'name': 'Tokyo',
        'country': 'Nhật Bản',
        'description': 'Thủ đô năng động nơi truyền thống và hiện đại hòa quyện. Từ những ngôi đền cổ kính Senso-ji, Meiji đến khu phố công nghệ Shibuya, Akihabara. Trải nghiệm văn hóa anime, manga tại Harajuku, thưởng thức sushi, ramen chính hiệu và ngắm hoa anh đào ở công viên Ueno. Shinjuku và Ginza mang đến cuộc sống đêm sôi động.',
        'info': '🗾 Truyền thống • 🌟 4.9/5 • 🌡️ Ôn đới lục địa',
        'colors': [Colors.pink.shade200, Colors.pink.shade400],
        'icon': Icons.temple_hindu,
      },
      {
        'name': 'New York',
        'country': 'Hoa Kỳ',
        'description': 'Thành phố không bao giờ ngủ với những địa danh nổi tiếng thế giới như Tượng Nữ thần Tự do, Times Square rực rỡ và Central Park xanh mướt. Khám phá các bảo tàng hàng đầu thế giới như MET, MoMA, thưởng thức Broadway shows và tận hưởng ẩm thực đa văn hóa từ pizza New York, bagel đến những nhà hàng Michelin danh tiếng.',
        'info': '🗽 Đô thị • 🌟 4.8/5 • 🌡️ Lục địa ôn đới',
        'colors': [Colors.indigo.shade200, Colors.indigo.shade400],
        'icon': Icons.location_city_outlined,
      },
    ];

    // Sort destinations: selected one first, others follow
    final sortedDestinations = List<Map<String, dynamic>>.from(destinations);
    if (widget.selectedDestination != null) {
      final selectedIndex = sortedDestinations.indexWhere(
        (dest) => dest['name'] == widget.selectedDestination,
      );
      if (selectedIndex != -1) {
        final selectedDest = sortedDestinations.removeAt(selectedIndex);
        sortedDestinations.insert(0, selectedDest);
      }
    }

    // Build cards with spacing
    final cards = <Widget>[];
    for (int i = 0; i < sortedDestinations.length; i++) {
      final dest = sortedDestinations[i];
      final isExpanded = dest['name'] == _currentExpandedCard;
      
      cards.add(
        _buildDestinationCard(
          dest['name'] as String,
          dest['country'] as String,
          dest['description'] as String,
          dest['info'] as String,
          dest['colors'] as List<Color>,
          dest['icon'] as IconData,
          initiallyExpanded: isExpanded,
          onTap: () => _onCardTapped(dest['name'] as String),
        ),
      );
      
      if (i < sortedDestinations.length - 1) {
        cards.add(const SizedBox(height: 16));
      }
    }
    
    return cards;
  }

  Widget _buildDestinationCard(
    String name,
    String country,
    String description,
    String info,
    List<Color> gradientColors,
    IconData icon, {
    bool initiallyExpanded = false,
    VoidCallback? onTap,
  }) {
    return ExpandableDestinationCard(
      name: name,
      country: country,
      description: description,
      info: info,
      gradientColors: gradientColors,
      icon: icon,
      initiallyExpanded: initiallyExpanded,
      onTap: onTap,
    );
  }
}