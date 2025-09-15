import 'package:flutter/material.dart';
import 'package:fly_journey/src/features/search/domain/models/airport.dart';

/// Enum định nghĩa loại địa điểm
enum PlaceType {
  domestic, // Nội địa
  international, // Quốc tế
  popular, // Phổ biến
  capital, // Thủ đô
  beach, // Biển
  mountain, // Núi
  cultural, // Văn hóa
  business, // Thương mại
}

/// Model mở rộng cho Airport với thêm thông tin địa lý và loại địa điểm
class Direction {
  final String code; // Mã IATA của sân bay
  final String name; // Tên sân bay
  final String city; // Tên thành phố
  final String country; // Tên quốc gia
  final String countryCode; // Mã quốc gia
  final List<PlaceType> placeTypes; // Các loại địa điểm
  final double latitude; // Vĩ độ
  final double longitude; // Kinh độ
  final String? timeZone; // Múi giờ
  final String? description; // Mô tả thêm
  final String? imageUrl; // URL hình ảnh đại diện

  const Direction({
    required this.code,
    required this.name,
    required this.city,
    required this.country,
    required this.countryCode,
    required this.placeTypes,
    required this.latitude,
    required this.longitude,
    this.timeZone,
    this.description,
    this.imageUrl,
  });

  // Chuyển đổi Direction sang Airport để tương thích với code hiện có
  Airport toAirport() {
    return Airport(
      code: this.code,
      name: this.name,
      city: this.city,
      country: this.country,
    );
  }

  // Helper method để kiểm tra xem địa điểm này có thuộc loại nào không
  bool isType(PlaceType type) {
    return placeTypes.contains(type);
  }
}

/// Đường bay phổ biến
class PopularRoute {
  final String fromCode; // Mã sân bay đi
  final String toCode; // Mã sân bay đến
  final String label; // Nhãn hiển thị
  final bool isPopular; // Có phải là đường bay phổ biến không
  final int searchCount; // Số lượt tìm kiếm (có thể dùng để sắp xếp)

  const PopularRoute({
    required this.fromCode,
    required this.toCode,
    required this.label,
    this.isPopular = true,
    this.searchCount = 0,
  });
}

