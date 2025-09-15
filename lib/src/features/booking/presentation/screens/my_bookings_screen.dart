import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fly_journey/src/features/booking/domain/models/booking.dart';
// Local storage removed for bookings – using real API only
import 'package:fly_journey/src/features/auth/data/services/auth_service.dart';
import 'package:fly_journey/src/features/booking/data/booking_repository.dart';
import 'package:fly_journey/src/features/booking/presentation/screens/booking_detail_screen.dart';
import 'package:fly_journey/src/features/payment/presentation/payment_flow_screen.dart';

class MyBookingsScreen extends StatefulWidget {
  final VoidCallback? onNavigateToSearch;
  final String? initialOpenBookingId; // optional: deep-open one booking
  
  const MyBookingsScreen({super.key, this.onNavigateToSearch, this.initialOpenBookingId});

  @override
  State<MyBookingsScreen> createState() => _MyBookingsScreenState();
}

class _MyBookingsScreenState extends State<MyBookingsScreen> {
  List<Booking> _bookings = [];
  bool _isLoading = true;
  final AuthService _authService = AuthService();
  BookingStatus? _filterStatus; // null = all
  TripTypeFilter _tripType = TripTypeFilter.all;
  SortOption _sort = SortOption.bookingIdDesc;
  String _search = '';
  final TextEditingController _searchCtrl = TextEditingController();
  bool _didOpenInitial = false;

  @override
  void initState() {
    super.initState();
    _loadBookings();
  }

