import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cnh_n/src/features/search/domain/models/airport.dart';
import 'package:cnh_n/src/features/search/presentation/screens/flight_search_results_screen.dart';
import 'package:cnh_n/src/features/notifications/presentation/screens/notifications_screen.dart';
import 'package:cnh_n/src/features/connection/presentation/screens/connection_test_screen.dart';
import 'package:cnh_n/src/core/constants/colors.dart';
import 'package:cnh_n/src/core/widgets/flight_filters.dart';

class FlightSearchScreen extends StatefulWidget {
  const FlightSearchScreen({super.key});

  @override
  State<FlightSearchScreen> createState() => _FlightSearchScreenState();
}

class _FlightSearchScreenState extends State<FlightSearchScreen> {
  Airport? _departure;
  Airport? _arrival;
  DateTime? _departureDate;
  DateTime? _returnDate;
  bool _isRoundTrip = false;
  int _passengers = 1;
  int _children = 0;
  int _infants = 0;
  List<int> _selectedAirlineIds = [];
  String _flightClass = 'business';
  int _maxStops = 2;
  double? _minPrice;
  double? _maxPrice;
  String _sortBy = 'price';
  String _sortOrder = 'asc';
  List<String> _departureTimeFilters = [];

  // Airport data
  final List<Airport> _airports = [
    Airport(code: 'HAN', name: 'Sân bay quốc tế Nội Bài', city: 'Hà Nội', country: 'Việt Nam'),
    Airport(code: 'SGN', name: 'Sân bay quốc tế Tân Sơn Nhất', city: 'TP.HCM', country: 'Việt Nam'),
    Airport(code: 'DAD', name: 'Sân bay quốc tế Đà Nẵng', city: 'Đà Nẵng', country: 'Việt Nam'),
    Airport(code: 'PQC', name: 'Sân bay quốc tế Phú Quốc', city: 'Phú Quốc', country: 'Việt Nam'),
    Airport(code: 'CXR', name: 'Sân bay Cam Ranh', city: 'Nha Trang', country: 'Việt Nam'),
    Airport(code: 'HPH', name: 'Sân bay Cát Bi', city: 'Hải Phòng', country: 'Việt Nam'),
    Airport(code: 'VCA', name: 'Sân bay Cần Thơ', city: 'Cần Thơ', country: 'Việt Nam'),
  ];