/// Danh sách các sân bay quốc tế và nội địa Việt Nam
const List<Direction> kDirections = [
  // Sân bay nội địa Việt Nam
  Direction(
    code: 'HAN',
    name: 'Sân bay Quốc tế Nội Bài',
    city: 'Hà Nội',
    country: 'Việt Nam',
    countryCode: 'VN',
    placeTypes: [
      PlaceType.domestic,
      PlaceType.popular,
      PlaceType.capital,
      PlaceType.cultural
    ],
    latitude: 21.2187149,
    longitude: 105.8019822,
    timeZone: 'Asia/Ho_Chi_Minh',
    description:
        'Sân bay quốc tế lớn nhất miền Bắc Việt Nam, cách trung tâm Hà Nội khoảng 35km.',
    imageUrl: 'https://example.com/images/hanoi.jpg',
  ),
  Direction(
    code: 'SGN',
    name: 'Sân bay Quốc tế Tân Sơn Nhất',
    city: 'TP.HCM',
    country: 'Việt Nam',
    countryCode: 'VN',
    placeTypes: [PlaceType.domestic, PlaceType.popular, PlaceType.business],
    latitude: 10.8184042,
    longitude: 106.6587131,
    timeZone: 'Asia/Ho_Chi_Minh',
    description:
        'Sân bay quốc tế lớn nhất Việt Nam, nằm trong nội thành TP.HCM.',
    imageUrl: 'https://example.com/images/hochiminh.jpg',
  ),
  Direction(
    code: 'DAD',
    name: 'Sân bay Quốc tế Đà Nẵng',
    city: 'Đà Nẵng',
    country: 'Việt Nam',
    countryCode: 'VN',
    placeTypes: [PlaceType.domestic, PlaceType.popular, PlaceType.beach],
    latitude: 16.0563873,
    longitude: 108.1993409,
    timeZone: 'Asia/Ho_Chi_Minh',
    description:
        'Sân bay quốc tế lớn thứ ba của Việt Nam, cách trung tâm thành phố Đà Nẵng khoảng 2km.',
    imageUrl: 'https://example.com/images/danang.jpg',
  ),
  Direction(
    code: 'PQC',
    name: 'Sân bay Quốc tế Phú Quốc',
    city: 'Phú Quốc',
    country: 'Việt Nam',
    countryCode: 'VN',
    placeTypes: [PlaceType.domestic, PlaceType.popular, PlaceType.beach],
    latitude: 10.1698,
    longitude: 103.9931,
    timeZone: 'Asia/Ho_Chi_Minh',
    description:
        'Sân bay quốc tế nằm ở đảo Phú Quốc, một trong những điểm du lịch nổi tiếng của Việt Nam.',
    imageUrl: 'https://example.com/images/phuquoc.jpg',
  ),
  Direction(
    code: 'CXR',
    name: 'Sân bay Quốc tế Cam Ranh',
    city: 'Nha Trang',
    country: 'Việt Nam',
    countryCode: 'VN',
    placeTypes: [PlaceType.domestic, PlaceType.popular, PlaceType.beach],
    latitude: 11.9982,
    longitude: 109.2192,
    timeZone: 'Asia/Ho_Chi_Minh',
    description: 'Sân bay quốc tế phục vụ khu vực Nha Trang và tỉnh Khánh Hòa.',
    imageUrl: 'https://example.com/images/nhatrang.jpg',
  ),
  Direction(
    code: 'HPH',
    name: 'Sân bay Quốc tế Cát Bi',
    city: 'Hải Phòng',
    country: 'Việt Nam',
    countryCode: 'VN',
    placeTypes: [PlaceType.domestic],
    latitude: 20.8194,
    longitude: 106.7247,
    timeZone: 'Asia/Ho_Chi_Minh',
    description: 'Sân bay quốc tế phục vụ thành phố cảng Hải Phòng.',
    imageUrl: 'https://example.com/images/haiphong.jpg',
  ),
  Direction(
    code: 'VCA',
    name: 'Sân bay Quốc tế Cần Thơ',
    city: 'Cần Thơ',
    country: 'Việt Nam',
    countryCode: 'VN',
    placeTypes: [PlaceType.domestic],
    latitude: 10.0851,
    longitude: 105.7119,
    timeZone: 'Asia/Ho_Chi_Minh',
    description: 'Sân bay quốc tế lớn nhất khu vực đồng bằng sông Cửu Long.',
    imageUrl: 'https://example.com/images/cantho.jpg',
  ),
  Direction(
    code: 'HUI',
    name: 'Sân bay Phú Bài',
    city: 'Huế',
    country: 'Việt Nam',
    countryCode: 'VN',
    placeTypes: [PlaceType.domestic, PlaceType.cultural],
    latitude: 16.4015,
    longitude: 107.7031,
    timeZone: 'Asia/Ho_Chi_Minh',
    description:
        'Sân bay phục vụ cố đô Huế, cách trung tâm thành phố khoảng 15km.',
    imageUrl: 'https://example.com/images/hue.jpg',
  ),
  Direction(
    code: 'DLI',
    name: 'Sân bay Liên Khương',
    city: 'Đà Lạt',
    country: 'Việt Nam',
    countryCode: 'VN',
    placeTypes: [PlaceType.domestic, PlaceType.popular, PlaceType.mountain],
    latitude: 11.7500,
    longitude: 108.3700,
    timeZone: 'Asia/Ho_Chi_Minh',
    description:
        'Sân bay phục vụ thành phố Đà Lạt, cách trung tâm khoảng 30km.',
    imageUrl: 'https://example.com/images/dalat.jpg',
  ),
  Direction(
    code: 'VDO',
    name: 'Sân bay Quốc tế Vân Đồn',
    city: 'Vân Đồn',
    country: 'Việt Nam',
    countryCode: 'VN',
    placeTypes: [PlaceType.domestic],
    latitude: 21.1142,
    longitude: 107.4058,
    timeZone: 'Asia/Ho_Chi_Minh',
    description: 'Sân bay quốc tế mới được xây dựng gần vịnh Hạ Long.',
    imageUrl: 'https://example.com/images/vandon.jpg',
  ),
  Direction(
    code: 'UIH',
    name: 'Sân bay Phù Cát',
    city: 'Quy Nhơn',
    country: 'Việt Nam',
    countryCode: 'VN',
    placeTypes: [PlaceType.domestic, PlaceType.beach],
    latitude: 13.7550,
    longitude: 109.2194,
    timeZone: 'Asia/Ho_Chi_Minh',
    description: 'Sân bay phục vụ thành phố Quy Nhơn và tỉnh Bình Định.',
    imageUrl: 'https://example.com/images/quynhon.jpg',
  ),

  // Sân bay quốc tế châu Á
  Direction(
    code: 'BKK',
    name: 'Sân bay Quốc tế Suvarnabhumi',
    city: 'Bangkok',
    country: 'Thái Lan',
    countryCode: 'TH',
    placeTypes: [PlaceType.international, PlaceType.popular, PlaceType.capital],
    latitude: 13.6900,
    longitude: 100.7501,
    timeZone: 'Asia/Bangkok',
    description: 'Sân bay quốc tế chính phục vụ Bangkok, Thái Lan.',
    imageUrl: 'https://example.com/images/bangkok.jpg',
  ),
  Direction(
    code: 'SIN',
    name: 'Sân bay Quốc tế Changi',
    city: 'Singapore',
    country: 'Singapore',
    countryCode: 'SG',
    placeTypes: [
      PlaceType.international,
      PlaceType.popular,
      PlaceType.capital,
      PlaceType.business
    ],
    latitude: 1.3644,
    longitude: 103.9915,
    timeZone: 'Asia/Singapore',
    description:
        'Một trong những sân bay tốt nhất thế giới, phục vụ thành phố Singapore.',
    imageUrl: 'https://example.com/images/singapore.jpg',
  ),
  Direction(
    code: 'ICN',
    name: 'Sân bay Quốc tế Incheon',
    city: 'Seoul',
    country: 'Hàn Quốc',
    countryCode: 'KR',
    placeTypes: [PlaceType.international, PlaceType.popular, PlaceType.capital],
    latitude: 37.4602,
    longitude: 126.4407,
    timeZone: 'Asia/Seoul',
    description: 'Sân bay quốc tế chính phục vụ Seoul, Hàn Quốc.',
    imageUrl: 'https://example.com/images/seoul.jpg',
  ),
  Direction(
    code: 'NRT',
    name: 'Sân bay Quốc tế Narita',
    city: 'Tokyo',
    country: 'Nhật Bản',
    countryCode: 'JP',
    placeTypes: [PlaceType.international, PlaceType.popular, PlaceType.capital],
    latitude: 35.7647,
    longitude: 140.3864,
    timeZone: 'Asia/Tokyo',
    description: 'Sân bay quốc tế chính phục vụ Tokyo, Nhật Bản.',
    imageUrl: 'https://example.com/images/tokyo.jpg',
  ),
  Direction(
    code: 'HKG',
    name: 'Sân bay Quốc tế Hong Kong',
    city: 'Hong Kong',
    country: 'Hong Kong',
    countryCode: 'HK',
    placeTypes: [
      PlaceType.international,
      PlaceType.popular,
      PlaceType.business
    ],
    latitude: 22.3080,
    longitude: 113.9185,
    timeZone: 'Asia/Hong_Kong',
    description: 'Sân bay quốc tế chính phục vụ Đặc khu Hành chính Hong Kong.',
    imageUrl: 'https://example.com/images/hongkong.jpg',
  ),
  Direction(
    code: 'KUL',
    name: 'Sân bay Quốc tế Kuala Lumpur',
    city: 'Kuala Lumpur',
    country: 'Malaysia',
    countryCode: 'MY',
    placeTypes: [PlaceType.international, PlaceType.popular, PlaceType.capital],
    latitude: 2.7456,
    longitude: 101.7099,
    timeZone: 'Asia/Kuala_Lumpur',
    description: 'Sân bay quốc tế chính phục vụ Kuala Lumpur, Malaysia.',
    imageUrl: 'https://example.com/images/kualalumpur.jpg',
  ),
  Direction(
    code: 'TPE',
    name: 'Sân bay Quốc tế Taiwan Taoyuan',
    city: 'Đài Bắc',
    country: 'Đài Loan',
    countryCode: 'TW',
    placeTypes: [PlaceType.international, PlaceType.capital],
    latitude: 25.0797,
    longitude: 121.2342,
    timeZone: 'Asia/Taipei',
    description: 'Sân bay quốc tế chính phục vụ Đài Bắc, Đài Loan.',
    imageUrl: 'https://example.com/images/taipei.jpg',
  ),

  // Sân bay quốc tế các châu lục khác
  Direction(
    code: 'SYD',
    name: 'Sân bay Quốc tế Sydney',
    city: 'Sydney',
    country: 'Australia',
    countryCode: 'AU',
    placeTypes: [PlaceType.international],
    latitude: -33.9399,
    longitude: 151.1753,
    timeZone: 'Australia/Sydney',
    description: 'Sân bay quốc tế lớn nhất Australia.',
    imageUrl: 'https://example.com/images/sydney.jpg',
  ),
  Direction(
    code: 'LAX',
    name: 'Sân bay Quốc tế Los Angeles',
    city: 'Los Angeles',
    country: 'Hoa Kỳ',
    countryCode: 'US',
    placeTypes: [PlaceType.international],
    latitude: 33.9416,
    longitude: -118.4085,
    timeZone: 'America/Los_Angeles',
    description: 'Sân bay quốc tế phục vụ Los Angeles, California.',
    imageUrl: 'https://example.com/images/losangeles.jpg',
  ),
  Direction(
    code: 'LHR',
    name: 'Sân bay Quốc tế Heathrow',
    city: 'London',
    country: 'Vương quốc Anh',
    countryCode: 'GB',
    placeTypes: [PlaceType.international, PlaceType.capital],
    latitude: 51.4700,
    longitude: -0.4543,
    timeZone: 'Europe/London',
    description: 'Sân bay quốc tế chính phục vụ London, Vương quốc Anh.',
    imageUrl: 'https://example.com/images/london.jpg',
  ),
  Direction(
    code: 'CDG',
    name: 'Sân bay Quốc tế Charles de Gaulle',
    city: 'Paris',
    country: 'Pháp',
    countryCode: 'FR',
    placeTypes: [PlaceType.international, PlaceType.capital],
    latitude: 49.0097,
    longitude: 2.5479,
    timeZone: 'Europe/Paris',
    description: 'Sân bay quốc tế chính phục vụ Paris, Pháp.',
    imageUrl: 'https://example.com/images/paris.jpg',
  ),
];

