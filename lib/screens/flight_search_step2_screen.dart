import 'package:flutter/material.dart';
import 'package:cnh_n/constants/colors.dart';
import 'package:cnh_n/models/search_data.dart';
import 'package:cnh_n/models/airport.dart';
import 'package:cnh_n/screens/flight_search_step3_screen.dart';
import 'package:cnh_n/widgets/flight_filters.dart';
import 'package:cnh_n/widgets/search_app_bar.dart';

class FlightSearchStep2Screen extends StatefulWidget {
  final SearchData searchData;

  const FlightSearchStep2Screen({super.key, required this.searchData});

  @override
  State<FlightSearchStep2Screen> createState() => _FlightSearchStep2ScreenState();
}

class _FlightSearchStep2ScreenState extends State<FlightSearchStep2Screen> {
  late SearchData _searchData;

  final List<Airport> _airports = [
    Airport(code: 'HAN', name: 'Sân bay quốc tế Nội Bài', city: 'Hà Nội', country: 'Việt Nam'),
    Airport(code: 'SGN', name: 'Sân bay quốc tế Tân Sơn Nhất', city: 'TP.HCM', country: 'Việt Nam'),
    Airport(code: 'DAD', name: 'Sân bay quốc tế Đà Nẵng', city: 'Đà Nẵng', country: 'Việt Nam'),
    Airport(code: 'PQC', name: 'Sân bay quốc tế Phú Quốc', city: 'Phú Quốc', country: 'Việt Nam'),
    Airport(code: 'CXR', name: 'Sân bay Cam Ranh', city: 'Nha Trang', country: 'Việt Nam'),
    Airport(code: 'HPH', name: 'Sân bay Cát Bi', city: 'Hải Phòng', country: 'Việt Nam'),
    Airport(code: 'VCA', name: 'Sân bay Cần Thơ', city: 'Cần Thơ', country: 'Việt Nam'),
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
                    _buildLocationSelector(),
                    const SizedBox(height: 32),
                    _buildQuickFilters(),
                    const SizedBox(height: 24),
                    _buildAdvancedFiltersButton(),
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
          Expanded(child: _buildProgressLine(true)),
          _buildProgressDot(true, '2'),
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
          'Chọn điểm đi và điểm đến',
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 24,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Chọn sân bay khởi hành và sân bay đến cho chuyến bay của bạn',
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

  Widget _buildLocationSelector() {
    return Column(
      children: [
        // From/To section
        Row(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () => _showAirportPicker('Chọn điểm đi', (airport) {
                  setState(() => _searchData = _searchData.copyWith(departure: airport));
                }),
                child: _buildLocationCard(
                  'Từ', 
                  _searchData.departure?.city ?? 'Chọn điểm đi',
                  _searchData.departure?.code ?? '',
                  Icons.flight_takeoff,
                  _searchData.departure != null,
                ),
              ),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    final temp = _searchData.departure;
                    _searchData = _searchData.copyWith(
                      departure: _searchData.arrival,
                      arrival: temp,
                    );
                  });
                },
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primaryBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.primaryBlue.withOpacity(0.3)),
                  ),
                  child: const Icon(
                    Icons.swap_horiz,
                    color: AppColors.primaryBlue,
                    size: 24,
                  ),
                ),
              ),
            ),
            Expanded(
              child: GestureDetector(
                onTap: () => _showAirportPicker('Chọn điểm đến', (airport) {
                  setState(() => _searchData = _searchData.copyWith(arrival: airport));
                }),
                child: _buildLocationCard(
                  'Đến', 
                  _searchData.arrival?.city ?? 'Chọn điểm đến',
                  _searchData.arrival?.code ?? '',
                  Icons.flight_land,
                  _searchData.arrival != null,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildLocationCard(String label, String city, String code, IconData icon, bool isSelected) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isSelected ? AppColors.primaryBlue.withOpacity(0.05) : Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? AppColors.primaryBlue : Colors.grey.shade300,
          width: isSelected ? 2 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.primaryBlue : Colors.grey.shade600,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey.shade700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            city,
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: isSelected ? AppColors.primaryBlue : 
                     (city.contains('Chọn') ? Colors.grey.shade500 : const Color(0xFF1E293B)),
            ),
          ),
          if (code.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(
              code,
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildQuickFilters() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Bộ lọc nhanh',
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 16),
        
        // Max stops filter
        Row(
          children: [
            for (int i = 0; i <= 2; i++) ...[
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _searchData = _searchData.copyWith(maxStops: i);
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: _searchData.maxStops == i 
                          ? AppColors.primaryBlue.withOpacity(0.1)
                          : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: _searchData.maxStops == i 
                            ? AppColors.primaryBlue
                            : Colors.grey.shade300,
                      ),
                    ),
                    child: Text(
                      i == 0 ? 'Bay thẳng' : '$i dừng',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontFamily: 'BalooBhaijaan2',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: _searchData.maxStops == i 
                            ? AppColors.primaryBlue
                            : const Color(0xFF6B7280),
                      ),
                    ),
                  ),
                ),
              ),
              if (i < 2) const SizedBox(width: 8),
            ],
          ],
        ),
        
        const SizedBox(height: 16),
        
        // Sort options
        const Text(
          'Sắp xếp theo',
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 12),
        
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            _buildSortChip('Giá thấp nhất', 'price', 'asc'),
            _buildSortChip('Bay nhanh nhất', 'duration', 'asc'),
            _buildSortChip('Khởi hành sớm', 'departure_time', 'asc'),
          ],
        ),
      ],
    );
  }

  Widget _buildSortChip(String label, String sortBy, String sortOrder) {
    final isSelected = _searchData.sortBy == sortBy && _searchData.sortOrder == sortOrder;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _searchData = _searchData.copyWith(
            sortBy: sortBy,
            sortOrder: sortOrder,
          );
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected 
              ? AppColors.primaryBlue.withOpacity(0.1)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: isSelected 
                ? AppColors.primaryBlue
                : Colors.grey.shade300,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: isSelected 
                ? AppColors.primaryBlue
                : const Color(0xFF6B7280),
          ),
        ),
      ),
    );
  }

  Widget _buildAdvancedFiltersButton() {
    final hasAdvancedFilters = _searchData.minPrice != null || 
                               _searchData.maxPrice != null || 
                               _searchData.departureTimeFilters.isNotEmpty;
    
    return GestureDetector(
      onTap: _showAdvancedFilters,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: hasAdvancedFilters 
              ? AppColors.primaryBlue.withOpacity(0.1)
              : Colors.grey.shade50,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: hasAdvancedFilters 
                ? AppColors.primaryBlue
                : Colors.grey.shade300,
          ),
        ),
        child: Row(
          children: [
            Icon(
              Icons.tune,
              color: hasAdvancedFilters 
                  ? AppColors.primaryBlue
                  : Colors.grey.shade600,
              size: 20,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                hasAdvancedFilters 
                    ? 'Bộ lọc nâng cao (đã áp dụng)'
                    : 'Bộ lọc nâng cao',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: hasAdvancedFilters 
                      ? AppColors.primaryBlue
                      : const Color(0xFF1E293B),
                ),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios,
              color: Colors.grey.shade400,
              size: 16,
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
          onPressed: _searchData.canProceedToStep3 ? _continueToStep3 : null,
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

  void _showAirportPicker(String title, Function(Airport) onSelected) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        height: 500,
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

  void _showAdvancedFilters() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        child: FlightFilters(
          minPrice: _searchData.minPrice,
          maxPrice: _searchData.maxPrice,
          maxStops: _searchData.maxStops,
          sortBy: _searchData.sortBy,
          sortOrder: _searchData.sortOrder,
          departureTimeFilters: _searchData.departureTimeFilters,
          onPriceRangeChanged: (minPrice, maxPrice) {
            setState(() {
              _searchData = _searchData.copyWith(
                minPrice: minPrice,
                maxPrice: maxPrice,
              );
            });
          },
          onMaxStopsChanged: (maxStops) {
            setState(() {
              _searchData = _searchData.copyWith(maxStops: maxStops);
            });
          },
          onSortChanged: (sortBy, sortOrder) {
            setState(() {
              _searchData = _searchData.copyWith(
                sortBy: sortBy,
                sortOrder: sortOrder,
              );
            });
          },
          onDepartureTimeFiltersChanged: (filters) {
            setState(() {
              _searchData = _searchData.copyWith(departureTimeFilters: filters);
            });
          },
        ),
      ),
    );
  }

  void _continueToStep3() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FlightSearchStep3Screen(searchData: _searchData),
      ),
    );
  }
}
