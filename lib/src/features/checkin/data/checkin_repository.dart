import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'package:fly_journey/src/core/config/api_config.dart';
import 'package:fly_journey/src/features/auth/data/services/auth_service.dart';
import 'package:fly_journey/src/features/checkin/domain/checkin_models.dart';
import 'package:fly_journey/src/core/config/dev_config.dart';

class CheckinApiException implements Exception {
  final String message;
  final int? statusCode;

  const CheckinApiException(this.message, {this.statusCode});

  @override
  String toString() =>
      'CheckinApiException: $message${statusCode != null ? ' (HTTP $statusCode)' : ''}';
}

class CheckinRepository {
  CheckinRepository._();

  static final http.Client _client = http.Client();
  static final AuthService _auth = AuthService();

  static Future<CheckinBooking> validateBooking({
    required String pnrCode,
    required String email,
    required String fullName,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.checkinValidate}');
    final body = json.encode({
      'pnr_code': pnrCode.trim(),
      'email': email.trim(),
      'full_name': fullName.trim(),
    });

    final response = await _client
        .post(
          uri,
          headers: _auth.getAuthHeaders(),
          body: body,
        )
        .timeout(ApiConfig.requestTimeout);

    if (response.statusCode != 200) {
      throw CheckinApiException('Không thể xác thực thông tin đặt chỗ',
          statusCode: response.statusCode);
    }

    final Map<String, dynamic> data =
        json.decode(response.body) as Map<String, dynamic>;

    if (data['status'] != true) {
      throw CheckinApiException(
        data['errorMessage']?.toString() ??
            data['message']?.toString() ??
            'Mã đặt chỗ không hợp lệ',
      );
    }

    final bookingPayload = data['data'] as Map<String, dynamic>?;

    if (bookingPayload == null) {
      throw const CheckinApiException('Dữ liệu đặt chỗ không hợp lệ');
    }

    return _parseBooking(bookingPayload);
  }

  static Future<SeatMapData> fetchSeatMap(int flightId) async {
    final path =
        ApiConfig.checkinSeatMap.replaceAll('{flightId}', flightId.toString());
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');

    final response = await _client
        .get(
          uri,
          headers: _auth.getAuthHeaders(),
        )
        .timeout(ApiConfig.requestTimeout);

    if (response.statusCode != 200) {
      throw CheckinApiException('Không thể tải sơ đồ ghế ngồi',
          statusCode: response.statusCode);
    }

    final Map<String, dynamic> payload =
        json.decode(response.body) as Map<String, dynamic>;
    final Map<String, dynamic>? data = payload['data'] as Map<String, dynamic>?;

    if (data == null) {
      throw const CheckinApiException('Không có dữ liệu sơ đồ ghế');
    }

    final List<dynamic> confirmedSeatsRaw =
        (data['confirmed_seats'] as List?) ?? const [];
    final Set<String> confirmedSeats = confirmedSeatsRaw
        .whereType<Map<String, dynamic>>()
        .map((seat) => seat['seat_number']?.toString() ?? '')
        .where((seat) => seat.isNotEmpty)
        .toSet();

    final List<dynamic> seatPricesRaw =
        (data['seat_prices'] as List?) ?? const [];
    final Map<String, int> seatPrices = {
      for (final entry in seatPricesRaw.whereType<Map<String, dynamic>>())
        if (entry['seat_number'] != null)
          entry['seat_number'].toString():
              _parsePrice(entry['price']) ?? 150000,
    };

    final Map<String, dynamic> seatMap =
        (data['seat_map'] as Map<String, dynamic>?) ?? const {};

    return _buildSeatMap(
      seatMap: seatMap,
      confirmedSeats: confirmedSeats,
      seatPrices: seatPrices,
    );
  }

