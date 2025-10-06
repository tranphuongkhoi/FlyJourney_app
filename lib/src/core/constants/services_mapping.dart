class ServiceMappingItem {
  final String id;
  final String label;
  final int price; // VND, per passenger
  final String? desc;

  const ServiceMappingItem({
    required this.id,
    required this.label,
    required this.price,
    this.desc,
  });
}

class ServiceMapping {
  // Synced with smt.md
  static const List<ServiceMappingItem> all = [
    ServiceMappingItem(
      id: 'seat_selection',
      label: 'Chọn chỗ ngồi',
      price: 150000,
      desc: 'Chọn vị trí ngồi ưa thích',
    ),
    ServiceMappingItem(
      id: 'priority_boarding',
      label: 'Lên máy bay ưu tiên',
      price: 100000,
      desc: 'Ưu tiên lên máy bay trước',
    ),
    ServiceMappingItem(
      id: 'lounge_access',
      label: 'Phòng chờ VIP',
      price: 300000,
      desc: 'Truy cập phòng chờ VIP sân bay',
    ),
    ServiceMappingItem(
      id: 'extra_legroom',
      label: 'Ghế khoang rộng',
      price: 250000,
      desc: 'Ghế có khoảng chân rộng hơn',
    ),
    ServiceMappingItem(
      id: 'wifi',
      label: 'WiFi trên máy bay',
      price: 80000,
      desc: 'Truy cập internet trong chuyến bay',
    ),
    ServiceMappingItem(
      id: 'meal_upgrade',
      label: 'Nâng cấp suất ăn',
      price: 200000,
      desc: 'Suất ăn cao cấp với menu đặc biệt',
    ),
    ServiceMappingItem(
      id: 'fast_track',
      label: 'Fast Track an ninh',
      price: 120000,
      desc: 'Ưu tiên qua cửa an ninh',
    ),
    ServiceMappingItem(
      id: 'travel_insurance',
      label: 'Bảo hiểm du lịch',
      price: 50000,
      desc: 'Bảo hiểm cơ bản cho chuyến bay',
    ),
  ];

  static ServiceMappingItem byId(String id) =>
      all.firstWhere((o) => o.id == id, orElse: () => all.first);
}

