import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cnh_n/models/airport.dart';
import 'package:cnh_n/models/flight.dart';
import 'package:cnh_n/data/sample_data.dart';
import 'package:cnh_n/widgets/flight_card.dart';
import 'package:cnh_n/screens/flight_details_screen.dart';

class SearchResultsScreen extends StatefulWidget {
  final Airport departure;
  final Airport arrival;
  final DateTime departureDate;
  final DateTime? returnDate;
  final int passengers;

  const SearchResultsScreen({
    super.key,
    required this.departure,
    required this.arrival,
    required this.departureDate,
    this.returnDate,
    required this.passengers,
  });

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  List<Flight> _flights = [];
  List<Flight> _filteredFlights = [];
  String _sortBy = 'price';
  double _maxPrice = 5000000;
  Set<String> _selectedAirlines = {};

  @override
  void initState() {
    super.initState();
    _loadFlights();
  }

  void _loadFlights() {
    _flights = SampleData.generateFlights(
      widget.departure,
      widget.arrival,
      widget.departureDate,
    );
    _filteredFlights = List.from(_flights);
    _maxPrice = _flights.map((f) => f.price).reduce((a, b) => a > b ? a : b);
    _applyFilters();
  }

  void _applyFilters() {
    setState(() {
      _filteredFlights = _flights.where((flight) {
        final priceMatch = flight.price <= _maxPrice;
        final airlineMatch = _selectedAirlines.isEmpty ||
            _selectedAirlines.contains(flight.airline);
        return priceMatch && airlineMatch;
      }).toList();

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
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${widget.departure.code} → ${widget.arrival.code}',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
            ),
            Text(
              DateFormat('dd/MM/yyyy').format(widget.departureDate),
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: Theme.of(context)
                        .colorScheme
                        .onPrimaryContainer
                        .withValues(alpha: 0.7),
                  ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: Icon(
              Icons.tune,
              color: Theme.of(context).colorScheme.onPrimaryContainer,
            ),
            onPressed: _showFilterBottomSheet,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildResultsHeader(),
          _buildSortingOptions(),
          Expanded(
            child: _filteredFlights.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    itemCount: _filteredFlights.length,
                    itemBuilder: (context, index) {
                      final flight = _filteredFlights[index];
                      return FlightCard(
                        flight: flight,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => FlightDetailsScreen(
                              flight: flight,
                              passengers: widget.passengers,
                              returnDate: widget.returnDate,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsHeader() {
    return Container(
      padding: const EdgeInsets.all(16),
      color:
          Theme.of(context).colorScheme.primaryContainer.withValues(alpha: 0.3),
      child: Row(
        children: [
          Icon(
            Icons.search,
            color: Theme.of(context).colorScheme.primary,
          ),
          const SizedBox(width: 8),
          Text(
            'Tìm thấy ${_filteredFlights.length} chuyến bay',
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          const Spacer(),
          Text(
            '${widget.passengers} hành khách',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortingOptions() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Text(
            'Sắp xếp:',
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildSortChip('Giá', 'price'),
                  const SizedBox(width: 8),
                  _buildSortChip('Giờ bay', 'departure'),
                  const SizedBox(width: 8),
                  _buildSortChip('Thời gian bay', 'duration'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSortChip(String label, String value) {
    final isSelected = _sortBy == value;
    return ChoiceChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (selected) {
        if (selected) {
          setState(() => _sortBy = value);
          _applyFilters();
        }
      },
      selectedColor: Theme.of(context).colorScheme.primaryContainer,
      labelStyle: TextStyle(
        color: isSelected
            ? Theme.of(context).colorScheme.onPrimaryContainer
            : null,
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 16),
          Text(
            'Không tìm thấy chuyến bay',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            'Thử điều chỉnh bộ lọc tìm kiếm',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
          ),
        ],
      ),
    );
  }

  void _showFilterBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => StatefulBuilder(
        builder: (context, setModalState) => Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Bộ lọc',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextButton(
                    onPressed: () {
                      setModalState(() {
                        _maxPrice = _flights
                            .map((f) => f.price)
                            .reduce((a, b) => a > b ? a : b);
                        _selectedAirlines.clear();
                      });
                    },
                    child: const Text('Đặt lại'),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Giá tối đa: ${NumberFormat('#,###', 'vi').format(_maxPrice)} ₫',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Slider(
                value: _maxPrice,
                min: _flights
                    .map((f) => f.price)
                    .reduce((a, b) => a < b ? a : b),
                max: _flights
                    .map((f) => f.price)
                    .reduce((a, b) => a > b ? a : b),
                divisions: 10,
                onChanged: (value) => setModalState(() => _maxPrice = value),
              ),
              const SizedBox(height: 16),
              Text(
                'Hãng hàng không',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              ...Set.from(_flights.map((f) => f.airline))
                  .map((airline) => CheckboxListTile(
                        title: Text(airline),
                        value: _selectedAirlines.contains(airline),
                        onChanged: (checked) {
                          setModalState(() {
                            if (checked == true) {
                              _selectedAirlines.add(airline);
                            } else {
                              _selectedAirlines.remove(airline);
                            }
                          });
                        },
                      ))
                  .toList(),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    _applyFilters();
                    Navigator.pop(context);
                  },
                  child: const Text('Áp dụng bộ lọc'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