  static Future<void> confirmSeat({
    required String pnrCode,
    required SeatAssignment seat,
  }) async {
    final normalizedPnr = pnrCode.trim().toUpperCase();
    final path =
        ApiConfig.checkinConfirm.replaceAll('{pnrCode}', normalizedPnr);
    final uri = Uri.parse('${ApiConfig.baseUrl}$path');
    final body = json.encode({
      'pnr_code': normalizedPnr,
      // Current API contract expects a single seat_number payload
      'seat_number': seat.seatNumber,
    });

    final response = await _client
        .post(
          uri,
          headers: _auth.getAuthHeaders(),
          body: body,
        )
        .timeout(ApiConfig.requestTimeout);

    if (response.statusCode != 200) {
      throw CheckinApiException('Xác nhận ghế thất bại',
          statusCode: response.statusCode);
    }

    final Map<String, dynamic> payload =
        json.decode(response.body) as Map<String, dynamic>;
    final bool success =
        payload['success'] == true || payload['status'] == true;

    if (!success) {
      throw CheckinApiException(
        payload['message']?.toString() ??
            payload['errorMessage']?.toString() ??
            'Không thể xác nhận ghế',
      );
    }
  }

  static Future<CheckinBooking> loadDevSampleBooking() async {
    final booking = CheckinBooking(
      bookingCode: 'DEV318',
      flightId: 318,
      flightNumber: 'VJ1206',
      departureTime: DateTime.utc(2025, 8, 20, 14, 45),
      arrivalTime: DateTime.utc(2025, 8, 20, 17, 0),
      departureAirport: 'Sân Bay Nội Bài (HAN)',
      arrivalAirport: 'Sân Bay Tân Sơn Nhất (SGN)',
      airlineName: 'VietJet Air',
      flightClass: 'economy',
      passengers: [
        CheckinPassenger(
          bookingDetailId: 999,
          passengerName: 'Dev Tester',
          passengerAge: 28,
          passengerGender: 'male',
          flightClassName: 'economy',
          seatNumber: null,
          isCheckedIn: false,
          idNumber: '123456789',
          idType: 'citizen_id',
        ),
      ],
    );

    if (!DevConfig.showDevTestUI) {
      return booking;
    }

    try {
      await fetchSeatMap(booking.flightId);
    } catch (_) {
      if (kDebugMode) {
        debugPrint(
            'Dev sample seat map fetch failed, continuing with mock data');
      }
    }

    return booking;
  }

  static CheckinBooking _parseBooking(Map<String, dynamic> json) {
    final List<dynamic> detailsRaw =
        (json['booking_details'] as List?) ?? const [];

    final passengers = detailsRaw
        .whereType<Map<String, dynamic>>()
        .map(
          (passenger) => CheckinPassenger(
            bookingDetailId: passenger['booking_detail_id'] is int
                ? passenger['booking_detail_id'] as int
                : int.tryParse(
                        passenger['booking_detail_id']?.toString() ?? '0') ??
                    0,
            passengerName: passenger['passenger_name']?.toString() ?? '',
            passengerAge: passenger['passenger_age'] is int
                ? passenger['passenger_age'] as int
                : int.tryParse(passenger['passenger_age']?.toString() ?? '0') ??
                    0,
            passengerGender: passenger['passenger_gender']?.toString() ?? '',
            flightClassName: passenger['flight_class_name']?.toString() ?? '',
            seatNumber: passenger['seat_number']?.toString(),
            isCheckedIn: passenger['is_checked_in'] == true,
            idNumber: passenger['id_number']?.toString() ?? '',
            idType: passenger['id_type']?.toString() ?? '',
          ),
        )
        .toList();

    return CheckinBooking(
      bookingCode: json['pnr_code']?.toString() ?? '',
      flightId: json['flight_id'] is int
          ? json['flight_id'] as int
          : int.tryParse(json['flight_id']?.toString() ?? '0') ?? 0,
      flightNumber: json['flight_number']?.toString() ?? '',
      departureTime: _parseDate(json['departure_time']) ?? DateTime.now(),
      arrivalTime: _parseDate(json['arrival_time']) ?? DateTime.now(),
      departureAirport: json['departure_airport']?.toString() ?? '',
      arrivalAirport: json['arrival_airport']?.toString() ?? '',
      airlineName: json['airline_name']?.toString() ?? '',
      flightClass: json['booking_details'] is List && passengers.isNotEmpty
          ? passengers.first.flightClassName
          : json['flight_class_name']?.toString() ?? '',
      passengers: passengers,
    );
  }

