import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fly_journey/src/core/constants/colors.dart';
import 'package:fly_journey/src/features/search/domain/models/flight.dart';
import 'package:fly_journey/src/features/booking/domain/models/passenger_models.dart';
import 'package:fly_journey/src/features/booking/data/booking_repository.dart';
import 'package:fly_journey/src/features/auth/data/services/auth_service.dart';
import 'package:fly_journey/src/features/auth/presentation/screens/login_screen.dart';
import 'package:fly_journey/src/core/constants/baggage_options.dart';
import 'package:fly_journey/src/core/constants/services_mapping.dart';
import 'package:fly_journey/src/features/booking/presentation/screens/booking_detail_screen.dart';

class BookingSummaryScreen extends StatefulWidget {
  final Flight outboundFlight;
  final Flight? returnFlight;
  final int passengers;
  final DateTime? returnDate;
  final List<PassengerInfo> passengersList;
  final ContactInfo contactInfo;
  final List<String> baggageSelections; // per passenger baggage id
  final List<String> selectedServices;  // service ids applied to all passengers

  const BookingSummaryScreen({
    super.key,
    required this.outboundFlight,
    this.returnFlight,
    required this.passengers,
    this.returnDate,
    required this.passengersList,
    required this.contactInfo,
    required this.baggageSelections,
    required this.selectedServices,
  });

  @override
  State<BookingSummaryScreen> createState() => _BookingSummaryScreenState();
}

class _BookingSummaryScreenState extends State<BookingSummaryScreen> {
  bool _submitting = false;

  int get _baggageTotal => widget.baggageSelections
      .map((id) => BaggageOptions.byId(id).price)
      .fold(0, (a, b) => a + b);

  int get _servicesTotal => widget.selectedServices
      .map((id) => ServiceMapping.byId(id).price * widget.passengers)
      .fold(0, (a, b) => a + b);

  double get _baseTotal =>
      (widget.outboundFlight.price + (widget.returnFlight?.price ?? 0)) * widget.passengers;

