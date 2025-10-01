class ApiConfig {
  // API Configuration
  static const String baseUrl = 'http://localhost:3000/api/v1';

  //Auth nhma để từ từ tính
  //static const String apiKey = 'YOUR_API_KEY';
  //static const String bearerToken = 'YOUR_BEARER_TOKEN';

  // Endpoints
  static const String searchFlights = '/flights/search';
  static const String searchRoundtripFlights = '/flights/search/roundtrip';
  static const String flightDetails = '/flights/{id}';
  static const String bookFlight = '/flights/book';

  // Check-in endpoints
  static const String checkinValidate = '/checkin/validate';
  static const String checkinSeatMap = '/checkin/{flightId}';
  static const String checkinConfirm = '/checkin/{pnrCode}/confirm';
  static const String checkinDevSampleFlightId = '318';
  // Booking endpoints (aligned with api-contract.md)
  static const String bookingRoot = '/booking';
  static const String bookingById = '/booking/{id}';
  static const String bookingByUser = '/booking/user/{userId}';

  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String confirmRegister = '/auth/confirm-register';
  static const String logout = '/auth/logout';
  static const String profile = '/auth/profile';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';

  // Payment endpoints
  static const String paymentMomo = '/payment/momo';

  // Support endpoints
  static const String supportSession = '/support/session';
  static const String supportMessage = '/support/message';
  static const String supportAvailability = '/support/availability';

  // Request timeout
  static const Duration requestTimeout = Duration(seconds: 30);

  // Mock mode for development
  static const bool useMockData = false; // Set to false when using real API

  // Development Mode Settings
  static const bool isDevMode = false; // Enable dev shortcuts and presets

  // Available data dates for development testing
  static const Map<String, List<String>> devDataDates = {
    'august_early': [
      '01/08/2025',
      '04/08/2025'
    ], // Original test data (10+4 flights)
    'august_27_only': [
      '27/08/2025',
      '27/08/2025'
    ], // User's main data (30 flights one-way)
    'august_mixed': [
      '27/08/2025',
      '01/08/2025'
    ], // Mix: rich outbound + inbound data
    'august_rich_roundtrip': [
      '27/08/2025',
      '27/08/2025'
    ], // Same date roundtrip (30+12 flights)
  };

  // Current dev preset (change this to switch data sets)
  static const String currentDevPreset =
      'august_rich_roundtrip'; // Using user's rich data

  // Data availability info for developers
  static const Map<String, String> devDataInfo = {
    'august_early': '10 outbound + 4 inbound flights (original)',
    'august_27_only': '30 flights for 27/08/2025 (one-way rich)',
    'august_mixed': '30 outbound (27/08) + 10 inbound (01/08)',
    'august_rich_roundtrip': '30 outbound + 12 inbound on 27/08/2025',
  };

  // Get dev dates for current preset
  static List<String> get currentDevDates =>
      devDataDates[currentDevPreset] ?? devDataDates['august_rich_roundtrip']!;

  // Get current preset info for debugging
  static String get currentDevInfo =>
      devDataInfo[currentDevPreset] ?? 'Unknown preset';

  // Headers - Simple headers without authentication
  static Map<String, String> get headers => {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
}
