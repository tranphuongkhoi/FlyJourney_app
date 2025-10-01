import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:fly_journey/src/features/booking/data/booking_repository.dart';
import 'package:fly_journey/src/features/payment/presentation/payment_flow_screen.dart';
import 'package:fly_journey/src/core/constants/colors.dart';
import 'package:fly_journey/src/features/booking/presentation/screens/my_bookings_screen.dart';

class BookingDetailScreen extends StatefulWidget {
  final String bookingId;

  const BookingDetailScreen({super.key, required this.bookingId});

  @override
  State<BookingDetailScreen> createState() => _BookingDetailScreenState();
}

class _BookingDetailScreenState extends State<BookingDetailScreen> {
  late Future<Map<String, dynamic>> _future;

  @override
  void initState() {
    super.initState();
    _future = BookingRepository.fetchBookingByIdRaw(widget.bookingId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Same as MyBookingsScreen
      appBar: AppBar(
        title: Text('Chi tiết vé #${widget.bookingId}'),
        centerTitle: true,
        backgroundColor: Colors.white, // Same as MyBookingsScreen
        foregroundColor: Colors.black,
        elevation: 0,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Text(
                  'Không thể tải chi tiết vé:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }
          final data = snapshot.data!;
          return _buildContent(context, data);
        },
      ),
    );
  }

