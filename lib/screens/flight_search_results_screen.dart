import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cnh_n/models/airport.dart';
import 'package:cnh_n/models/flight.dart';
import 'package:cnh_n/screens/flight_overview_screen.dart';
import 'package:cnh_n/constants/colors.dart';
import 'package:cnh_n/services/flight_service.dart';

class FlightSearchResultsScreen extends StatefulWidget {
  final Map<String, dynamic> searchParams;
  final bool isRoundTrip;

  const FlightSearchResultsScreen({
    super.key,
    required this.searchParams,
    required this.isRoundTrip,
  });

  @override
  State<FlightSearchResultsScreen> createState() => _FlightSearchResultsScreenState();
}

class _FlightSearchResultsScreenState extends State<FlightSearchResultsScreen> {
  List<Flight> _flights = [];
  List<Flight> _filteredFlights = [];
  List<Flight> _outboundFlights = [];
  List<Flight> _inboundFlights = [];
  Flight? _selectedOutboundFlight;
  Flight? _selectedInboundFlight;
  String _sortBy = 'price';
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _loadFlights();
  }

  void _loadFlights() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      // Call real API
      final result = await FlightService.searchFlights(widget.searchParams);
      
      if (result['success'] == true) {
        // Parse API response to Flight objects
        final searchResults = result['data']['search_results'];
        
        List<Flight> allFlights = [];
        
        // Check if search_results is a List or Map
        if (searchResults is List) {
          // Case 1: search_results is directly a list of flights (one-way)
          print('🛫 Direct flights list with ${searchResults.length} flights');
          _outboundFlights = searchResults.map((flightData) => _parseApiFlightToModel(flightData)).toList();
          _inboundFlights = [];
          allFlights.addAll(_outboundFlights);
        } else if (searchResults is Map<String, dynamic>) {
          // Case 2: search_results is an object with outbound_flights and inbound_flights (roundtrip)
          final outboundFlights = (searchResults['outbound_flights'] as List?) ?? [];
          final inboundFlights = (searchResults['inbound_flights'] as List?) ?? [];
          
          print('🛫 Outbound flights count: ${outboundFlights.length}');
          print('🛬 Inbound flights count: ${inboundFlights.length}');
          
          _outboundFlights = outboundFlights.map((flightData) => _parseApiFlightToModel(flightData)).toList();
          _inboundFlights = inboundFlights.map((flightData) => _parseApiFlightToModel(flightData)).toList();
          
          // For roundtrip, show outbound flights first, then inbound  
          allFlights.addAll(_outboundFlights);
          if (widget.isRoundTrip) {
            allFlights.addAll(_inboundFlights);
          }
        }
        
        _flights = allFlights;
        _filteredFlights = List.from(_flights);
        
        if (_flights.isEmpty) {
          _errorMessage = 'Không tìm thấy chuyến bay nào cho tuyến này. Hiển thị dữ liệu mẫu.';
          // Fallback to sample data if no flights found
          _flights = _createSampleFlights();
          _filteredFlights = List.from(_flights);
          
          // For sample data, split into outbound/inbound based on flight logic
          if (widget.isRoundTrip) {
            // Sample data is already structured with outbound first, then inbound
            _outboundFlights = _flights.where((flight) => 
              flight.departureTime.difference(DateTime.now()).inDays <= 7
            ).toList();
            _inboundFlights = _flights.where((flight) => 
              flight.departureTime.difference(DateTime.now()).inDays > 7
            ).toList();
          } else {
            _outboundFlights = _flights;
            _inboundFlights = [];
          }
        }
        
        _sortFlights();
      } else {
        // API error
        _errorMessage = result['message'] ?? 'Có lỗi xảy ra khi tìm kiếm chuyến bay';
        print('API Error: ${result['error']} - ${result['message']}');
        
        // Fallback to sample data for development
        _flights = _createSampleFlights();
        _filteredFlights = List.from(_flights);
        
        // For sample data, split into outbound/inbound based on flight logic
        if (widget.isRoundTrip) {
          // Sample data is already structured with outbound first, then inbound
          _outboundFlights = _flights.where((flight) => 
            flight.departureTime.difference(DateTime.now()).inDays <= 7
          ).toList();
          _inboundFlights = _flights.where((flight) => 
            flight.departureTime.difference(DateTime.now()).inDays > 7
          ).toList();
        } else {
          _outboundFlights = _flights;
          _inboundFlights = [];
        }
        
        _sortFlights();
      }
    } catch (e) {
      // Network error
      _errorMessage = 'Không thể kết nối đến server. Đang hiển thị dữ liệu mẫu.';
      print('Network Error: $e');
      
      // Fallback to sample data
      _flights = _createSampleFlights();
      _filteredFlights = List.from(_flights);
      
      // For sample data, split into outbound/inbound based on flight logic
      if (widget.isRoundTrip) {
        // Sample data is already structured with outbound first, then inbound
        _outboundFlights = _flights.where((flight) => 
          flight.departureTime.difference(DateTime.now()).inDays <= 7
        ).toList();
        _inboundFlights = _flights.where((flight) => 
          flight.departureTime.difference(DateTime.now()).inDays > 7
        ).toList();
      } else {
        _outboundFlights = _flights;
        _inboundFlights = [];
      }
      
      _sortFlights();
    }

    setState(() {
      _isLoading = false;
    });
  }

  Flight _parseApiFlightToModel(Map<String, dynamic> apiData) {
    // Use the updated Flight.fromJson method that handles all the new fields
    return Flight.fromJson(apiData);
  }

  String _formatDuration(int minutes) {
    final hours = minutes ~/ 60;
    final remainingMinutes = minutes % 60;
    return '${hours}h ${remainingMinutes}m';
  }

  List<Flight> _createSampleFlights() {
    final departureCode = widget.searchParams['departure_airport_code'] ?? 'HAN';
    final arrivalCode = widget.searchParams['arrival_airport_code'] ?? 'SGN';
    final departureDate = DateTime.now().add(const Duration(days: 7));
    final returnDate = widget.isRoundTrip 
        ? DateTime.now().add(const Duration(days: 10))
        : departureDate;
    
    final departure = Airport(
      code: departureCode,
      name: departureCode == 'HAN' ? 'Sân bay quốc tế Nội Bài' : 'Sân bay quốc tế Tân Sơn Nhất',
      city: departureCode == 'HAN' ? 'Hà Nội' : 'TP.HCM',
      country: 'Việt Nam',
    );
    
    final arrival = Airport(
      code: arrivalCode,
      name: arrivalCode == 'SGN' ? 'Sân bay quốc tế Tân Sơn Nhất' : 'Sân bay quốc tế Nội Bài',
      city: arrivalCode == 'SGN' ? 'TP.HCM' : 'Hà Nội',
      country: 'Việt Nam',
    );

    // Outbound flights (chuyến bay đi)
    List<Flight> outboundFlights = [
      Flight(
        flightId: 1,
        flightClassId: 1,
        flightNumber: 'VJ123',
        airlineId: 2,
        airline: 'VietJet Air',
        airlineLogo: '',
        departure: departure,
        arrival: arrival,
        departureTime: departureDate.add(const Duration(hours: 6)),
        arrivalTime: departureDate.add(const Duration(hours: 8, minutes: 30)),
        price: 1450000,
        aircraft: 'Airbus A321',
        availableSeats: 24,
        duration: '2h 30m',
        durationMinutes: 150,
        stopsCount: 0,
        distance: 1166,
        flightClass: 'economy',
        totalSeats: 180,
        taxAndFees: 150000,
      ),
      Flight(
        flightId: 2,
        flightClassId: 2,
        flightNumber: 'VN456',
        airlineId: 1,
        airline: 'Vietnam Airlines',
        airlineLogo: '',
        departure: departure,
        arrival: arrival,
        departureTime: departureDate.add(const Duration(hours: 8)),
        arrivalTime: departureDate.add(const Duration(hours: 10, minutes: 45)),
        price: 2100000,
        aircraft: 'Boeing 787',
        availableSeats: 12,
        duration: '2h 45m',
        durationMinutes: 165,
        stopsCount: 0,
        distance: 1166,
        flightClass: 'business',
        totalSeats: 180,
        taxAndFees: 200000,
      ),
      Flight(
        flightId: 3,
        flightClassId: 1,
        flightNumber: 'BL789',
        airlineId: 3,
        airline: 'Bamboo Airways',
        airlineLogo: '',
        departure: departure,
        arrival: arrival,
        departureTime: departureDate.add(const Duration(hours: 14)),
        arrivalTime: departureDate.add(const Duration(hours: 16, minutes: 30)),
        price: 1650000,
        aircraft: 'Embraer E195',
        availableSeats: 18,
        duration: '2h 30m',
        durationMinutes: 150,
        stopsCount: 0,
        distance: 1166,
        flightClass: 'economy',
        totalSeats: 180,
        taxAndFees: 150000,
      ),
      Flight(
        flightId: 4,
        flightClassId: 1,
        flightNumber: 'VJ234',
        airlineId: 2,
        airline: 'VietJet Air',
        airlineLogo: '',
        departure: departure,
        arrival: arrival,
        departureTime: departureDate.add(const Duration(hours: 18)),
        arrivalTime: departureDate.add(const Duration(hours: 20, minutes: 30)),
        price: 1350000,
        aircraft: 'Airbus A320',
        availableSeats: 30,
        duration: '2h 30m',
        durationMinutes: 150,
        stopsCount: 0,
        distance: 1166,
        flightClass: 'economy',
        totalSeats: 180,
        taxAndFees: 150000,
      ),
    ];

    // Inbound flights (chuyến bay về) - chỉ có khi khứ hồi
    List<Flight> inboundFlights = [];
    if (widget.isRoundTrip) {
      inboundFlights = [
        Flight(
          flightId: 5,
          flightClassId: 1,
          flightNumber: 'VJ567',
          airlineId: 2,
          airline: 'VietJet Air',
          airlineLogo: '',
          departure: arrival, // Đổi ngược lại: từ điểm đến về điểm đi
          arrival: departure, // Đổi ngược lại: từ điểm đến về điểm đi
          departureTime: returnDate.add(const Duration(hours: 7)),
          arrivalTime: returnDate.add(const Duration(hours: 9, minutes: 30)),
          price: 1500000,
          aircraft: 'Airbus A321',
          availableSeats: 20,
          duration: '2h 30m',
          durationMinutes: 150,
          stopsCount: 0,
          distance: 1166,
          flightClass: 'economy',
          totalSeats: 180,
          taxAndFees: 150000,
        ),
        Flight(
          flightId: 6,
          flightClassId: 2,
          flightNumber: 'VN678',
          airlineId: 1,
          airline: 'Vietnam Airlines',
          airlineLogo: '',
          departure: arrival, // Đổi ngược lại
          arrival: departure, // Đổi ngược lại
          departureTime: returnDate.add(const Duration(hours: 11)),
          arrivalTime: returnDate.add(const Duration(hours: 13, minutes: 45)),
          price: 2200000,
          aircraft: 'Boeing 787',
          availableSeats: 15,
          duration: '2h 45m',
          durationMinutes: 165,
          stopsCount: 0,
          distance: 1166,
          flightClass: 'business',
          totalSeats: 180,
          taxAndFees: 200000,
        ),
        Flight(
          flightId: 7,
          flightClassId: 1,
          flightNumber: 'BL890',
          airlineId: 3,
          airline: 'Bamboo Airways',
          airlineLogo: '',
          departure: arrival, // Đổi ngược lại
          arrival: departure, // Đổi ngược lại
          departureTime: returnDate.add(const Duration(hours: 16)),
          arrivalTime: returnDate.add(const Duration(hours: 18, minutes: 30)),
          price: 1750000,
          aircraft: 'Embraer E195',
          availableSeats: 22,
          duration: '2h 30m',
          durationMinutes: 150,
          stopsCount: 0,
          distance: 1166,
          flightClass: 'economy',
          totalSeats: 180,
          taxAndFees: 150000,
        ),
      ];
    }

    return [...outboundFlights, ...inboundFlights];
  }

  Widget _buildViewDetailsButton() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      width: double.infinity,
      child: FloatingActionButton.extended(
        onPressed: () {
          if (_selectedOutboundFlight != null && _selectedInboundFlight != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => FlightOverviewScreen(
                  flight: _selectedOutboundFlight!,
                  returnFlight: _selectedInboundFlight!,
                  passengers: widget.searchParams['passenger']?['adults'] ?? 1,
                  returnDate: DateTime.tryParse(widget.searchParams['return_date'] ?? ''),
                ),
              ),
            );
          }
        },
        backgroundColor: AppColors.primaryBlue,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        label: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.airplane_ticket,
              color: Colors.white,
              size: 24,
            ),
            const SizedBox(width: 12),
            const Text(
              'Xem chi tiết vé khứ hồi',
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '${NumberFormat('#,###', 'vi').format((_selectedOutboundFlight?.price ?? 0) + (_selectedInboundFlight?.price ?? 0))} ₫',
                style: const TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _sortFlights() {
    _filteredFlights.sort((a, b) {
      switch (_sortBy) {
        case 'price':
          return a.price.compareTo(b.price);
        case 'departure':
          return a.departureTime.compareTo(b.departureTime);
        case 'duration':
          return a.duration.compareTo(b.duration);
        default:
          return 0;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool canProceedToOverview = widget.isRoundTrip 
        ? (_selectedOutboundFlight != null && _selectedInboundFlight != null)
        : false; // One-way navigates immediately
        
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA), // Exact same as homepage
      body: SafeArea(
        child: _isLoading ? _buildLoadingScreen() : _buildMainContent(),
      ),
      floatingActionButton: canProceedToOverview 
          ? _buildViewDetailsButton()
          : null,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildLoadingScreen() {
    return Container(
      color: const Color(0xFFE0F7FA),
      child: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryBlue),
              strokeWidth: 3,
            ),
            SizedBox(height: 24),
            Text(
              'Đang tìm kiếm chuyến bay tốt nhất...',
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 18,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1E293B),
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Vui lòng chờ trong giây lát',
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 14,
                color: Color(0xFF64748B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    return Column(
      children: [
        _buildTopBar(),
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSearchSummaryCard(),
                if (_errorMessage != null) ...[
                  const SizedBox(height: 16),
                  _buildErrorMessage(),
                ],
                const SizedBox(height: 24),
                _buildFlightsList(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorMessage() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange[200]!),
      ),
      child: Row(
        children: [
          Icon(
            Icons.warning_amber,
            color: Colors.orange[600],
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              _errorMessage!,
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 14,
                color: Colors.orange[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          GestureDetector(
            onTap: _loadFlights,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.orange[600],
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Text(
                'Thử lại',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
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
                'Kết quả tìm kiếm',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          // Fly Journey Brand with Hero Animation
          Hero(
            tag: 'fly_journey_logo',
            child: Material(
              color: Colors.transparent,
              child: const Text(
                'Fly Journey',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchSummaryCard() {
    final departureCode = widget.searchParams['departure_airport_code'] ?? 'HAN';
    final arrivalCode = widget.searchParams['arrival_airport_code'] ?? 'SGN';
    
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
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
          // Flight route info
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Text(
                      departureCode,
                      style: const TextStyle(
                        fontFamily: 'BalooBhaijaan2',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      departureCode == 'HAN' ? 'Hà Nội' : 'TP.HCM',
                      style: const TextStyle(
                        fontFamily: 'BalooBhaijaan2',
                        fontSize: 14,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
                // Trip type and dates info
                Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: AppColors.primaryBlue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            widget.isRoundTrip ? Icons.sync_alt : Icons.arrow_forward,
                            color: AppColors.primaryBlue,
                            size: 16,
                          ),
                          const SizedBox(width: 4),
                          Text(
                            widget.isRoundTrip ? 'Khứ hồi' : 'Một chiều',
                            style: const TextStyle(
                              fontFamily: 'BalooBhaijaan2',
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: AppColors.primaryBlue,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (widget.isRoundTrip) ...[
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.flight_land,
                              color: Colors.green[600],
                              size: 16,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              DateFormat('dd/MM').format(DateTime.now().add(const Duration(days: 10))),
                              style: TextStyle(
                                fontFamily: 'BalooBhaijaan2',
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: Colors.green[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              Expanded(
                child: Column(
                  children: [
                    Text(
                      arrivalCode,
                      style: const TextStyle(
                        fontFamily: 'BalooBhaijaan2',
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      arrivalCode == 'SGN' ? 'TP.HCM' : 'Hà Nội',
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
          const SizedBox(height: 20),
          // Results summary
          Text(
            widget.isRoundTrip && _inboundFlights.isNotEmpty
                ? 'Tìm thấy ${_outboundFlights.length} chuyến bay đi • ${_inboundFlights.length} chuyến bay về • ${widget.searchParams['passenger']?['adults'] ?? 1} hành khách'
                : 'Tìm thấy ${_filteredFlights.length} chuyến bay • ${widget.searchParams['passenger']?['adults'] ?? 1} hành khách',
            style: const TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlightsList() {
    if (widget.isRoundTrip && _inboundFlights.isNotEmpty) {
      // Roundtrip - show outbound and inbound separately
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Outbound flights section
          if (_outboundFlights.isNotEmpty) ...[
            _buildSectionHeader('🛫 Chuyến bay đi'),
            const SizedBox(height: 16),
            ..._outboundFlights.map((flight) => _buildFlightCard(flight, _outboundFlights.indexOf(flight), isOutbound: true)).toList(),
            const SizedBox(height: 32),
          ],
          
          // Inbound flights section
          if (_inboundFlights.isNotEmpty) ...[
            _buildSectionHeader('🛬 Chuyến bay về'),
            const SizedBox(height: 16),
            ..._inboundFlights.map((flight) => _buildFlightCard(flight, _inboundFlights.indexOf(flight), isOutbound: false)).toList(),
          ],
        ],
      );
    } else {
      // One-way - show all flights normally
      return Column(
        children: _filteredFlights.map((flight) => _buildFlightCard(flight, _filteredFlights.indexOf(flight))).toList(),
      );
    }
  }

  Widget _buildSectionHeader(String title) {
    final bool isOutbound = title.contains('đi');
    final Color primaryColor = isOutbound ? AppColors.primaryBlue : Colors.green[600]!;
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      margin: const EdgeInsets.symmetric(horizontal: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            primaryColor.withOpacity(0.08),
            primaryColor.withOpacity(0.12),
          ],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: primaryColor.withOpacity(0.15)),
        boxShadow: [
          BoxShadow(
            color: primaryColor.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Text(
            title,
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: primaryColor,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.15),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              isOutbound 
                  ? '${_outboundFlights.length} chuyến bay'
                  : '${_inboundFlights.length} chuyến bay',
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: primaryColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFlightCard(Flight flight, int index, {bool? isOutbound}) {
    final bool isSelected = (isOutbound == true && _selectedOutboundFlight == flight) ||
                           (isOutbound == false && _selectedInboundFlight == flight);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isSelected ? Colors.blue.shade50 : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: isSelected 
            ? Border.all(
                color: isOutbound == true 
                    ? AppColors.primaryBlue
                    : Colors.green[600]!,
                width: 3,
              )
            : (isOutbound != null 
                ? Border.all(
                    color: isOutbound == true 
                        ? AppColors.primaryBlue.withOpacity(0.3)
                        : Colors.green.withOpacity(0.3),
                    width: 2,
                  )
                : null),
        boxShadow: [
          BoxShadow(
            color: isSelected 
                ? (isOutbound == true ? AppColors.primaryBlue : Colors.green[600]!).withOpacity(0.2)
                : Colors.black.withOpacity(0.05),
            blurRadius: isSelected ? 15 : 20,
            offset: Offset(0, isSelected ? 6 : 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          borderRadius: BorderRadius.circular(8),
          onTap: () {
            if (widget.isRoundTrip && _inboundFlights.isNotEmpty) {
              // Roundtrip: Toggle selection for flights
              setState(() {
                if (isOutbound == true) {
                  if (_selectedOutboundFlight == flight) {
                    _selectedOutboundFlight = null; // Deselect if already selected
                  } else {
                    _selectedOutboundFlight = flight; // Select new flight
                  }
                } else if (isOutbound == false) {
                  if (_selectedInboundFlight == flight) {
                    _selectedInboundFlight = null; // Deselect if already selected
                  } else {
                    _selectedInboundFlight = flight; // Select new flight
                  }
                }
              });
            } else {
              // One-way: Navigate immediately
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FlightOverviewScreen(
                    flight: flight,
                    passengers: widget.searchParams['passenger']?['adults'] ?? 1,
                    returnDate: null,
                  ),
                ),
              );
            }
          },
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Header with airline and price
                Row(
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: _getAirlineColor(flight.airline).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.flight,
                        color: _getAirlineColor(flight.airline),
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            flight.airline,
                            style: const TextStyle(
                              fontFamily: 'BalooBhaijaan2',
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            flight.flightNumber,
                            style: const TextStyle(
                              fontFamily: 'BalooBhaijaan2',
                              fontSize: 14,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          '${NumberFormat('#,###', 'vi').format(flight.price)} ₫',
                          style: const TextStyle(
                            fontFamily: 'BalooBhaijaan2',
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          'mỗi khách',
                          style: TextStyle(
                            fontFamily: 'BalooBhaijaan2',
                            fontSize: 12,
                            color: Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                // Flight time info
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            DateFormat('HH:mm').format(flight.departureTime),
                            style: const TextStyle(
                              fontFamily: 'BalooBhaijaan2',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            flight.departure.code,
                            style: const TextStyle(
                              fontFamily: 'BalooBhaijaan2',
                              fontSize: 14,
                              color: Color(0xFF64748B),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            flight.duration,
                            style: const TextStyle(
                              fontFamily: 'BalooBhaijaan2',
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF64748B),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  height: 2,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryBlue.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                ),
                              ),
                              Icon(
                                Icons.flight,
                                color: AppColors.primaryBlue,
                                size: 16,
                              ),
                              Expanded(
                                child: Container(
                                  height: 2,
                                  decoration: BoxDecoration(
                                    color: AppColors.primaryBlue.withOpacity(0.3),
                                    borderRadius: BorderRadius.circular(1),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Bay thẳng',
                            style: TextStyle(
                              fontFamily: 'BalooBhaijaan2',
                              fontSize: 12,
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
                            DateFormat('HH:mm').format(flight.arrivalTime),
                            style: const TextStyle(
                              fontFamily: 'BalooBhaijaan2',
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1E293B),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            flight.arrival.code,
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
                const SizedBox(height: 16),
                // Footer with seats and select button
                Row(
                  children: [
                    Text(
                      'Còn ${flight.availableSeats} ghế',
                      style: TextStyle(
                        fontFamily: 'BalooBhaijaan2',
                        fontSize: 14,
                        color: flight.availableSeats > 15 
                            ? Colors.green[600] 
                            : Colors.orange[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      decoration: BoxDecoration(
                        color: isSelected 
                            ? (isOutbound == true ? AppColors.primaryBlue : Colors.green[600]!)
                            : AppColors.primaryBlue,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (isSelected) ...[
                            const Icon(
                              Icons.check_circle,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                          ],
                          Text(
                            isSelected ? 'Đã chọn' : 'Chọn',
                            style: const TextStyle(
                              fontFamily: 'BalooBhaijaan2',
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
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
        ),
      ),
    );
  }

  Color _getAirlineColor(String airline) {
    switch (airline) {
      case 'VietJet Air':
        return const Color(0xFFE53E3E);
      case 'Vietnam Airlines':
        return const Color(0xFF1E3A8A);
      case 'Bamboo Airways':
        return const Color(0xFF16A34A);
      default:
        return Colors.grey.shade600;
    }
  }
}