  double get _grandTotal => _baseTotal + _baggageTotal + _servicesTotal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _topBar(),
            _progress(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sectionHeader('Tóm tắt chuyến bay', Icons.flight_takeoff),
                    const SizedBox(height: 12),
                    _flightCard(widget.outboundFlight, 'Chuyến bay đi'),
                    if (widget.returnFlight != null) ...[
                      const SizedBox(height: 12),
                      _flightCard(widget.returnFlight!, 'Chuyến bay về'),
                    ],
                    const SizedBox(height: 24),
                    _sectionHeader('Hành khách', Icons.people_alt),
                    const SizedBox(height: 12),
                    ...List.generate(widget.passengersList.length, (i) => _passengerTile(i)),
                    const SizedBox(height: 24),
                    _sectionHeader('Dịch vụ bổ sung', Icons.miscellaneous_services),
                    const SizedBox(height: 12),
                    _servicesSummary(),
                    const SizedBox(height: 24),
                    _sectionHeader('Chi phí', Icons.receipt_long),
                    const SizedBox(height: 12),
                    _pricing(),
                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
            _bottomBar(),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryBlue, size: 20),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Widget _topBar() {
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
              child: const Icon(Icons.arrow_back, color: Color(0xFF6B7280), size: 20),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Xác nhận đặt vé',
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const Spacer(),
          const Text('Bước 3 / 3', style: TextStyle(fontSize: 14, color: Color(0xFF64748B))),
        ],
      ),
    );
  }

  Widget _progress() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _step(1, 'Xác nhận', completed: true),
          _line(active: true),
          _step(2, 'Hành khách', completed: true),
          _line(active: true),
          _step(3, 'Đặt vé', active: true),
        ],
      ),
    );
  }

  Widget _step(int n, String label, {bool completed = false, bool active = false}) {
    final color = (completed || active) ? AppColors.primaryBlue : Colors.grey.shade300;
    final showLabel = active;
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 50,
          height: 50,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          child: Center(
            child: completed
                ? const Icon(Icons.check, color: Colors.white, size: 24)
                : Text('$n', style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
          ),
        ),
        const SizedBox(height: 8),
        AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: showLabel ? 1 : 0,
          child: Text(label, style: TextStyle(color: showLabel ? AppColors.primaryBlue : Colors.transparent)),
        ),
      ],
    );
  }

  Widget _line({required bool active}) {
    return Container(
      width: 60,
      height: 3,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      decoration: BoxDecoration(color: active ? AppColors.primaryBlue : Colors.grey.shade300, borderRadius: BorderRadius.circular(2)),
    );
  }

  Widget _flightCard(Flight flight, String title) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2))],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text('${flight.departure.code} → ${flight.arrival.code}'),
        Text(DateFormat('dd/MM/yyyy HH:mm').format(flight.departureTime)),
        Text('Hãng: ${flight.airline}  |  Hạng: ${flight.flightClass}')
      ]),
    );
  }

  Widget _passengerTile(int index) {
    final p = widget.passengersList[index];
    final bgOpt = BaggageOptions.byId(widget.baggageSelections[index]);
    final bgText = bgOpt.price == 0
        ? 'Không mua thêm'
        : '${bgOpt.label} (+${NumberFormat('#,###', 'vi').format(bgOpt.price)} ₫)';
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Hành khách ${index + 1}: ${p.lastName} ${p.firstName}', style: const TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: 4),
        Text('Giới tính: ${p.gender} • Quốc tịch: ${p.nationality}'),
        Text('Giấy tờ: ${p.documentType} - ${p.documentNumber}'),
        Text('Hành lý thêm: $bgText'),
      ]),
    );
  }

  Widget _servicesSummary() {
    if (widget.selectedServices.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(color: Colors.grey.shade50, borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.grey.shade200)),
        child: const Text('Không chọn dịch vụ bổ sung'),
      );
    }
    return Column(
      children: widget.selectedServices.map((id) {
        final s = ServiceMapping.byId(id);
        final perPax = NumberFormat('#,###', 'vi').format(s.price);
        final total = NumberFormat('#,###', 'vi').format(s.price * widget.passengers);
        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: const Icon(Icons.check_circle, color: Colors.green),
          title: Text(s.label),
          subtitle: Text('${s.desc ?? ''}'),
          trailing: Text('$perPax ₫/khách • Tổng $total ₫'),
        );
      }).toList(),
    );
  }

  Widget _pricing() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12), boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 2)),
      ]),
      child: Column(children: [
        _row('Giá vé x ${widget.passengers} người', NumberFormat('#,###', 'vi').format(_baseTotal)),
        if (_baggageTotal > 0) _row('Hành lý ký gửi thêm', '+${NumberFormat('#,###', 'vi').format(_baggageTotal)}'),
        if (_servicesTotal > 0) _row('Dịch vụ bổ sung', '+${NumberFormat('#,###', 'vi').format(_servicesTotal)}'),
        const Divider(height: 24),
        _row('Tổng thanh toán', NumberFormat('#,###', 'vi').format(_grandTotal), emphasize: true),
      ]),
    );
  }

  Widget _row(String left, String right, {bool emphasize = false}) {
    final style = emphasize
        ? const TextStyle(fontWeight: FontWeight.w700)
        : const TextStyle(fontWeight: FontWeight.w500);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(left),
        Text(right, style: style),
      ]),
    );
  }

  Widget _bottomBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -2)),
      ]),
      child: SafeArea(
        child: Row(children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisSize: MainAxisSize.min, children: [
              const Text('Tổng thanh toán', style: TextStyle(color: Color(0xFF64748B))),
              Text(
                '${NumberFormat('#,###', 'vi').format(_grandTotal)} ₫',
                style: TextStyle(fontWeight: FontWeight.w700, color: AppColors.primaryBlue, fontSize: 20),
              ),
            ]),
          ),
          ElevatedButton(
            onPressed: _submitting ? null : _submitBooking,
            style: ElevatedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
            child: _submitting
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2))
                : const Text('Đặt vé'),
          ),
        ]),
      ),
    );
  }

  Future<void> _submitBooking() async {
    final auth = AuthService();
    if (!auth.isLoggedIn) {
      // Ask user to log in, then continue booking submission
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => LoginScreen(
            onSuccess: () {
              // After login, resume booking submission
              _submitBooking();
            },
          ),
        ),
      );
      return;
    }

    setState(() => _submitting = true);
    try {
      final result = await BookingRepository.createBooking(
        outboundFlight: widget.outboundFlight,
        returnFlight: widget.returnFlight,
        passengers: widget.passengersList,
        contact: widget.contactInfo,
        baggageSelections: widget.baggageSelections,
        selectedServices: widget.selectedServices,
        totalAmount: _grandTotal,
      );
      if (!mounted) return;
      // Navigate to booking detail if id exists
      if (result != null && result['booking_id'] != null) {
        final id = result['booking_id'].toString();
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => BookingDetailScreen(bookingId: id)),
        );
      } else {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi đặt vé: $e')));
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }
}
