import 'package:flutter/material.dart';
import 'package:cnh_n/constants/colors.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

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
          'Hỗ trợ',
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
              _buildSectionTitle('Câu hỏi thường gặp'),
              const SizedBox(height: 16),
              _buildFAQItem(
                'Làm thế nào để đặt vé?',
                'Bạn có thể đặt vé bằng cách tìm kiếm chuyến bay, chọn chuyến bay phù hợp và điền thông tin hành khách.',
              ),
              const SizedBox(height: 12),
              _buildFAQItem(
                'Tôi có thể hủy vé không?',
                'Có, bạn có thể hủy vé trong vòng 24 giờ sau khi đặt. Phí hủy có thể áp dụng tùy theo điều kiện vé.',
              ),
              const SizedBox(height: 12),
              _buildFAQItem(
                'Làm sao để thay đổi thông tin vé?',
                'Bạn có thể liên hệ hotline hoặc gửi email để được hỗ trợ thay đổi thông tin vé.',
              ),
              const SizedBox(height: 12),
              _buildFAQItem(
                'Phương thức thanh toán nào được chấp nhận?',
                'Chúng tôi chấp nhận thanh toán qua thẻ tín dụng, thẻ ghi nợ và ví điện tử.',
              ),
              const SizedBox(height: 32),
              _buildSectionTitle('Liên hệ hỗ trợ'),
              const SizedBox(height: 16),
              _buildContactItem(
                'Hotline',
                '1900 1234',
                Icons.phone,
                () => _showContactDialog(context, 'Hotline', '1900 1234'),
              ),
              const SizedBox(height: 12),
              _buildContactItem(
                'Email',
                'support@flyjourney.com',
                Icons.email,
                () => _showContactDialog(context, 'Email', 'support@flyjourney.com'),
              ),
              const SizedBox(height: 12),
              _buildContactItem(
                'Chat trực tuyến',
                'Hỗ trợ 24/7',
                Icons.chat,
                () => _showContactDialog(context, 'Chat', 'Đang kết nối với nhân viên hỗ trợ...'),
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

  Widget _buildFAQItem(String question, String answer) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFAFAFA),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1F2937),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: const TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 14,
              color: Color(0xFF6B7280),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildContactItem(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
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
                color: AppColors.primaryBlue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
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
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
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

  void _showContactDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          title,
          style: const TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontWeight: FontWeight.w600,
          ),
        ),
        content: Text(
          content,
          style: const TextStyle(
            fontFamily: 'BalooBhaijaan2',
          ),
        ),
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
