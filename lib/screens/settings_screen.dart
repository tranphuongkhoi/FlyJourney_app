import 'package:flutter/material.dart';
import 'package:cnh_n/constants/colors.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _darkMode = false;
  bool _notifications = true;
  String _language = 'Tiếng Việt';
  String _currency = 'VND';

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
          'Cài đặt',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSectionTitle('Giao diện'),
              const SizedBox(height: 16),
              _buildSettingItem(
                'Chế độ tối',
                'Sử dụng giao diện tối',
                _darkMode,
                Icons.dark_mode,
                (value) => setState(() => _darkMode = value),
                isSwitch: true,
              ),
              const SizedBox(height: 12),
              _buildSettingItem(
                'Ngôn ngữ',
                _language,
                null,
                Icons.language,
                () => _showLanguageDialog(),
                isSwitch: false,
              ),
              const SizedBox(height: 32),
              _buildSectionTitle('Thông báo'),
              const SizedBox(height: 16),
              _buildSettingItem(
                'Thông báo đẩy',
                'Nhận thông báo từ ứng dụng',
                _notifications,
                Icons.notifications,
                (value) => setState(() => _notifications = value),
                isSwitch: true,
              ),
              const SizedBox(height: 32),
              _buildSectionTitle('Tài khoản'),
              const SizedBox(height: 16),
              _buildSettingItem(
                'Đơn vị tiền tệ',
                _currency,
                null,
                Icons.attach_money,
                () => _showCurrencyDialog(),
                isSwitch: false,
              ),
              const SizedBox(height: 12),
              _buildSettingItem(
                'Đăng xuất',
                'Đăng xuất khỏi tài khoản',
                null,
                Icons.logout,
                () => _showLogoutDialog(),
                isSwitch: false,
                isDestructive: true,
              ),
              const SizedBox(height: 32),
              _buildSectionTitle('Ứng dụng'),
              const SizedBox(height: 16),
              _buildSettingItem(
                'Phiên bản',
                '1.0.0',
                null,
                Icons.info,
                null,
                isSwitch: false,
              ),
              const SizedBox(height: 12),
              _buildSettingItem(
                'Điều khoản sử dụng',
                'Xem điều khoản và điều kiện',
                null,
                Icons.description,
                () => _showTermsDialog(),
                isSwitch: false,
              ),
              const SizedBox(height: 12),
              _buildSettingItem(
                'Chính sách bảo mật',
                'Xem chính sách bảo mật',
                null,
                Icons.privacy_tip,
                () => _showPrivacyDialog(),
                isSwitch: false,
              ),
            ],
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

  Widget _buildSettingItem(
    String title,
    String subtitle,
    bool? value,
    IconData icon,
    dynamic onTap,
    {required bool isSwitch, bool isDestructive = false}
  ) {
    return InkWell(
      onTap: isSwitch ? null : onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFAFAFA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFE5E7EB)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: isDestructive 
                  ? Colors.red.withOpacity(0.1)
                  : AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                icon,
                color: isDestructive ? Colors.red : AppColors.primaryBlue,
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
                      color: isDestructive ? Colors.red : const Color(0xFF1F2937),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontFamily: 'BalooBhaijaan2',
                      fontSize: 14,
                      color: Color(0xFF6B7280),
                    ),
                  ),
                ],
              ),
            ),
            if (isSwitch)
              Switch(
                value: value!,
                onChanged: onTap,
                activeColor: AppColors.primaryBlue,
              )
            else
              Icon(
                Icons.arrow_forward_ios,
                color: AppColors.primaryBlue,
                size: 16,
              ),
          ],
        ),
      ),
    );
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Chọn ngôn ngữ',
          style: TextStyle(fontFamily: 'BalooBhaijaan2'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption('Tiếng Việt', 'vi'),
            _buildLanguageOption('English', 'en'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String name, String code) {
    return ListTile(
      title: Text(name, style: const TextStyle(fontFamily: 'BalooBhaijaan2')),
      onTap: () {
        setState(() => _language = name);
        Navigator.pop(context);
      },
    );
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Chọn đơn vị tiền tệ',
          style: TextStyle(fontFamily: 'BalooBhaijaan2'),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCurrencyOption('VND', '₫'),
            _buildCurrencyOption('USD', '\$'),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyOption(String name, String symbol) {
    return ListTile(
      title: Text('$name ($symbol)', style: const TextStyle(fontFamily: 'BalooBhaijaan2')),
      onTap: () {
        setState(() => _currency = name);
        Navigator.pop(context);
      },
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(
          'Đăng xuất',
          style: TextStyle(fontFamily: 'BalooBhaijaan2'),
        ),
        content: const Text(
          'Bạn có chắc chắn muốn đăng xuất?',
          style: TextStyle(fontFamily: 'BalooBhaijaan2'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Hủy',
              style: TextStyle(fontFamily: 'BalooBhaijaan2'),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã đăng xuất')),
              );
            },
            child: Text(
              'Đăng xuất',
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                color: Colors.red,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showTermsDialog() {
    _showInfoDialog('Điều khoản sử dụng', 'Nội dung điều khoản sử dụng sẽ được hiển thị ở đây.');
  }

  void _showPrivacyDialog() {
    _showInfoDialog('Chính sách bảo mật', 'Nội dung chính sách bảo mật sẽ được hiển thị ở đây.');
  }

  void _showInfoDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title, style: const TextStyle(fontFamily: 'BalooBhaijaan2')),
        content: Text(content, style: const TextStyle(fontFamily: 'BalooBhaijaan2')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Đóng',
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                color: AppColors.primaryBlue,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
