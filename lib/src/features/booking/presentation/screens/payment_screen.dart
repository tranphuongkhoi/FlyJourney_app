import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:fly_journey/src/features/search/domain/models/flight.dart';
import 'package:fly_journey/src/core/constants/colors.dart';
import 'package:fly_journey/src/features/booking/domain/models/passenger_models.dart';
import 'package:fly_journey/src/features/booking/domain/models/booking.dart';
import 'package:fly_journey/src/features/booking/domain/models/passenger.dart';
import 'package:fly_journey/src/features/booking/data/services/storage_service.dart';
import 'package:fly_journey/src/features/booking/presentation/screens/payment_success_screen.dart';
import 'package:fly_journey/src/core/constants/baggage_options.dart';
import 'package:fly_journey/src/core/constants/services_mapping.dart';

class PaymentScreen extends StatefulWidget {
  final Flight outboundFlight;
  final Flight? returnFlight;
  final int passengers;
  final DateTime? returnDate;
  final List<PassengerInfo> passengersList;
  final ContactInfo contactInfo;
  final List<String> baggageSelections; // per passenger baggage id
  final List<String> selectedServices;  // service ids applied to all passengers

  const PaymentScreen({
    super.key,
    required this.outboundFlight,
    this.returnFlight,
    required this.passengers,
    this.returnDate,
    required this.passengersList,
    required this.contactInfo,
    required this.baggageSelections,
    required this.selectedServices,
  });

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> 
    with SingleTickerProviderStateMixin {
  
  // Animation for smooth progress transitions
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  
  // Payment method selection
  String _selectedPaymentMethod = 'credit_card';
  
  // Credit card form
  final _cardNumberController = TextEditingController();
  final _cardHolderController = TextEditingController();
  final _expiryController = TextEditingController();
  final _cvvController = TextEditingController();
  
  // Banking form
  String _selectedBank = '';
  
  // Form validation
  final _formKey = GlobalKey<FormState>();
  bool _agreedToTerms = false;
  bool _isProcessingPayment = false;
  
  @override
  void initState() {
    super.initState();
    _initializeAnimation();
  }
  
  void _initializeAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _progressAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutQuart,
    );
    
