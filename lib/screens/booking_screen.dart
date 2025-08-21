import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cnh_n/models/flight.dart';
import 'package:cnh_n/models/passenger.dart';
import 'package:cnh_n/models/booking.dart';
import 'package:cnh_n/services/storage_service.dart';

class BookingScreen extends StatefulWidget {
  final Flight flight;
  final int passengers;
  final DateTime? returnDate;

  const BookingScreen({
    super.key,
    required this.flight,
    required this.passengers,
    this.returnDate,
  });

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  final _formKey = GlobalKey<FormState>();
  final List<Map<String, TextEditingController>> _passengerControllers = [];
  final _contactEmailController = TextEditingController();
  final _contactPhoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    for (int i = 0; i < widget.passengers; i++) {
      _passengerControllers.add({
        'firstName': TextEditingController(),
        'lastName': TextEditingController(),
        'idNumber': TextEditingController(),
        'email': TextEditingController(),
        'phone': TextEditingController(),
      });
    }
  }

  @override
  void dispose() {
    for (final controllers in _passengerControllers) {
      for (final controller in controllers.values) {
        controller.dispose();
      }
    }
    _contactEmailController.dispose();
    _contactPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thông tin đặt vé',
          style: TextStyle(
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        iconTheme: IconThemeData(
          color: Theme.of(context).colorScheme.onPrimaryContainer,
        ),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildFlightSummary(),
              const SizedBox(height: 24),
              _buildPassengerForms(),
              const SizedBox(height: 24),
              _buildContactInfo(),
              const SizedBox(height: 24),
              _buildPriceBreakdown(),
              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomBar(),
    );
  }

  Widget _buildFlightSummary() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.flight_takeoff,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Tóm tắt chuyến bay',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(widget.flight.airlineLogo),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.flight.airline} ${widget.flight.flightNumber}',
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        '${widget.flight.departure.code} → ${widget.flight.arrival.code}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      Text(
                        DateFormat('dd/MM/yyyy HH:mm')
                            .format(widget.flight.departureTime),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
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
      ),
    );
  }

  Widget _buildPassengerForms() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Thông tin hành khách',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 16),
        ...List.generate(
          widget.passengers,
          (index) => _buildPassengerForm(index),
        ),
      ],
    );
  }

  Widget _buildPassengerForm(int index) {
    final controllers = _passengerControllers[index];
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Hành khách ${index + 1}',
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: controllers['firstName'],
                    decoration: const InputDecoration(
                      labelText: 'Tên',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập tên';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: controllers['lastName'],
                    decoration: const InputDecoration(
                      labelText: 'Họ',
                      border: OutlineInputBorder(),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập họ';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controllers['idNumber'],
              decoration: const InputDecoration(
                labelText: 'Số CMND/CCCD',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập số CMND/CCCD';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controllers['email'],
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập email';
                }
                if (!value.contains('@')) {
                  return 'Email không hợp lệ';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: controllers['phone'],
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Số điện thoại',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập số điện thoại';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactInfo() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.contact_phone,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Thông tin liên hệ',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contactEmailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                labelText: 'Email liên hệ',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.email),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập email liên hệ';
                }
                if (!value.contains('@')) {
                  return 'Email không hợp lệ';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _contactPhoneController,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: 'Số điện thoại liên hệ',
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.phone),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Vui lòng nhập số điện thoại liên hệ';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPriceBreakdown() {
    final totalPrice = widget.flight.price * widget.passengers;
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.receipt,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 8),
                Text(
                  'Chi tiết thanh toán',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Giá vé x ${widget.passengers} người',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  '${NumberFormat('#,###', 'vi').format(totalPrice)} ₫',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Thuế và phí',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Text(
                  'Đã bao gồm',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.green.shade600,
                      ),
                ),
              ],
            ),
            const Divider(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Tổng thanh toán',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                Text(
                  '${NumberFormat('#,###', 'vi').format(totalPrice)} ₫',
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomBar() {
    final totalPrice = widget.flight.price * widget.passengers;
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade300,
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Tổng thanh toán',
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
                Text(
                  '${NumberFormat('#,###', 'vi').format(totalPrice)} ₫',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: _isLoading ? null : _completeBooking,
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Text(
                    'Xác nhận đặt vé',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                          color: Theme.of(context).colorScheme.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
          ),
        ],
      ),
    );
  }

  Future<void> _completeBooking() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final passengers = <Passenger>[];
      for (int i = 0; i < widget.passengers; i++) {
        final controllers = _passengerControllers[i];
        passengers.add(
          Passenger(
            firstName: controllers['firstName']!.text,
            lastName: controllers['lastName']!.text,
            idNumber: controllers['idNumber']!.text,
            idType: 'CMND/CCCD',
            dateOfBirth:
                DateTime.now().subtract(const Duration(days: 365 * 25)),
            gender: 'Nam',
            email: controllers['email']!.text,
            phone: controllers['phone']!.text,
          ),
        );
      }

      final booking = Booking(
        bookingId: 'VN${DateTime.now().millisecondsSinceEpoch}',
        flight: widget.flight,
        passengers: passengers,
        bookingDate: DateTime.now(),
        totalPrice: widget.flight.price * widget.passengers,
        status: BookingStatus.confirmed,
        contactEmail: _contactEmailController.text,
        contactPhone: _contactPhoneController.text,
      );

      await StorageService.saveBooking(booking);

      if (mounted) {
        _showSuccessDialog(booking);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Có lỗi xảy ra: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSuccessDialog(Booking booking) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: Icon(
          Icons.check_circle,
          color: Colors.green,
          size: 64,
        ),
        title: const Text('Đặt vé thành công!'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Mã đặt chỗ: ${booking.bookingId}'),
            const SizedBox(height: 8),
            Text(
              'Vui lòng lưu mã đặt chỗ để tra cứu vé.',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).popUntil((route) => route.isFirst);
            },
            child: const Text('Về trang chủ'),
          ),
        ],
      ),
    );
  }
}
