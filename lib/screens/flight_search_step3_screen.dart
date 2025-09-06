import 'package:flutter/material.dart';
import 'package:cnh_n/constants/colors.dart';
import 'package:cnh_n/models/search_data.dart';
import 'package:cnh_n/screens/flight_search_results_screen.dart';
import 'package:cnh_n/widgets/search_app_bar.dart';

class FlightSearchStep3Screen extends StatefulWidget {
  final SearchData searchData;

  const FlightSearchStep3Screen({super.key, required this.searchData});

  @override
  State<FlightSearchStep3Screen> createState() => _FlightSearchStep3ScreenState();
}

class _FlightSearchStep3ScreenState extends State<FlightSearchStep3Screen> {
  late SearchData _searchData;

  final List<Map<String, dynamic>> _airlines = [
    {
      'id': 1, 
      'name': 'Vietnam Airlines', 
      'shortName': 'VN',
      'imagePath': 'lib/assets/Images/VietnamAirlines.png',
      'description': 'Hãng hàng không quốc gia Việt Nam',
      'features': ['Bữa ăn miễn phí', '23kg hành lý', 'Giải trí trên máy bay'],
    },
    {
      'id': 2, 
      'name': 'VietJet Air', 
      'shortName': 'VJ',
      'imagePath': 'lib/assets/Images/vietjetair.png',
      'description': 'Hãng hàng không giá rẻ hàng đầu',
      'features': ['Giá cạnh tranh', 'Bay đúng giờ', 'Đặt vé dễ dàng'],
    },
    {
      'id': 3, 
      'name': 'Bamboo Airways', 
      'shortName': 'QH',
      'imagePath': 'lib/assets/Images/BambooAirways.png',
      'description': 'Hãng hàng không 5 sao Việt Nam',
      'features': ['Dịch vụ cao cấp', 'Ghế rộng rãi', 'Phục vụ chu đáo'],
    },
    {
      'id': 4, 
      'name': 'Airline 4', 
      'shortName': 'A4',
      'imagePath': '',
      'description': 'Thêm logo hãng bay',
      'features': ['Chờ cập nhật'],
    },
    {
      'id': 5, 
      'name': 'Airline 5', 
      'shortName': 'A5',
      'imagePath': '',
      'description': 'Thêm logo hãng bay',
      'features': ['Chờ cập nhật'],
    },
    {
      'id': 6, 
      'name': 'Airline 6', 
      'shortName': 'A6',
      'imagePath': '',
      'description': 'Thêm logo hãng bay',
      'features': ['Chờ cập nhật'],
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchData = widget.searchData;
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
                    _buildTripSummary(),
                    const SizedBox(height: 32),
                    _buildAirlineSelection(),
                  ],
                ),
              ),
            ),
            
            // Search button
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
          Expanded(child: _buildProgressLine(true)),
          _buildProgressDot(true, '2'),
          Expanded(child: _buildProgressLine(true)),
          _buildProgressDot(true, '3'),
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
        child: isActive && number == '3' 
            ? const Icon(Icons.check, color: Colors.white, size: 16)
            : Text(
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
          'Chọn hãng hàng không',
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Chọn hãng hàng không bạn muốn hoặc tìm kiếm tất cả',
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

  Widget _buildTripSummary() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryBlue.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryBlue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.flight_takeoff,
                color: AppColors.primaryBlue,
                size: 20,
              ),
              const SizedBox(width: 8),
              const Text(
                'Tóm tắt chuyến bay',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Route
          Row(
            children: [
              Text(
                _searchData.departure?.code ?? 'HAN',
                style: const TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(width: 12),
              Icon(
                _searchData.isRoundTrip ? Icons.sync_alt : Icons.arrow_forward,
                color: AppColors.primaryBlue,
                size: 20,
              ),
              const SizedBox(width: 12),
              Text(
                _searchData.arrival?.code ?? 'SGN',
                style: const TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 8),
          
          // Date and passengers
          Row(
            children: [
              Text(
                _searchData.departureDate != null
                    ? "${_searchData.departureDate!.day}/${_searchData.departureDate!.month}"
                    : '01/08',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
              if (_searchData.isRoundTrip && _searchData.returnDate != null) ...[
                Text(
                  ' - ${_searchData.returnDate!.day}/${_searchData.returnDate!.month}',
                  style: TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700,
                  ),
                ),
              ],
              const SizedBox(width: 16),
              Icon(
                Icons.people,
                color: Colors.grey.shade600,
                size: 16,
              ),
              const SizedBox(width: 4),
              Text(
                '${_searchData.passengers + _searchData.children + _searchData.infants}',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAirlineSelection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Hãng hàng không',
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            if (_searchData.selectedAirlineIds.isNotEmpty)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${_searchData.selectedAirlineIds.length} đã chọn',
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
        const SizedBox(height: 16),
        
        // Airlines grid 2x3
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            childAspectRatio: 0.75,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: _airlines.length,
          itemBuilder: (context, index) {
            return _buildAirlineCard(_airlines[index]);
          },
        ),
      ],
    );
  }

  Widget _buildAirlineCard(Map<String, dynamic> airline) {
    final int airlineId = airline['id'];
    final bool isSelected = _searchData.selectedAirlineIds.contains(airlineId);
    
    return GestureDetector(
      onTap: () {
        setState(() {
          // Toggle individual airline selection
          List<int> newSelection = List.from(_searchData.selectedAirlineIds);
          if (isSelected) {
            newSelection.remove(airlineId);
          } else {
            newSelection.add(airlineId);
          }
          _searchData = _searchData.copyWith(selectedAirlineIds: newSelection);
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.primaryBlue.withOpacity(0.05)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected 
                ? AppColors.primaryBlue
                : Colors.grey.shade300,
            width: 2,
          ),
        ),
        child: Column(
          children: [
            // Airline logo
            Container(
              width: 60,
              height: 60,
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
              child: airline['imagePath'].isEmpty
                  ? const Icon(
                      Icons.flight,
                      color: AppColors.primaryBlue,
                      size: 32,
                    )
                  : ClipRRect(
                      borderRadius: BorderRadius.circular(8),
                      child: Image.asset(
                        airline['imagePath'],
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return const Icon(
                            Icons.flight,
                            color: AppColors.primaryBlue,
                            size: 32,
                          );
                        },
                      ),
                    ),
            ),
            
            const SizedBox(height: 8),
            
            // Airline info
            Expanded(
              child: Column(
                children: [
                  // Airline name and code
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Flexible(
                        child: Text(
                          airline['name'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'BalooBhaijaan2',
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: isSelected
                                ? AppColors.primaryBlue
                                : const Color(0xFF1E293B),
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      airline['shortName'],
                      style: const TextStyle(
                        fontFamily: 'BalooBhaijaan2',
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF6B7280),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    airline['description'],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'BalooBhaijaan2',
                      fontSize: 11,
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
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
          onPressed: _searchFlights,
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
              Icon(Icons.search, size: 20),
              SizedBox(width: 12),
              Text(
                'Tìm kiếm chuyến bay',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _searchFlights() {
    // Convert to API params and navigate to results
    final apiParams = _searchData.toApiParams();
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlightSearchResultsScreen(
          searchParams: apiParams,
          isRoundTrip: _searchData.isRoundTrip,
        ),
      ),
    );
  }
}