  static SeatMapData _buildSeatMap({
    required Map<String, dynamic> seatMap,
    required Set<String> confirmedSeats,
    required Map<String, int> seatPrices,
  }) {
    final List<SeatRow> rows = [];

    final List<int> allRows = seatMap.keys
        .map((row) => int.tryParse(row.toString()) ?? 0)
        .where((row) => row > 0)
        .toList()
      ..sort();

    if (allRows.isEmpty) {
      // Default to 30 rows if API doesn't provide specifics
      allRows.addAll(List<int>.generate(30, (index) => index + 1));
    }

    for (final rowNumber in allRows) {
      final List<String> tags =
          (seatMap['$rowNumber'] as List?)?.map((e) => e.toString()).toList() ??
              const [];

      final SeatCabinClass seatClass = _resolveSeatClass(rowNumber, tags);
      final bool isExitRow = tags.contains('exit');
      final bool isExtraLegroom =
          tags.contains('extra_legroom') || tags.contains('extra');
      final bool isBlockedRow = tags.contains('blocked');

      final List<SeatInfo> seats = [];
      const List<String> seatLetters = ['A', 'B', 'C', 'D', 'E', 'F'];

      for (final letter in seatLetters) {
        final seatNumber = '$rowNumber$letter';
        final bool isOccupied = confirmedSeats.contains(seatNumber);
        final int price = seatPrices[seatNumber] ??
            _defaultSeatPrice(
              seatClass: seatClass,
              isExitRow: isExitRow,
              isExtraLegroom: isExtraLegroom,
            );

        seats.add(
          SeatInfo(
            row: rowNumber,
            seatLetter: letter,
            status: isOccupied
                ? SeatStatus.occupied
                : (isBlockedRow
                    ? SeatStatus.unavailable
                    : SeatStatus.available),
            price: price,
            seatClass: seatClass,
            isExitRow: isExitRow,
            isExtraLegroom: isExtraLegroom,
            isBlocked: isBlockedRow,
          ),
        );
      }

      rows.add(SeatRow(rowNumber: rowNumber, seats: seats));
    }

    return SeatMapData(
      rows: rows,
      confirmedSeats: confirmedSeats,
      seatPrices: seatPrices,
    );
  }

  static SeatCabinClass _resolveSeatClass(int rowNumber, List<String> tags) {
    if (tags.contains('first')) return SeatCabinClass.first;
    if (tags.contains('business')) return SeatCabinClass.business;
    if (tags.contains('premium')) return SeatCabinClass.premium;

    if (rowNumber <= 3) return SeatCabinClass.first;
    if (rowNumber <= 8) return SeatCabinClass.business;
    if (rowNumber <= 15) return SeatCabinClass.premium;
    return SeatCabinClass.economy;
  }

  static int _defaultSeatPrice({
    required SeatCabinClass seatClass,
    required bool isExitRow,
    required bool isExtraLegroom,
  }) {
    const int baseEconomy = 150000;
    const int premiumEconomy = 220000;
    const int business = 320000;
    const int first = 420000;

    int price;
    switch (seatClass) {
      case SeatCabinClass.economy:
        price = baseEconomy;
        break;
      case SeatCabinClass.premium:
        price = premiumEconomy;
        break;
      case SeatCabinClass.business:
        price = business;
        break;
      case SeatCabinClass.first:
        price = first;
        break;
    }

    if (isExitRow) {
      price += 60000;
    }

    if (isExtraLegroom) {
      price += 80000;
    }

    return price;
  }

  static int? _parsePrice(dynamic value) {
    if (value == null) return null;
    if (value is num) return value.toInt();
    if (value is String) {
      final normalised = value.replaceAll(RegExp(r'[^0-9]'), '');
      return int.tryParse(normalised);
    }
    return null;
  }

  static DateTime? _parseDate(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value * 1000, isUtc: true);
    }

    if (value is String) {
      final parsed = DateTime.tryParse(value);
      if (parsed != null) {
        return parsed.toUtc();
      }
    }
    return null;
  }
}
