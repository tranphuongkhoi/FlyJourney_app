import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cnh_n/src/core/constants/colors.dart';
import 'package:cnh_n/src/features/search/domain/models/search_data.dart';
import 'package:cnh_n/src/features/search/presentation/screens/flight_search_step2_screen.dart';
import 'package:cnh_n/src/core/widgets/search_app_bar.dart';
import 'package:cnh_n/src/core/config/api_config.dart';

class FlightSearchStep1Screen extends StatefulWidget {
  final SearchData? initialData;

  const FlightSearchStep1Screen({super.key, this.initialData});

  @override
  State<FlightSearchStep1Screen> createState() => _FlightSearchStep1ScreenState();
}

class _FlightSearchStep1ScreenState extends State<FlightSearchStep1Screen> {
  late SearchData _searchData;

  @override
  void initState() {
    super.initState();
    _searchData = widget.initialData ?? SearchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const SearchAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            _buildProgressIndicator(),
            
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStepTitle(),
                    const SizedBox(height: 32),
                    _buildTripTypeSelector(),
                    const SizedBox(height: 32),
                    _buildDateSelectors(),
                    const SizedBox(height: 32),
                    _buildPassengerSelector(),
                    const SizedBox(height: 32),
                    _buildFlightClassSelector(),
                  ],
                ),
              ),
            ),
            
            // Continue button
            _buildBottomSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          _buildProgressDot(true, '1'),
          Expanded(child: _buildProgressLine(false)),
          _buildProgressDot(false, '2'),
          Expanded(child: _buildProgressLine(false)),
          _buildProgressDot(false, '3'),
        ],
      ),
    );
  }

  Widget _buildProgressDot(bool isActive, String number) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: isActive ? AppColors.primaryBlue : Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          number,
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: isActive ? Colors.white : Colors.grey.shade600,
          ),
        ),
      ),
    );
  }

  Widget _buildProgressLine(bool isActive) {
    return Container(
      height: 2,
      color: isActive ? AppColors.primaryBlue : Colors.grey.shade300,
      margin: const EdgeInsets.symmetric(horizontal: 8),
    );
  }

  Widget _buildStepTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chọn thời gian và hành khách',
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Vui lòng chọn ngày bay và số lượng hành khách',
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  Widget _buildTripTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Loại chuyến bay',
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _searchData = _searchData.copyWith(isRoundTrip: true);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: _searchData.isRoundTrip ? AppColors.primaryBlue : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: _searchData.isRoundTrip ? AppColors.primaryBlue : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.sync_alt,
                        color: _searchData.isRoundTrip ? Colors.white : Colors.grey.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Khứ hồi',
                        style: TextStyle(
                          fontFamily: 'BalooBhaijaan2',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: _searchData.isRoundTrip ? Colors.white : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _searchData = _searchData.copyWith(isRoundTrip: false);
                  });
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                  decoration: BoxDecoration(
                    color: !_searchData.isRoundTrip ? AppColors.primaryBlue : Colors.transparent,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: !_searchData.isRoundTrip ? AppColors.primaryBlue : Colors.grey.shade300,
                      width: 2,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.arrow_forward,
                        color: !_searchData.isRoundTrip ? Colors.white : Colors.grey.shade600,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Text(
                        'Một chiều',
                        style: TextStyle(
                          fontFamily: 'BalooBhaijaan2',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: !_searchData.isRoundTrip ? Colors.white : Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateSelectors() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chọn ngày bay',
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: _showDepartureDatePicker,
                child: _buildDateCard(
                  'Ngày đi',
                  _searchData.departureDate,
                  Icons.flight_takeoff,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: GestureDetector(
                onTap: _searchData.isRoundTrip ? _showReturnDatePicker : null,
                child: _buildDateCard(
                  'Ngày về',
                  _searchData.isRoundTrip ? _searchData.returnDate : null,
                  Icons.flight_land,
                  enabled: _searchData.isRoundTrip,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateCard(String label, DateTime? date, IconData icon, {bool enabled = true}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: enabled ? Colors.grey.shade50 : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: enabled ? Colors.grey.shade300 : Colors.grey.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: enabled ? AppColors.primaryBlue : Colors.grey.shade400,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: enabled ? Colors.grey.shade700 : Colors.grey.shade400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            date != null 
                ? DateFormat('dd/MM/yyyy').format(date)
                : enabled 
                    ? 'Chọn ngày'
                    : '--/--/----',
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: enabled 
                  ? (date != null ? const Color(0xFF1E293B) : Colors.grey.shade500)
                  : Colors.grey.shade400,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPassengerSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Số lượng hành khách',
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 16),
        GestureDetector(
          onTap: _showPassengerPicker,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.people,
                  color: AppColors.primaryBlue,
                  size: 24,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    _buildPassengerText(),
                    style: const TextStyle(
                      fontFamily: 'BalooBhaijaan2',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
                const Icon(
                  Icons.keyboard_arrow_down,
                  color: Colors.grey,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildFlightClassSelector() {
    final classes = [
      {'value': 'all', 'label': 'Tất cả hạng vé', 'icon': Icons.flight_class},
      {'value': 'economy', 'label': 'Phổ thông', 'icon': Icons.airline_seat_recline_normal},
      {'value': 'premium_economy', 'label': 'Phổ thông đặc biệt', 'icon': Icons.airline_seat_recline_extra},
      {'value': 'business', 'label': 'Thương gia', 'icon': Icons.airline_seat_flat},
      {'value': 'first', 'label': 'Hạng nhất', 'icon': Icons.airline_seat_individual_suite},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Hạng vé',
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            _buildSelectAllClassesButton(),
          ],
        ),
        const SizedBox(height: 16),
        ...classes.map((cls) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          child: GestureDetector(
            onTap: () {
              setState(() {
                _searchData = _searchData.copyWith(flightClass: cls['value'] as String);
              });
            },
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: _searchData.flightClass == cls['value']
                    ? AppColors.primaryBlue.withOpacity(0.1)
                    : Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _searchData.flightClass == cls['value']
                      ? AppColors.primaryBlue
                      : Colors.grey.shade300,
                  width: 2,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    cls['icon'] as IconData,
                    color: _searchData.flightClass == cls['value']
                        ? AppColors.primaryBlue
                        : Colors.grey.shade600,
                    size: 24,
                  ),
                  const SizedBox(width: 16),
                  Text(
                    cls['label'] as String,
                    style: TextStyle(
                      fontFamily: 'BalooBhaijaan2',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: _searchData.flightClass == cls['value']
                          ? AppColors.primaryBlue
                          : Colors.grey.shade700,
                    ),
                  ),
                  const Spacer(),
                  if (_searchData.flightClass == cls['value'])
                    const Icon(
                      Icons.check_circle,
                      color: AppColors.primaryBlue,
                      size: 20,
                    ),
                ],
              ),
            ),
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildSelectAllClassesButton() {
    final bool isAllSelected = _searchData.flightClass == 'all';
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _searchData = _searchData.copyWith(
            flightClass: isAllSelected ? 'economy' : 'all'
          );
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isAllSelected ? AppColors.primaryBlue : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: AppColors.primaryBlue,
            width: 1.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isAllSelected ? Icons.check : Icons.flight_class,
              color: isAllSelected ? Colors.white : AppColors.primaryBlue,
              size: 16,
            ),
            const SizedBox(width: 6),
            Text(
              isAllSelected ? 'Đã chọn tất cả' : 'Chọn tất cả hạng',
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: isAllSelected ? Colors.white : AppColors.primaryBlue,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      padding: const EdgeInsets.all(24),
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
      child: SizedBox(
        width: double.infinity,
        height: 56,
        child: ElevatedButton(
          onPressed: _searchData.canProceedToStep2 ? _continueToStep2 : null,
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
              Text(
                'Tiếp tục',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.arrow_forward, size: 20),
            ],
          ),
        ),
      ),
    );
  }

  String _buildPassengerText() {
    List<String> parts = [];
    parts.add('${_searchData.passengers} người lớn');
    if (_searchData.children > 0) parts.add('${_searchData.children} trẻ em');
    if (_searchData.infants > 0) parts.add('${_searchData.infants} em bé');
    return parts.join(', ');
  }

  void _showDepartureDatePicker() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _searchData.departureDate ?? _parseDevDate(ApiConfig.currentDevDates[0]), // Dev mode date
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        _searchData = _searchData.copyWith(departureDate: date);
      });
    }
  }

  void _showReturnDatePicker() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _searchData.returnDate ?? _parseDevDate(ApiConfig.currentDevDates[1]), // Dev mode return date
      firstDate: _searchData.departureDate ?? DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      setState(() {
        _searchData = _searchData.copyWith(returnDate: date);
      });
    }
  }

  // Helper function to parse date from DD/MM/YYYY format (same as SearchData)
  DateTime _parseDevDate(String dateStr) {
    final parts = dateStr.split('/');
    if (parts.length == 3) {
      final day = int.parse(parts[0]);
      final month = int.parse(parts[1]);
      final year = int.parse(parts[2]);
      return DateTime(year, month, day);
    }
    // Fallback to default dev date if parsing fails
    return DateTime(2025, 8, 27);
  }

  void _showPassengerPicker() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(24),
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chọn số hành khách',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 24),
              
              // Adults
              _buildPassengerRow(
                'Người lớn',
                'Từ 12 tuổi trở lên',
                _searchData.passengers,
                (value) {
                  setModalState(() {
                    _searchData = _searchData.copyWith(passengers: value);
                    if (_searchData.infants > _searchData.passengers) {
                      _searchData = _searchData.copyWith(infants: _searchData.passengers);
                    }
                  });
                  setState(() {});
                },
                1,
                9,
              ),
              
              const SizedBox(height: 16),
              
              // Children
              _buildPassengerRow(
                'Trẻ em',
                'Từ 2-11 tuổi',
                _searchData.children,
                (value) {
                  setModalState(() {
                    _searchData = _searchData.copyWith(children: value);
                  });
                  setState(() {});
                },
                0,
                9,
              ),
              
              const SizedBox(height: 16),
              
              // Infants
              _buildPassengerRow(
                'Em bé',
                'Dưới 2 tuổi (ngồi cùng ghế)',
                _searchData.infants,
                (value) {
                  setModalState(() {
                    _searchData = _searchData.copyWith(infants: value);
                  });
                  setState(() {});
                },
                0,
                _searchData.passengers,
              ),
              
              const Spacer(),
              
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Xác nhận',
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
      ),
    );
  }

  Widget _buildPassengerRow(String title, String subtitle, int value, Function(int) onChanged, int min, int max) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1E293B),
              ),
            ),
            Text(
              subtitle,
              style: const TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 12,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              onPressed: value > min ? () => onChanged(value - 1) : null,
              icon: const Icon(Icons.remove_circle_outline),
            ),
            Text(
              '$value',
              style: const TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 16,
                fontWeight: FontWeight.w500,
              ),
            ),
            IconButton(
              onPressed: value < max ? () => onChanged(value + 1) : null,
              icon: const Icon(Icons.add_circle_outline),
            ),
          ],
        ),
      ],
    );
  }

  void _continueToStep2() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlightSearchStep2Screen(searchData: _searchData),
      ),
    );
  }
}
