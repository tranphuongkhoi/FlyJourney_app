import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import 'package:fly_journey/src/core/config/api_config.dart';
import 'package:fly_journey/src/features/auth/data/services/auth_service.dart';
import 'package:fly_journey/src/features/booking/domain/models/booking.dart';
import 'package:fly_journey/src/features/booking/domain/models/passenger.dart';
import 'package:fly_journey/src/features/booking/domain/models/passenger_models.dart';
import 'package:fly_journey/src/features/search/domain/models/flight.dart';
import 'package:fly_journey/src/core/constants/baggage_options.dart';
import 'package:fly_journey/src/core/constants/services_mapping.dart';
import 'package:intl/intl.dart';

class BookingApiException implements Exception {
  final String message;
  final int? statusCode;
  const BookingApiException(this.message, {this.statusCode});
  @override
  String toString() =>
      'BookingApiException: $message${statusCode != null ? ' (HTTP ${statusCode.toString()})' : ''}';
}

class BookingRepository {
  static final http.Client _client = http.Client();
  static final AuthService _auth = AuthService();

  // Fetch bookings for current logged-in user
  static Future<List<Booking>> fetchMyBookings() async {
    if (!_auth.isLoggedIn || _auth.currentUser == null) {
      throw const BookingApiException('Bạn cần đăng nhập để xem vé đã đặt');
    }

    final userId = _auth.currentUser!.id;
    final path = ApiConfig.bookingByUser.replaceAll('{userId}', userId);
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');

    try {
      final response = await _client
          .get(uri, headers: _auth.getAuthHeaders())
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode != 200) {
        throw BookingApiException('Yêu cầu thất bại', statusCode: response.statusCode);
      }

      final Map<String, dynamic> body = json.decode(response.body) as Map<String, dynamic>;

      // Expect common API envelope: { status, data, errorCode, errorMessage }
      if (body['status'] != true) {
        throw BookingApiException(body['errorMessage'] ?? 'Lỗi API');
      }

      final dynamic data = body['data'];

      // Accept either a list directly or wrapped in a field like 'bookings'
      final List<dynamic> rawList = (data is List)
          ? data
          : (data is Map<String, dynamic> && data['bookings'] is List)
              ? data['bookings'] as List
              : <dynamic>[];

      return rawList
          .whereType<Map<String, dynamic>>()
          .map(_bookingFromApi)
          .toList();
    } catch (e) {
      debugPrint('fetchMyBookings error: $e');
      if (e is BookingApiException) rethrow;
      throw BookingApiException(e.toString());
    }
  }

  // Create a booking (Step 3 submit)
  static Future<Map<String, dynamic>?> createBooking({
    required Flight outboundFlight,
    Flight? returnFlight,
    required List<PassengerInfo> passengers,
    required ContactInfo contact,
    required List<String> baggageSelections, // per passenger baggage id
    required List<String> selectedServices,  // service ids applied to all passengers
    required double totalAmount,
  }) async {
    if (!_auth.isLoggedIn || _auth.currentUser == null) {
      throw const BookingApiException('Bạn cần đăng nhập để đặt vé');
    }

    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.bookingRoot}');

    // Build ancillaries array matching API template (smt.md)
    final List<Map<String, dynamic>> ancillaries = [];
    for (int i = 0; i < baggageSelections.length; i++) {
      final opt = BaggageOptions.byId(baggageSelections[i]);
      if (opt.price > 0) {
        final p = passengers[i];
        final fullName = '${p.lastName}, ${p.firstName}';
        ancillaries.add({
          'type': 'baggage',
          'description': ' Hành lý ký gửi thêm ${opt.extraKg}kg - Hành khách ${i + 1}: $fullName',
          'quantity': opt.extraKg,
          'price': opt.price,
        });
      }
    }
    for (final id in selectedServices) {
      final s = ServiceMapping.byId(id);
      // Ensure description matches API expectation style: 'Dịch vụ ... - N hành khách'
      final String descPrefix = s.label.startsWith('Dịch vụ') ? s.label : 'Dịch vụ ${s.label.toLowerCase()}';
      ancillaries.add({
        'type': 'service',
        'description': '$descPrefix - ${passengers.length} hành khách',
        'quantity': passengers.length,
        'price': s.price,
      });
    }

    String _fmtDmy(DateTime? d) {
      if (d == null) return '';
      return DateFormat('dd/MM/yyyy').format(d);
    }

    String _mapGender(String g) {
      final s = g.toLowerCase();
      if (s.startsWith('nữ') || s.contains('female')) return 'female';
      return 'male';
    }

    String _mapIdType(String t) {
      final s = t.toLowerCase();
      if (s.contains('hộ chiếu') || s.contains('passport')) return 'passport';
      return 'id_card';
    }

    String _mapCountry(String nat) {
      final s = nat.toLowerCase();
      if (s.contains('vi') || s.contains('viet')) return 'VN';
      return 'VN';
    }

    int _calcAge(DateTime? dob) {
      if (dob == null) return 25;
      final now = DateTime.now();
      int age = now.year - dob.year;
      if (now.month < dob.month || (now.month == dob.month && now.day < dob.day)) {
        age--;
      }
      return age;
    }

    // Per passenger price (base only), distribute evenly
    final baseTotal = (outboundFlight.price + (returnFlight?.price ?? 0)) * passengers.length;
    final perPaxPrice = (baseTotal / (passengers.isEmpty ? 1 : passengers.length)).round();

    final details = passengers.asMap().entries.map((entry) {
      final i = entry.key;
      final p = entry.value;
      final map = <String, dynamic>{
        'passenger_age': _calcAge(p.dateOfBirth),
        'passenger_gender': _mapGender(p.gender),
        'flight_class_id': outboundFlight.flightClassId ?? 0,
        'price': perPaxPrice,
        'last_name': p.lastName,
        'first_name': p.firstName,
        'date_of_birth': _fmtDmy(p.dateOfBirth),
        'id_type': _mapIdType(p.documentType),
        'id_number': p.documentNumber,
        'issuing_country': _mapCountry(p.nationality),
        'nationality': _mapCountry(p.nationality),
      };
      // API requires ExpiryDate for all details. If missing, synthesize a future date.
      final DateTime expiry = p.documentExpiry ?? DateTime.now().add(const Duration(days: 365 * 5));
      map['expiry_date'] = _fmtDmy(expiry);
      return map;
    }).toList();

    final contactName = passengers.isNotEmpty ? '${passengers.first.lastName} ${passengers.first.firstName}' : '';
    final contactPhone = passengers.isNotEmpty ? passengers.first.phoneNumber : '';

    final body = {
      'flight_id': outboundFlight.flightId,
      'contact_name': contactName,
      'contact_email': contact.email,
      'contact_phone': contactPhone,
      'contact_address': contact.address,
      'note': '',
      'total_price': totalAmount.round(),
      'details': details,
      'ancillaries': ancillaries,
    };

    try {
      final response = await _client
          .post(
            uri,
            headers: _auth.getAuthHeaders(),
            body: json.encode(body),
          )
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode != 200 && response.statusCode != 201) {
        throw BookingApiException('Yêu cầu thất bại', statusCode: response.statusCode);
      }

      final Map<String, dynamic> resp = json.decode(response.body) as Map<String, dynamic>;
      if (resp['status'] == true && resp['data'] is Map<String, dynamic>) {
        return resp['data'] as Map<String, dynamic>;
      }
      // Some APIs return booking object directly
      if (resp['booking_id'] != null || resp['bookingId'] != null) {
        return resp;
      }
      return null;
    } catch (e) {
      if (e is BookingApiException) rethrow;
      throw BookingApiException(e.toString());
    }
  }

  // Optional: fetch a single booking by id (not used yet by UI)
  static Future<Booking> fetchBookingById(String bookingId) async {
    final path = ApiConfig.bookingById.replaceAll('{id}', bookingId);
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');

    try {
      final response = await _client
          .get(uri, headers: _auth.getAuthHeaders())
          .timeout(ApiConfig.requestTimeout);

      if (response.statusCode != 200) {
        throw BookingApiException('Yêu cầu thất bại', statusCode: response.statusCode);
      }

      final Map<String, dynamic> body = json.decode(response.body) as Map<String, dynamic>;
      if (body['status'] != true) {
        throw BookingApiException(body['errorMessage'] ?? 'Lỗi API');
      }

      final Map<String, dynamic> data = (body['data'] as Map<String, dynamic>? ?? {});
      return _bookingFromApi(data);
    } catch (e) {
      if (e is BookingApiException) rethrow;
      throw BookingApiException(e.toString());
    }
  }

  // Raw getter for detail screen when needing extra fields (payment, ancillaries)
  static Future<Map<String, dynamic>> fetchBookingByIdRaw(String bookingId) async {
    final path = ApiConfig.bookingById.replaceAll('{id}', bookingId);
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    try {
      final response = await _client
          .get(uri, headers: _auth.getAuthHeaders())
          .timeout(ApiConfig.requestTimeout);
      if (response.statusCode != 200) {
        throw BookingApiException('Yêu cầu thất bại', statusCode: response.statusCode);
      }
      final Map<String, dynamic> body = json.decode(response.body) as Map<String, dynamic>;
      if (body['status'] != true) {
        throw BookingApiException(body['errorMessage'] ?? 'Lỗi API');
      }
      // Expect body['data'] to be booking object
      final data = body['data'];
      if (data is Map<String, dynamic>) return data;
      throw const BookingApiException('Định dạng dữ liệu không hợp lệ');
    } catch (e) {
      if (e is BookingApiException) rethrow;
      throw BookingApiException(e.toString());
    }
  }

  // Map API booking object -> domain Booking
  static Booking _bookingFromApi(Map<String, dynamic> json) {
    // booking id (stringify to be safe)
    final String id = (json['booking_id'] ?? json['bookingId'] ?? '').toString();

    // status mapping (api may return e.g. confirmed/cancelled/completed or other)
    final String rawStatus = (json['status'] ?? 'confirmed').toString().toLowerCase();
    final BookingStatus status = rawStatus.contains('pending')
        ? BookingStatus.pendingPayment
        : rawStatus.contains('cancel')
            ? BookingStatus.cancelled
            : rawStatus.contains('complete')
                ? BookingStatus.completed
                : BookingStatus.confirmed;

    // contact info
    final String contactEmail = (json['contact_email'] ?? json['contactEmail'] ?? '').toString();
    final String contactPhone = (json['contact_phone'] ?? json['contactPhone'] ?? '').toString();

    // price
    final double totalPrice = _toDouble(json['total_price'] ?? json['totalPrice'] ?? 0);

    // booking date (prefer explicit field, fallback to created_at)
    final String? bookingDateStr = (json['booking_date'] ?? json['bookingDate'] ?? json['created_at'])?.toString();
    final DateTime bookingDate = _parseDateTime(bookingDateStr) ?? DateTime.now();

    // flight info: accept nested 'flight' or flat snake_case keys understood by Flight.fromJson
    final Map<String, dynamic> flightJson = json['flight'] is Map<String, dynamic>
        ? (json['flight'] as Map<String, dynamic>)
        : json;
    final Flight flight = Flight.fromJson(flightJson);

    // return flight (optional)
    Flight? returnFlight;
    if (json['return_flight'] is Map<String, dynamic>) {
      returnFlight = Flight.fromJson(json['return_flight'] as Map<String, dynamic>);
    } else if (json['returnFlight'] is Map<String, dynamic>) {
      returnFlight = Flight.fromJson(json['returnFlight'] as Map<String, dynamic>);
    }

    // passengers: some APIs use 'details' as passenger items
    final List<dynamic> passengerList =
        (json['passengers'] as List?) ?? (json['details'] as List?) ?? const [];

    // Determine roundtrip by presence of return_flight_id or any detail.return_flight_class_id
    bool roundTripHint = false;
    if (json['return_flight_id'] != null) {
      roundTripHint = true;
    } else {
      for (final d in passengerList) {
        if (d is Map<String, dynamic> && d['return_flight_class_id'] != null) {
          roundTripHint = true;
          break;
        }
      }
    }

    final List<Passenger> passengers = passengerList
        .whereType<Map<String, dynamic>>()
        .map((p) {
          final String firstName = (p['first_name'] ?? p['firstName'] ?? '').toString();
          final String lastName = (p['last_name'] ?? p['lastName'] ?? '').toString();
          final String idNumber = (p['id_number'] ?? p['idNumber'] ?? '').toString();
          final String idType = (p['id_type'] ?? p['idType'] ?? '').toString();
          final String dobStr = (p['date_of_birth'] ?? p['dateOfBirth'] ?? '').toString();
          final DateTime dob = _parseDateTime(dobStr) ?? DateTime(1990, 1, 1);
          final String gender = (p['passenger_gender'] ?? p['gender'] ?? '').toString();
          return Passenger(
            firstName: firstName,
            lastName: lastName,
            idNumber: idNumber,
            idType: idType,
            dateOfBirth: dob,
            gender: gender,
            email: contactEmail,
            phone: contactPhone,
          );
        })
        .toList();

    return Booking(
      bookingId: id,
      flight: flight,
      returnFlight: returnFlight,
      passengers: passengers,
      bookingDate: bookingDate,
      totalPrice: totalPrice,
      status: status,
      contactEmail: contactEmail,
      contactPhone: contactPhone,
      roundTripHint: roundTripHint,
    );
  }

  static double _toDouble(dynamic value) {
    if (value is num) return value.toDouble();
    if (value is String) return double.tryParse(value.replaceAll(',', '')) ?? 0;
    return 0;
    }

  static DateTime? _parseDateTime(String? value) {
    if (value == null || value.isEmpty) return null;
    // Try ISO8601 first
    final iso = DateTime.tryParse(value);
    if (iso != null) return iso;
    // Try dd/MM/yyyy or dd/MM/yyyy HH:mm
    try {
      // Basic manual parsing to avoid intl dependency here
      final parts = value.split(' ');
      final date = parts[0];
      final dmy = date.split('/');
      if (dmy.length == 3) {
        final d = int.tryParse(dmy[0]) ?? 1;
        final m = int.tryParse(dmy[1]) ?? 1;
        final y = int.tryParse(dmy[2]) ?? DateTime.now().year;
        if (parts.length > 1 && parts[1].contains(':')) {
          final hm = parts[1].split(':');
          final h = int.tryParse(hm[0]) ?? 0;
          final min = int.tryParse(hm[1]) ?? 0;
          return DateTime(y, m, d, h, min);
        }
        return DateTime(y, m, d);
      }
    } catch (_) {}
    return null;
  }
}
