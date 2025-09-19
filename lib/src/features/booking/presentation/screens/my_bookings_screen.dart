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
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : !_authService.isLoggedIn
                      ? _buildLoginRequired()
                      : _buildBookingsList(),
            ),
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
            onTap: () => _loadBookings(), // Refresh danh sách vé
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
                Icons.refresh,
                color: Color(0xFF3B82F6),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Vé đã đặt',
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              '${_bookings.length} vé',
              style: const TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF3B82F6),
              ),
            ),
          ),
        ],
      ),
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
          const Text(
            'Vui lòng đăng nhập',
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Đăng nhập để xem các vé đã đặt của bạn',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 14,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(context).pushNamed('/login'),
            icon: const Icon(Icons.login),
            label: const Text('Đến màn đăng nhập'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
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
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: const Color(0xFF3B82F6).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.flight_takeoff,
              size: 48,
              color: Color(0xFF3B82F6),
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Chưa có vé nào',
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Hãy đặt vé máy bay đầu tiên của bạn',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 14,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 32),
          ElevatedButton.icon(
            onPressed: widget.onNavigateToSearch ?? () => Navigator.pop(context),
            icon: const Icon(Icons.search),
            label: const Text('Tìm chuyến bay'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingCard(Booking booking) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: const Color(0xFF3B82F6).withOpacity(0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
          BoxShadow(
            color: const Color(0xFF3B82F6).withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _openBookingDetails(booking),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildBookingHeader(booking),
              const SizedBox(height: 16),
              _buildFlightInfo(booking),
              const SizedBox(height: 16),
              _buildBookingFooter(booking),
              const SizedBox(height: 16),
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
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6).withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: (booking.flight.airlineLogo.isNotEmpty)
              ? Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(booking.flight.airlineLogo),
                      fit: BoxFit.cover,
                    ),
                  ),
                )
              : const Icon(
                  Icons.flight,
                  color: Color(0xFF3B82F6),
                  size: 24,
                ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '#${booking.bookingId}',
                style: const TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${booking.flight.airline.isNotEmpty ? booking.flight.airline : 'Chuyến bay'} ${booking.flight.flightNumber}'.trim(),
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
        itemCount: 2 + visible.length,
        itemBuilder: (context, index) {
          if (index == 0) return _buildFilterDropdown();
          if (index == 1) return const SizedBox(height: 16); // Khoảng cách
          final booking = visible[index - 2];
          return _buildBookingCard(booking);
        },
      ),
    );
  }

  Widget _buildFilterDropdown() {
    final total = _bookings.length;
    final confirmed = _countByStatus(BookingStatus.confirmed);
    final pending = _countByStatus(BookingStatus.pendingPayment);
    final cancelled = _countByStatus(BookingStatus.cancelled);
    final oneWay = _bookings.where((b) => !b.isRoundTrip).length;
    final roundTrip = _bookings.where((b) => b.isRoundTrip).length;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF3B82F6).withOpacity(0.15),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: ExpansionTile(
          tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          collapsedShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFF3B82F6).withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.tune,
            color: Color(0xFF3B82F6),
            size: 20,
          ),
        ),
        title: const Text(
          'Bộ lọc & Tìm kiếm',
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        subtitle: Text(
          _getFilterSummary(),
          style: const TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 12,
            color: Color(0xFF64748B),
          ),
        ),
        children: [
          const SizedBox(height: 16),
          _buildFilterRow(
            icon: Icons.tag,
            label: 'Trạng thái',
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
                  child: Text('Chờ thanh toán ($pending)'),
                ),
                DropdownMenuItem(
                  value: BookingStatus.cancelled,
                  child: Text('Đã hủy ($cancelled)'),
                ),
              ],
              onChanged: (v) => setState(() => _filterStatus = v),
            ),
          ),
          const SizedBox(height: 16),
          _buildFilterRow(
            icon: Icons.flight_class,
            label: 'Loại chuyến',
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
          const SizedBox(height: 16),
          _buildFilterRow(
            icon: Icons.calendar_month,
            label: 'Sắp xếp',
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
          const SizedBox(height: 16),
          _buildFilterRow(
            icon: Icons.search,
            label: 'Tìm kiếm',
            child: TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                hintText: 'Nhập mã booking...',
                isDense: true,
                suffixIcon: _search.isEmpty
                    ? null
                    : IconButton(
                        icon: const Icon(Icons.clear, size: 18),
                        onPressed: () => setState(() {
                          _search = '';
                          _searchCtrl.clear();
                        }),
                      ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: const Color(0xFF3B82F6).withOpacity(0.2)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
                ),
              ),
              onChanged: (v) => setState(() => _search = v.trim()),
            ),
          ),
        ],
        ),
      ),
    );
  }

  Widget _buildFilterRow({required IconData icon, required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 16, color: const Color(0xFF3B82F6)),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  String _getFilterSummary() {
    final parts = <String>[];
    
    // Status
    if (_filterStatus == null) {
      parts.add('Tất cả trạng thái');
    } else {
      switch (_filterStatus!) {
        case BookingStatus.confirmed:
          parts.add('Đã xác nhận');
          break;
        case BookingStatus.pendingPayment:
          parts.add('Chờ thanh toán');
          break;
        case BookingStatus.cancelled:
          parts.add('Đã hủy');
          break;
        case BookingStatus.completed:
          parts.add('Hoàn thành');
          break;
      }
    }
    
    // Trip type
    switch (_tripType) {
      case TripTypeFilter.all:
        parts.add('Tất cả loại');
        break;
      case TripTypeFilter.oneway:
        parts.add('Một chiều');
        break;
      case TripTypeFilter.roundtrip:
        parts.add('Khứ hồi');
        break;
    }
    
    // Search
    if (_search.isNotEmpty) {
      parts.add('Tìm: $_search');
    }
    
    return parts.join(' • ');
  }

  Widget _buildFlightInfo(Booking booking) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF3B82F6).withOpacity(0.2),
          width: 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  DateFormat('HH:mm').format(booking.flight.departureTime),
                  style: const TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  booking.flight.departure.code,
                  style: const TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Text(
                  booking.flight.departure.city,
                  style: const TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF3B82F6).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  booking.flight.duration,
                  style: const TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF3B82F6),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF3B82F6),
                      shape: BoxShape.circle,
                    ),
                  ),
                  Container(
                    width: 40,
                    height: 2,
                    color: const Color(0xFF3B82F6),
                  ),
                  const Icon(
                    Icons.flight,
                    color: Color(0xFF3B82F6),
                    size: 16,
                  ),
                  Container(
                    width: 40,
                    height: 2,
                    color: const Color(0xFF3B82F6),
                  ),
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF3B82F6),
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
                  style: const TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  booking.flight.arrival.code,
                  style: const TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Text(
                  booking.flight.arrival.city,
                  style: const TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 12,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBookingFooter(Booking booking) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF3B82F6).withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF3B82F6).withOpacity(0.1),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Ngày đặt',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 12,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                DateFormat('dd/MM/yyyy').format(booking.bookingDate),
                style: const TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                'Hành khách',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 12,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${booking.passengers.length} người',
                style: const TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              const Text(
                'Tổng giá',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 12,
                  color: Color(0xFF64748B),
                ),
              ),
              const SizedBox(height: 4),
              Text(
                '${NumberFormat('#,###', 'vi').format(booking.totalPrice)} ₫',
                style: const TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF3B82F6),
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
        text = 'Chờ thanh toán';
        break;
      case BookingStatus.cancelled:
        backgroundColor = Colors.red.shade100;
        textColor = Colors.red.shade700;
        text = 'Đã hủy';
        break;
      case BookingStatus.completed:
        backgroundColor = const Color(0xFF3B82F6).withOpacity(0.1);
        textColor = const Color(0xFF3B82F6);
        text = 'Hoàn thành';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontFamily: 'BalooBhaijaan2',
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: textColor,
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
    
    if (canPay) {
      // Có nút thanh toán khi chờ thanh toán
      return Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => _openBookingDetails(booking),
              icon: const Icon(Icons.receipt_long),
              label: const Text('Xem chi tiết'),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: Color(0xFF3B82F6), width: 2),
                foregroundColor: const Color(0xFF3B82F6),
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () => _openPayment(booking),
              icon: const Icon(Icons.payments),
              label: const Text('Thanh toán'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 0,
              ),
            ),
          ),
        ],
      );
    } else {
      // Chỉ có nút xem chi tiết khi đã thanh toán
      return SizedBox(
        width: double.infinity,
        child: OutlinedButton.icon(
          onPressed: () => _openBookingDetails(booking),
          icon: const Icon(Icons.receipt_long),
          label: const Text('Xem chi tiết'),
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFF3B82F6), width: 2),
            foregroundColor: const Color(0xFF3B82F6),
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      );
    }
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
