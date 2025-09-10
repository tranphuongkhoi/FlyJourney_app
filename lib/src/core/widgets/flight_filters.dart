import 'package:flutter/material.dart';
import 'package:cnh_n/src/core/constants/colors.dart';

class FlightFilters extends StatefulWidget {
  final double? minPrice;
  final double? maxPrice;
  final int maxStops;
  final String sortBy;
  final String sortOrder;
  final List<String> departureTimeFilters;
  final Function(double? minPrice, double? maxPrice) onPriceRangeChanged;
  final Function(int maxStops) onMaxStopsChanged;
  final Function(String sortBy, String sortOrder) onSortChanged;
  final Function(List<String> filters) onDepartureTimeFiltersChanged;

  const FlightFilters({
    super.key,
    this.minPrice,
    this.maxPrice,
    required this.maxStops,
    required this.sortBy,
    required this.sortOrder,
    required this.departureTimeFilters,
    required this.onPriceRangeChanged,
    required this.onMaxStopsChanged,
    required this.onSortChanged,
    required this.onDepartureTimeFiltersChanged,
  });

  @override
  State<FlightFilters> createState() => _FlightFiltersState();
}

class _FlightFiltersState extends State<FlightFilters> {
  late RangeValues _priceRange;
  late int _maxStops;
  late String _sortBy;
  late String _sortOrder;
  late List<String> _departureTimeFilters;

  final double _minPriceLimit = 500000; // 500k VND
  final double _maxPriceLimit = 10000000; // 10M VND

  @override
  void initState() {
    super.initState();
    _priceRange = RangeValues(
      widget.minPrice ?? _minPriceLimit,
      widget.maxPrice ?? _maxPriceLimit,
    );
    _maxStops = widget.maxStops;
    _sortBy = widget.sortBy;
    _sortOrder = widget.sortOrder;
    _departureTimeFilters = List.from(widget.departureTimeFilters);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Bộ lọc tìm kiếm',
                  style: TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Price Range Filter
            _buildSectionTitle('Khoảng giá'),
            const SizedBox(height: 12),
            _buildPriceRangeFilter(),
            const SizedBox(height: 24),

            // Max Stops Filter
            _buildSectionTitle('Số điểm dừng tối đa'),
            const SizedBox(height: 12),
            _buildMaxStopsFilter(),
            const SizedBox(height: 24),

            // Departure Time Filter
            _buildSectionTitle('Thời gian khởi hành'),
            const SizedBox(height: 12),
            _buildDepartureTimeFilter(),
            const SizedBox(height: 24),

            // Sort Options
            _buildSectionTitle('Sắp xếp theo'),
            const SizedBox(height: 12),
            _buildSortOptions(),
            const SizedBox(height: 32),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _resetFilters,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primaryBlue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Đặt lại',
                      style: TextStyle(
                        fontFamily: 'BalooBhaijaan2',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryBlue,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _applyFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Text(
                      'Áp dụng',
                      style: TextStyle(
                        fontFamily: 'BalooBhaijaan2',
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontFamily: 'BalooBhaijaan2',
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: Color(0xFF374151),
      ),
    );
  }

  Widget _buildPriceRangeFilter() {
    return Column(
      children: [
        RangeSlider(
          values: _priceRange,
          min: _minPriceLimit,
          max: _maxPriceLimit,
          divisions: 50,
          activeColor: AppColors.primaryBlue,
          onChanged: (values) {
            setState(() {
              _priceRange = values;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '${(_priceRange.start / 1000).toStringAsFixed(0)}k ₫',
              style: const TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
            Text(
              '${(_priceRange.end / 1000).toStringAsFixed(0)}k ₫',
              style: const TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 12,
                color: Color(0xFF6B7280),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMaxStopsFilter() {
    return Row(
      children: [
        for (int i = 0; i <= 3; i++) ...[
          Expanded(
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _maxStops = i;
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 12),
                decoration: BoxDecoration(
                  color: _maxStops == i 
                      ? AppColors.primaryBlue.withOpacity(0.1)
                      : Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: _maxStops == i 
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
                    color: _maxStops == i 
                        ? AppColors.primaryBlue
                        : const Color(0xFF6B7280),
                  ),
                ),
              ),
            ),
          ),
          if (i < 3) const SizedBox(width: 8),
        ],
      ],
    );
  }

  Widget _buildDepartureTimeFilter() {
    final timeSlots = [
      {'key': 'morning', 'label': 'Sáng', 'time': '06:00-12:00'},
      {'key': 'afternoon', 'label': 'Chiều', 'time': '12:00-18:00'},
      {'key': 'evening', 'label': 'Tối', 'time': '18:00-24:00'},
      {'key': 'night', 'label': 'Đêm', 'time': '00:00-06:00'},
    ];

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: timeSlots.map((slot) {
        final isSelected = _departureTimeFilters.contains(slot['key']);
        return GestureDetector(
          onTap: () {
            setState(() {
              if (isSelected) {
                _departureTimeFilters.remove(slot['key']);
              } else {
                _departureTimeFilters.add(slot['key']!);
              }
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
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  slot['label']!,
                  style: TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: isSelected 
                        ? AppColors.primaryBlue
                        : const Color(0xFF374151),
                  ),
                ),
                Text(
                  slot['time']!,
                  style: TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 10,
                    color: isSelected 
                        ? AppColors.primaryBlue
                        : const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSortOptions() {
    final sortOptions = [
      {'key': 'price_asc', 'label': 'Giá thấp nhất', 'sortBy': 'price', 'sortOrder': 'asc'},
      {'key': 'price_desc', 'label': 'Giá cao nhất', 'sortBy': 'price', 'sortOrder': 'desc'},
      {'key': 'departure_asc', 'label': 'Khởi hành sớm', 'sortBy': 'departure_time', 'sortOrder': 'asc'},
      {'key': 'duration_asc', 'label': 'Bay nhanh nhất', 'sortBy': 'duration', 'sortOrder': 'asc'},
    ];

    return Column(
      children: sortOptions.map((option) {
        final isSelected = _sortBy == option['sortBy'] && _sortOrder == option['sortOrder'];
        return GestureDetector(
          onTap: () {
            setState(() {
              _sortBy = option['sortBy']!;
              _sortOrder = option['sortOrder']!;
            });
          },
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isSelected 
                  ? AppColors.primaryBlue.withOpacity(0.1)
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: isSelected 
                    ? AppColors.primaryBlue
                    : Colors.grey.shade300,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                  color: isSelected ? AppColors.primaryBlue : const Color(0xFF6B7280),
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  option['label']!,
                  style: TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected 
                        ? AppColors.primaryBlue
                        : const Color(0xFF374151),
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  void _resetFilters() {
    setState(() {
      _priceRange = RangeValues(_minPriceLimit, _maxPriceLimit);
      _maxStops = 2;
      _sortBy = 'price';
      _sortOrder = 'asc';
      _departureTimeFilters.clear();
    });
  }

  void _applyFilters() {
    widget.onPriceRangeChanged(_priceRange.start, _priceRange.end);
    widget.onMaxStopsChanged(_maxStops);
    widget.onSortChanged(_sortBy, _sortOrder);
    widget.onDepartureTimeFiltersChanged(_departureTimeFilters);
    Navigator.pop(context);
  }
}
