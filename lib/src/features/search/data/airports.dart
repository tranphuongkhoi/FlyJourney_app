import 'package:fly_journey/src/features/search/domain/models/airport.dart';

/// Danh sách các sân bay được hỗ trợ
final List<Airport> airports = const [
  // Major Vietnamese airports
  Airport(code: 'HAN', name: 'Nội Bài', city: 'Hà Nội', country: 'Việt Nam'),
  Airport(
      code: 'SGN',
      name: 'Tân Sơn Nhất',
      city: 'TP. Hồ Chí Minh',
      country: 'Việt Nam'),
  Airport(code: 'DAD', name: 'Đà Nẵng', city: 'Đà Nẵng', country: 'Việt Nam'),
  Airport(
      code: 'CXR', name: 'Cam Ranh', city: 'Nha Trang', country: 'Việt Nam'),
  Airport(code: 'PQC', name: 'Phú Quốc', city: 'Phú Quốc', country: 'Việt Nam'),
  Airport(code: 'VCA', name: 'Cần Thơ', city: 'Cần Thơ', country: 'Việt Nam'),
  Airport(code: 'HPH', name: 'Cát Bi', city: 'Hải Phòng', country: 'Việt Nam'),
  Airport(code: 'HUI', name: 'Phú Bài', city: 'Huế', country: 'Việt Nam'),
  Airport(code: 'UIH', name: 'Phù Cát', city: 'Quy Nhon', country: 'Việt Nam'),
  Airport(
      code: 'DLI', name: 'Liên Khương', city: 'Đà Lạt', country: 'Việt Nam'),
  Airport(
      code: 'BMV',
      name: 'Buôn Ma Thuột',
      city: 'Buôn Ma Thuột',
      country: 'Việt Nam'),
  Airport(code: 'PXU', name: 'Pleiku', city: 'Pleiku', country: 'Việt Nam'),
  Airport(code: 'VII', name: 'Vinh', city: 'Vinh', country: 'Việt Nam'),
  Airport(code: 'CAH', name: 'Cà Mau', city: 'Cà Mau', country: 'Việt Nam'),
  Airport(code: 'VKG', name: 'Rạch Giá', city: 'Rạch Giá', country: 'Việt Nam'),
  Airport(code: 'VCS', name: 'Côn Đảo', city: 'Côn Đảo', country: 'Việt Nam'),
  // International airports
  Airport(
      code: 'BKK', name: 'Suvarnabhumi', city: 'Bangkok', country: 'Thái Lan'),
  Airport(code: 'SIN', name: 'Changi', city: 'Singapore', country: 'Singapore'),
  Airport(code: 'KUL', name: 'KLIA', city: 'Kuala Lumpur', country: 'Malaysia'),
  Airport(
      code: 'MNL',
      name: 'Ninoy Aquino',
      city: 'Manila',
      country: 'Philippines'),
  Airport(code: 'ICN', name: 'Incheon', city: 'Seoul', country: 'Hàn Quốc'),
  Airport(code: 'NRT', name: 'Narita', city: 'Tokyo', country: 'Nhật Bản'),
];

/// Thành phố phổ biến cho việc chọn nhanh
final List<Map<String, String>> popularCities = const [
  {'code': 'HAN', 'name': 'Hà Nội'},
  {'code': 'SGN', 'name': 'TP. Hồ Chí Minh'},
  {'code': 'DAD', 'name': 'Đà Nẵng'},
  {'code': 'CXR', 'name': 'Nha Trang'},
  {'code': 'PQC', 'name': 'Phú Quốc'},
  {'code': 'HUI', 'name': 'Huế'},
  {'code': 'DLI', 'name': 'Đà Lạt'},
  {'code': 'VCA', 'name': 'Cần Thơ'},
];

/// Các tuyến đường phổ biến cho việc chọn nhanh
final List<Map<String, String>> popularRoutes = const [
  {'from': 'HAN', 'to': 'SGN', 'label': 'Hà Nội → TP.HCM'},
  {'from': 'SGN', 'to': 'HAN', 'label': 'TP.HCM → Hà Nội'},
  {'from': 'HAN', 'to': 'DAD', 'label': 'Hà Nội → Đà Nẵng'},
  {'from': 'SGN', 'to': 'DAD', 'label': 'TP.HCM → Đà Nẵng'},
  {'from': 'HAN', 'to': 'PQC', 'label': 'Hà Nội → Phú Quốc'},
  {'from': 'SGN', 'to': 'PQC', 'label': 'TP.HCM → Phú Quốc'},
];

/// Bản đồ mã sân bay -> tên thành phố theo smt.md
Map<String, String> airportToCityMapping = {
  'SGN': "TP. Hồ Chí Minh",
  'TSN': "TP. Hồ Chí Minh",
  'HAN': "Hà Nội",
  'NOI': "Hà Nội",
  'DAD': "Đà Nẵng",
  'CXR': "Nha Trang",
  'KHA': "Nha Trang",
  'PQC': "Phú Quốc",
  'VCA': "Cần Thơ",
  'HPH': "Hải Phòng",
  'HUI': "Huế",
  'UIH': "Quy Nhon",
  'DLI': "Đà Lạt",
  'BMV': "Buôn Ma Thuột",
  'PXU': "Pleiku",
  'VII': "Vinh",
  'CAH': "Cà Mau",
  'VKG': "Rạch Giá",
  'VCS': "Côn Đảo",
  'BKK': "Bangkok",
  'SIN': "Singapore",
  'KUL': "Kuala Lumpur",
  'MNL': "Manila",
  'ICN': "Seoul",
  'NRT': "Tokyo",
};

/// Hàm trợ giúp lấy tên thành phố từ mã sân bay
String getCityFromAirportCode(String code) {
  if (code.isEmpty) return "";

  final upperCode = code.toUpperCase();
  return airportToCityMapping[upperCode] ?? upperCode;
}

/// Định dạng hiển thị sân bay: "Tên thành phố (Mã sân bay)"
String formatAirportDisplay(String code) {
  if (code.isEmpty) return "---";

  final upperCode = code.toUpperCase();
  final cityName = airportToCityMapping[upperCode];

  if (cityName != null) {
    return "$cityName ($upperCode)";
  }
  return upperCode;
}
