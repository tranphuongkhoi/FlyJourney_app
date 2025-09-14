import 'package:flutter/material.dart';
import 'package:cnh_n/constants/colors.dart';

class BookingsScreen extends StatefulWidget {
  const BookingsScreen({super.key});

  @override
  State<BookingsScreen> createState() => _BookingsScreenState();
}

class _BookingsScreenState extends State<BookingsScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        toolbarHeight: 80,
        title: const Text(
          'Vé đã đặt',
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: AppColors.primaryBlue,
          indicatorWeight: 3,
          labelColor: AppColors.primaryBlue,
          unselectedLabelColor: const Color(0xFF64748B),
          labelStyle: const TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: const TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          tabs: const [
            Tab(text: 'Sắp tới'),
            Tab(text: 'Hoàn tất'),
            Tab(text: 'Đã hủy'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildUpcomingTab(),
          _buildCompletedTab(),
          _buildCancelledTab(),
        ],
      ),
    );
  }

  Widget _buildUpcomingTab() {
    // Ví dụ dữ liệu vé sắp tới
    List<Map<String, dynamic>> upcomingBookings = [
      {
        'flightNumber': 'VJ123',
        'origin': 'Hà Nội (HAN)',
        'destination': 'Hồ Chí Minh (SGN)',
        'departureDate': '25/09/2025',
        'departureTime': '08:30',
        'arrivalTime': '10:40',
        'status': 'Đã xác nhận',
        'airline': 'VietJet Air',
      },
      {
        'flightNumber': 'VN456',
        'origin': 'Hồ Chí Minh (SGN)',
        'destination': 'Đà Nẵng (DAD)',
        'departureDate': '15/10/2025',
        'departureTime': '14:15',
        'arrivalTime': '15:40',
        'status': 'Chờ thanh toán',
        'airline': 'Vietnam Airlines',
      },
    ];

    return upcomingBookings.isEmpty
        ? _buildEmptyState('Bạn chưa có vé máy bay nào sắp tới', 'Hãy đặt vé ngay để trải nghiệm các chuyến bay tuyệt vời')
        : _buildBookingList(upcomingBookings);
  }

  Widget _buildCompletedTab() {
    // Ví dụ dữ liệu vé đã hoàn tất
    List<Map<String, dynamic>> completedBookings = [
      {
        'flightNumber': 'VN789',
        'origin': 'Hà Nội (HAN)',
        'destination': 'Đà Nẵng (DAD)',
        'departureDate': '15/08/2025',
        'departureTime': '09:30',
        'arrivalTime': '11:00',
        'status': 'Hoàn tất',
        'airline': 'Vietnam Airlines',
      },
    ];

    return completedBookings.isEmpty
        ? _buildEmptyState('Chưa có vé máy bay nào đã hoàn tất', 'Các chuyến bay đã hoàn tất sẽ hiển thị ở đây')
        : _buildBookingList(completedBookings);
  }

  Widget _buildCancelledTab() {
    // Ví dụ dữ liệu vé đã hủy
    List<Map<String, dynamic>> cancelledBookings = [];

    return cancelledBookings.isEmpty
        ? _buildEmptyState('Không có vé máy bay nào đã hủy', 'Các vé đã hủy sẽ hiển thị ở đây')
        : _buildBookingList(cancelledBookings);
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.flight,
                size: 60,
                color: AppColors.primaryBlue,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF64748B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: 200,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Chuyển đến trang tìm kiếm chuyến bay
                  Navigator.pop(context); // Quay lại trang chính
                  // Chuyển đến tab tìm kiếm (giả sử tab index là 0)
                  // Có thể sử dụng Provider hoặc cách khác để điều hướng tab
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Đặt vé ngay',
                  style: TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBookingList(List<Map<String, dynamic>> bookings) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: bookings.length,
      itemBuilder: (context, index) {
        final booking = bookings[index];
        return _buildBookingCard(booking);
      },
    );
  }

  Widget _buildBookingCard(Map<String, dynamic> booking) {
    Color statusColor;
    
    switch (booking['status']) {
      case 'Đã xác nhận':
        statusColor = Colors.green;
        break;
      case 'Chờ thanh toán':
        statusColor = Colors.orange;
        break;
      case 'Hoàn tất':
        statusColor = Colors.blue;
        break;
      case 'Đã hủy':
        statusColor = Colors.red;
        break;
      default:
        statusColor = Colors.grey;
    }
    
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Airline and flight number
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  booking['airline'],
                  style: const TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    booking['status'],
                    style: TextStyle(
                      fontFamily: 'BalooBhaijaan2',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: statusColor,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              'Mã chuyến bay: ${booking['flightNumber']}',
              style: const TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF64748B),
              ),
            ),
            const SizedBox(height: 16),
            
            // Departure and arrival
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Khởi hành',
                        style: TextStyle(
                          fontFamily: 'BalooBhaijaan2',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        booking['departureTime'],
                        style: const TextStyle(
                          fontFamily: 'BalooBhaijaan2',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        booking['origin'],
                        style: const TextStyle(
                          fontFamily: 'BalooBhaijaan2',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Flight indicator
                Column(
                  children: [
                    const Icon(
                      Icons.flight,
                      color: AppColors.primaryBlue,
                      size: 24,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      width: 100,
                      height: 1,
                      color: const Color(0xFFE2E8F0),
                    ),
                  ],
                ),
                
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      const Text(
                        'Đến',
                        style: TextStyle(
                          fontFamily: 'BalooBhaijaan2',
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xFF64748B),
                        ),
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        booking['arrivalTime'],
                        style: const TextStyle(
                          fontFamily: 'BalooBhaijaan2',
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                        textAlign: TextAlign.right,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        booking['destination'],
                        style: const TextStyle(
                          fontFamily: 'BalooBhaijaan2',
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF64748B),
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 16),
            const Divider(height: 1, color: Color(0xFFE2E8F0)),
            const SizedBox(height: 16),
            
            // Date and action button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Ngày khởi hành',
                      style: TextStyle(
                        fontFamily: 'BalooBhaijaan2',
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      booking['departureDate'],
                      style: const TextStyle(
                        fontFamily: 'BalooBhaijaan2',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {
                    // Chuyển đến trang chi tiết vé
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Xem chi tiết',
                    style: TextStyle(
                      fontFamily: 'BalooBhaijaan2',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
