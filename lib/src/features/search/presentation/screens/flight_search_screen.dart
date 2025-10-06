import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:fly_journey/src/core/config/dev_config.dart';
import 'package:fly_journey/src/core/constants/airlines.dart';
import 'package:fly_journey/src/core/constants/colors.dart';
import 'package:fly_journey/src/core/widgets/flight_filters.dart';
import 'package:fly_journey/src/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:fly_journey/src/features/search/domain/models/airport.dart';
import 'package:fly_journey/src/features/search/data/airports.dart';
import 'package:fly_journey/src/features/search/data/directions.dart';
import 'package:fly_journey/src/features/search/presentation/screens/flight_search_results_screen.dart';

class FlightSearchScreen extends StatefulWidget {
  const FlightSearchScreen({super.key});

  @override
  State<FlightSearchScreen> createState() => _FlightSearchScreenState();
}

class _FlightSearchScreenState extends State<FlightSearchScreen> {
  // State
  Airport? _departure;
  Airport? _arrival;
  DateTime? _departureDate;
  DateTime? _returnDate;
  bool _isRoundTrip = false;
  int _adults = 1;
  int _children = 0;
  int _infants = 0;
  String _flightClass = 'all'; // all, economy, business
  List<int> _selectedAirlineIds = [];
  int _maxStops = 2;
  double? _minPrice;
  double? _maxPrice;
  String _sortBy = 'price';
  String _sortOrder = 'asc';
  List<String> _departureTimeFilters = [];
  int? _hoveredAirlineId; // for web hover feedback

  // Popular routes for quick selection - imported from directions.dart
  List<Map<String, String>> get _popularRoutes => kPopularRoutes
      .map((route) =>
          {'from': route.fromCode, 'to': route.toCode, 'label': route.label})
      .toList();

  // Danh sách sân bay được lấy từ directions.dart
  List<Airport> get _airports => kAirports;

