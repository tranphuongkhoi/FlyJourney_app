import 'package:flutter/material.dart';
import 'package:cnh_n/constants/colors.dart';

class PersonalInfoScreen extends StatefulWidget {
  const PersonalInfoScreen({super.key});

  @override
  State<PersonalInfoScreen> createState() => _PersonalInfoScreenState();
}

class _PersonalInfoScreenState extends State<PersonalInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Nguyễn Văn A');
  final _emailController = TextEditingController(text: 'nguyenvana@email.com');
  final _phoneController = TextEditingController(text: '0123456789');
  final _addressController = TextEditingController(text: '123 Đường ABC, Quận 1, TP.HCM');
  
  String _selectedGender = 'Nam';
  DateTime _selectedDate = DateTime(1990, 1, 1);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, color: Color(0xFF6B7280)),
        ),
        title: const Text(
          'Thông tin cá nhân',
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildSectionTitle('Thông tin cơ bản'),
                const SizedBox(height: 16),
                _buildTextField('Họ và tên', _nameController, Icons.person),
                const SizedBox(height: 16),
                _buildTextField('Email', _emailController, Icons.email),
                const SizedBox(height: 16),
                _buildTextField('Số điện thoại', _phoneController, Icons.phone),
                const SizedBox(height: 16),
                _buildGenderSelector(),
                const SizedBox(height: 16),
                _buildDateSelector(),
                const SizedBox(height: 24),
                _buildSectionTitle('Địa chỉ'),
                const SizedBox(height: 16),
                _buildTextField('Địa chỉ', _addressController, Icons.location_on),
                const SizedBox(height: 40),
                _buildSaveButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontFamily: 'BalooBhaijaan2',
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.primaryBlue,
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primaryBlue),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFE5E7EB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primaryBlue, width: 2),
        ),
      ),
    );
  }

  Widget _buildGenderSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Giới tính',
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Nam'),
                value: 'Nam',
                groupValue: _selectedGender,
                onChanged: (value) => setState(() => _selectedGender = value!),
                activeColor: AppColors.primaryBlue,
              ),
            ),
            Expanded(
              child: RadioListTile<String>(
                title: const Text('Nữ'),
                value: 'Nữ',
                groupValue: _selectedGender,
                onChanged: (value) => setState(() => _selectedGender = value!),
                activeColor: AppColors.primaryBlue,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Ngày sinh',
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: _selectDate,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFFE5E7EB)),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.calendar_today, color: AppColors.primaryBlue),
                const SizedBox(width: 12),
                Text(
                  '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  style: const TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 16,
                    color: Color(0xFF374151),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _saveProfile,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primaryBlue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Lưu thông tin',
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (date != null) {
      setState(() => _selectedDate = date);
    }
  }

  void _saveProfile() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Đã lưu thông tin thành công!'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}
