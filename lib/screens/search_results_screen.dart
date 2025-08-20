import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cnh_n/models/airport.dart';
import 'package:cnh_n/models/flight.dart';
import 'package:cnh_n/data/sample_data.dart';
import 'package:cnh_n/widgets/flight_card.dart';
import 'package:cnh_n/screens/flight_details_screen.dart';
import 'package:cnh_n/utils/format.dart';

enum SortBy { cheapest, earliest, shortest }

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
    this.passengers = 1,
  });

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late List<Flight> _flights;
  late List<Flight> _filtered;
  double _maxPrice = 0;
  double _price = 0;
  SortBy _sort = SortBy.cheapest;
  String? _airline;

  @override
  void initState() {
    super.initState();
    _flights = SampleData.generateFlights(widget.departure, widget.arrival, widget.departureDate);
    _filtered = List.of(_flights);
    _maxPrice = _flights.map((e) => e.price).fold<double>(0, (p, e) => e > p ? e : p);
    _price = _maxPrice;
    _apply();
  }

  void _apply() {
    List<Flight> data = _flights.where((f) => f.price <= _price).toList();
    if (_airline != null) {
      data = data.where((f) => f.airline == _airline).toList();
    }
    data.sort((a, b) {
      switch (_sort) {
        case SortBy.cheapest:
          return a.price.compareTo(b.price);
        case SortBy.earliest:
          return a.departureTime.compareTo(b.departureTime);
        case SortBy.shortest:
          final da = a.arrivalTime.difference(a.departureTime);
          final db = b.arrivalTime.difference(b.departureTime);
          return da.compareTo(db);
      }
    });
    setState(() => _filtered = data);
  }

  @override
  Widget build(BuildContext context) {
    final t = Theme.of(context);
    final airlines = _flights.map((f) => f.airline).toSet().toList()..sort();

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.departure.code} → ${widget.arrival.code}'),
      ),
      body: Column(
        children: [
          _filters(t, airlines),
          const Divider(),
          Expanded(
            child: _filtered.isEmpty
                ? Center(child: Text('Không tìm thấy chuyến bay phù hợp', style: t.textTheme.bodyLarge))
                : ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                    itemBuilder: (c, i) => FlightCard(
                      flight: _filtered[i],
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => FlightDetailsScreen(
                              flight: _filtered[i],
                              passengers: widget.passengers,
                              returnDate: widget.returnDate,
                            ),
                          ),
                        );
                      },
                    ),
                    separatorBuilder: (_, __) => const SizedBox(height: 14),
                    itemCount: _filtered.length,
                  ),
          ),
        ],
      ),
    );
  }

  Widget _filters(ThemeData t, List<String> airlines) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Giá tối đa', style: t.textTheme.labelLarge),
                    Slider(
                      value: _price,
                      min: 0,
                      max: _maxPrice,
                      onChanged: (v) => setState(() => _price = v),
                      onChangeEnd: (_) => _apply(),
                    ),
                    Text(formatVND(_price), style: t.textTheme.titleMedium),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Sắp xếp', style: t.textTheme.labelLarge),
                    const SizedBox(height: 8),
                    DropdownButtonFormField<SortBy>(
                      value: _sort,
                      items: const [
                        DropdownMenuItem(value: SortBy.cheapest, child: Text('Rẻ nhất')),
                        DropdownMenuItem(value: SortBy.earliest, child: Text('Sớm nhất')),
                        DropdownMenuItem(value: SortBy.shortest, child: Text('Ngắn nhất')),
                      ],
                      onChanged: (v) { if (v != null) { setState(() => _sort = v); _apply(); } },
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('Tất cả hãng'),
                  selected: _airline == null,
                  onSelected: (_) { setState(() => _airline = null); _apply(); },
                ),
                const SizedBox(width: 8),
                ...airlines.map((a) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: ChoiceChip(
                    label: Text(a),
                    selected: _airline == a,
                    onSelected: (_) { setState(() => _airline = a); _apply(); },
                  ),
                )),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
