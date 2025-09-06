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
  static const String getBookings = '/bookings';
  
  // Auth endpoints
  static const String login = '/auth/login';
  static const String register = '/auth/register';
  static const String confirmRegister = '/auth/confirm-register';
  static const String logout = '/auth/logout';
  static const String profile = '/auth/profile';
  static const String refreshToken = '/auth/refresh';
  static const String forgotPassword = '/auth/forgot-password';
  static const String resetPassword = '/auth/reset-password';
  
  // Request timeout
  static const Duration requestTimeout = Duration(seconds: 30);
  
  // Mock mode for development
  static const bool useMockData = false; // Set to false when using real API
  
  // Headers - Simple headers without authentication
  static Map<String, String> get headers => {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
  
  // API Response Structure Expected
  /*
  Search Flights Response:
  {
    "data": {
      "arrival_airport": "string",
      "arrival_date": "string",
      "departure_airport": "string", 
      "departure_date": "string",
      "flight_class": "string",
      "limit": number,
      "page": number,
      "passengers": {
        "adults": number,
        "children": number,
        "infants": number
      },
      "search_results": [
        {
          "flight_id": number,
          "flight_class_id": number,
          "flight_number": "string",
          "airline_id": number,
          "airline_name": "string",
          "logo_url": "string",
          "departure_airport_code": "string",
          "arrival_airport_code": "string",
          "departure_airport": "string",
          "arrival_airport": "string",
          "departure_time": "ISO string",
          "arrival_time": "ISO string",
          "duration_minutes": number,
          "stops_count": number,
          "distance": number,
          "flight_class": "string",
          "total_seats": number,
          "fare_class_details": {
            "fare_class_code": "string",
            "cabin_class": "string",
            "refundable": boolean,
            "changeable": boolean,
            "baggage_kg": "string",
            "description": "string",
            "refund_change_policy": "string"
          },
          "pricing": {
            "base_prices": {
              "adult": number,
              "child": number,
              "infant": number
            },
            "total_prices": {
              "adult": number,
              "child": number,
              "infant": number
            },
            "taxes": {
              "adult": number
            },
            "grand_total": number,
            "currency": "string"
          },
          "tax_and_fees": number
        }
      ],
      "sort_by": "string",
      "sort_order": "string", 
      "total_count": number,
      "total_pages": number
    },
    "status": boolean,
    "errorCode": "string",
    "errorMessage": "string"
  }
  
  Error Response:
  {
    "status": false,
    "errorCode": "string",
    "errorMessage": "string"
  }
  */
}