    // Start animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    _cardNumberController.dispose();
    _cardHolderController.dispose();
    _expiryController.dispose();
    _cvvController.dispose();
    super.dispose();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildProgressIndicator(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildOrderSummary(),
                      const SizedBox(height: 24),
                      _buildPaymentMethods(),
                      const SizedBox(height: 24),
                      _buildPaymentForm(),
                      const SizedBox(height: 24),
                      _buildTermsAndConditions(),
                      const SizedBox(height: 100),
                    ],
                  ),
                ),
              ),
            ),
            _buildBottomButtons(),
          ],
        ),
      ),
    );
  }
  
  Widget _buildTopBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Color(0xFF1E293B),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Text(
              'Thanh toán',
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1E293B),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 24),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildStepCircle(1, 'Xác nhận', isCompleted: true),
          _buildProgressLine(isActive: true),
          _buildStepCircle(2, 'Hành khách', isCompleted: true),
          _buildProgressLine(isActive: true),
          _buildStepCircle(3, 'Thanh toán', isCompleted: false, isActive: true),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int stepNumber, String label, {required bool isCompleted, bool isActive = false}) {
    final bool showLabel = isActive;
    
    return Column(
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: (isCompleted || isActive) ? AppColors.primaryBlue : Colors.grey.shade300,
            shape: BoxShape.circle,
          ),
          child: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 300),
              child: isCompleted
                  ? const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 24,
                      key: ValueKey('check'),
                    )
                  : Text(
                      stepNumber.toString(),
                      key: ValueKey('number'),
                      style: TextStyle(
                        fontFamily: 'BalooBhaijaan2',
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: isActive ? Colors.white : Colors.grey.shade600,
                      ),
                    ),
            ),
          ),
        ),
        
        const SizedBox(height: 8),
        
        AnimatedOpacity(
          duration: const Duration(milliseconds: 300),
          opacity: showLabel ? 1.0 : 0.0,
          child: Text(
            label,
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: showLabel ? AppColors.primaryBlue : Colors.transparent,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressLine({required bool isActive}) {
    return Container(
      width: 60,
      height: 3,
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 400),
        decoration: BoxDecoration(
          color: isActive ? AppColors.primaryBlue : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(2),
        ),
      ),
    );
  }

  Widget _buildOrderSummary() {
    final double outboundPrice = widget.outboundFlight.price;
    final double returnPrice = widget.returnFlight?.price ?? 0;
    final double basePrice = outboundPrice + returnPrice;
    final double totalPassengerPrice = basePrice * widget.passengers;
    final int baggageTotal = _calcBaggageTotal();
    final int servicesTotal = _calcServicesTotal();
    final double taxes = totalPassengerPrice * 0.1; // sample tax calc
    final double totalPrice = totalPassengerPrice + taxes + baggageTotal + servicesTotal;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppColors.primaryBlue.withOpacity(0.1),
            AppColors.primaryBlue.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryBlue.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.primaryBlue,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.receipt_long,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Text(
                'Tóm tắt đơn hàng',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          // Flight summary
          _buildFlightSummaryRow('🛫 Chuyến bay đi', 
            '${widget.outboundFlight.departure.code} → ${widget.outboundFlight.arrival.code}',
            NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(outboundPrice)),
          
          if (widget.returnFlight != null)
            _buildFlightSummaryRow('🛬 Chuyến bay về', 
              '${widget.returnFlight!.arrival.code} → ${widget.returnFlight!.departure.code}',
              NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(returnPrice)),
          
          const Divider(height: 24),
          
          // Pricing breakdown
          _buildPriceRow('Giá vé (${widget.passengers} hành khách)', 
            NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(totalPassengerPrice)),
          _buildPriceRow('Thuế và phí', 
            NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(taxes)),
          if (baggageTotal > 0)
            _buildPriceRow('Hành lý ký gửi thêm', 
              NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(baggageTotal)),
          if (servicesTotal > 0)
            _buildPriceRow('Dịch vụ bổ sung', 
              NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(servicesTotal)),
          
          const Divider(height: 16),
          
          _buildPriceRow('Tổng cộng', 
            NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(totalPrice),
            isTotal: true),
      ],
    ),
  );
}

  Widget _buildFlightSummaryRow(String title, String route, String price) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Text(
                  route,
                  style: TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: const TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String price, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w500,
              color: isTotal ? AppColors.primaryBlue : const Color(0xFF1E293B),
            ),
          ),
          Text(
            price,
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: isTotal ? 18 : 14,
              fontWeight: FontWeight.w700,
              color: isTotal ? AppColors.primaryBlue : const Color(0xFF1E293B),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Phương thức thanh toán',
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 16),
        
        _buildPaymentMethodTile(
          'credit_card',
          'Thẻ tín dụng/ghi nợ',
          Icons.credit_card,
          'Visa, Mastercard, JCB',
        ),
        
        _buildPaymentMethodTile(
          'banking',
          'Chuyển khoản ngân hàng',
          Icons.account_balance,
          'Vietcombank, Techcombank, BIDV',
        ),
        
        _buildPaymentMethodTile(
          'ewallet',
          'Ví điện tử',
          Icons.wallet,
          'MoMo, ZaloPay, ViettelPay',
        ),
        
        _buildPaymentMethodTile(
          'qr_code',
          'Quét mã QR',
          Icons.qr_code,
          'Thanh toán nhanh qua QR',
        ),
      ],
    );
  }

  Widget _buildPaymentMethodTile(String value, String title, IconData icon, String subtitle) {
    final bool isSelected = _selectedPaymentMethod == value;
    
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = value;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? AppColors.primaryBlue : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryBlue : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey.shade600,
                size: 20,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontFamily: 'BalooBhaijaan2',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isSelected ? AppColors.primaryBlue : const Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontFamily: 'BalooBhaijaan2',
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: AppColors.primaryBlue,
                size: 24,
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentForm() {
    switch (_selectedPaymentMethod) {
      case 'credit_card':
        return _buildCreditCardForm();
      case 'banking':
        return _buildBankingForm();
      case 'ewallet':
        return _buildEWalletForm();
      case 'qr_code':
        return _buildQRCodeForm();
      default:
        return const SizedBox.shrink();
    }
  }

  Widget _buildCreditCardForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Thông tin thẻ',
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          
          _buildInputField(
            controller: _cardNumberController,
            label: 'Số thẻ',
            hint: '1234 5678 9012 3456',
            keyboardType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty) return 'Số thẻ là bắt buộc';
              if (value.length < 16) return 'Số thẻ không hợp lệ';
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          _buildInputField(
            controller: _cardHolderController,
            label: 'Tên chủ thẻ',
            hint: 'NGUYEN VAN A',
            validator: (value) {
              if (value == null || value.isEmpty) return 'Tên chủ thẻ là bắt buộc';
              return null;
            },
          ),
          
          const SizedBox(height: 16),
          
          Row(
            children: [
              Expanded(
                child: _buildInputField(
                  controller: _expiryController,
                  label: 'MM/YY',
                  hint: '12/25',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'Ngày hết hạn là bắt buộc';
                    return null;
                  },
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildInputField(
                  controller: _cvvController,
                  label: 'CVV',
                  hint: '123',
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) return 'CVV là bắt buộc';
                    return null;
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBankingForm() {
    final banks = [
      'Vietcombank',
      'Techcombank', 
      'BIDV',
      'VietinBank',
      'Agribank',
      'ACB',
      'MB Bank',
      'TPBank'
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chọn ngân hàng',
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          
          DropdownButtonFormField<String>(
            value: _selectedBank.isEmpty ? null : _selectedBank,
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white,
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
            hint: const Text('Chọn ngân hàng'),
            items: banks.map((bank) {
              return DropdownMenuItem<String>(
                value: bank,
                child: Text(bank),
              );
            }).toList(),
            onChanged: (value) {
              setState(() {
                _selectedBank = value ?? '';
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) return 'Vui lòng chọn ngân hàng';
              return null;
            },
          ),
          
          if (_selectedBank.isNotEmpty) ...[
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bạn sẽ được chuyển đến trang thanh toán của ngân hàng',
                    style: TextStyle(
                      fontFamily: 'BalooBhaijaan2',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Thời gian thanh toán: 15 phút\nVé sẽ được giữ trong thời gian này',
                    style: TextStyle(
                      fontFamily: 'BalooBhaijaan2',
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildEWalletForm() {
    final wallets = [
      {'name': 'MoMo', 'icon': Icons.account_balance_wallet},
      {'name': 'ZaloPay', 'icon': Icons.payment},
      {'name': 'ViettelPay', 'icon': Icons.phone_android},
      {'name': 'VNPAY', 'icon': Icons.credit_card},
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Chọn ví điện tử',
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 16),
          
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 3,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
            ),
            itemCount: wallets.length,
            itemBuilder: (context, index) {
              final wallet = wallets[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Icon(
                      wallet['icon'] as IconData,
                      color: AppColors.primaryBlue,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        wallet['name'] as String,
                        style: const TextStyle(
                          fontFamily: 'BalooBhaijaan2',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1E293B),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildQRCodeForm() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          const Text(
            'Quét mã QR để thanh toán',
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 20),
          
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.grey.shade300),
            ),
            child: const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.qr_code,
                    size: 80,
                    color: AppColors.primaryBlue,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Mã QR sẽ được tạo\nsau khi xác nhận',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'BalooBhaijaan2',
                      fontSize: 14,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 20),
          
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.orange.shade50,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.shade200),
            ),
            child: Column(
              children: [
                const Text(
                  'Hướng dẫn thanh toán',
                  style: TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '1. Mở ứng dụng ngân hàng\n2. Chọn tính năng quét QR\n3. Quét mã QR trên màn hình\n4. Xác nhận thanh toán',
                  style: TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          decoration: InputDecoration(
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryBlue),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildTermsAndConditions() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                value: _agreedToTerms,
                onChanged: (value) {
                  setState(() {
                    _agreedToTerms = value ?? false;
                  });
                },
                activeColor: AppColors.primaryBlue,
              ),
              const Expanded(
                child: Text(
                  'Tôi đồng ý với Điều khoản sử dụng và Chính sách bảo mật',
                  style: TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 14,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
            ],
          ),
          
          const SizedBox(height: 12),
          
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.blue.shade200),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.security, size: 16, color: Colors.blue.shade600),
                    const SizedBox(width: 8),
                    const Text(
                      'Thông tin bảo mật',
                      style: TextStyle(
                        fontFamily: 'BalooBhaijaan2',
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  '• Thông tin thanh toán được mã hóa SSL 256-bit\n• Không lưu trữ thông tin thẻ của bạn\n• Tuân thủ chuẩn bảo mật PCI DSS',
                  style: TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons() {
    final bool canProceed = _agreedToTerms && _validatePaymentForm();
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => Navigator.pop(context),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primaryBlue),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Quay lại',
                  style: TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              flex: 2,
              child: ElevatedButton(
                onPressed: canProceed ? _processPayment : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canProceed ? AppColors.primaryBlue : Colors.grey.shade400,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: _isProcessingPayment
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                        ),
                      )
                    : const Text(
                        'Thanh toán ngay',
                        style: TextStyle(
                          fontFamily: 'BalooBhaijaan2',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  bool _validatePaymentForm() {
    switch (_selectedPaymentMethod) {
      case 'credit_card':
        return _cardNumberController.text.isNotEmpty &&
               _cardHolderController.text.isNotEmpty &&
               _expiryController.text.isNotEmpty &&
               _cvvController.text.isNotEmpty;
      case 'banking':
        return _selectedBank.isNotEmpty;
      case 'ewallet':
      case 'qr_code':
        return true;
      default:
        return false;
    }
  }

  void _processPayment() async {
    if (!_formKey.currentState!.validate()) return;
    
    setState(() {
      _isProcessingPayment = true;
    });
    
    // Simulate payment processing
    await Future.delayed(const Duration(seconds: 3));
    
    // Calculate total amount
    final totalAmount = _calculateTotalAmount();
    
    // Create booking object
    final bookingId = 'FL${DateTime.now().millisecondsSinceEpoch.toString().substring(7)}';
    
    // Convert PassengerInfo to Passenger objects
    final passengers = widget.passengersList.map((passengerInfo) => Passenger(
      firstName: passengerInfo.firstName,
      lastName: passengerInfo.lastName,
      idNumber: passengerInfo.documentNumber,
      idType: passengerInfo.documentType,
      dateOfBirth: passengerInfo.dateOfBirth ?? DateTime.now().subtract(const Duration(days: 365 * 25)), // Default age 25
      gender: passengerInfo.gender,
      email: widget.contactInfo.email, // Use contact email for all passengers
      phone: passengerInfo.phoneNumber.isNotEmpty ? passengerInfo.phoneNumber : '', // Use passenger's phone or empty
    )).toList();
    
    final booking = Booking(
      bookingId: bookingId,
      flight: widget.outboundFlight,
      returnFlight: widget.returnFlight,
      passengers: passengers,
      bookingDate: DateTime.now(),
      totalPrice: totalAmount,
      status: BookingStatus.confirmed,
      contactEmail: widget.contactInfo.email,
      contactPhone: widget.passengersList.isNotEmpty ? widget.passengersList.first.phoneNumber : '',
    );
    
    // Save booking to local storage
    try {
      await StorageService.saveBooking(booking);
      // Booking saved successfully
    } catch (e) {
      // Swallow save error; consider showing a SnackBar if needed
    }
    
    setState(() {
      _isProcessingPayment = false;
    });
    
    // Navigate to PaymentSuccessScreen
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentSuccessScreen(
          flight: widget.outboundFlight,
          returnFlight: widget.returnFlight,
          passengers: widget.passengersList,
          contactInfo: widget.contactInfo,
          totalPassengers: widget.passengers,
          totalAmount: totalAmount,
        ),
      ),
    );
  }

  double _calculateTotalAmount() {
    // Calculate total based on outbound + return flight prices
    double total = widget.outboundFlight.price.toDouble() * widget.passengers;
    
    if (widget.returnFlight != null) {
      total += widget.returnFlight!.price.toDouble() * widget.passengers;
    }
    // Add extras
    total += _calcBaggageTotal();
    total += _calcServicesTotal();
    return total;
  }

  int _calcBaggageTotal() {
    int total = 0;
    for (final id in widget.baggageSelections) {
      total += BaggageOptions.byId(id).price;
    }
    return total;
  }

  int _calcServicesTotal() {
    int total = 0;
    for (final id in widget.selectedServices) {
      final item = ServiceMapping.byId(id);
      total += item.price * widget.passengers;
    }
    return total;
  }
}
