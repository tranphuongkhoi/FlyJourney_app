import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cnh_n/src/features/search/domain/models/flight.dart';
import 'package:cnh_n/src/core/constants/colors.dart';
import 'package:cnh_n/src/features/booking/presentation/screens/payment_screen.dart';
import 'package:cnh_n/src/features/booking/domain/models/passenger_models.dart';

class PassengerInformationScreen extends StatefulWidget {
  final Flight outboundFlight;
  final Flight? returnFlight;
  final int passengers;
  final DateTime? returnDate;

  const PassengerInformationScreen({
    super.key,
    required this.outboundFlight,
    this.returnFlight,
    required this.passengers,
    this.returnDate,
  });

  @override
  State<PassengerInformationScreen> createState() => _PassengerInformationScreenState();
}

class _PassengerInformationScreenState extends State<PassengerInformationScreen> 
    with SingleTickerProviderStateMixin {
  final PageController _pageController = PageController();
  
  // Animation for smooth progress transitions
  late AnimationController _animationController;
  late Animation<double> _progressAnimation;
  
  // Form data
  List<PassengerInfo> passengersList = [];
  ContactInfo contactInfo = ContactInfo();
  String specialRequests = '';
  
  // UI state
  int currentPassengerIndex = 0;
  bool _isFormValid = false;
  
  @override
  void initState() {
    super.initState();
    _initializePassengers();
    _initializeAnimation();
  }
  
  void _initializeAnimation() {
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 1200), // Siêu mượt
      vsync: this,
    );
    
    _progressAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOutQuart, // Curve siêu mượt
    );
    
    // Start animation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }
  
  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
  
  void _initializePassengers() {
    passengersList = List.generate(
      widget.passengers,
      (index) => PassengerInfo(isBooker: index == 0),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          children: [
            _buildTopBar(),
            _buildSmoothProgressIndicator(),
            Expanded(
              child: _buildFormContent(),
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
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(
                Icons.arrow_back,
                color: Color(0xFF6B7280),
                size: 20,
              ),
            ),
          ),
          const SizedBox(width: 16),
          const Text(
            'Thông tin hành khách',
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1E293B),
            ),
          ),
          const Spacer(),
          const Text(
            'Bước 2 / 3',
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 14,
              color: Color(0xFF64748B),
            ),
          ),
        ],
      ),
    );
  }
  
  Widget _buildSmoothProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: AnimatedBuilder(
        animation: _progressAnimation,
        builder: (context, child) {
          return _buildProgressSteps(currentStep: 2); // Bước 2 hiện tại
        },
      ),
    );
  }
  
  Widget _buildProgressSteps({required int currentStep}) {
    final steps = [
      {'number': 1, 'label': 'Xác nhận'},
      {'number': 2, 'label': 'Hành khách'},
      {'number': 3, 'label': 'Thanh toán'},
    ];
    
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (int i = 0; i < steps.length; i++) ...[
          _buildStepCircle(
            stepNumber: steps[i]['number'] as int,
            label: steps[i]['label'] as String,
            currentStep: currentStep,
          ),
          if (i < steps.length - 1) // Không thêm line sau step cuối
            _buildSmoothProgressLine(
              isActive: currentStep > (steps[i]['number'] as int),
            ),
        ],
      ],
    );
  }

  Widget _buildStepCircle({
    required int stepNumber,
    required String label,
    required int currentStep,
  }) {
    final isCompleted = stepNumber < currentStep; 
    final isActive = stepNumber <= currentStep;   
    final showLabel = stepNumber == currentStep;  
    
    return Column(
      children: [
        // Simple animated circle
        AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primaryBlue : Colors.grey.shade300,
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
        
        // Simple label
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

  Widget _buildSmoothProgressLine({required bool isActive}) {
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
  
  Widget _buildFormContent() {
    return PageView(
      controller: _pageController,
      onPageChanged: (index) {
        setState(() {
          currentPassengerIndex = index;
        });
        
        // Trigger smooth animation
        _animationController.reset();
        _animationController.forward();
      },
      children: [
        // Passenger pages
        ...List.generate(
          widget.passengers,
          (index) => _buildPassengerForm(index),
        ),
        // Final page: Contact info + Special requests
        _buildFinalForm(),
      ],
    );
  }
  
  Widget _buildPassengerForm(int passengerIndex) {
    final passenger = passengersList[passengerIndex];
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Form(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildPassengerHeader(passengerIndex),
            const SizedBox(height: 24),
            _buildPersonalInfoSection(passenger),
            const SizedBox(height: 24),
            _buildDocumentSection(passenger),
            const SizedBox(height: 24),
            _buildBaggageSection(passenger),
            const SizedBox(height: 100),
          ],
        ),
      ),
    );
  }
  
  Widget _buildPassengerHeader(int index) {
    final isBooker = index == 0;
    
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
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primaryBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              isBooker ? Icons.person : Icons.person_outline,
              color: Colors.white,
              size: 24,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isBooker ? 'Người đặt vé (Hành khách ${index + 1})' : 'Hành khách ${index + 1}',
                  style: const TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: AppColors.primaryBlue,
                  ),
                ),
                Text(
                  isBooker ? 'Thông tin liên lạc và thanh toán' : 'Thông tin cá nhân',
                  style: const TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 14,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          if (widget.passengers > 1)
            Text(
              '${index + 1}/${widget.passengers}',
              style: const TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryBlue,
              ),
            ),
        ],
      ),
    );
  }
  
  Widget _buildPersonalInfoSection(PassengerInfo passenger) {
    return _buildSection(
      title: 'Thông tin cá nhân',
      icon: Icons.person,
      children: [
        Row(
          children: [
            Expanded(
              flex: 2,
              child: _buildTextField(
                label: 'Họ và tên đệm',
                value: passenger.lastName,
                onChanged: (value) => passenger.lastName = value,
                isRequired: true,
                hint: 'VD: Nguyễn Văn',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                label: 'Tên',
                value: passenger.firstName,
                onChanged: (value) => passenger.firstName = value,
                isRequired: true,
                hint: 'VD: An',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDateField(
                label: 'Ngày sinh',
                value: passenger.dateOfBirth,
                onChanged: (date) {
                  passenger.dateOfBirth = date;
                  _updatePassengerType(passenger);
                },
                isRequired: true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildDropdownField(
                label: 'Giới tính',
                value: passenger.gender,
                items: const ['Nam', 'Nữ', 'Khác'],
                onChanged: (value) => passenger.gender = value!,
                isRequired: true,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: _buildDropdownField(
                label: 'Quốc tịch',
                value: passenger.nationality,
                items: const ['Việt Nam', 'Hoa Kỳ', 'Nhật Bản', 'Hàn Quốc', 'Khác'],
                onChanged: (value) => passenger.nationality = value!,
                isRequired: true,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _buildTextField(
                label: passenger.isBooker ? 'Số điện thoại' : 'Số điện thoại (tùy chọn)',
                value: passenger.phoneNumber,
                onChanged: (value) => passenger.phoneNumber = value,
                isRequired: passenger.isBooker,
                hint: 'VD: 0901234567',
                keyboardType: TextInputType.phone,
              ),
            ),
          ],
        ),
        if (passenger.passengerType.isNotEmpty) ...[
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.green.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.green.shade700, size: 16),
                const SizedBox(width: 8),
                Text(
                  'Loại hành khách: ${passenger.passengerType}',
                  style: TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 12,
                    color: Colors.green.shade700,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
  
  Widget _buildDocumentSection(PassengerInfo passenger) {
    return _buildSection(
      title: 'Giấy tờ tùy thân',
      icon: Icons.credit_card,
      children: [
        _buildDropdownField(
          label: 'Loại giấy tờ',
          value: passenger.documentType,
          items: const ['CCCD/CMND', 'Hộ chiếu'],
          onChanged: (value) {
            passenger.documentType = value!;
            setState(() {});
          },
          isRequired: true,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Số ${passenger.documentType}',
          value: passenger.documentNumber,
          onChanged: (value) => passenger.documentNumber = value,
          isRequired: true,
          hint: passenger.documentType == 'Hộ chiếu' ? 'VD: A1234567' : 'VD: 123456789012',
        ),
        if (passenger.documentType == 'Hộ chiếu') ...[
          const SizedBox(height: 16),
          _buildDateField(
            label: 'Ngày hết hạn hộ chiếu',
            value: passenger.documentExpiry,
            onChanged: (date) => passenger.documentExpiry = date,
            isRequired: true,
          ),
        ],
      ],
    );
  }
  
  Widget _buildBaggageSection(PassengerInfo passenger) {
    return _buildSection(
      title: 'Hành lý ký gửi',
      icon: Icons.luggage,
      children: [
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
                'Hành lý cơ bản (đã bao gồm)',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                '• Hành lý xách tay: 7kg\n• Hành lý ký gửi: 20kg',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 12,
                  color: Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        const Text(
          'Hành lý ký gửi bổ sung',
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 12),
        ...['Không', '+5kg (+200.000đ)', '+10kg (+350.000đ)', '+15kg (+500.000đ)'].map((option) {
          final isSelected = passenger.extraBaggage == option;
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            child: GestureDetector(
              onTap: () {
                setState(() {
                  passenger.extraBaggage = option;
                });
              },
              child: Container(
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
                    Icon(
                      isSelected ? Icons.radio_button_checked : Icons.radio_button_unchecked,
                      color: isSelected ? AppColors.primaryBlue : Colors.grey.shade400,
                      size: 20,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      option,
                      style: TextStyle(
                        fontFamily: 'BalooBhaijaan2',
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? AppColors.primaryBlue : const Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }).toList(),
      ],
    );
  }
  
  Widget _buildFinalForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Thông tin liên hệ', Icons.contact_mail),
          const SizedBox(height: 16),
          _buildContactSection(),
          const SizedBox(height: 24),
          _buildSectionHeader('Yêu cầu đặc biệt', Icons.note_add),
          const SizedBox(height: 16),
          _buildSpecialRequestsSection(),
          const SizedBox(height: 24),
          _buildSectionHeader('Kiểm tra thông tin', Icons.checklist),
          const SizedBox(height: 16),
          _buildValidationSection(),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
  
  Widget _buildContactSection() {
    return _buildSection(
      title: 'Địa chỉ liên hệ',
      icon: Icons.location_on,
      children: [
        _buildTextField(
          label: 'Địa chỉ liên hệ',
          value: contactInfo.address,
          onChanged: (value) => contactInfo.address = value,
          isRequired: true,
          hint: 'VD: 123 Đường ABC, Quận 1, TP.HCM',
          maxLines: 2,
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Email',
          value: contactInfo.email,
          onChanged: (value) => contactInfo.email = value,
          isRequired: true,
          hint: 'VD: example@email.com',
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }
  
  Widget _buildSpecialRequestsSection() {
    final requests = [
      'Không hút thuốc',
      'Yêu cầu ghế cửa sổ',
      'Yêu cầu ghế lối đi',
      'Cần hỗ trợ di chuyển',
      'Suất ăn chay',
      'Suất ăn Halal',
      'Khác',
    ];
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chọn yêu cầu đặc biệt (nếu có)',
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: requests.map((request) {
            final isSelected = specialRequests.contains(request);
            return GestureDetector(
              onTap: () {
                setState(() {
                  if (isSelected) {
                    specialRequests = specialRequests.replaceAll('$request, ', '').replaceAll(request, '');
                  } else {
                    if (specialRequests.isEmpty) {
                      specialRequests = request;
                    } else {
                      specialRequests += ', $request';
                    }
                  }
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.primaryBlue : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected ? AppColors.primaryBlue : Colors.grey.shade300,
                  ),
                ),
                child: Text(
                  request,
                  style: TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : const Color(0xFF64748B),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 16),
        _buildTextField(
          label: 'Ghi chú thêm',
          value: '',
          onChanged: (value) {},
          hint: 'Nhập yêu cầu đặc biệt khác...',
          maxLines: 3,
        ),
      ],
    );
  }
  
  Widget _buildValidationSection() {
    final missingInfo = _getMissingRequiredFields();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: missingInfo.isEmpty ? Colors.green.shade50 : Colors.orange.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: missingInfo.isEmpty ? Colors.green.shade200 : Colors.orange.shade200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                missingInfo.isEmpty ? Icons.check_circle : Icons.warning,
                color: missingInfo.isEmpty ? Colors.green.shade700 : Colors.orange.shade700,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                missingInfo.isEmpty ? 'Thông tin đã đầy đủ' : 'Cần bổ sung thông tin',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: missingInfo.isEmpty ? Colors.green.shade700 : Colors.orange.shade700,
                ),
              ),
            ],
          ),
          if (missingInfo.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...missingInfo.map((info) => Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Text(
                '• $info',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 12,
                  color: Colors.orange.shade700,
                ),
              ),
            )).toList(),
          ],
        ],
      ),
    );
  }
  
  Widget _buildSection({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: AppColors.primaryBlue, size: 20),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }
  
  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, color: AppColors.primaryBlue, size: 24),
        const SizedBox(width: 12),
        Text(
          title,
          style: const TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: AppColors.primaryBlue,
          ),
        ),
      ],
    );
  }
  
  Widget _buildTextField({
    required String label,
    required String value,
    required Function(String) onChanged,
    bool isRequired = false,
    String? hint,
    TextInputType? keyboardType,
    int maxLines = 1,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          onChanged: onChanged,
          keyboardType: keyboardType,
          maxLines: maxLines,
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
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: (value) {
            if (isRequired && (value == null || value.isEmpty)) {
              return '$label là bắt buộc';
            }
            return null;
          },
        ),
      ],
    );
  }
  
  Widget _buildDropdownField({
    required String label,
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          value: value.isEmpty ? null : value,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppColors.primaryBlue),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          ),
          validator: (value) {
            if (isRequired && value == null) {
              return '$label là bắt buộc';
            }
            return null;
          },
        ),
      ],
    );
  }
  
  Widget _buildDateField({
    required String label,
    required DateTime? value,
    required Function(DateTime?) onChanged,
    bool isRequired = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
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
            if (isRequired)
              const Text(
                ' *',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: () async {
            final date = await showDatePicker(
              context: context,
              initialDate: value ?? DateTime.now().subtract(const Duration(days: 7300)), // 20 years ago
              firstDate: DateTime.now().subtract(const Duration(days: 36500)), // 100 years ago
              lastDate: DateTime.now(),
            );
            if (date != null) {
              onChanged(date);
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(12),
              color: Colors.grey.shade50,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    value != null 
                        ? DateFormat('dd/MM/yyyy').format(value) 
                        : 'Chọn ngày',
                    style: TextStyle(
                      fontFamily: 'BalooBhaijaan2',
                      fontSize: 14,
                      color: value != null ? const Color(0xFF1E293B) : Colors.grey.shade600,
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  color: AppColors.primaryBlue,
                  size: 20,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  
  Widget _buildBottomButtons() {
    final isLastPassenger = currentPassengerIndex >= widget.passengers;
    final canProceed = _canProceedToNext();
    
    // Logic for button text:
    // - < 2 passengers (1 passenger): Always "Tiếp tục thanh toán"
    // - ≥ 2 passengers: "Hành khách tiếp theo" until final passenger, then "Tiếp tục thanh toán"
    String getButtonText() {
      if (widget.passengers < 2) {
        return 'Tiếp tục thanh toán';  // Always for single passenger
      } else {
        // For multiple passengers
        final isFinalPassenger = currentPassengerIndex == widget.passengers - 1;
        if (isFinalPassenger || isLastPassenger) {
          return 'Tiếp tục thanh toán';
        } else {
          return 'Hành khách tiếp theo';
        }
      }
    }
    
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
            if (currentPassengerIndex > 0)
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    _pageController.previousPage(
                      duration: const Duration(milliseconds: 300),
                      curve: Curves.easeInOut,
                    );
                    // Trigger smooth animation
                    _animationController.reset();
                    _animationController.forward();
                  },
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
            if (currentPassengerIndex > 0) const SizedBox(width: 16),
            Expanded(
              child: ElevatedButton(
                onPressed: canProceed ? () {
                  if (widget.passengers < 2) {
                    // Single passenger: always navigate to payment
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PaymentScreen(
                          outboundFlight: widget.outboundFlight,
                          returnFlight: widget.returnFlight,
                          passengers: widget.passengers,
                          returnDate: widget.returnDate,
                          passengersList: passengersList,
                          contactInfo: contactInfo,
                        ),
                      ),
                    );
                  } else {
                    // Multiple passengers logic
                    final isFinalPassenger = currentPassengerIndex == widget.passengers - 1;
                    if (isFinalPassenger || isLastPassenger) {
                      // Final passenger or contact form: navigate to payment
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PaymentScreen(
                            outboundFlight: widget.outboundFlight,
                            returnFlight: widget.returnFlight,
                            passengers: widget.passengers,
                            returnDate: widget.returnDate,
                            passengersList: passengersList,
                            contactInfo: contactInfo,
                          ),
                        ),
                      );
                    } else {
                      // Continue to next passenger
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      );
                      // Trigger smooth animation
                      _animationController.reset();
                      _animationController.forward();
                    }
                  }
                } : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: canProceed ? AppColors.primaryBlue : Colors.grey.shade400,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  getButtonText(),
                  style: const TextStyle(
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
  
  bool _canProceedToNext() {
    if (currentPassengerIndex < widget.passengers) {
      final passenger = passengersList[currentPassengerIndex];
      return passenger.isValid();
    } else {
      // Final form validation
      return contactInfo.isValid() && _getMissingRequiredFields().isEmpty;
    }
  }
  
  List<String> _getMissingRequiredFields() {
    List<String> missing = [];
    
    for (int i = 0; i < passengersList.length; i++) {
      final passenger = passengersList[i];
      if (!passenger.isValid()) {
        missing.add('Hành khách ${i + 1}: Thông tin chưa đầy đủ');
      }
    }
    
    if (!contactInfo.isValid()) {
      missing.add('Thông tin liên hệ chưa đầy đủ');
    }
    
    return missing;
  }
  
  void _updatePassengerType(PassengerInfo passenger) {
    if (passenger.dateOfBirth == null) return;
    
    final age = DateTime.now().difference(passenger.dateOfBirth!).inDays ~/ 365;
    
    if (age < 2) {
      passenger.passengerType = 'Trẻ sơ sinh (dưới 2 tuổi)';
    } else if (age < 12) {
      passenger.passengerType = 'Trẻ em (2-11 tuổi)';
    } else {
      passenger.passengerType = 'Người lớn (từ 12 tuổi)';
    }
    
    setState(() {});
  }

}
