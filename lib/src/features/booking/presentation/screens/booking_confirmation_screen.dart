import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cnh_n/src/features/search/domain/models/flight.dart';
import 'package:cnh_n/src/core/constants/colors.dart';
import 'package:cnh_n/src/features/booking/presentation/screens/passenger_information_screen.dart';

class BookingConfirmationScreen extends StatelessWidget {
  final Flight outboundFlight;
  final Flight? returnFlight;
  final int passengers;
  final DateTime? returnDate;

  const BookingConfirmationScreen({
    super.key,
    required this.outboundFlight,
    this.returnFlight,
    required this.passengers,
    this.returnDate,
  });

  String _getAirlineImagePath(String airlineName) {
    // Map airline names to actual file names
    final Map<String, String> airlineImageMap = {
      'Vietnam Airlines': 'VietnamAirlines.png',
      'VietJet Air': 'vietjetair.png',
      'Bamboo Airways': 'BambooAirways.png',
    };
    
    return airlineImageMap[airlineName] ?? 'VietnamAirlines.png'; // Default fallback
  }

  @override
  Widget build(BuildContext context) {
    final bool isRoundTrip = returnFlight != null;
    final double totalPrice = outboundFlight.price + (returnFlight?.price ?? 0);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            _buildProgressIndicator(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildHeaderSection(),
                    const SizedBox(height: 24),
                    _buildFlightSummaryCard(outboundFlight, true),
                    if (isRoundTrip) ...[
                      const SizedBox(height: 16),
                      _buildFlightSummaryCard(returnFlight!, false),
                    ],
                    const SizedBox(height: 24),
                    _buildPricingSummary(totalPrice),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            _buildBottomButtons(context),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Color(0xFF6B7280),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Đặt vé máy bay',
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const Spacer(),
          const Text(
            'Bước 1 / 3',
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 14,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return _buildProgressSteps(currentStep: 1); // Bước 1 hiện tại
  }

  Widget _buildProgressSteps({required int currentStep}) {
    final steps = [
      {'number': 1, 'label': 'Xác nhận'},
      {'number': 2, 'label': 'Hành khách'},
      {'number': 3, 'label': 'Thanh toán'},
    ];
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          for (int i = 0; i < steps.length; i++) ...[
            _buildStepCircle(
              stepNumber: steps[i]['number'] as int,
              label: steps[i]['label'] as String,
              currentStep: currentStep,
            ),
            if (i < steps.length - 1) // Không thêm line sau step cuối
              _buildSmoothProgressLine(
                isActive: currentStep > (steps[i]['number'] as int),
              ),
          ],
        ],
      ),
    );
  }

  Widget _buildStepCircle({
    required int stepNumber,
    required String label,
    required int currentStep,
  }) {
    final isCompleted = stepNumber < currentStep; 
    final isActive = stepNumber <= currentStep;   
    final showLabel = stepNumber == currentStep;  
    
    return Column(
      children: [
        // Simple animated circle
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryBlue : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isCompleted
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 24,
                      key: ValueKey('check'),
                    )
                  : Text(
                      stepNumber.toString(),
                      key: ValueKey('number'),
                      style: TextStyle(
                        fontFamily: 'BalooBhaijaan2',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isActive ? Colors.white : Colors.grey.shade600,
                      ),
                    ),
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Simple label
        AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: showLabel ? 1.0 : 0.0,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: showLabel ? AppColors.primaryBlue : Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSmoothProgressLine({required bool isActive}) {
    return Container(
      width: 60,
      height: 3,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryBlue : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildHeaderSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryBlue.withOpacity(0.1),
            AppColors.primaryBlue.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryBlue.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              borderRadius: BorderRadius.circular(50),
            ),
            child: const Icon(
              Icons.verified_user,
              color: Colors.white,
              size: 32,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Xác nhận giữ chỗ chuyến bay',
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryBlue,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Vui lòng kiểm tra thông tin chuyến bay và tiếp tục để nhập thông tin hành khách',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 14,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlightSummaryCard(Flight flight, bool isOutbound) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isOutbound ? AppColors.primaryBlue.withOpacity(0.3) : Colors.green.withOpacity(0.3),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: isOutbound ? AppColors.primaryBlue : Colors.green,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  isOutbound ? 'Chuyến bay đi' : 'Chuyến bay về',
                  style: const TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const Spacer(),
              Text(
                NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(flight.price),
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: isOutbound ? AppColors.primaryBlue : Colors.green,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      flight.departure.code,
                      style: const TextStyle(
                        fontFamily: 'BalooBhaijaan2',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      DateFormat('HH:mm').format(flight.departureTime),
                      style: const TextStyle(
                        fontFamily: 'BalooBhaijaan2',
                        fontSize: 14,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.flight_takeoff, size: 16, color: Color(0xFF64748B)),
                    const SizedBox(width: 8),
                    Text(
                      flight.duration,
                      style: const TextStyle(
                        fontFamily: 'BalooBhaijaan2',
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      flight.arrival.code,
                      style: const TextStyle(
                        fontFamily: 'BalooBhaijaan2',
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      DateFormat('HH:mm').format(flight.arrivalTime),
                      style: const TextStyle(
                        fontFamily: 'BalooBhaijaan2',
                        fontSize: 14,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                Image.asset(
                  'assets/Images/${_getAirlineImagePath(flight.airline)}',
                  width: 24,
                  height: 24,
                  errorBuilder: (context, error, stackTrace) => const Icon(
                    Icons.flight,
                    size: 24,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '${flight.airline} • ${flight.flightNumber} • ${flight.aircraft}',
                    style: const TextStyle(
                      fontFamily: 'BalooBhaijaan2',
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingSummary(double totalPrice) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tổng chi phí',
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Giá vé',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 14,
                  color: Color(0xFF64748B),
                ),
              ),
              Text(
                NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(totalPrice),
                style: const TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 14,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Thuế và phí',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 14,
                  color: Color(0xFF64748B),
                ),
              ),
              Text(
                NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(totalPrice * 0.1),
                style: const TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 14,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Tổng cộng',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
              Text(
                NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(totalPrice * 1.1),
                style: const TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primaryBlue),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Chọn lại',
                  style: TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => PassengerInformationScreen(
                        outboundFlight: outboundFlight,
                        returnFlight: returnFlight,
                        passengers: passengers,
                        returnDate: returnDate,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryBlue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: const Text(
                  'Tiếp tục',
                  style: TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
