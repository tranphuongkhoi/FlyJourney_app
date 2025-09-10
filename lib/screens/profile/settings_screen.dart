import 'package:flutter/material.dart';
import 'package:cnh_n/constants/colors.dart';
import 'package:cnh_n/services/auth_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final AuthService _authService = AuthService();
  bool _notificationsEnabled = true;
  bool _emailNotifications = true;
  bool _darkMode = false;
  String _currency = 'VND';
  String _language = 'Tiếng Việt';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _notificationsEnabled = prefs.getBool('notifications_enabled') ?? true;
      _emailNotifications = prefs.getBool('email_notifications') ?? true;
      _darkMode = prefs.getBool('dark_mode') ?? false;
      _currency = prefs.getString('currency') ?? 'VND';
      _language = prefs.getString('language') ?? 'Tiếng Việt';
    });
  }

  Future<void> _saveSettings(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

  void _showLanguageDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: const Text(
          'Chọn ngôn ngữ',
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildLanguageOption('Tiếng Việt'),
            _buildLanguageOption('English'),
          ],
        ),
      ),
    );
  }

  Widget _buildLanguageOption(String language) {
    final isSelected = _language == language;
    
    return InkWell(
      onTap: () {
        setState(() {
          _language = language;
        });
        _saveSettings('language', language);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                language,
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppColors.primaryBlue : const Color(0xFF1E293B),
                ),
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check,
                color: AppColors.primaryBlue,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  void _showCurrencyDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: const Text(
          'Chọn đơn vị tiền tệ',
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildCurrencyOption('VND', 'Việt Nam Đồng'),
            _buildCurrencyOption('USD', 'US Dollar'),
            _buildCurrencyOption('EUR', 'Euro'),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyOption(String currencyCode, String currencyName) {
    final isSelected = _currency == currencyCode;
    
    return InkWell(
      onTap: () {
        setState(() {
          _currency = currencyCode;
        });
        _saveSettings('currency', currencyCode);
        Navigator.pop(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryBlue.withOpacity(0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    currencyCode,
                    style: TextStyle(
                      fontFamily: 'BalooBhaijaan2',
                      fontSize: 16,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                      color: isSelected ? AppColors.primaryBlue : const Color(0xFF1E293B),
                    ),
                  ),
                  Text(
                    currencyName,
                    style: const TextStyle(
                      fontFamily: 'BalooBhaijaan2',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              const Icon(
                Icons.check,
                color: AppColors.primaryBlue,
                size: 20,
              ),
          ],
        ),
      ),
    );
  }

  void _clearCache() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        title: const Text(
          'Xóa bộ nhớ đệm',
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1E293B),
          ),
        ),
        content: const Text(
          'Bạn có chắc chắn muốn xóa bộ nhớ đệm? Điều này có thể làm chậm ứng dụng lần đầu sau khi xóa.',
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF64748B),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Hủy',
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Color(0xFF64748B),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Implement cache clearing
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Đã xóa bộ nhớ đệm')),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryBlue,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Xóa',
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
          contentPadding: const EdgeInsets.all(32),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Icon
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(40),
                ),
                child: Icon(
                  Icons.logout,
                  size: 40,
                  color: Colors.orange[600],
                ),
              ),
              const SizedBox(height: 24),
              
              // Title
              const Text(
                'Xác nhận đăng xuất',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF1E293B),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              
              // Content
              const Text(
                'Bạn có chắc chắn muốn đăng xuất khỏi tài khoản không?',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                  color: Color(0xFF64748B),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32),
              
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // Đóng dialog
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: const Color(0xFF64748B),
                        side: const BorderSide(color: Color(0xFFE5E7EB)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text(
                        'Hủy',
                        style: TextStyle(
                          fontFamily: 'BalooBhaijaan2',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {
                        Navigator.of(context).pop(); // Đóng dialog
                        
                        // Thực hiện logout
                        await _authService.logout();
                        
                        // Navigate back to main screen and refresh
                        if (mounted) {
                          Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Đăng xuất',
                        style: TextStyle(
                          fontFamily: 'BalooBhaijaan2',
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
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
          'Cài đặt',
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
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thông báo
            const Text(
              'Thông báo',
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            _buildSwitchItem(
              icon: Icons.notifications_none,
              title: 'Thông báo ứng dụng',
              subtitle: 'Nhận thông báo về chuyến bay, ưu đãi và cập nhật',
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
                _saveSettings('notifications_enabled', value);
              },
            ),
            _buildSwitchItem(
              icon: Icons.email_outlined,
              title: 'Thông báo email',
              subtitle: 'Nhận thông báo qua email',
              value: _emailNotifications,
              onChanged: (value) {
                setState(() {
                  _emailNotifications = value;
                });
                _saveSettings('email_notifications', value);
              },
            ),
            
            const SizedBox(height: 24),
            
            // Giao diện
            const Text(
              'Giao diện',
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            _buildSwitchItem(
              icon: Icons.dark_mode_outlined,
              title: 'Chế độ tối',
              subtitle: 'Bật chế độ tối cho ứng dụng',
              value: _darkMode,
              onChanged: (value) {
                setState(() {
                  _darkMode = value;
                });
                _saveSettings('dark_mode', value);
                // TODO: Implement theme change
              },
            ),
            
            const SizedBox(height: 24),
            
            // Tùy chỉnh
            const Text(
              'Tùy chỉnh',
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            _buildSettingItem(
              icon: Icons.language,
              title: 'Ngôn ngữ',
              subtitle: _language,
              onTap: _showLanguageDialog,
            ),
            _buildSettingItem(
              icon: Icons.attach_money,
              title: 'Đơn vị tiền tệ',
              subtitle: _currency,
              onTap: _showCurrencyDialog,
            ),
            
            const SizedBox(height: 24),
            
            // Khác
            const Text(
              'Khác',
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            _buildSettingItem(
              icon: Icons.cleaning_services_outlined,
              title: 'Xóa bộ nhớ đệm',
              subtitle: 'Giải phóng không gian lưu trữ',
              onTap: _clearCache,
            ),
            _buildSettingItem(
              icon: Icons.info_outline,
              title: 'Về ứng dụng',
              subtitle: 'Phiên bản 1.0.0',
              onTap: () {
                // Hiển thị thông tin ứng dụng
              },
            ),
            _buildSettingItem(
              icon: Icons.privacy_tip_outlined,
              title: 'Chính sách quyền riêng tư',
              subtitle: 'Xem chính sách quyền riêng tư của chúng tôi',
              onTap: () {
                // Mở trang chính sách quyền riêng tư
              },
            ),
            
            if (_authService.isLoggedIn) ...[
              const SizedBox(height: 24),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _logout,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 0,
                  ),
                  child: const Text(
                    'Đăng xuất',
                    style: TextStyle(
                      fontFamily: 'BalooBhaijaan2',
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
            child: Icon(
              icon,
              color: AppColors.primaryBlue,
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
                  style: const TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E293B),
                  ),
                ),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: AppColors.primaryBlue,
            activeTrackColor: AppColors.primaryBlue.withOpacity(0.2),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: onTap,
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
                child: Icon(
                  icon,
                  color: AppColors.primaryBlue,
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
                      style: const TextStyle(
                        fontFamily: 'BalooBhaijaan2',
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Color(0xFF1E293B),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontFamily: 'BalooBhaijaan2',
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        color: Color(0xFF64748B),
                      ),
                    ),
                  ],
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
    );
  }
}
