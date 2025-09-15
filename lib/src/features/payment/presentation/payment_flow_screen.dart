import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:fly_journey/src/features/payment/data/payment_repository.dart';

class PaymentFlowScreen extends StatefulWidget {
  final String bookingId;
  final num amount;

  const PaymentFlowScreen({super.key, required this.bookingId, required this.amount});

  @override
  State<PaymentFlowScreen> createState() => _PaymentFlowScreenState();
}

class _PaymentFlowScreenState extends State<PaymentFlowScreen> {
  bool _submitting = false;
  Map<String, dynamic>? _result;
  String? _error;
  _PayMethod _method = _PayMethod.momo; // default

  Future<void> _startPayment() async {
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      if (_method == _PayMethod.momo) {
        final amountStr = widget.amount.toStringAsFixed(0);
        final now = DateTime.now().millisecondsSinceEpoch;
        final random = (now % 10000).toString().padLeft(4, '0');
        final orderId = 'FJ${now}$random';
        final requestId = '$now';

        final data = await PaymentRepository.payWithMomo(
          bookingId: widget.bookingId,
          amount: amountStr,
          partnerCode: 'MOMO',
          accessKey: 'F8BBA842ECF85',
          requestId: requestId,
          orderId: orderId,
          orderInfo: 'Thanh toan ve may bay FlyJourney - ${widget.bookingId}',
          redirectUrl: 'http://localhost:3030/my-bookings',
          ipnUrl: 'https://example-ngrok-callback/api/v1/payment/momo/callback',
          extraData: '',
          requestType: 'captureWallet',
        );
        setState(() => _result = data);
        _autoOpenMomoUrlIfAny(data);
      } else {
        // Placeholder for other payment methods
        throw Exception('Phương thức thanh toán chưa được hỗ trợ trong phiên bản này');
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final currency = NumberFormat('#,###', 'vi').format(widget.amount);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thanh toán MoMo'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _methodSelector(),
            _summaryCard(currency),
            const SizedBox(height: 16),
            if (_error != null)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  _error!,
                  style: TextStyle(color: Colors.red.shade700),
                ),
              ),
            if (_result != null) _resultView(_result!),
            const Spacer(),
            SafeArea(
              child: Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: _submitting ? null : () => Navigator.pop(context),
                      child: const Text('Hủy'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: _submitting ? null : _startPayment,
                      icon: _submitting
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                            )
                          : const Icon(Icons.payment),
                      label: Text(_submitting ? 'Đang xử lý...' : 'Thanh toán'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _methodSelector() {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Chọn phương thức thanh toán', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            children: [
              _methodChip(_PayMethod.momo, 'MoMo', Icons.qr_code_2),
              _methodChip(_PayMethod.atm, 'ATM/Bank', Icons.credit_card),
              _methodChip(_PayMethod.qr, 'QR/Internet Banking', Icons.qr_code),
            ],
          ),
        ],
      ),
    );
  }

  Widget _methodChip(_PayMethod method, String label, IconData icon) {
    final selected = _method == method;
    return ChoiceChip(
      label: Row(
        mainAxisSize: MainAxisSize.min,
        children: [Icon(icon, size: 16), const SizedBox(width: 6), Text(label)],
      ),
      selected: selected,
      onSelected: (_) => setState(() => _method = method),
    );
  }

  Widget _summaryCard(String amount) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Thông tin thanh toán', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          _row('Mã đặt chỗ', '#${widget.bookingId}'),
          _row('Số tiền', '$amount ₫'),
          _row('Phương thức', _methodLabel(_method)),
        ],
      ),
    );
  }

  Widget _resultView(Map<String, dynamic> data) {
    final momo = data['momoResponse'] as Map<String, dynamic>?;
    return Container(
      margin: const EdgeInsets.only(top: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Quét QR bằng MoMo để thanh toán', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 12),
          if (momo != null) _qrPreview(momo),
          const SizedBox(height: 12),
          if (momo != null) _maybePayLink(momo),
        ],
      ),
    );
  }

  Widget _row(String label, dynamic value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(width: 140, child: Text(label, style: TextStyle(color: Colors.grey.shade600, fontSize: 12))),
          Expanded(child: Text((value ?? '--').toString(), style: const TextStyle(fontWeight: FontWeight.w600))),
        ],
      ),
    );
  }

  Widget _maybePayLink(Map<String, dynamic> momo) {
    final url = _selectMomoUrl(momo, preferWebHttp: true);
    if (url == null) {
      return const SizedBox.shrink();
    }
    final isHttp = url.startsWith('http');
    final label = isHttp ? 'Mở liên kết thanh toán' : 'Mở bằng ứng dụng MoMo';
    return ElevatedButton.icon(
      onPressed: () => launchUrlString(url, mode: LaunchMode.externalApplication),
      icon: const Icon(Icons.open_in_new),
      label: Text(label),
    );
  }

  void _autoOpenMomoUrlIfAny(Map<String, dynamic> data) {
    final momo = data['momoResponse'] as Map<String, dynamic>?;
    if (momo == null) return;
    final url = _selectMomoUrl(momo, preferWebHttp: true);
    if (url == null) return;
    // Trên web chỉ auto open nếu là http(s). Deeplink momo:// không khả dụng trên browser
    if (kIsWeb && !url.startsWith('http')) return;
    launchUrlString(url, mode: LaunchMode.externalApplication);
  }

  Widget _qrPreview(Map<String, dynamic> momo) {
    final qr = momo['qrCodeUrl']?.toString();
    if (qr == null || qr.isEmpty) return const SizedBox.shrink();
    // Chỉ hiển thị QR khi là http(s) image URL
    if (!qr.startsWith('http')) {
      return const SizedBox.shrink();
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Quét QR bằng MoMo để thanh toán'),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(qr, width: 220, height: 220, fit: BoxFit.cover),
        ),
      ],
    );
  }

  String? _selectMomoUrl(Map<String, dynamic> momo, {bool preferWebHttp = false}) {
    final deeplink = momo['deeplink']?.toString();
    final payUrl = momo['payUrl']?.toString();
    final deeplinkWeb = momo['deeplink_web']?.toString();
    final qrCodeUrl = momo['qrCodeUrl']?.toString();
    final shortLink = momo['shortLink']?.toString();

    if (kIsWeb || preferWebHttp) {
      // Trên web ưu tiên http(s)
      final httpCandidates = [qrCodeUrl, payUrl, deeplinkWeb, shortLink];
      final http = httpCandidates.firstWhere(
        (e) => e != null && e.toString().startsWith('http'),
        orElse: () => null,
      );
      if (http != null) return http as String;
      // Nếu không có http, trả về deeplink để app mobile có thể dùng
      if (!kIsWeb && deeplink != null && deeplink.isNotEmpty) return deeplink;
      return null;
    }

    // Mặc định trên mobile: ưu tiên deeplink app
    final mobileCandidates = [deeplink, payUrl, deeplinkWeb, shortLink];
    final chosen = mobileCandidates.firstWhere(
      (e) => e != null && e.toString().isNotEmpty,
      orElse: () => null,
    );
    return chosen as String?;
  }

  String _methodLabel(_PayMethod method) {
    switch (method) {
      case _PayMethod.momo:
        return 'MoMo';
      case _PayMethod.atm:
        return 'ATM/Bank';
      case _PayMethod.qr:
        return 'QR/Internet Banking';
    }
  }
}

enum _PayMethod { momo, atm, qr }
