import 'package:flutter/material.dart';

import 'package:fly_journey/src/core/constants/colors.dart';

class CheckinForm extends StatefulWidget {
  final void Function(String pnr, String email, String fullName) onSubmit;
  final VoidCallback? onUseDevSample;

  const CheckinForm({
    super.key,
    required this.onSubmit,
    this.onUseDevSample,
  });

  @override
  State<CheckinForm> createState() => _CheckinFormState();
}

class _CheckinFormState extends State<CheckinForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _pnrController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();

  bool _submitted = false;

  @override
  void dispose() {
    _pnrController.dispose();
    _emailController.dispose();
    _fullNameController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    setState(() {
      _submitted = true;
    });
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSubmit(
        _pnrController.text,
        _emailController.text,
        _fullNameController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),
          _buildIntroCard(context),
          const SizedBox(height: 24),
          Form(
            key: _formKey,
            autovalidateMode: _submitted
                ? AutovalidateMode.always
                : AutovalidateMode.disabled,
            child: Column(
              children: [
                _buildTextField(
                  controller: _pnrController,
                  label: 'Mã đặt chỗ (PNR)',
                  hint: 'Ví dụ: ABC123',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập mã đặt chỗ';
                    }
                    if (value.trim().length < 5) {
                      return 'Mã đặt chỗ cần ít nhất 5 ký tự';
                    }
                    return null;
                  },
                  textCapitalization: TextCapitalization.characters,
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _emailController,
                  label: 'Email',
                  hint: 'example@email.com',
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập email';
                    }
                    final emailRegex =
                        RegExp(r'^[\w\.-]+@[\w\.-]+\.[a-zA-Z]{2,}$');
                    if (!emailRegex.hasMatch(value.trim())) {
                      return 'Email không hợp lệ';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                _buildTextField(
                  controller: _fullNameController,
                  label: 'Họ và tên hành khách',
                  hint: 'Nguyen Van A',
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) {
                      return 'Vui lòng nhập họ tên hành khách';
                    }
                    if (!value.trim().contains(' ')) {
                      return 'Vui lòng nhập đầy đủ họ và tên';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: _handleSubmit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryBlue,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Tiếp tục',
                      style: TextStyle(
                        fontFamily: 'BalooBhaijaan2',
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
                if (widget.onUseDevSample != null) ...[
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    height: 48,
                    child: OutlinedButton.icon(
                      onPressed: widget.onUseDevSample,
                      icon: const Icon(Icons.build_circle_outlined),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.primaryBlue,
                        side: const BorderSide(color: AppColors.primaryBlue),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      label: const Text(
                        '🔧 Test với dữ liệu mẫu',
                        style: TextStyle(
                          fontFamily: 'BalooBhaijaan2',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildIntroCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Hoàn tất check-in trong vài phút',
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Nhập mã đặt chỗ, email và họ tên hành khách để bắt đầu quy trình check-in trực tuyến.',
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 14,
              fontWeight: FontWeight.w400,
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
          SizedBox(height: 12),
          Text(
            'Lưu ý: Check-in mở trước giờ khởi hành 24 tiếng và đóng trước giờ bay 2 tiếng.',
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.primaryBlue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    TextCapitalization textCapitalization = TextCapitalization.none,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      textCapitalization: textCapitalization,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        labelStyle: const TextStyle(
          fontFamily: 'BalooBhaijaan2',
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: AppColors.textSecondary,
        ),
        hintStyle: const TextStyle(
          fontFamily: 'BalooBhaijaan2',
          fontSize: 14,
          color: AppColors.grey400,
        ),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: AppColors.primaryBlue),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Colors.redAccent),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      ),
      style: const TextStyle(
        fontFamily: 'BalooBhaijaan2',
        fontSize: 16,
        color: AppColors.textPrimary,
      ),
    );
  }
}
