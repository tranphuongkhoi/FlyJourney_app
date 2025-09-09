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

  // Track expanded states for flight cards
  Map<int, bool> _expandedStates = {};

  // Helper function to get total passenger count from search params
  int get _totalPassengers {
    final passengers = widget.searchParams['passengers'] ?? widget.searchParams['passenger'] ?? {};
    final adults = passengers['adults'] ?? 1;
    final children = passengers['children'] ?? 0; 
    final infants = passengers['infants'] ?? passengers['infant'] ?? 0;
    return adults + children + infants;
  }

  // Helper function to get formatted return date from search params
  String _getReturnDateString() {
    final returnDateStr = widget.searchParams['return_date'] as String?;
    if (returnDateStr != null && returnDateStr.isNotEmpty) {
      try {
        // Parse DD/MM/YYYY format
        final parts = returnDateStr.split('/');
        if (parts.length == 3) {
          final day = int.parse(parts[0]);
          final month = int.parse(parts[1]);
          final year = int.parse(parts[2]);
          final returnDate = DateTime(year, month, day);
          return DateFormat('dd/MM').format(returnDate);
        }
      } catch (e) {
        print('Error parsing return date: $e');
      }
    }
    // Fallback to current dev date
    return '27/08';
  }

  // Helper function to get unique key for flight (handles nullable flightId)
  int _getFlightKey(Flight flight) {
    return flight.flightId ?? flight.hashCode;
  }

  // Apply client-side filtering based on user selections
  List<Flight> _applyClientSideFiltering(List<Flight> flights) {
    List<Flight> filtered = List.from(flights);
    
    // Get user selections from search params
    final flightClass = widget.searchParams['flight_class'] as String?;
    final airlineIds = widget.searchParams['airline_ids'] as List?;
    
    print('🎯 CLIENT-SIDE FILTERING:');
    print('  - Original flights: ${flights.length}');
    print('  - User flight_class: $flightClass');
    print('  - User airline_ids: $airlineIds');
    
    // Filter by flight class if user selected specific class (not "all")
    if (flightClass != null && flightClass != 'all' && flightClass.isNotEmpty) {
      final originalCount = filtered.length;
      filtered = filtered.where((flight) {
        // Match exact flight class
        final matches = flight.flightClass.toLowerCase() == flightClass.toLowerCase();
        return matches;
      }).toList();
      print('  - After flight_class filter: ${filtered.length} (removed ${originalCount - filtered.length})');
    }
    
    // Filter by airline IDs if user selected specific airlines (not empty)
    if (airlineIds != null && airlineIds.isNotEmpty) {
      final originalCount = filtered.length;
      final selectedIds = airlineIds.cast<int>(); // Convert to int list
      filtered = filtered.where((flight) {
        final matches = selectedIds.contains(flight.airlineId);
        return matches;
      }).toList();
      print('  - After airline_ids filter: ${filtered.length} (removed ${originalCount - filtered.length})');
    }
    
    print('  - Final filtered count: ${filtered.length}');
    return filtered;
  }

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
          print('🔍 ONE-WAY PARSING:');
          print('  - widget.isRoundTrip: ${widget.isRoundTrip}');
          print('  - searchResults is List: true');
          print('  - flights count: ${searchResults.length}');
          _outboundFlights = searchResults.map((flightData) => _parseApiFlightToModel(flightData)).toList();
          _inboundFlights = [];
          allFlights.addAll(_outboundFlights);
        } else if (searchResults is Map<String, dynamic>) {
          // Case 2: search_results is an object with outbound_flights and inbound_flights (roundtrip)
          final outboundFlights = (searchResults['outbound_flights'] as List?) ?? [];
          final inboundFlights = (searchResults['inbound_flights'] as List?) ?? [];
          
          // Debug: Check what we got
          print('🔍 ROUNDTRIP PARSING:');
          print('  - widget.isRoundTrip: ${widget.isRoundTrip}');
          print('  - searchResults keys: ${searchResults.keys.toList()}');
          print('  - outbound count: ${outboundFlights.length}');
          print('  - inbound count: ${inboundFlights.length}');

          _outboundFlights = outboundFlights.map((flightData) => _parseApiFlightToModel(flightData)).toList();
          _inboundFlights = inboundFlights.map((flightData) => _parseApiFlightToModel(flightData)).toList();
          
          // Apply client-side filtering based on user selections
          _outboundFlights = _applyClientSideFiltering(_outboundFlights);
          _inboundFlights = _applyClientSideFiltering(_inboundFlights);
          
          // For roundtrip, show outbound flights first, then inbound  
          allFlights.addAll(_outboundFlights);
          if (widget.isRoundTrip) {
            allFlights.addAll(_inboundFlights);
          }
        }
        
        // Apply client-side filtering for one-way flights too
        if (searchResults is List) {
          _outboundFlights = _applyClientSideFiltering(_outboundFlights);
          allFlights = _outboundFlights;
        }
        
        _flights = allFlights;
        _filteredFlights = List.from(_flights);
        
        if (_flights.isEmpty) {
          _errorMessage = 'Không tìm thấy chuyến bay nào cho tuyến này. Vui lòng thử lại với ngày khác hoặc bộ lọc khác.';
        }
        
        _sortFlights();
      } else {
        // API error - show error without fallback
        _errorMessage = result['message'] ?? 'Có lỗi xảy ra khi tìm kiếm chuyến bay. Vui lòng thử lại.';
        print('API Error: ${result['error']} - ${result['message']}');
        
        // Clear flights data
        _flights = [];
        _filteredFlights = [];
        _outboundFlights = [];
        _inboundFlights = [];
      }
    } catch (e) {
      // Network error - show error without fallback
      _errorMessage = 'Không thể kết nối đến server. Vui lòng kiểm tra kết nối mạng và thử lại.';
      print('Network Error: $e');
      
      // Clear flights data  
      _flights = [];
      _filteredFlights = [];
      _outboundFlights = [];
      _inboundFlights = [];
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
                    passengers: _totalPassengers,
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
                              _getReturnDateString(),
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
                ? 'Tìm thấy ${_outboundFlights.length} chuyến bay đi • ${_inboundFlights.length} chuyến bay về • $_totalPassengers hành khách'
                : 'Tìm thấy ${_filteredFlights.length} chuyến bay • $_totalPassengers hành khách',
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
    if (widget.isRoundTrip) {
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
          ] else ...[
            // Show message when no inbound flights
            Container(
              padding: const EdgeInsets.all(20),
              margin: const EdgeInsets.symmetric(horizontal: 4),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline, color: Colors.orange.shade600),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Không tìm thấy chuyến bay về cho ngày này. Vui lòng thử ngày khác.',
                      style: TextStyle(
                        fontFamily: 'BalooBhaijaan2',
                        fontSize: 14,
                        color: Colors.orange.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),
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
            if (widget.isRoundTrip) {
              // Roundtrip: Always use selection logic
              setState(() {
                if (isOutbound == true) {
                  // Selecting outbound flight
                  if (_selectedOutboundFlight == flight) {
                    _selectedOutboundFlight = null; // Deselect if already selected
                  } else {
                    _selectedOutboundFlight = flight; // Select new flight
                  }
                } else if (isOutbound == false) {
                  // Selecting inbound flight
                  if (_selectedInboundFlight == flight) {
                    _selectedInboundFlight = null; // Deselect if already selected
                  } else {
                    _selectedInboundFlight = flight; // Select new flight
                  }
                } else {
                  // For one-way flights in roundtrip search (shouldn't happen normally)
                  _selectedOutboundFlight = flight;
                }
              });
            } else {
              // One-way: Navigate immediately
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FlightOverviewScreen(
                    flight: flight,
                    passengers: _totalPassengers,
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
                // Footer with seats, details, and select button
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
                    const SizedBox(width: 16),
                    // Details expand button
                    GestureDetector(
                      onTap: () {
                        setState(() {
                          final flightKey = _getFlightKey(flight);
                          _expandedStates[flightKey] = !(_expandedStates[flightKey] ?? false);
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.grey.shade100,
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'Chi tiết',
                              style: TextStyle(
                                fontFamily: 'BalooBhaijaan2',
                                fontSize: 12,
                                color: Colors.grey.shade700,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(width: 4),
                            AnimatedRotation(
                              duration: const Duration(milliseconds: 200),
                              turns: (_expandedStates[_getFlightKey(flight)] ?? false) ? 0.5 : 0,
                              child: Icon(
                                Icons.keyboard_arrow_down,
                                size: 16,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
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
                // Expandable details section
                AnimatedCrossFade(
                  duration: const Duration(milliseconds: 300),
                  crossFadeState: (_expandedStates[_getFlightKey(flight)] ?? false) 
                      ? CrossFadeState.showSecond 
                      : CrossFadeState.showFirst,
                  firstChild: const SizedBox.shrink(),
                  secondChild: _buildFlightDetails(flight),
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

  Widget _buildFlightDetails(Flight flight) {
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildDetailRow('Ngày giờ khởi hành', '${DateFormat('dd/MM/yyyy - HH:mm').format(flight.departureTime)}'),
          _buildDetailRow('Ngày giờ đến', '${DateFormat('dd/MM/yyyy - HH:mm').format(flight.arrivalTime)}'),
          _buildDetailRow('Số chuyến bay', flight.flightNumber),
          _buildDetailRow('Loại máy bay', flight.aircraft),
          _buildDetailRow('Thời gian bay', flight.duration),
          _buildDetailRow('Hạng vé', _getFlightClassDisplay(flight.flightClass)),
          const Divider(height: 20),
          _buildSectionTitle('Hành lý', Icons.luggage),
          const SizedBox(height: 8),
          _buildBaggageInfo(),
          const SizedBox(height: 12),
          _buildSectionTitle('Quy định vé', Icons.description),
          const SizedBox(height: 8),
          _buildTicketPolicy(),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 13,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const Text(': ', style: TextStyle(fontSize: 13)),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primaryBlue),
        const SizedBox(width: 6),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryBlue,
          ),
        ),
      ],
    );
  }

  Widget _buildBaggageInfo() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade200),
      ),
      child: Column(
        children: [
          _buildBaggageRow('Hành lý xách tay', '7kg (miễn phí)', Icons.backpack),
          const SizedBox(height: 6),
          _buildBaggageRow('Hành lý ký gửi', '20kg (miễn phí)', Icons.luggage),
          const SizedBox(height: 6),
          _buildBaggageRow('Hành lý thêm', 'Từ 200,000 VNĐ/kg', Icons.add_circle_outline),
        ],
      ),
    );
  }

  Widget _buildBaggageRow(String title, String description, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.blue.shade600),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.blue.shade800,
          ),
        ),
        const Spacer(),
        Text(
          description,
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 12,
            color: Colors.blue.shade700,
          ),
        ),
      ],
    );
  }

  Widget _buildTicketPolicy() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.orange.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.shade200),
      ),
      child: Column(
        children: [
          _buildPolicyRow('Đổi vé', 'Phí từ 500,000 VNĐ', Icons.swap_horiz),
          const SizedBox(height: 6),
          _buildPolicyRow('Hoàn vé', 'Phí từ 800,000 VNĐ', Icons.cancel),
          const SizedBox(height: 6),
          _buildPolicyRow('Chọn chỗ ngồi', 'Từ 50,000 VNĐ/ghế', Icons.airline_seat_recline_normal),
        ],
      ),
    );
  }

  Widget _buildPolicyRow(String title, String description, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.orange.shade600),
        const SizedBox(width: 8),
        Text(
          title,
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Colors.orange.shade800,
          ),
        ),
        const Spacer(),
        Text(
          description,
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 12,
            color: Colors.orange.shade700,
          ),
        ),
      ],
    );
  }

  String _getFlightClassDisplay(String flightClass) {
    switch (flightClass.toLowerCase()) {
      case 'economy':
        return 'Phổ thông (Economy)';
      case 'business':
        return 'Thương gia (Business)';
      case 'first':
        return 'Hạng nhất (First Class)';
      default:
        return 'Phổ thông (Economy)';
    }
  }
}
