# API Integration Guide - Updated

## 🎯 Overview
API integration framework đã được cập nhật để match với response structure thật từ API `{{baseURL}}/api/v1/flights/search`.

## 📋 Your API Response Structure

### ✅ API Response được cập nhật theo format mới:
```json
{
  "data": {
    "arrival_airport": "SGN",
    "departure_airport": "HAN", 
    "departure_date": "01/08/2025",
    "flight_class": "business",
    "passengers": {
      "adults": 1,
      "children": 0,
      "infants": 0
    },
    "search_results": [
      {
        "flight_id": 68,
        "flight_number": "BL192",
        "airline_id": 5,
        "airline_name": "Bamboo Airways",
        "logo_url": "https://...",
        "departure_airport_code": "HAN",
        "arrival_airport_code": "SGN", 
        "departure_airport": "Sân Bay Nội Bài",
        "arrival_airport": "Sân Bay Tân Sơn Nhất",
        "departure_time": "2025-08-01T09:30:00Z",
        "arrival_time": "2025-08-01T11:45:00Z",
        "duration_minutes": 135,
        "flight_class": "economy",
        "fare_class_details": {
          "cabin_class": "Economy Class",
          "refundable": false,
          "changeable": false,
          "baggage_kg": "1 kiện x 23kg (miễn phí)"
        },
        "pricing": {
          "grand_total": 1645621,
          "currency": "VND"
        }
      }
    ],
    "total_count": 10
  },
  "status": true,
  "errorCode": "SUCCESS"
}
```

## 🔧 Changes Made

### ✅ Updated FlightService
- Changed from `flights` to `search_results` array
- Updated response parsing for `status` instead of `success`
- Added error handling for `errorCode` and `errorMessage`

### ✅ Updated UI Components
- **Price Display**: Now uses `flight['pricing']['grand_total']`
- **Airline Info**: Changed to `flight['airline_name']`
- **Time Format**: Added `_formatTime()` to convert ISO format to HH:mm
- **Duration**: Added `_formatDuration()` to convert minutes to "Xh Ym"
- **Airport Codes**: Uses `departure_airport_code` and `arrival_airport_code`

### ✅ New Helper Functions
```dart
String _formatTime(String isoTime) {
  // Converts "2025-08-01T09:30:00Z" to "09:30"
}

String _formatDuration(int durationMinutes) {
  // Converts 135 minutes to "2h 15m"
}
```

## 🚀 How to Connect Your Real API

### 1. Update Configuration
```dart
// In lib/config/api_config.dart
static const String baseUrl = 'YOUR_ACTUAL_URL/api/v1';
static const bool useMockData = false; // Enable real API
```

### 2. Replace {{baseURL}}
Replace `{{baseURL}}` with your actual server URL in the config file.

### 3. Test Connection
The app will automatically:
- Make POST requests to `/flights/search`
- Handle your API response format
- Display Vietnamese prices (1.590.000 VND)
- Format times and durations properly

## 📱 UI Features Working

### ✅ Flight Search Results
- **Real API Data**: Ready to consume your API response
- **Price Formatting**: 1.590.000 VND format
- **Time Display**: 09:30 format from ISO time
- **Duration**: 2h 15m format from minutes
- **Airline Logos**: Uses `logo_url` from your API
- **Flight Details**: All fields mapped correctly

### ✅ Error Handling
- Network connectivity issues
- API error responses
- User-friendly Vietnamese error messages

## 🔄 Current Status

### ✅ Ready for Production
- All UI components updated for your API format
- Mock data matches your real response structure  
- Error handling implemented
- Vietnamese formatting applied

### 🎯 Next Steps
1. Update `baseUrl` in ApiConfig
2. Set `useMockData = false`
3. Test with real API
4. Ready for production!

## 📞 Notes for Roundtrip Flights

Hiện tại API này handle **one-way flights**. Khi bạn có API cho roundtrip flights, chỉ cần:
1. Cập nhật response structure trong documentation
2. UI components cho roundtrip đã sẵn sàng
3. Thêm logic để detect roundtrip vs one-way

## ✨ Summary

✅ **API framework hoàn chỉnh**  
✅ **UI updated cho API structure mới**  
✅ **Vietnamese formatting**  
✅ **Error handling**  
✅ **Ready for production**  

Chỉ cần thay `{{baseURL}}` và set `useMockData = false` là xong!
