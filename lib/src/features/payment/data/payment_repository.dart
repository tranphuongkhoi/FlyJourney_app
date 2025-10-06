import 'dart:convert';
import 'package:http/http.dart' as http;

import 'package:fly_journey/src/core/config/api_config.dart';
import 'package:fly_journey/src/features/auth/data/services/auth_service.dart';

class PaymentApiException implements Exception {
  final String message;
  final int? statusCode;
  const PaymentApiException(this.message, {this.statusCode});
  @override
  String toString() =>
      'PaymentApiException: $message${statusCode != null ? ' (HTTP ${statusCode.toString()})' : ''}';
}

class PaymentRepository {
  static final http.Client _client = http.Client();
  static final AuthService _auth = AuthService();

  /// Initiate MoMo payment for a booking
  /// Returns a map containing momoResponse and createdPayment (when available)
  static Future<Map<String, dynamic>> payWithMomo({
    required String bookingId,
    required String amount,
    String? partnerCode,
    String? accessKey,
    String? requestId,
    String? orderId,
    String? orderInfo,
    String? redirectUrl,
    String? ipnUrl,
    String? extraData,
    String? requestType,
  }) async {
    final uri = Uri.parse('${ApiConfig.baseUrl}${ApiConfig.paymentMomo}');
    final body = <String, dynamic>{
      'booking_id': bookingId,
      'amount': amount,
      if (partnerCode != null) 'partnerCode': partnerCode,
      if (accessKey != null) 'accessKey': accessKey,
      if (requestId != null) 'requestId': requestId,
      if (orderId != null) 'orderId': orderId,
      if (orderInfo != null) 'orderInfo': orderInfo,
      if (redirectUrl != null) 'redirectUrl': redirectUrl,
      if (ipnUrl != null) 'ipnUrl': ipnUrl,
      if (extraData != null) 'extraData': extraData,
      if (requestType != null) 'requestType': requestType,
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
        throw PaymentApiException('Yêu cầu thanh toán thất bại',
            statusCode: response.statusCode);
      }

      final Map<String, dynamic> jsonBody =
          json.decode(response.body) as Map<String, dynamic>;
      if (jsonBody['status'] != true) {
        throw PaymentApiException(jsonBody['errorMessage'] ?? 'Lỗi API thanh toán');
      }
      final data = jsonBody['data'] as Map<String, dynamic>?;
      return data ?? <String, dynamic>{};
    } catch (e) {
      if (e is PaymentApiException) rethrow;
      throw PaymentApiException(e.toString());
    }
  }
}
