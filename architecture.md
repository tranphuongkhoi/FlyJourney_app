# Flight Booking App Architecture

## Core Features (MVP)
1. **Flight Search** - Tìm kiếm chuyến bay theo tuyến đường và ngày
2. **Flight Results** - Hiển thị danh sách kết quả với lọc và sắp xếp
3. **Flight Details** - Thông tin chi tiết về chuyến bay
4. **Booking Process** - Quy trình đặt vé với thông tin hành khách
5. **My Bookings** - Quản lý vé đã đặt

## Technical Architecture

### Data Models
- `Flight` - Thông tin chuyến bay (mã chuyến bay, hãng hàng không, giờ bay, giá vé)
- `Airport` - Thông tin sân bay (mã IATA, tên, thành phố, quốc gia)
- `Booking` - Thông tin đặt vé (mã đặt chỗ, hành khách, trạng thái)
- `Passenger` - Thông tin hành khách (họ tên, giấy tờ tùy thân)

### File Structure
```
lib/
├── main.dart
├── theme.dart
├── models/
│   ├── flight.dart
│   ├── airport.dart
│   ├── booking.dart
│   └── passenger.dart
├── screens/
│   ├── home_screen.dart
│   ├── search_results_screen.dart
│   ├── flight_details_screen.dart
│   ├── booking_screen.dart
│   └── my_bookings_screen.dart
├── widgets/
│   ├── flight_card.dart
│   ├── search_form.dart
│   └── booking_summary.dart
├── services/
│   └── storage_service.dart
└── data/
    └── sample_data.dart
```

### Implementation Steps
1. **Setup Data Models** - Create flight, airport, booking, and passenger models
2. **Create Sample Data** - Generate realistic Vietnamese flight data
3. **Build Home Screen** - Search form with origin/destination/dates
4. **Implement Search Results** - Flight list with filtering options
5. **Flight Details Page** - Comprehensive flight information
6. **Booking Flow** - Passenger information and confirmation
7. **My Bookings** - Booking management with local storage
8. **Add Dependencies** - Include required packages for date picker and local storage
9. **Test & Debug** - Compile and fix any issues

### Key Features
- Modern card-based UI with Vietnamese airline branding
- Intuitive date picker for departure/return flights
- Price filtering and sorting options
- Local storage for bookings (no backend required)
- Responsive design with smooth animations
- Support for both one-way and round-trip flights

### Vietnamese Airlines & Routes
- Vietnam Airlines (VN), VietJet Air (VJ), Bamboo Airways (QH)
- Major routes: HAN-SGN, HAN-DAD, SGN-DAD, HAN-PQC, SGN-PQC
- Realistic pricing and flight schedules