  // Popular cities for quick selection - imported from directions.dart
  List<Map<String, String>> get _popularCities => kPopularCities;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            _buildTopBar(context),
            Expanded(
              child: Container(
                color: Colors.white,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSearchCard(),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        20, 
        16 + MediaQuery.of(context).padding.top, 
        20, 
        16
      ),
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
                color: Color(0xFF3B82F6),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Tìm kiếm chuyến bay',
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const NotificationsScreen()),
            ),
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
                Icons.notifications_outlined,
                color: Color(0xFF64748B),
                size: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Column(
          children: [
            _buildSearchHeader(),
            const Divider(height: 1, color: Color(0xFFE5E7EB)),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildTripTypeSection(),
                  const SizedBox(height: 20),
                  _buildLocationSection(),
                  const SizedBox(height: 20),
                  _buildDateSection(),
                  const SizedBox(height: 20),
                  _buildPassengerSection(),
                  const SizedBox(height: 20),
                  _buildAirlinesSection(),
                  const SizedBox(height: 16),
                  _buildActionButtons(),
                  _buildQuickTips(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchHeader() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.primaryBlue.withOpacity(0.05),
            AppColors.primaryBlue.withOpacity(0.02),
          ],
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.border),
            ),
            child: const Icon(Icons.flight_takeoff,
                color: AppColors.primaryBlue, size: 20),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Text(
              'Cá nhân hóa chuyến bay phù hợp với bạn',
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTripTypeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Loại vé',
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: [
              Expanded(child: _buildTripTypeOption('Một chiều', false)),
              const SizedBox(width: 8),
              Expanded(child: _buildTripTypeOption('Khứ hồi', true)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTripTypeOption(String label, bool isRoundTrip) {
    final bool isSelected = _isRoundTrip == isRoundTrip;
    return GestureDetector(
      onTap: () => setState(() => _isRoundTrip = isRoundTrip),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primaryBlue.withOpacity(0.2),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: isSelected ? Colors.white : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildLocationSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Điểm khởi hành và điểm đến',
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        _buildQuickRoutes(),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _onSelectDeparture,
                child: _buildLocationSelector(
                  'Điểm đi',
                  _departure != null
                      ? '${_departure!.city} (${_departure!.code})'
                      : 'Chọn điểm đi',
                  Icons.flight_takeoff,
                  _departure != null,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () => _onSelectAirport('arrival'),
                child: _buildLocationSelector(
                  'Điểm đến',
                  _arrival != null
                      ? '${_arrival!.city} (${_arrival!.code})'
                      : 'Chọn điểm đến',
                  Icons.flight_land,
                  _arrival != null,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildQuickRoutes() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.location_city, color: AppColors.primaryBlue, size: 16),
            SizedBox(width: 6),
            Text(
              'Điểm đến phổ biến',
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 38,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _popularCities.length,
            separatorBuilder: (_, __) => const SizedBox(width: 8),
            itemBuilder: (context, index) {
              final city = _popularCities[index];
              final isDeparture = _departure?.code == city['code'];
              final isArrival = _arrival?.code == city['code'];
              final isSelected = isDeparture || isArrival;

              // Không hiển thị thành phố đã chọn làm điểm đi trong trường hợp đang chọn điểm đến
              // Không cần làm mờ các thành phố nữa, người dùng có thể chọn/bỏ chọn bất kỳ thành phố nào
              // với logic mới - chọn điểm 1 là đi, điểm 2 là đến và có thể deselect bất kỳ lúc nào

              return GestureDetector(
                onTap: () => _selectQuickCity(city['code']!, city['name']!),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  decoration: BoxDecoration(
                    color: isDeparture
                        ? const Color(0xFFDEEBFF) // Màu xanh nhạt cho điểm đi
                        : (isArrival
                            ? const Color(
                                0xFFFFEEE0) // Màu cam nhạt cho điểm đến
                            : Colors.grey.shade50),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDeparture
                          ? const Color(0xFF0052CC) // Màu xanh đậm cho điểm đi
                          : (isArrival
                              ? const Color(
                                  0xFFFF5630) // Màu cam đậm cho điểm đến
                              : AppColors.border),
                      width: isSelected ? 1.5 : 1,
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isDeparture
                            ? Icons.flight_takeoff
                            : (isArrival
                                ? Icons.flight_land
                                : Icons.location_on_outlined),
                        size: 14,
                        color: isDeparture
                            ? const Color(0xFF0052CC)
                            : (isArrival
                                ? const Color(0xFFFF5630)
                                : AppColors.textSecondary),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        city['name']!,
                        style: TextStyle(
                          fontFamily: 'BalooBhaijaan2',
                          fontSize: 13,
                          fontWeight:
                              isSelected ? FontWeight.w700 : FontWeight.w600,
                          color: isDeparture
                              ? const Color(0xFF0052CC)
                              : (isArrival
                                  ? const Color(0xFFFF5630)
                                  : AppColors.textSecondary),
                        ),
                      ),
                      // Thêm biểu tượng nhỏ ở góc để biểu thị đi/đến
                      if (isSelected) ...[
                        const SizedBox(width: 4),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 2),
                          decoration: BoxDecoration(
                            color: isDeparture
                                ? const Color(0xFF0052CC)
                                : const Color(0xFFFF5630),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            isDeparture ? 'Đi' : 'Đến',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildDateSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ngày khởi hành và ngày về',
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _showDatePicker(
                    (date) => setState(() => _departureDate = date)),
                child: _buildDatePickerField(
                  'Ngày đi',
                  _departureDate != null
                      ? DateFormat('dd/MM/yyyy').format(_departureDate!)
                      : 'Chọn ngày đi',
                  _departureDate != null,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: _isRoundTrip
                    ? () => _showDatePicker(
                        (date) => setState(() => _returnDate = date))
                    : null,
                child: _buildDatePickerField(
                  'Ngày về',
                  _isRoundTrip
                      ? (_returnDate != null
                          ? DateFormat('dd/MM/yyyy').format(_returnDate!)
                          : 'Chọn ngày về')
                      : 'Không cần',
                  _isRoundTrip && _returnDate != null,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPassengerSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hành khách và hạng ghế',
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        GestureDetector(
          onTap: _showPassengerPicker,
          child: _buildPassengerField(),
        ),
      ],
    );
  }

  Widget _buildAirlinesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  'Hãng hàng không',
                  style: TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Chọn hãng bay yêu thích (không bắt buộc)',
                  style: TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
            if (_selectedAirlineIds.isNotEmpty)
              GestureDetector(
                onTap: () => setState(() => _selectedAirlineIds.clear()),
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Xóa tất cả',
                    style: TextStyle(
                      fontFamily: 'BalooBhaijaan2',
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        _buildAirlinesGrid(),
      ],
    );
  }

  Widget _buildActionButtons() {
    final bool canSearch = _canSearch();
    return Row(
      children: [
        Expanded(
          child: OutlinedButton(
            onPressed: _showFilters,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: AppColors.primaryBlue),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Bộ lọc',
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.primaryBlue,
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: ElevatedButton(
            onPressed: canSearch ? _search : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              disabledBackgroundColor: Colors.grey.shade300,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                Icon(Icons.search, color: Colors.white, size: 18),
                SizedBox(width: 8),
                Text(
                  'Tìm chuyến bay',
                  style: TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickTips() {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border.withOpacity(0.6)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.tips_and_updates,
                  color: AppColors.primaryBlue, size: 18),
              SizedBox(width: 8),
              Text(
                'Mẹo săn vé rẻ',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildTipItem('Đặt trước 2-3 tuần để có giá tốt nhất'),
          _buildTipItem('Thứ 3, 4 thường có vé rẻ hơn cuối tuần'),
          _buildTipItem('Chuyến bay sáng sớm và tối muộn thường rẻ hơn'),
        ],
      ),
    );
  }

  Widget _buildTipItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 6,
            height: 6,
            margin: const EdgeInsets.only(top: 8),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Widgets: controls ----------

  Widget _buildAirlinesGrid() {
    return LayoutBuilder(
      builder: (context, constraints) {
        int columns = 3;
        if (constraints.maxWidth < 400) {
          columns = 3;
        } else if (constraints.maxWidth >= 600) {
          columns = 4;
        } else if (constraints.maxWidth >= 900) {
          columns = 5;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.0, // square cards for logos only
          ),
          itemCount: kAirlines.length,
          itemBuilder: (context, index) {
            final airline = kAirlines[index];
            return _buildAirlineCard(airline.logo, airline.id);
          },
        );
      },
    );
  }

  Widget _buildAirlineCard(String imagePath, int airlineId) {
    final bool isSelected = _selectedAirlineIds.contains(airlineId);
    final bool isHovered = _hoveredAirlineId == airlineId;

    return MouseRegion(
      onEnter: (_) => setState(() => _hoveredAirlineId = airlineId),
      onExit: (_) => setState(() => _hoveredAirlineId = null),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            setState(() {
              if (isSelected) {
                _selectedAirlineIds.remove(airlineId);
              } else {
                _selectedAirlineIds.add(airlineId);
              }
            });
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isSelected
                  ? AppColors.primaryBlue.withOpacity(0.08)
                  : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isSelected
                    ? AppColors.primaryBlue
                    : AppColors.border.withOpacity(0.3),
                width: isSelected ? 2 : 1,
              ),
              boxShadow: [
                if (isHovered || isSelected)
                  BoxShadow(
                    color: AppColors.primaryBlue.withOpacity(0.15),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                    spreadRadius: 0,
                  )
                else
                  BoxShadow(
                    color: Colors.black.withOpacity(0.06),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                    spreadRadius: 0,
                  ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Logo container
                Container(
                  width: double.infinity,
                  height: double.infinity,
                  padding: const EdgeInsets.all(12.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Image.asset(
                    imagePath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) {
                      return Icon(
                        Icons.airplanemode_active,
                        color: AppColors.primaryBlue.withOpacity(0.7),
                        size: 36,
                      );
                    },
                  ),
                ),

                // Selection indicator
                if (isSelected)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue,
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 12,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLocationSelector(String label, String value, IconData icon,
      [bool isSelected = false]) {
    final bool isPlaceholder =
        value == 'Chọn điểm đi' || value == 'Chọn điểm đến';
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isSelected
            ? AppColors.primaryBlue.withOpacity(0.05)
            : AppColors.grey50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isSelected ? AppColors.primaryBlue : AppColors.border,
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(icon,
                  size: 18,
                  color: isPlaceholder
                      ? AppColors.grey400
                      : AppColors.primaryBlue),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isPlaceholder
                        ? AppColors.grey500
                        : AppColors.textPrimary,
                  ),
                ),
              ),
              if (!isPlaceholder)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: const Text(
                    'Thay đổi',
                    style:
                        TextStyle(fontSize: 10, color: AppColors.textSecondary),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDatePickerField(String label, String value,
      [bool isSelected = false]) {
    final bool isPlaceholder =
        value == 'Chọn ngày đi' || value == 'Chọn ngày về';
    final bool isDisabled = value == 'Không cần';
    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDisabled
            ? AppColors.grey100
            : (isSelected
                ? AppColors.primaryBlue.withOpacity(0.05)
                : AppColors.grey50),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isDisabled
              ? AppColors.border
              : (isSelected ? AppColors.primaryBlue : AppColors.border),
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.calendar_today,
                  size: 18,
                  color: isPlaceholder
                      ? AppColors.grey400
                      : AppColors.primaryBlue),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  value,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: isPlaceholder
                        ? AppColors.grey500
                        : AppColors.textPrimary,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerField() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Text(
                'Số hành khách',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.people_alt_outlined,
                  size: 18, color: AppColors.primaryBlue),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  _buildPassengerText(),
                  style: const TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.border),
                ),
                child: Text(
                  _flightClass == 'all'
                      ? 'Mọi hạng'
                      : (_flightClass == 'economy'
                          ? 'Phổ thông'
                          : 'Thương gia'),
                  style: const TextStyle(
                      fontSize: 10, color: AppColors.textSecondary),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------- Logic helpers ----------

  String _buildPassengerText() {
    final parts = <String>[];
    parts.add('$_adults người lớn');
    if (_children > 0) parts.add('$_children trẻ em');
    if (_infants > 0) parts.add('$_infants em bé');
    return parts.join(', ');
  }

  bool _canSearch() {
    bool ok = _departure != null && _arrival != null && _departureDate != null;
    if (_isRoundTrip) ok = ok && _returnDate != null;
    return ok;
  }

  void _selectQuickRoute(String fromCode, String toCode) {
    final from = _airports.firstWhere((a) => a.code == fromCode);
    final to = _airports.firstWhere((a) => a.code == toCode);
    setState(() {
      _departure = from;
      _arrival = to;
    });
  }

  void _selectQuickCity(String cityCode, String cityName) {
    final airport = _airports.firstWhere((a) => a.code == cityCode);

    // Logic tuần tự: Ưu tiên chọn điểm đi trước, sau đó là điểm đến
    setState(() {
      // Trường hợp 1: Đã chọn cùng mã sân bay như đang chọn
      if (_departure != null && _departure!.code == cityCode) {
        _departure = null; // Bỏ chọn điểm đi
        return;
      }
      if (_arrival != null && _arrival!.code == cityCode) {
        _arrival = null; // Bỏ chọn điểm đến
        return;
      }

      // Trường hợp 2: Chưa chọn điểm đi
      if (_departure == null) {
        _departure = airport; // Ưu tiên chọn điểm đi trước
        return;
      }

      // Trường hợp 3: Đã chọn điểm đi, chưa chọn điểm đến
      if (_arrival == null) {
        // Không cho phép chọn trùng
        if (_departure!.code != cityCode) {
          _arrival = airport; // Chọn điểm đến
        }
        return;
      }

      // Trường hợp 4: Đã chọn cả điểm đi và điểm đến, muốn chọn điểm mới
      // Trong trường hợp này, nếu người dùng chọn một điểm mới, ta sẽ thay thế điểm đến
      if (_departure!.code != cityCode) {
        _arrival = airport; // Thay thế điểm đến
      }
    });
  }

  Future<void> _onSelectDeparture() async {
    final selected = await _pickAirport('departure');
    if (selected != null) {
      setState(() => _departure = selected);
      // Smooth flow: open arrival picker right after choosing departure
      await Future.delayed(const Duration(milliseconds: 120));
      final arrival = await _pickAirport('arrival');
      if (arrival != null) {
        setState(() => _arrival = arrival);
      }
    }
  }

  Future<void> _onSelectAirport(String type) async {
    final selected = await _pickAirport(type);
    if (selected != null) {
      setState(() {
        if (type == 'departure') {
          _departure = selected;
        } else {
          _arrival = selected;
        }
      });
    }
  }

  Future<Airport?> _pickAirport(String type) async {
    final availableAirports = type == 'arrival' && _departure != null
        ? _airports.where((a) => a.code != _departure!.code).toList()
        : List<Airport>.from(_airports);

    return showModalBottomSheet<Airport?>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          height: MediaQuery.of(context).size.height * 0.75,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              const SizedBox(height: 10),
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: Row(
                  children: [
                    Text(
                      type == 'departure' ? 'Chọn điểm đi' : 'Chọn điểm đến',
                      style: const TextStyle(
                        fontFamily: 'BalooBhaijaan2',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const Spacer(),
                    IconButton(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView.separated(
                  itemCount: availableAirports.length,
                  separatorBuilder: (_, __) =>
                      const Divider(height: 1, color: Color(0xFFE5E7EB)),
                  itemBuilder: (context, index) {
                    final airport = availableAirports[index];
                    return ListTile(
                      leading: CircleAvatar(
                        backgroundColor: AppColors.primaryBlue.withOpacity(0.1),
                        child: const Icon(Icons.flight,
                            color: AppColors.primaryBlue, size: 18),
                      ),
                      title: Text(
                        '${airport.city} (${airport.code})',
                        style: const TextStyle(
                          fontFamily: 'BalooBhaijaan2',
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      subtitle: Text(
                        airport.name,
                        style: const TextStyle(
                          fontFamily: 'BalooBhaijaan2',
                          fontSize: 12,
                          color: AppColors.textSecondary,
                        ),
                      ),
                      onTap: () => Navigator.pop(context, airport),
                    );
                  },
                ),
              ),
              SizedBox(height: MediaQuery.of(context).padding.bottom + 12),
            ],
          ),
        );
      },
    );
  }

  Future<void> _showDatePicker(Function(DateTime) onSelected) async {
    final now = DateTime.now();
    final firstDate = DevConfig.allowPastDates
        ? DevConfig.earliestDate
        : DateTime(now.year, now.month, now.day);
    final lastDate = now.add(const Duration(days: 365));
    final initial = _departureDate ?? now;
    final safeInitial = initial.isBefore(firstDate) ? firstDate : initial;

    final date = await showDatePicker(
      context: context,
      initialDate: safeInitial,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (date != null) onSelected(date);
  }

  void _showPassengerPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          height: MediaQuery.of(context).size.height * 0.7,
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Chọn hành khách và hạng ghế',
                  style: TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 16),
                _buildPassengerCounter(
                  'Người lớn',
                  'Từ 12 tuổi trở lên',
                  Icons.person,
                  _adults,
                  (value) {
                    setModalState(() {
                      _adults = value;
                      if (_infants > _adults) {
                        _infants = _adults; // infants <= adults
                      }
                    });
                    setState(() {});
                  },
                  minValue: 1,
                  canDecrease: _adults > 1,
                  canIncrease: (_adults + _children + _infants) <
                      DevConfig.maxTotalPassengers,
                ),
                const SizedBox(height: 10),
                _buildPassengerCounter(
                  'Trẻ em',
                  'Từ 2 - 11 tuổi',
                  Icons.child_care,
                  _children,
                  (value) {
                    setModalState(() => _children = value);
                    setState(() {});
                  },
                  minValue: 0,
                  canDecrease: _children > 0,
                  canIncrease: (_adults + _children + _infants) <
                      DevConfig.maxTotalPassengers,
                ),
                const SizedBox(height: 10),
                _buildPassengerCounter(
                  'Em bé',
                  'Dưới 2 tuổi',
                  Icons.stroller,
                  _infants,
                  (value) {
                    setModalState(() {
                      final next = value;
                      // infants cannot exceed adults
                      _infants = next > _adults ? _adults : next;
                    });
                    setState(() {});
                  },
                  minValue: 0,
                  canDecrease: _infants > 0,
                  canIncrease: (_adults + _children + _infants) <
                          DevConfig.maxTotalPassengers &&
                      _infants < _adults,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Hạng ghế',
                  style: TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _buildClassChip('Mọi hạng', 'all', setModalState),
                    const SizedBox(width: 8),
                    _buildClassChip('Phổ thông', 'economy', setModalState),
                    const SizedBox(width: 8),
                    _buildClassChip('Thương gia', 'business', setModalState),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: const Text(
                      'Xong',
                      style: TextStyle(
                        fontFamily: 'BalooBhaijaan2',
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildClassChip(
      String label, String value, StateSetter setModalState) {
    final bool selected = _flightClass == value;
    return GestureDetector(
      onTap: () {
        setModalState(() => _flightClass = value);
        setState(() {});
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.primaryBlue.withOpacity(0.1)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
              color: selected ? AppColors.primaryBlue : AppColors.border),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: selected ? AppColors.primaryBlue : AppColors.textSecondary,
          ),
        ),
      ),
    );
  }

  Widget _buildPassengerCounter(
    String title,
    String description,
    IconData icon,
    int value,
    Function(int) onChanged, {
    int minValue = 0,
    required bool canDecrease,
    required bool canIncrease,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.grey50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: AppColors.border),
            ),
            child: Icon(icon, size: 18, color: AppColors.primaryBlue),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: const TextStyle(
                      fontSize: 12, color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
          _buildCounterButton(Icons.remove, canDecrease, () {
            if (value > minValue) onChanged(value - 1);
          }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              '$value',
              style: const TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
          ),
          _buildCounterButton(Icons.add, canIncrease, () {
            if (canIncrease) onChanged(value + 1);
          }),
        ],
      ),
    );
  }

  Widget _buildCounterButton(
      IconData icon, bool enabled, VoidCallback onPressed) {
    return Material(
      color: enabled ? AppColors.primaryBlue : AppColors.grey200,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: enabled ? onPressed : null,
        child: Container(
          padding: const EdgeInsets.all(8),
          child: Icon(icon, color: Colors.white, size: 18),
        ),
      ),
    );
  }

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: FlightFilters(
          minPrice: _minPrice,
          maxPrice: _maxPrice,
          maxStops: _maxStops,
          sortBy: _sortBy,
          sortOrder: _sortOrder,
          departureTimeFilters: _departureTimeFilters,
          onPriceRangeChanged: (min, max) {
            setState(() {
              _minPrice = min;
              _maxPrice = max;
            });
          },
          onMaxStopsChanged: (value) => setState(() => _maxStops = value),
          onSortChanged: (sortBy, sortOrder) => setState(() {
            _sortBy = sortBy;
            _sortOrder = sortOrder;
          }),
          onDepartureTimeFiltersChanged: (filters) =>
              setState(() => _departureTimeFilters = filters),
        ),
      ),
    );
  }

  void _search() {
    if (_departure == null) {
      _showErrorSnackBar('Vui lòng chọn điểm đi', Icons.location_on_outlined);
      return;
    }
    if (_arrival == null) {
      _showErrorSnackBar('Vui lòng chọn điểm đến', Icons.location_on);
      return;
    }
    if (_departure!.code == _arrival!.code) {
      _showErrorSnackBar(
          'Điểm đi và điểm đến không thể giống nhau', Icons.swap_horiz);
      return;
    }
    if (_departureDate == null) {
      _showErrorSnackBar('Vui lòng chọn ngày khởi hành', Icons.calendar_today);
      return;
    }
    if (_isRoundTrip && _returnDate == null) {
      _showErrorSnackBar(
          'Vui lòng chọn ngày về cho chuyến khứ hồi', Icons.calendar_today);
      return;
    }
    if (_isRoundTrip && _returnDate!.isBefore(_departureDate!)) {
      _showErrorSnackBar(
          'Ngày về không thể trước ngày khởi hành', Icons.warning);
      return;
    }

    // quick loading cue
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: const [
            SizedBox(
              width: 18,
              height: 18,
              child: CircularProgressIndicator(
                  strokeWidth: 2, color: Colors.white),
            ),
            SizedBox(width: 12),
            Text('Đang tìm vé tốt nhất...'),
          ],
        ),
        backgroundColor: AppColors.primaryBlue,
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    // Build search params for results screen
    final params = <String, dynamic>{
      'departure_airport_code': _departure!.code,
      'arrival_airport_code': _arrival!.code,
      'departure_date': DateFormat('dd/MM/yyyy').format(_departureDate!),
      'flight_class': _flightClass,
      'airline_ids': _selectedAirlineIds.isEmpty ? [] : _selectedAirlineIds,
      'page': 1,
      'limit': 50,
      'sort_by': _sortBy,
      'sort_order': _sortOrder,
      if (_minPrice != null) 'min_price': _minPrice,
      if (_maxPrice != null) 'max_price': _maxPrice,
      if (_departureTimeFilters.isNotEmpty)
        'departure_time_filters': _departureTimeFilters,
    };

    if (_isRoundTrip) {
      params['return_date'] = DateFormat('dd/MM/yyyy').format(_returnDate!);
      params['passengers'] = {
        'adults': _adults,
        'children': _children,
        'infants': _infants,
      };
    } else {
      params['passenger'] = {
        'adults': _adults,
        'children': _children,
        'infant': _infants,
      };
    }

    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondary) =>
            FlightSearchResultsScreen(
          searchParams: params,
          isRoundTrip: _isRoundTrip,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final tween = Tween(begin: const Offset(0, 0.05), end: Offset.zero)
              .chain(CurveTween(curve: Curves.easeOutCubic));
          return SlideTransition(
              position: animation.drive(tween), child: child);
        },
        transitionDuration: const Duration(milliseconds: 250),
      ),
    );
  }

  void _showErrorSnackBar(String message, IconData icon) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: Colors.red.shade400,
        duration: const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      ),
    );
  }
}