  // Airline data
  final List<Map<String, dynamic>> _airlines = [
    {'id': 1, 'name': 'Vietnam\nAirlines', 'imagePath': 'assets/Images/VietnamAirlines.png'},
    {'id': 2, 'name': 'VietJet\nAir', 'imagePath': 'assets/Images/vietjetair.png'},
    {'id': 3, 'name': 'Bamboo\nAirways', 'imagePath': 'assets/Images/BambooAirways.png'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
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
              color: AppColors.primaryBlue,
              size: 20,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Tìm kiếm chuyến bay',
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        centerTitle: true,
        actions: [
          // Debug button for API testing
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const ConnectionTestScreen(),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue[200]!),
              ),
              child: Icon(
                Icons.bug_report,
                color: Colors.blue[600],
                size: 20,
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const NotificationsScreen(),
                ),
              );
            },
            child: Container(
              margin: const EdgeInsets.only(right: 16),
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
                color: Color(0xFF6B7280),
                size: 20,
              ),
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.flight_takeoff,
                  color: AppColors.primaryBlue,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Tìm kiếm chuyến bay',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Chọn nhanh hàng bay Việt Nam',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF64748B),
                ),
              ),
              if (_selectedAirlineIds.isNotEmpty)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '${_selectedAirlineIds.length} đã chọn',
                    style: const TextStyle(
                      fontFamily: 'BalooBhaijaan2',
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Airlines selection
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(child: _buildAirlineCard(_airlines[0]['name'], _airlines[0]['imagePath'], _airlines[0]['id'])),
              const SizedBox(width: 12),
              Expanded(child: _buildAirlineCard(_airlines[1]['name'], _airlines[1]['imagePath'], _airlines[1]['id'])),
              const SizedBox(width: 12),
              Expanded(child: _buildAirlineCard(_airlines[2]['name'], _airlines[2]['imagePath'], _airlines[2]['id'])),
            ],
          ),
          const SizedBox(height: 24),
          
          // Trip type selector
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isRoundTrip = true;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    decoration: BoxDecoration(
                      color: _isRoundTrip ? AppColors.primaryBlue : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: _isRoundTrip ? AppColors.primaryBlue : const Color(0xFFE5E7EB),
                      ),
                    ),
                    child: Text(
                      'Khứ hồi',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'BalooBhaijaan2',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _isRoundTrip ? Colors.white : const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isRoundTrip = false;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 20),
                    decoration: BoxDecoration(
                      color: !_isRoundTrip ? AppColors.primaryBlue : Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: !_isRoundTrip ? AppColors.primaryBlue : const Color(0xFFE5E7EB),
                      ),
                    ),
                    child: Text(
                      'Một chiều',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'BalooBhaijaan2',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: !_isRoundTrip ? Colors.white : const Color(0xFF64748B),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // From/To section
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _showAirportPicker('Chọn điểm đi', (airport) {
                    setState(() => _departure = airport);
                  }),
                  child: _buildLocationSelector(
                    'Từ', 
                    _departure?.city ?? 'Chọn điểm đi', 
                    Icons.location_on_outlined
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 12),
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      final temp = _departure;
                      _departure = _arrival;
                      _arrival = temp;
                    });
                  },
                  child: const Icon(
                    Icons.swap_horiz,
                    color: Color(0xFF64748B),
                    size: 20,
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () => _showAirportPicker('Chọn điểm đến', (airport) {
                    setState(() => _arrival = airport);
                  }),
                  child: _buildLocationSelector(
                    'Đến', 
                    _arrival?.city ?? 'Chọn điểm đến', 
                    Icons.location_on
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Date section
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () => _showDatePicker((date) {
                    setState(() => _departureDate = date);
                  }),
                  child: _buildDatePickerField(
                    'Ngày khởi hành', 
                    _departureDate != null 
                      ? DateFormat('dd/MM/yyyy').format(_departureDate!)
                      : 'Chọn ngày đi'
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: GestureDetector(
                  onTap: _isRoundTrip ? () => _showDatePicker((date) {
                    setState(() => _returnDate = date);
                  }) : null,
                  child: _buildDatePickerField(
                    'Ngày về', 
                    _isRoundTrip 
                      ? (_returnDate != null 
                          ? DateFormat('dd/MM/yyyy').format(_returnDate!)
                          : 'Chọn ngày về')
                      : '--/--/----'
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Passengers section
          GestureDetector(
            onTap: () => _showPassengerPicker(),
            child: _buildPassengerField(),
          ),
          const SizedBox(height: 24),
          
          // Filters and Search buttons
          Row(
            children: [
              Expanded(
                flex: 1,
                child: SizedBox(
                  height: 56,
                  child: OutlinedButton(
                    onPressed: _showFilters,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primaryBlue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.tune,
                          color: AppColors.primaryBlue,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Bộ lọc',
                          style: TextStyle(
                            fontFamily: 'BalooBhaijaan2',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                flex: 2,
                child: SizedBox(
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _canSearch() ? _search : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Tìm kiếm',
                      style: TextStyle(
                        fontFamily: 'BalooBhaijaan2',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // All the helper methods (copy from home_screen.dart)
  Widget _buildAirlineCard(String name, String imagePath, int airlineId) {
    bool isSelected = _selectedAirlineIds.contains(airlineId);
    
    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedAirlineIds.remove(airlineId);
          } else {
            _selectedAirlineIds.add(airlineId);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue.withOpacity(0.05) : const Color(0xFFF9FAFB),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : const Color(0xFFE5E7EB),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          children: [
            Container(
              width: 50,
              height: 50,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return Icon(
                      Icons.flight,
                      color: isSelected ? AppColors.primaryBlue : const Color(0xFF6B7280),
                      size: 24,
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: isSelected ? AppColors.primaryBlue : const Color(0xFF374151),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLocationSelector(String label, String value, IconData icon) {
    bool isPlaceholder = value == 'Chọn điểm đi' || value == 'Chọn điểm đến';
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              Icon(
                icon,
                color: const Color(0xFF6B7280),
                size: 16,
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  value,
                  style: TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isPlaceholder ? const Color(0xFF9CA3AF) : const Color(0xFF1E293B),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDatePickerField(String label, String value) {
    bool isPlaceholder = value == 'Chọn ngày đi' || value == 'Chọn ngày về';
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                color: Color(0xFF6B7280),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                value,
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: isPlaceholder ? const Color(0xFF9CA3AF) : const Color(0xFF1E293B),
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
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hành khách & Hạng',
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.person,
                color: Color(0xFF6B7280),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                _buildPassengerText(),
                style: const TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _buildPassengerText() {
    List<String> parts = [];
    parts.add('$_passengers người lớn');
    if (_children > 0) parts.add('$_children trẻ em');
    if (_infants > 0) parts.add('$_infants em bé');
    return parts.join(', ');
  }

  bool _canSearch() {
    bool hasRequiredFields = _departure != null && _arrival != null && _departureDate != null;
    
    if (_isRoundTrip) {
      hasRequiredFields = hasRequiredFields && _returnDate != null;
    }
    
    return hasRequiredFields;
  }

  void _showAirportPicker(String title, Function(Airport) onSelected) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        height: 400,
        child: Column(
          children: [
            Text(
              title,
              style: const TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: _airports
                    .map((airport) => ListTile(
                          leading: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.primaryBlue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.flight,
                              color: AppColors.primaryBlue,
                              size: 20,
                            ),
                          ),
                          title: Text(
                            airport.city,
                            style: const TextStyle(
                              fontFamily: 'BalooBhaijaan2',
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          subtitle: Text(
                            '${airport.name} (${airport.code})',
                            style: const TextStyle(
                              fontFamily: 'BalooBhaijaan2',
                              fontSize: 12,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          onTap: () {
                            onSelected(airport);
                            Navigator.pop(context);
                          },
                        ))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDatePicker(Function(DateTime) onSelected) async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (date != null) {
      onSelected(date);
    }
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Người lớn',
                        style: TextStyle(
                          fontFamily: 'BalooBhaijaan2',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        'Từ 12 tuổi trở lên',
                        style: TextStyle(
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
                        onPressed: _passengers > 1
                            ? () {
                                setModalState(() {
                                  _passengers--;
                                  if (_infants > _passengers) {
                                    _infants = _passengers;
                                  }
                                });
                                setState(() {});
                              }
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text(
                        '$_passengers',
                        style: const TextStyle(
                          fontFamily: 'BalooBhaijaan2',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        onPressed: _passengers < 9
                            ? () {
                                setModalState(() => _passengers++);
                                setState(() {});
                              }
                            : null,
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Children
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Trẻ em',
                        style: TextStyle(
                          fontFamily: 'BalooBhaijaan2',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        'Từ 2-11 tuổi',
                        style: TextStyle(
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
                        onPressed: _children > 0
                            ? () {
                                setModalState(() => _children--);
                                setState(() {});
                              }
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text(
                        '$_children',
                        style: const TextStyle(
                          fontFamily: 'BalooBhaijaan2',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        onPressed: _children < 9
                            ? () {
                                setModalState(() => _children++);
                                setState(() {});
                              }
                            : null,
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 16),
              
              // Infants
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Em bé',
                        style: TextStyle(
                          fontFamily: 'BalooBhaijaan2',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                      Text(
                        'Dưới 2 tuổi (ngồi cùng ghế)',
                        style: TextStyle(
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
                        onPressed: _infants > 0
                            ? () {
                                setModalState(() => _infants--);
                                setState(() {});
                              }
                            : null,
                        icon: const Icon(Icons.remove_circle_outline),
                      ),
                      Text(
                        '$_infants',
                        style: const TextStyle(
                          fontFamily: 'BalooBhaijaan2',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      IconButton(
                        onPressed: _infants < _passengers
                            ? () {
                                setModalState(() => _infants++);
                                setState(() {});
                              }
                            : null,
                        icon: const Icon(Icons.add_circle_outline),
                      ),
                    ],
                  ),
                ],
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
                      borderRadius: BorderRadius.circular(8),
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

  void _showFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        child: FlightFilters(
          minPrice: _minPrice,
          maxPrice: _maxPrice,
          maxStops: _maxStops,
          sortBy: _sortBy,
          sortOrder: _sortOrder,
          departureTimeFilters: _departureTimeFilters,
          onPriceRangeChanged: (minPrice, maxPrice) {
            setState(() {
              _minPrice = minPrice;
              _maxPrice = maxPrice;
            });
          },
          onMaxStopsChanged: (maxStops) {
            setState(() {
              _maxStops = maxStops;
            });
          },
          onSortChanged: (sortBy, sortOrder) {
            setState(() {
              _sortBy = sortBy;
              _sortOrder = sortOrder;
            });
          },
          onDepartureTimeFiltersChanged: (filters) {
            setState(() {
              _departureTimeFilters = filters;
            });
          },
        ),
      ),
    );
  }

  void _search() {
    // Validate required fields
    if (_departure == null || _arrival == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn điểm đi và điểm đến')),
      );
      return;
    }

    if (_departureDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ngày khởi hành')),
      );
      return;
    }

    if (_isRoundTrip && _returnDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Vui lòng chọn ngày về cho chuyến khứ hồi')),
      );
      return;
    }
    
    // Create search parameters according to the API format
    final searchParams = {
      "departure_airport_code": _departure!.code,
      "arrival_airport_code": _arrival!.code,
      "departure_date": DateFormat('dd/MM/yyyy').format(_departureDate!),
      "flight_class": _flightClass,
      "airline_ids": _selectedAirlineIds.isEmpty ? [] : _selectedAirlineIds,
      "max_stops": _maxStops,
      "passengers": {
        "adults": _passengers,
        "children": _children,
        "infants": _infants,
      },
      "passenger": {
        "adults": _passengers,
        "children": _children,
        "infant": _infants,
      },
      "page": 1,
      "limit": 50,
      "sort_by": _sortBy,
      "sort_order": _sortOrder,
      if (_minPrice != null) "min_price": _minPrice,
      if (_maxPrice != null) "max_price": _maxPrice,
      if (_departureTimeFilters.isNotEmpty) "departure_time_filters": _departureTimeFilters,
    };

    if (_isRoundTrip && _returnDate != null) {
      searchParams["return_date"] = DateFormat('dd/MM/yyyy').format(_returnDate!);
    }

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlightSearchResultsScreen(
          searchParams: searchParams,
          isRoundTrip: _isRoundTrip,
        ),
      ),
    );
  }
}
