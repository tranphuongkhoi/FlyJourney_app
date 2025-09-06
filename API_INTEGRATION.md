r# API Integration Guide

## 🎯 Overview
Ứng dụng đã được thiết kế với kiến trúc sẵn sàng để tích hợp API thật. Hiện tại đang chạy ở chế độ Mock để phát triển.

## 📁 File Structure
```
lib/
├── config/
│   └── api_config.dart          # Cấu hình API endpoints và headers
├── services/
│   └── flight_service.dart      # Service xử lý API calls
└── screens/
    └── flight_search_results_screen.dart  # UI sử dụng service
```

## ⚙️ Configuration

### 1. API Config (`lib/config/api_config.dart`)
```dart
class ApiConfig {
  // Thay đổi những giá trị này theo API thật của bạn
  static const String baseUrl = 'https://your-api-domain.com/api/v1';
  static const String apiKey = 'YOUR_API_KEY';
  static const String bearerToken = 'YOUR_BEARER_TOKEN';
  
  // Tắt mock mode khi sẵn sàng dùng API thật
  static const bool useMockData = false; // Đổi thành false
}
```

### 2. Endpoints
- **Search Flights**: `POST /flights/search`
- **Flight Details**: `GET /flights/{id}`
- **Book Flight**: `POST /flights/book`

## 📋 API Request/Response Format

### Search Request
```json
{
  "departure_airport_code": "HAN",
  "arrival_airport_code": "SGN",
  "departure_date": "2025-08-01",
  "return_date": "2025-08-15", // Optional for roundtrip
  "flight_class": "business",
  "airline_ids": ["1", "2"],
  "passengers": {
    "adults": 2,
    "children": 1,
    "infants": 0
  },
  "page": 1,
  "limit": 50
}
```

### Expected Response
```json
{
  "success": true,
  "data": {
    "flights": [
      {
        "id": "1",
        "type": "oneway", // hoặc "roundtrip"
        "airline": "Vietnam Airlines",
        "airline_code": "VN",
        "flight_number": "VN214",
        "departure_time": "08:30",
        "arrival_time": "10:00",
        "duration": "1h 30m",
        "flight_class": "business",
        "price": 3500000,
        
        // Cho roundtrip flights
        "outbound_flight": {...},
        "return_flight": {...},
        "total_price": 7000000
      }
    ],
    "total_count": 10,
    "page": 1,
    "limit": 50
  }
}
```

## 🔄 Switching to Real API

### Bước 1: Cập nhật config
```dart
// lib/config/api_config.dart
static const String baseUrl = 'https://your-real-api.com/api/v1';
static const String bearerToken = 'your-real-token';
static const bool useMockData = false; // ✨ Quan trọng!
```

### Bước 2: Test API calls
```dart
// lib/services/flight_service.dart
// FlightService.searchFlights() sẽ tự động chuyển sang real API
```

### Bước 3: Error Handling
Ứng dụng đã có sẵn error handling cho:
- Network errors
- API errors (4xx, 5xx)
- Timeout errors
- JSON parsing errors

## 🧪 Testing

### Mock Mode (Current)
```dart
ApiConfig.useMockData = true;  // Dùng data giả
```

### Real API Mode
```dart
ApiConfig.useMockData = false; // Dùng API thật
```

## 📱 UI Integration

### Loading State
- ✅ CircularProgressIndicator với màu xanh
- ✅ "Đang tìm kiếm chuyến bay..." với font BalooBhaijaan2

### Error Handling
- ✅ SnackBar hiển thị lỗi cho user
- ✅ Empty state khi không có kết quả

### Data Display
- ✅ Flight cards hiển thị class, date, passengers riêng biệt
- ✅ Giá tiền format Việt Nam: "1.590.000 VND"
- ✅ Roundtrip flights hiển thị chi tiết cho cả 2 chuyến

## 🔧 Development Tips

1. **Test với Postman** trước khi tích hợp
2. **Kiểm tra response format** phải match với expected structure
3. **Set timeout phù hợp** cho API calls
4. **Handle authentication** nếu cần
5. **Log requests/responses** để debug

## 🚀 Ready to Deploy!

Khi nào API thật sẵn sàng:
1. Đổi `useMockData = false`
2. Cập nhật `baseUrl` và `bearerToken`
3. Test thoroughly
4. Deploy! 🎉

---
*Ứng dụng đã sẵn sàng 100% để gắn API thật vào! 💪*
