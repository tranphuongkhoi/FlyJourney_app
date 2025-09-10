import 'package:flutter/material.dart';
import 'package:cnh_n/services/auth_service.dart';
import 'package:cnh_n/constants/colors.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final AuthService _authService = AuthService();
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    final user = _authService.currentUser!;
    _nameController = TextEditingController(text: user.name);
    _emailController = TextEditingController(text: user.email);
    _phoneController = TextEditingController(text: ''); // Giả sử không có số điện thoại ban đầu
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _toggleEdit() {
    setState(() {
      _isEditing = !_isEditing;
    });
  }

  Future<void> _saveChanges() async {
    if (_formKey.currentState!.validate()) {
      // Đây sẽ là nơi cập nhật thông tin người dùng thông qua API
      // Ví dụ: await _authService.updateUserInfo(_nameController.text, _phoneController.text);
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cập nhật thông tin thành công')),
      );
      
      setState(() {
        _isEditing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0F7FA),
        elevation: 0,
        toolbarHeight: 80,
        title: const Text(
          'Thông tin cá nhân',
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1E293B)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _isEditing ? _saveChanges : _toggleEdit,
            child: Text(
              _isEditing ? 'Lưu' : 'Chỉnh sửa',
              style: const TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.primaryBlue,
              ),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Avatar section
              Center(
                child: Column(
                  children: [
                    Stack(
                      children: [
                        Container(
                          width: 100,
                          height: 100,
                          decoration: BoxDecoration(
                            color: AppColors.primaryBlue,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: const Icon(
                            Icons.person,
                            color: Colors.white,
                            size: 50,
                          ),
                        ),
                        if (_isEditing)
                          Positioned(
                            right: 0,
                            bottom: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _authService.currentUser!.name,
                      style: const TextStyle(
                        fontFamily: 'BalooBhaijaan2',
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              
              // Form fields
              const Text(
                'Thông tin cơ bản',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 16),
              
              // Họ tên
              _buildTextField(
                label: 'Họ và tên',
                hintText: 'Nhập họ và tên của bạn',
                controller: _nameController,
                enabled: _isEditing,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập họ và tên';
                  }
                  return null;
                },
              ),
              
              // Email
              _buildTextField(
                label: 'Email',
                hintText: 'Nhập email của bạn',
                controller: _emailController,
                enabled: false, // Email không được phép thay đổi
                keyboardType: TextInputType.emailAddress,
              ),
              
              // Số điện thoại
              _buildTextField(
                label: 'Số điện thoại',
                hintText: 'Nhập số điện thoại của bạn',
                controller: _phoneController,
                enabled: _isEditing,
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value != null && value.isNotEmpty) {
                    if (!RegExp(r'^\d{10}$').hasMatch(value)) {
                      return 'Số điện thoại phải có 10 chữ số';
                    }
                  }
                  return null;
                },
              ),
              
              const SizedBox(height: 32),
              
              // Thông tin bảo mật
              const Text(
                'Bảo mật',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
              ),
              const SizedBox(height: 16),
              
              // Nút đổi mật khẩu
              InkWell(
                onTap: () {
                  // Điều hướng đến trang đổi mật khẩu
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 10,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.lock_outline,
                          color: AppColors.primaryBlue,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Expanded(
                        child: Text(
                          'Đổi mật khẩu',
                          style: TextStyle(
                            fontFamily: 'BalooBhaijaan2',
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Color(0xFF1E293B),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right,
                        color: Color(0xFF9CA3AF),
                        size: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hintText,
    required TextEditingController controller,
    bool enabled = true,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 8),
          TextFormField(
            controller: controller,
            enabled: enabled,
            keyboardType: keyboardType,
            validator: validator,
            style: const TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1E293B),
            ),
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: const TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 16,
                fontWeight: FontWeight.w400,
                color: Color(0xFFA0AEC0),
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            ),
          ),
        ],
      ),
    );
  }
}
