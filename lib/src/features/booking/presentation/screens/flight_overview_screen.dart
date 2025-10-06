import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fly_journey/src/features/search/domain/models/flight.dart';
import 'package:fly_journey/src/features/booking/presentation/screens/booking_confirmation_screen.dart';

class FlightOverviewScreen extends StatelessWidget {
  final Flight flight;
  final Flight? returnFlight;
  final int passengers;
  final DateTime? returnDate;

  const FlightOverviewScreen({
    super.key,
    required this.flight,
    this.returnFlight,
    required this.passengers,
    this.returnDate,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA), // Homepage background color
      appBar: AppBar(
        title: Text(
          returnFlight != null ? 'Chi tiết vé khứ hồi' : 'Chi tiết chuyến bay',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFFE0F7FA), // Homepage background color
        foregroundColor: Colors.black,
        elevation: 0,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Outbound flight section
                  _buildSectionHeader('🛫 Chuyến bay đi', true),
                  const SizedBox(height: 16),
                  _buildFlightHeader(flight),
                  const SizedBox(height: 16),
                  _buildFlightRoute(flight),
                  const SizedBox(height: 16),
                  _buildFlightDetails(flight),
                  
                  // Return flight section (if exists)
                  if (returnFlight != null) ...[
                    const SizedBox(height: 32),
                    _buildSectionHeader('🛬 Chuyến bay về', false),
                    const SizedBox(height: 16),
                    _buildFlightHeader(returnFlight!),
                    const SizedBox(height: 16),
                    _buildFlightRoute(returnFlight!),
                    const SizedBox(height: 16),
                    _buildFlightDetails(returnFlight!),
                  ],
                  
                  const SizedBox(height: 24),
                  _buildPricingDetails(),
                  const SizedBox(height: 24),
                  _buildPassengerInfoForFlight('🛫 Chuyến bay đi', flight, passengers),
                  if (returnFlight != null) ...[
                    const SizedBox(height: 16),
                    _buildPassengerInfoForFlight('🛬 Chuyến bay về', returnFlight!, passengers),
                  ],
                  const SizedBox(height: 24),
                  _buildPolicies(),
                  const SizedBox(height: 100), // Space for bottom buttons
                ],
              ),
            ),
          ),
          _buildBottomButtons(context),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, bool isOutbound) {
    final Color primaryColor = isOutbound ? Colors.blue[600]! : Colors.green[600]!;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(0.15),
            primaryColor.withOpacity(0.25),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: primaryColor.withOpacity(0.3), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isOutbound ? Icons.flight_takeoff : Icons.flight_land,
              color: primaryColor,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 24,
                fontWeight: FontWeight.w800,
                color: primaryColor,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlightHeader(Flight flightData) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.blue.shade200),
                ),
                child: Icon(
                  Icons.flight,
                  color: Colors.blue.shade600,
                  size: 30,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      flightData.airline,
                      style: TextStyle(
                        color: Colors.blue.shade800,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Chuyến bay ${flightData.flightNumber}',
                      style: TextStyle(
                        color: Colors.blue.shade600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Text(
              flightData.aircraft,
              style: TextStyle(
                color: Colors.blue.shade700,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlightRoute(Flight flightData) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      flightData.departure.code,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      flightData.departure.name,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat('HH:mm').format(flightData.departureTime),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy').format(flightData.departureTime),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      flightData.duration,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.blue.shade800,
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 80,
                    height: 2,
                    color: Colors.blue.shade300,
                  ),
                  const SizedBox(height: 4),
                  Icon(
                    Icons.flight_takeoff,
                    color: Colors.blue.shade600,
                    size: 20,
                  ),
                ],
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      flightData.arrival.code,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Text(
                      flightData.arrival.name,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      DateFormat('HH:mm').format(flightData.arrivalTime),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      DateFormat('dd/MM/yyyy').format(flightData.arrivalTime),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFlightDetails(Flight flightData) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thông tin chuyến bay',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Số chuyến bay', flightData.flightNumber),
          _buildDetailRow('Hãng hàng không', flightData.airline),
          _buildDetailRow('Máy bay', flightData.aircraft),
          _buildDetailRow('Thời gian bay', flightData.duration),
          _buildDetailRow('Ghế trống', '${flightData.availableSeats} ghế'),
          _buildDetailRow('Loại ghế', 'Economy Class'), // From API: cabin_class
          _buildDetailRow('Hành lý', '1 kiện x 23kg (miễn phí)'), // From API: baggage_kg
          _buildDetailRow('Trạng thái', flightData.availableSeats > 0 ? 'Còn chỗ' : 'Hết chỗ'),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                color: Colors.grey.shade600,
                fontSize: 14,
              ),
            ),
          ),
          const Text(': ', style: TextStyle(fontSize: 14)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricingDetails() {
    final double outboundPrice = flight.price;
    final double returnPrice = returnFlight?.price ?? 0;
    final double totalPrice = outboundPrice + returnPrice;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt, color: Colors.blue.shade700),
              const SizedBox(width: 8),
              const Text(
                'Chi tiết giá vé',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Outbound flight pricing
          _buildPriceRow('🛫 Chuyến bay đi', outboundPrice),
          
          // Return flight pricing (if exists)
          if (returnFlight != null) 
            _buildPriceRow('🛬 Chuyến bay về', returnPrice),
          
          const Divider(height: 24),
          _buildPriceRow(
            returnFlight != null ? 'Tổng cộng (khứ hồi)' : 'Tổng cộng',
            totalPrice,
            isTotal: true,
          ),
          const SizedBox(height: 8),
          Text(
            'Giá vé cho $passengers hành khách',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
            ),
          ),
          Text(
            '${NumberFormat('#,###', 'vi').format(amount)} ₫',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w500,
              fontSize: isTotal ? 16 : 14,
              color: isTotal ? Colors.green.shade700 : Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerInfoForFlight(String title, Flight flightData, int passengerCount) {
    final Color primaryColor = title.contains('đi') ? Colors.blue[600]! : Colors.green[600]!;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.05),
            blurRadius: 8,
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
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  title.contains('đi') ? Icons.flight_takeoff : Icons.flight_land,
                  color: primaryColor,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Số hành khách', '$passengerCount người'),
          _buildDetailRow('Loại vé', 'Người lớn'),
          _buildDetailRow('Hãng bay', flightData.airline),
          _buildDetailRow('Số chuyến bay', flightData.flightNumber),
          _buildDetailRow('Ngày bay', DateFormat('dd/MM/yyyy').format(flightData.departureTime)),
          _buildDetailRow('Giờ khởi hành', DateFormat('HH:mm').format(flightData.departureTime)),
        ],
      ),
    );
  }

  Widget _buildPolicies() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF3B82F6).withOpacity(0.15), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.policy, color: Colors.green.shade700),
              const SizedBox(width: 8),
              const Text(
                'Chính sách vé',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildPolicyItem(
            'Hoàn vé',
            'Không hoàn vé',
            Icons.cancel,
            Colors.red,
          ),
          _buildPolicyItem(
            'Đổi vé',
            'Đổi vé mất phí 500k',
            Icons.sync,
            Colors.orange,
          ),
          _buildPolicyItem(
            'Hành lý',
            '1 kiện x 23kg (miễn phí)',
            Icons.luggage,
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildPolicyItem(String title, String description, IconData icon, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
                Text(
                  description,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
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
            color: Colors.grey.withValues(alpha: 0.3),
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
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  side: BorderSide(color: Colors.blue.shade600, width: 2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Chọn lại',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.blue.shade600,
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
                      builder: (context) => BookingConfirmationScreen(
                        outboundFlight: flight,
                        returnFlight: returnFlight,
                        passengers: passengers,
                        returnDate: returnDate,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue.shade600,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Xác nhận',
                  style: TextStyle(
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
