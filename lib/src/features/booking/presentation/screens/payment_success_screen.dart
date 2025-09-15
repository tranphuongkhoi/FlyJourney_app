import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fly_journey/src/core/constants/colors.dart';
import 'package:fly_journey/src/features/search/domain/models/flight.dart';
import 'package:fly_journey/src/features/booking/domain/models/passenger_models.dart';
import 'package:fly_journey/src/features/home/presentation/screens/main_screen.dart';
import 'package:fly_journey/src/features/search/presentation/screens/flight_search_screen.dart';

class PaymentSuccessScreen extends StatelessWidget {
  final Flight flight;
  final Flight? returnFlight;
  final List<PassengerInfo> passengers;
  final ContactInfo contactInfo;
  final int totalPassengers;
  final double totalAmount;
  final String? bookingId; // optional: allow deep-opening the created ticket

  const PaymentSuccessScreen({
    super.key,
    required this.flight,
    this.returnFlight,
    required this.passengers,
    required this.contactInfo,
    required this.totalPassengers,
    required this.totalAmount,
    this.bookingId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),
              _buildSuccessContent(context),
              _buildBookingDetails(),
              const SizedBox(height: 32),
              _buildActionButtons(context),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: const BoxDecoration(
        color: Colors.white,
      ),
      child: Column(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: AppColors.primaryBlue.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.check_circle_outline,
              color: AppColors.primaryBlue,
              size: 60,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Thanh toán thành công!',
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 28,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Vé máy bay của bạn đã được đặt thành công',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: AppColors.primaryBlue,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSuccessContent(BuildContext context) {
    final bookingId = 'FL${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    
    return Container(
      margin: const EdgeInsets.all(24),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Booking ID
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Mã đặt vé:',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Text(
                bookingId,
                style: const TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Total Amount
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tổng tiền:',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Text(
                '${NumberFormat('#,###', 'vi').format(totalAmount)} ₫',
                style: const TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Passengers
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Số hành khách:',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Text(
                '$totalPassengers người',
                style: const TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Booking Time
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Thời gian đặt:',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              Text(
                DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now()),
                style: const TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBookingDetails() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 24),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: AppColors.primaryBlue.withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.info_outline,
                color: AppColors.primaryBlue,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Thông tin quan trọng',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            '• Email xác nhận đã được gửi đến địa chỉ email của bạn\n'
            '• Vui lòng check-in trực tuyến trước 2 giờ\n'
            '• Mang theo giấy tờ tùy thân hợp lệ khi bay\n'
            '• Đến sân bay trước 1.5-2 giờ để làm thủ tục',
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF374151),
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          // Xem chi tiết vé
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: () => _viewTicketDetails(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 0,
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.airplane_ticket, size: 20),
                  SizedBox(width: 12),
                  Text(
                    'Xem chi tiết vé đã đặt',
                    style: TextStyle(
                      fontFamily: 'BalooBhaijaan2',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Đặt thêm vé
          SizedBox(
            width: double.infinity,
            height: 56,
            child: OutlinedButton(
              onPressed: () => _bookMoreTickets(context),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primaryBlue, width: 2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.add_circle_outline, color: AppColors.primaryBlue, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    'Đặt thêm vé',
                    style: TextStyle(
                      fontFamily: 'BalooBhaijaan2',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          
          // Về trang chủ
          SizedBox(
            width: double.infinity,
            height: 56,
            child: TextButton(
              onPressed: () => _goToHome(context),
              style: TextButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.home_outlined, color: Colors.grey.shade600, size: 20),
                  const SizedBox(width: 12),
                  Text(
                    'Về trang chủ',
                    style: TextStyle(
                      fontFamily: 'BalooBhaijaan2',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _viewTicketDetails(BuildContext context) {
    // Navigate to MainScreen with MyBookings tab selected and specific ticket opened
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => MainScreen(
          initialIndex: 2, // MyBookings tab index
          initialBookingId: bookingId,
        ),
      ),
      (route) => false, // Remove all previous routes
    );
  }

  void _bookMoreTickets(BuildContext context) {
    // Navigate to single-step FlightSearchScreen
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const FlightSearchScreen(),
      ),
      (route) => false, // Remove all previous routes
    );
  }

  void _goToHome(BuildContext context) {
    // Navigate to MainScreen with Home tab selected
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const MainScreen(
          initialIndex: 0, // Home tab index
        ),
      ),
      (route) => false, // Remove all previous routes
    );
  }
}
