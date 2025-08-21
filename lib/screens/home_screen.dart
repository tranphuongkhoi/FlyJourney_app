import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cnh_n/data/sample_data.dart';
import 'package:cnh_n/models/airport.dart';
import 'package:cnh_n/screens/search_results_screen.dart';
import 'package:cnh_n/screens/my_bookings_screen.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Airport? _departure;
  Airport? _arrival;
  DateTime _departureDate = DateTime.now().add(const Duration(days: 1));
  DateTime? _returnDate;
  bool _isRoundTrip = false;
  int _passengers = 1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            floating: false,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(
                'Đặt vé máy bay',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.primaryContainer,
                    ],
                  ),
                ),
                child: Stack(
                  children: [
                    Positioned(
                      right: -50,
                      top: 50,
                      child: Icon(
                        Icons.flight_takeoff,
                        size: 120,
                        color: Colors.white.withValues(alpha: 0.2),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.bookmark_border, color: Colors.white),
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const MyBookingsScreen()),
                ),
              ),
            ],
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  _buildSearchCard(),
                  const SizedBox(height: 24),
                  _buildPopularDestinations(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.search,
                    color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 8),
                Text(
                  'Tìm chuyến bay',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Một chiều'),
                    selected: !_isRoundTrip,
                    onSelected: (selected) =>
                        setState(() => _isRoundTrip = false),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ChoiceChip(
                    label: const Text('Khứ hồi'),
                    selected: _isRoundTrip,
                    onSelected: (selected) =>
                        setState(() => _isRoundTrip = true),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _buildAirportSelector('Điểm đi', _departure, Icons.flight_takeoff,
                (airport) {
              setState(() => _departure = airport);
            }),
            const SizedBox(height: 12),
            _buildAirportSelector('Điểm đến', _arrival, Icons.flight_land,
                (airport) {
              setState(() => _arrival = airport);
            }),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildDateSelector(
                    'Ngày đi',
                    _departureDate,
                    (date) => setState(() => _departureDate = date),
                  ),
                ),
                if (_isRoundTrip) ...[
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildDateSelector(
                      'Ngày về',
                      _returnDate ??
                          _departureDate.add(const Duration(days: 1)),
                      (date) => setState(() => _returnDate = date),
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            _buildPassengerSelector(),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _canSearch() ? _search : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.search,
                        color: Theme.of(context).colorScheme.onPrimary),
                    const SizedBox(width: 8),
                    Text(
                      'Tìm chuyến bay',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context).colorScheme.onPrimary,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAirportSelector(String label, Airport? selected, IconData icon,
      Function(Airport) onSelected) {
    return InkWell(
      onTap: () => _showAirportPicker(label, onSelected),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Icon(icon, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                  ),
                  Text(
                    selected?.city ?? 'Chọn sân bay',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w500,
                        ),
                  ),
                  if (selected != null)
                    Text(
                      selected!.code,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                ],
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector(
      String label, DateTime date, Function(DateTime) onSelected) {
    return InkWell(
      onTap: () => _showDatePicker(onSelected),
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey.shade300),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              DateFormat('dd/MM/yyyy').format(date),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            Text(
              DateFormat('EEEE', 'vi').format(date),
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPassengerSelector() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(Icons.person, color: Theme.of(context).colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Số hành khách',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
                Text(
                  '$_passengers người',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              IconButton(
                onPressed: _passengers > 1
                    ? () => setState(() => _passengers--)
                    : null,
                icon: const Icon(Icons.remove_circle_outline),
              ),
              Text('$_passengers'),
              IconButton(
                onPressed: _passengers < 9
                    ? () => setState(() => _passengers++)
                    : null,
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPopularDestinations() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Điểm đến phổ biến',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
        ),
        const SizedBox(height: 12),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 2.5,
          children: [
            _buildDestinationCard('Hà Nội', 'HAN', Icons.location_city),
            _buildDestinationCard('TP.HCM', 'SGN', Icons.business),
            _buildDestinationCard('Đà Nẵng', 'DAD', Icons.beach_access),
            _buildDestinationCard('Phú Quốc', 'PQC', Icons.water),
          ],
        ),
      ],
    );
  }

  Widget _buildDestinationCard(String city, String code, IconData icon) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () {
          final airport = SampleData.airports.firstWhere((a) => a.code == code);
          if (_departure == null) {
            setState(() => _departure = airport);
          } else if (_arrival == null && _departure!.code != code) {
            setState(() => _arrival = airport);
          }
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Icon(icon, color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      city,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    Text(
                      code,
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                    ),
                  ],
                ),
              ),
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 16),
            ...SampleData.airports
                .map((airport) => ListTile(
                      leading: Icon(Icons.flight,
                          color: Theme.of(context).colorScheme.primary),
                      title: Text(airport.city),
                      subtitle: Text('${airport.name} (${airport.code})'),
                      onTap: () {
                        onSelected(airport);
                        Navigator.pop(context);
                      },
                    ))
                .toList(),
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

  bool _canSearch() =>
      _departure != null && _arrival != null && _departure != _arrival;

  void _search() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsScreen(
          departure: _departure!,
          arrival: _arrival!,
          departureDate: _departureDate,
          returnDate: _isRoundTrip ? _returnDate : null,
          passengers: _passengers,
        ),
      ),
    );
  }
}
