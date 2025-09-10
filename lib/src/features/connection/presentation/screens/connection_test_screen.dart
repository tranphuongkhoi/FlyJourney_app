import 'package:flutter/material.dart';
import 'package:fly_journey/src/features/search/data/flight_repository.dart';
import 'package:fly_journey/src/core/config/api_config.dart';

class ConnectionTestScreen extends StatefulWidget {
  const ConnectionTestScreen({super.key});

  @override
  State<ConnectionTestScreen> createState() => _ConnectionTestScreenState();
}

class _ConnectionTestScreenState extends State<ConnectionTestScreen> {
  String _status = 'Chưa kiểm tra';
  Color _statusColor = Colors.grey;
  bool _isLoading = false;
  String _details = '';

  Future<void> _testConnection() async {
    setState(() {
      _isLoading = true;
      _status = 'Đang kiểm tra...';
      _statusColor = Colors.orange;
      _details = '';
    });

    try {
      final result = await FlightRepository.testConnection();
      
      setState(() {
        _isLoading = false;
        if (result['success']) {
          _status = 'Kết nối thành công!';
          _statusColor = Colors.green;
          _details = 'Backend đã sẵn sàng nhận requests';
        } else {
          _status = 'Kết nối thất bại';
          _statusColor = Colors.red;
          _details = result['message'] ?? 'Lỗi không xác định';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _status = 'Lỗi kết nối';
        _statusColor = Colors.red;
        _details = e.toString();
      });
    }
  }

  Future<void> _testFlightSearch() async {
    setState(() {
      _isLoading = true;
      _status = 'Đang test tìm kiếm chuyến bay...';
      _statusColor = Colors.orange;
      _details = '';
    });

    try {
      final result = await FlightRepository.searchFlights({
        'departure_airport_code': 'HAN',
        'arrival_airport_code': 'SGN',
        'departure_date': '01/08/2025',
        'passengers': {'adults': 1, 'children': 0, 'infants': 0},
      });
      
      setState(() {
        _isLoading = false;
        if (result['success']) {
          _status = 'API hoạt động tốt!';
          _statusColor = Colors.green;
          final data = result['data'];
          _details = 'Tìm thấy ${data['total_count']} chuyến bay\nEndpoint: ${data['departure_airport']} → ${data['arrival_airport']}';
        } else {
          _status = 'API lỗi';
          _statusColor = Colors.red;
          _details = '${result['error']}: ${result['message']}';
        }
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _status = 'Lỗi API';
        _statusColor = Colors.red;
        _details = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Test Kết Nối Backend'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thông tin Backend',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Text('URL: ${ApiConfig.baseUrl}'),
                    Text('Mock Data: ${ApiConfig.useMockData ? "Bật" : "Tắt"}'),
                    Text('Timeout: ${ApiConfig.requestTimeout.inSeconds}s'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Trạng thái kết nối',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: _statusColor,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _status,
                          style: TextStyle(
                            color: _statusColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (_isLoading) ...[
                          const SizedBox(width: 8),
                          const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ],
                      ],
                    ),
                    if (_details.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text(
                        _details,
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _testConnection,
              icon: const Icon(Icons.wifi_tethering),
              label: const Text('Test Kết Nối Cơ Bản'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _isLoading ? null : _testFlightSearch,
              icon: const Icon(Icons.flight_takeoff),
              label: const Text('Test API Tìm Chuyến Bay'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.all(16),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              color: Colors.amber[50],
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.info, color: Colors.amber[700]),
                        const SizedBox(width: 8),
                        Text(
                          'Hướng dẫn',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.amber[700],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '1. Đảm bảo backend đang chạy tại localhost:3000\n'
                      '2. Kiểm tra firewall không chặn port 3000\n'
                      '3. Nếu dùng simulator, đảm bảo localhost có thể truy cập\n'
                      '4. Kiểm tra logs trong Debug Console để xem chi tiết',
                      style: TextStyle(fontSize: 12),
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
}