/// Danh sách các thành phố phổ biến cho lựa chọn nhanh
const List<Map<String, String>> kPopularCities = [
  {'code': 'HAN', 'name': 'Hà Nội'},
  {'code': 'SGN', 'name': 'TP.HCM'},
  {'code': 'DAD', 'name': 'Đà Nẵng'},
  {'code': 'PQC', 'name': 'Phú Quốc'},
  {'code': 'CXR', 'name': 'Nha Trang'},
  {'code': 'HPH', 'name': 'Hải Phòng'},
  {'code': 'VCA', 'name': 'Cần Thơ'},
  {'code': 'BKK', 'name': 'Bangkok'},
  {'code': 'SIN', 'name': 'Singapore'},
  {'code': 'ICN', 'name': 'Seoul'},
  {'code': 'NRT', 'name': 'Tokyo'},
];

/// Danh sách các đường bay phổ biến
const List<PopularRoute> kPopularRoutes = [
  PopularRoute(
    fromCode: 'HAN',
    toCode: 'SGN',
    label: 'Hà Nội → TP.HCM',
    searchCount: 10000,
  ),
  PopularRoute(
    fromCode: 'SGN',
    toCode: 'HAN',
    label: 'TP.HCM → Hà Nội',
    searchCount: 9500,
  ),
  PopularRoute(
    fromCode: 'HAN',
    toCode: 'DAD',
    label: 'Hà Nội → Đà Nẵng',
    searchCount: 7500,
  ),
  PopularRoute(
    fromCode: 'SGN',
    toCode: 'DAD',
    label: 'TP.HCM → Đà Nẵng',
    searchCount: 7000,
  ),
  PopularRoute(
    fromCode: 'HAN',
    toCode: 'PQC',
    label: 'Hà Nội → Phú Quốc',
    searchCount: 5500,
  ),
  PopularRoute(
    fromCode: 'SGN',
    toCode: 'PQC',
    label: 'TP.HCM → Phú Quốc',
    searchCount: 6000,
  ),
];

/// Helper function để lấy Direction theo mã IATA
Direction getDirectionByCode(String code) {
  return kDirections.firstWhere(
    (direction) => direction.code == code,
    orElse: () => throw Exception('Không tìm thấy địa điểm có mã: $code'),
  );
}

/// Helper function để lấy danh sách Direction theo loại địa điểm
List<Direction> getDirectionsByType(PlaceType type) {
  return kDirections.where((direction) => direction.isType(type)).toList();
}

/// Helper function để lấy danh sách Direction theo quốc gia
List<Direction> getDirectionsByCountry(String countryCode) {
  return kDirections
      .where((direction) => direction.countryCode == countryCode)
      .toList();
}

/// Helper function để chuyển đổi danh sách Direction sang danh sách Airport
List<Airport> directionsToAirports(List<Direction> directions) {
  return directions.map((direction) => direction.toAirport()).toList();
}

/// Danh sách các sân bay dưới dạng Airport để tương thích với code hiện có
final List<Airport> kAirports = directionsToAirports(kDirections);