  Future<void> _loadBookings() async {
    try {
      if (!_authService.isLoggedIn) {
        setState(() {
          _bookings = [];
          _isLoading = false;
        });
        return;
      }

      final bookings = await BookingRepository.fetchMyBookings();
      setState(() {
        _bookings = bookings;
        _isLoading = false;
      });

      // Deep open a specific booking once
      if (!_didOpenInitial && (widget.initialOpenBookingId?.isNotEmpty ?? false)) {
        _didOpenInitial = true;
        final id = widget.initialOpenBookingId!;
        final local = _bookings.where((b) => b.bookingId == id).toList();
        if (local.isNotEmpty) {
          _openBookingDetails(local.first);
        } else {
          // Fallback: fetch detail by id then open
          try {
            final detail = await BookingRepository.fetchBookingById(id);
            if (mounted) _openBookingDetails(detail);
          } catch (_) {}
        }
      }
    } catch (e) {
      setState(() => _isLoading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Có lỗi xảy ra: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA), // Homepage background color
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0F7FA), // Homepage background color
        elevation: 0,
        toolbarHeight: 80, // Increased height to match explore screen spacing
        title: const Text(
          'Thông tin vé đã đặt',
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 28,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        centerTitle: true, // Center the title to match explore screen
        iconTheme: const IconThemeData(
          color: Color(0xFF1E293B),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : !_authService.isLoggedIn
              ? _buildLoginRequired()
              : _buildBookingsList(),
    );
  }

  Widget _buildLoginRequired() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.lock_outline,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Vui lòng đăng nhập',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Đăng nhập để xem các vé đã đặt của bạn',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pushNamed('/login'),
            icon: const Icon(Icons.login),
            label: const Text('Đến màn đăng nhập'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.flight_takeoff,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Chưa có vé nào',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Hãy đặt vé máy bay đầu tiên của bạn',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: widget.onNavigateToSearch ?? () => Navigator.pop(context),
            icon: const Icon(Icons.search),
            label: const Text('Tìm chuyến bay'),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 2,
      child: InkWell(
        onTap: () => _openBookingDetails(booking),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBookingHeader(booking),
              const SizedBox(height: 16),
              _buildFlightInfo(booking),
              const SizedBox(height: 16),
              _buildBookingFooter(booking),
              const SizedBox(height: 12),
              _buildActions(booking),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBookingHeader(Booking booking) {
    return Row(
      children: [
        (booking.flight.airlineLogo.isNotEmpty)
            ? Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  image: DecorationImage(
                    image: NetworkImage(booking.flight.airlineLogo),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey.shade200,
                child: const Icon(Icons.flight, color: Colors.blue),
              ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                booking.bookingId,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
              Text(
                '${booking.flight.airline.isNotEmpty ? booking.flight.airline : 'Chuyến bay'} ${booking.flight.flightNumber}'.trim(),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
        ),
        _buildStatusChip(booking.status),
      ],
    );
  }

  Widget _buildBookingsList() {
    final visible = _filteredBookings();

    return RefreshIndicator(
      onRefresh: _loadBookings,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 1 + visible.length,
        itemBuilder: (context, index) {
          if (index == 0) return _buildFilters();
          final booking = visible[index - 1];
          return _buildBookingCard(booking);
        },
      ),
    );
  }

  Widget _buildFilters() {
    final total = _bookings.length;
    final confirmed = _countByStatus(BookingStatus.confirmed);
    final pending = _countByStatus(BookingStatus.pendingPayment);
    final cancelled = _countByStatus(BookingStatus.cancelled);
    final oneWay = _bookings.where((b) => !b.isRoundTrip).length;
    final roundTrip = _bookings.where((b) => b.isRoundTrip).length;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth > 700;
          final children = <Widget>[
            _filterColumn(
              icon: Icons.tag,
              label: '# Trạng thái',
              child: DropdownButton<BookingStatus?>(
                isExpanded: true,
                value: _filterStatus,
                items: [
                  DropdownMenuItem(
                    value: null,
                    child: Text('Tất cả ($total)'),
                  ),
                  DropdownMenuItem(
                    value: BookingStatus.confirmed,
                    child: Text('Đã xác nhận ($confirmed)'),
                  ),
                  DropdownMenuItem(
                    value: BookingStatus.pendingPayment,
                    child: Text('Chờ xử lý ($pending)'),
                  ),
                  DropdownMenuItem(
                    value: BookingStatus.cancelled,
                    child: Text('Đã hủy ($cancelled)'),
                  ),
                ],
                onChanged: (v) => setState(() => _filterStatus = v),
              ),
            ),
            _filterColumn(
              icon: Icons.flight_class,
              label: '✈ Loại chuyến',
              child: DropdownButton<TripTypeFilter>(
                isExpanded: true,
                value: _tripType,
                items: [
                  DropdownMenuItem(
                    value: TripTypeFilter.all,
                    child: Text('Tất cả ($total)'),
                  ),
                  DropdownMenuItem(
                    value: TripTypeFilter.oneway,
                    child: Text('Một chiều ($oneWay)'),
                  ),
                  DropdownMenuItem(
                    value: TripTypeFilter.roundtrip,
                    child: Text('Khứ hồi ($roundTrip)'),
                  ),
                ],
                onChanged: (v) => setState(() => _tripType = v ?? TripTypeFilter.all),
              ),
            ),
            _filterColumn(
              icon: Icons.calendar_month,
              label: '📅 Sắp xếp',
              child: DropdownButton<SortOption>(
                isExpanded: true,
                value: _sort,
                items: const [
                  DropdownMenuItem(value: SortOption.bookingIdDesc, child: Text('Mã booking giảm dần')),
                  DropdownMenuItem(value: SortOption.bookingIdAsc, child: Text('Mã booking tăng dần')),
                  DropdownMenuItem(value: SortOption.dateNearest, child: Text('Ngày gần nhất')),
                  DropdownMenuItem(value: SortOption.dateFarthest, child: Text('Ngày xa nhất')),
                ],
                onChanged: (v) => setState(() => _sort = v ?? SortOption.bookingIdDesc),
              ),
            ),
            _filterColumn(
              icon: Icons.search,
              label: '🔍 Tìm kiếm',
              child: TextField(
                controller: _searchCtrl,
                decoration: InputDecoration(
                  hintText: 'Nhập mã booking...',
                  isDense: true,
                  suffixIcon: _search.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: () => setState(() {
                            _search = '';
                            _searchCtrl.clear();
                          }),
                        ),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onChanged: (v) => setState(() => _search = v.trim()),
              ),
            ),
          ];

          if (isWide) {
            return Row(
              children: [
                Expanded(child: children[0]),
                const SizedBox(width: 12),
                Expanded(child: children[1]),
                const SizedBox(width: 12),
                Expanded(child: children[2]),
                const SizedBox(width: 12),
                Expanded(child: children[3]),
              ],
            );
          }
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              children[0],
              const SizedBox(height: 12),
              children[1],
              const SizedBox(height: 12),
              children[2],
              const SizedBox(height: 12),
              children[3],
            ],
          );
        },
      ),
    );
  }

  Widget _filterColumn({required IconData icon, required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: const Color(0xFF64748B)),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF0F172A))),
          ],
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }

  Widget _buildFlightInfo(Booking booking) {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat('HH:mm').format(booking.flight.departureTime),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                booking.flight.departure.code,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              Text(
                booking.flight.departure.city,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
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
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                booking.flight.duration,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Theme.of(context).colorScheme.onPrimaryContainer,
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
                Container(
                  width: 40,
                  height: 2,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Icon(
                  Icons.flight,
                  color: Theme.of(context).colorScheme.primary,
                  size: 16,
                ),
                Container(
                  width: 40,
                  height: 2,
                  color: Theme.of(context).colorScheme.primary,
                ),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    shape: BoxShape.circle,
                  ),
                ),
              ],
            ),
          ],
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                DateFormat('HH:mm').format(booking.flight.arrivalTime),
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              Text(
                booking.flight.arrival.code,
                style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
              Text(
                booking.flight.arrival.city,
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildBookingFooter(Booking booking) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context)
            .colorScheme
            .primaryContainer
            .withValues(alpha: 0.3),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Ngày đặt',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
              Text(
                DateFormat('dd/MM/yyyy').format(booking.bookingDate),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                'Hành khách',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
              Text(
                '${booking.passengers.length} người',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'Tổng giá',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: Colors.grey.shade600,
                    ),
              ),
              Text(
                '${NumberFormat('#,###', 'vi').format(booking.totalPrice)} ₫',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.primary,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusChip(BookingStatus status) {
    Color backgroundColor;
    Color textColor;
    String text;

    switch (status) {
      case BookingStatus.confirmed:
        backgroundColor = Colors.green.shade100;
        textColor = Colors.green.shade700;
        text = 'Đã xác nhận';
        break;
      case BookingStatus.pendingPayment:
        backgroundColor = Colors.orange.shade100;
        textColor = Colors.orange.shade700;
        text = 'Chờ xử lý';
        break;
      case BookingStatus.cancelled:
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade700;
        text = 'Đã hủy';
        break;
      case BookingStatus.completed:
        backgroundColor = Colors.blue.shade100;
        textColor = Colors.blue.shade700;
        text = 'Hoàn thành';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
              color: textColor,
              fontWeight: FontWeight.w500,
            ),
      ),
    );
  }

  void _openBookingDetails(Booking booking) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => BookingDetailScreen(bookingId: booking.bookingId),
      ),
    );
  }

  int _countByStatus(BookingStatus s) => _bookings.where((b) => b.status == s).length;

  List<Booking> _filteredBookings() {
    List<Booking> list = List.of(_bookings);
    // search by booking id
    if (_search.isNotEmpty) {
      list = list.where((b) => b.bookingId.toLowerCase().contains(_search.toLowerCase())).toList();
    }
    // status filter
    if (_filterStatus != null) {
      list = list.where((b) => b.status == _filterStatus).toList();
    }
    // trip type
    switch (_tripType) {
      case TripTypeFilter.oneway:
        list = list.where((b) => !b.isRoundTrip).toList();
        break;
      case TripTypeFilter.roundtrip:
        list = list.where((b) => b.isRoundTrip).toList();
        break;
      case TripTypeFilter.all:
        break;
    }
    // sort
    int asInt(String s) => int.tryParse(s.replaceAll(RegExp(r'[^0-9]'), '')) ?? 0;
    list.sort((a, b) {
      switch (_sort) {
        case SortOption.bookingIdDesc:
          return asInt(b.bookingId).compareTo(asInt(a.bookingId));
        case SortOption.bookingIdAsc:
          return asInt(a.bookingId).compareTo(asInt(b.bookingId));
        case SortOption.dateNearest:
          final now = DateTime.now();
          final da = (a.bookingDate.difference(now)).abs();
          final db = (b.bookingDate.difference(now)).abs();
          return da.compareTo(db);
        case SortOption.dateFarthest:
          final now = DateTime.now();
          final da = (a.bookingDate.difference(now)).abs();
          final db = (b.bookingDate.difference(now)).abs();
          return db.compareTo(da);
      }
    });
    return list;
  }

  Widget _buildActions(Booking booking) {
    final canPay = booking.status == BookingStatus.pendingPayment;
    return Row(
      children: [
        Expanded(
          child: ElevatedButton.icon(
            onPressed: canPay ? () => _openPayment(booking) : null,
            icon: const Icon(Icons.payments),
            label: const Text('Thanh toán'),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () => _openBookingDetails(booking),
            icon: const Icon(Icons.receipt_long),
            label: const Text('Xem chi tiết'),
          ),
        ),
      ],
    );
  }

  void _openPayment(Booking booking) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => PaymentFlowScreen(
          bookingId: booking.bookingId,
          amount: booking.totalPrice,
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
  }

// Hủy vé bằng API không khả dụng trong tài liệu hiện tại
}

enum TripTypeFilter { all, oneway, roundtrip }

enum SortOption { bookingIdDesc, bookingIdAsc, dateNearest, dateFarthest }