  Widget _buildContent(BuildContext context, Map<String, dynamic> data) {
    final theme = Theme.of(context);
    final status = (data['status'] ?? '').toString();
    final totalPrice = data['total_price'];
    final bookingId = (data['booking_id'] ?? data['id'] ?? '').toString();
    final pnrCode = (data['pnr_code'] ?? '').toString();
    final checkinStatus = (data['check_in_status'] ?? '').toString();
    final createdAt = _parseDate(data['created_at']);
    final updatedAt = _parseDate(data['updated_at']);
    final departureTime = _parseDate(data['departure_time']);
    final arrivalTime = _parseDate(data['arrival_time']);
    final duration = data['duration'];
    final depCode = (data['departure_airport_code'] ?? '').toString();
    final arrCode = (data['arrival_airport_code'] ?? '').toString();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16), // Normal padding
      children: [
        // Tổng quan đặt chỗ
        _section(
          title: 'Tổng quan đặt chỗ',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _row('Mã đặt chỗ', '#$bookingId'),
              if (pnrCode.isNotEmpty) _row('Mã PNR', pnrCode),
              _row('Trạng thái check-in', checkinStatus.isEmpty ? '--' : checkinStatus),
              if (createdAt != null)
                _row('Tạo lúc', DateFormat('HH:mm dd/MM/yyyy').format(createdAt)),
              if (updatedAt != null)
                _row('Cập nhật', DateFormat('HH:mm dd/MM/yyyy').format(updatedAt)),
            ],
          ),
        ),

        const SizedBox(height: 12),
        _section(
          child: Row(
            children: [
              const Icon(Icons.flight_takeoff, color: Colors.blue),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Tuyến đường', style: theme.textTheme.titleMedium),
                    const SizedBox(height: 6),
                    Text('$depCode → $arrCode', style: theme.textTheme.bodyLarge),
                  ],
                ),
              ),
              _statusChip(status),
            ],
          ),
        ),

        const SizedBox(height: 12),
        _section(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _kv('Khởi hành', departureTime != null ? DateFormat('HH:mm dd/MM/yyyy').format(departureTime) : '--'),
              _kv('Hạ cánh', arrivalTime != null ? DateFormat('HH:mm dd/MM/yyyy').format(arrivalTime) : '--'),
              _kv('Thời lượng', duration is int ? _formatDuration(duration) : (duration?.toString() ?? '--')),
            ],
          ),
        ),

        const SizedBox(height: 12),
        _section(
          title: 'Liên hệ',
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _row('Họ tên', data['contact_name']),
              _row('Email', data['contact_email']),
              _row('Số điện thoại', data['contact_phone']),
              if ((data['contact_address'] ?? '').toString().isNotEmpty)
                _row('Địa chỉ', data['contact_address']),
              if ((data['note'] ?? '').toString().isNotEmpty)
                _row('Ghi chú', data['note']),
              _row('Tổng giá', _formatCurrency(totalPrice)),
            ],
          ),
        ),

        const SizedBox(height: 12),
        _section(
          title: 'Hành khách',
          child: _buildPassengers(data['details'] as List? ?? const []),
        ),

        const SizedBox(height: 12),
        _section(
          title: 'Dịch vụ bổ sung',
          child: _buildAncillaries(data['ancillaries'] as List? ?? const []),
        ),

        const SizedBox(height: 12),
        _section(
          title: 'Thanh toán',
          child: _buildPayment(data['payment'] as Map<String, dynamic>?),
        ),
        
        const SizedBox(height: 24),
        _buildActionButtons(context, data),
        const SizedBox(height: 24),
      ],
    );
  }

  Widget _buildPassengers(List list) {
    if (list.isEmpty) {
      return const Text('Không có dữ liệu hành khách');
    }
    return Column(
      children: List.generate(list.length, (i) {
        final p = list[i] as Map<String, dynamic>;
        final name = '${p['first_name'] ?? ''} ${p['last_name'] ?? ''}'.trim();
        final gender = (p['passenger_gender'] ?? '').toString();
        final rawIdType = (p['id_type'] ?? '').toString();
        final idType = _formatIdType(rawIdType);
        final idNumber = (p['id_number'] ?? '').toString();
        final idNumberLabel = _idNumberLabel(rawIdType);
        final dob = _parseDate(p['date_of_birth']);
        final expiry = _parseDate(p['expiry_date']);
        final nationality = (p['nationality'] ?? '').toString();
        final issuing = (p['issuing_country'] ?? '').toString();
        final seat = (p['seat_id']?.toString() ?? '').toString();
        final cls = (p['flight_class_name'] ?? '').toString();
        final age = (p['passenger_age']?.toString() ?? '').toString();
        return _subCard([
          _row('Họ tên', name),
          if (age.isNotEmpty) _row('Tuổi', age),
          if (cls.isNotEmpty) _row('Hạng ghế', cls),
          if (seat.isNotEmpty && seat != 'null') _row('Số ghế', seat),
          _row('Giới tính', gender),
          _row('Ngày sinh', dob != null ? DateFormat('dd/MM/yyyy').format(dob) : '--'),
          _row('Loại giấy tờ', idType),
          _row(idNumberLabel, idNumber),
          if (nationality.isNotEmpty) _row('Quốc tịch', nationality),
          if (issuing.isNotEmpty) _row('Nơi cấp', issuing),
          if (expiry != null) _row('Hết hạn', DateFormat('dd/MM/yyyy').format(expiry)),
        ]);
      }),
    );
  }

  Widget _buildAncillaries(List list) {
    if (list.isEmpty) {
      return const Text('Không có dịch vụ bổ sung');
    }
    return Column(
      children: List.generate(list.length, (i) {
        final a = list[i] as Map<String, dynamic>;
        final created = _parseDate(a['created_at']);
        return _subCard([
          _row('Loại', a['type']),
          _row('Mô tả', a['description']),
          _row('Số lượng', a['quantity']),
          _row('Giá', _formatCurrency(a['price'])),
          if (created != null)
            _row('Thời gian', DateFormat('HH:mm dd/MM/yyyy').format(created)),
        ]);
      }),
    );
  }

  Widget _buildPayment(Map<String, dynamic>? p) {
    if (p == null) {
      return const Text('Chưa có thanh toán');
    }
    final paidAt = _parseDate(p['paid_at']);
    return _subCard([
      _row('Trạng thái', p['status']),
      _row('Số tiền', p['amount']),
      _row('Phương thức', p['payment_method']),
      _row('Mã giao dịch', p['transaction_id']),
      _row('Thanh toán lúc', paidAt != null ? DateFormat('HH:mm dd/MM/yyyy').format(paidAt) : '--'),
    ]);
  }

  Widget _buildActionButtons(BuildContext context, Map<String, dynamic> data) {
    final status = (data['status'] ?? '').toString().toLowerCase();
    final canPay = status.contains('pending');
    final canCancel = status.contains('pending') || status.contains('waiting');
    final bookingId = (data['booking_id'] ?? data['id'] ?? '').toString();
    final amountDynamic = data['total_price'] ?? 0;
    final amount = amountDynamic is num
        ? amountDynamic.toDouble()
        : double.tryParse(amountDynamic.toString().replaceAll(',', '').replaceAll(' ', '')) ?? 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: canCancel ? _buildThreeButtons(context, bookingId, canPay, amount) : _buildTwoButtons(context, canPay, bookingId, amount),
    );
  }

  Widget _buildTwoButtons(BuildContext context, bool canPay, String bookingId, double amount) {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 56,
            child: OutlinedButton(
              onPressed: () => _navigateBackToBookings(context),
              child: const Text(
                'Về vé của tôi',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF3B82F6), width: 2),
                foregroundColor: const Color(0xFF3B82F6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: canPay
                  ? () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => PaymentFlowScreen(
                            bookingId: bookingId,
                            amount: amount,
                          ),
                        ),
                      );
                    }
                  : null,
              child: const Text(
                'Thanh toán',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: canPay ? const Color(0xFF3B82F6) : const Color(0xFF94A3B8),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildThreeButtons(BuildContext context, String bookingId, bool canPay, double amount) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: SizedBox(
                height: 56,
                child: OutlinedButton(
                  onPressed: () => _navigateBackToBookings(context),
                  child: const Text(
                    'Về vé của tôi',
                    style: TextStyle(
                      fontFamily: 'BalooBhaijaan2',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF3B82F6), width: 2),
                    foregroundColor: const Color(0xFF3B82F6),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 56,
                child: ElevatedButton(
                  onPressed: canPay
                      ? () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) => PaymentFlowScreen(
                                bookingId: bookingId,
                                amount: amount,
                              ),
                            ),
                          );
                        }
                      : null,
                  child: const Text(
                    'Thanh toán',
                    style: TextStyle(
                      fontFamily: 'BalooBhaijaan2',
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: canPay ? const Color(0xFF3B82F6) : const Color(0xFF94A3B8),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 0,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: OutlinedButton(
            onPressed: () => _showCancelDialog(context, bookingId),
            child: const Text(
              'Hủy vé',
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.red, width: 2),
              foregroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ),
      ],
    );
  }

  void _showCancelDialog(BuildContext context, String bookingId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          contentPadding: const EdgeInsets.all(32),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Icon(
                  Icons.cancel_outlined,
                  size: 40,
                  color: Colors.red[600],
                ),
              ),
              const SizedBox(height: 24),
              
              // Title
              const Text(
                'Xác nhận hủy vé',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              
              // Content
              const Text(
                'Bạn có chắc chắn muốn hủy vé này không? Hành động này không thể hoàn tác.',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF64748B),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Đóng dialog
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF64748B),
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Không',
                        style: TextStyle(
                          fontFamily: 'BalooBhaijaan2',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Đóng dialog
                        _cancelBooking(bookingId);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Hủy vé',
                        style: TextStyle(
                          fontFamily: 'BalooBhaijaan2',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _cancelBooking(String bookingId) async {
    // TODO: Implement actual cancel booking API call
    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 1));
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Vé đã được hủy thành công'),
            backgroundColor: Colors.green,
          ),
        );
        
        // Navigate back to bookings list
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Không thể hủy vé: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _navigateBackToBookings(BuildContext context) {
    // Navigate back to MainScreen with My Bookings tab selected
    Navigator.pushNamedAndRemoveUntil(
      context,
      '/main',
      (route) => false,
      arguments: {'initialTab': 3}, // 3 = My Bookings tab (index 3)
    );
  }

  Widget _statusChip(String status) {
    final s = status.toLowerCase();
    Color bg;
    Color fg;
    String label;
    if (s.contains('pending')) {
      bg = Colors.orange.shade100;
      fg = Colors.orange.shade700;
      label = 'Chờ thanh toán';
    } else if (s.contains('cancel')) {
      bg = Colors.red.shade100;
      fg = Colors.red.shade700;
      label = 'Đã hủy';
    } else if (s.contains('complete')) {
      bg = Colors.blue.shade100;
      fg = Colors.blue.shade700;
      label = 'Hoàn thành';
    } else {
      bg = Colors.green.shade100;
      fg = Colors.green.shade700;
      label = 'Đã xác nhận';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(14)),
      child: Text(label, style: TextStyle(color: fg, fontWeight: FontWeight.w600)),
    );
  }

  Widget _section({Widget? child, String? title}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF3B82F6).withOpacity(0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),
          ],
          if (child != null) child,
        ],
      ),
    );
  }

  Widget _subCard(List<Widget> children) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF3B82F6).withOpacity(0.15),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  Widget _kv(String k, String v) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(k, style: TextStyle(color: Colors.grey.shade600, fontSize: 12)),
        const SizedBox(height: 4),
        Text(v, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  Widget _row(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              (value == null) ? '--' : value.toString(),
              style: const TextStyle(fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
    );
  }

  DateTime? _parseDate(dynamic v) {
    if (v == null) return null;
    return DateTime.tryParse(v.toString());
  }

  String _formatDuration(int minutes) {
    final h = minutes ~/ 60;
    final m = minutes % 60;
    return '${h}h ${m}m';
  }

  String _formatCurrency(dynamic value) {
    final num? n = (value is num)
        ? value
        : (value is String)
            ? num.tryParse(value.replaceAll(',', '').replaceAll(' ', ''))
            : null;
    if (n == null) return value?.toString() ?? '--';
    return '${NumberFormat('#,###', 'vi').format(n)} ₫';
  }

  String _formatIdType(String? idType) {
    final t = (idType ?? '').toLowerCase();
    if (t == 'id_card') return 'CCCD/CMND';
    if (t == 'passport') return 'Hộ chiếu';
    if (t.isEmpty) return '--';
    // Fallback: capitalize first letter
    return t[0].toUpperCase() + t.substring(1);
  }

  String _idNumberLabel(String? idType) {
    final t = (idType ?? '').toLowerCase();
    if (t == 'id_card') return 'Số CCCD/CMND';
    if (t == 'passport') return 'Số hộ chiếu';
    return 'Số giấy tờ';
  }
}
