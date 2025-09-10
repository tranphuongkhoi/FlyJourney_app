import 'package:flutter/material.dart';
import 'package:cnh_n/constants/colors.dart';
import 'package:url_launcher/url_launcher.dart';

class SupportScreen extends StatelessWidget {
  const SupportScreen({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw Exception('Không thể mở liên kết: $url');
    }
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': 'Yêu cầu hỗ trợ từ ứng dụng Fly Journey',
      },
    );
    
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw Exception('Không thể mở ứng dụng email');
    }
  }

  Future<void> _launchPhone(String phone) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phone,
    );
    
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw Exception('Không thể gọi điện thoại');
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
          'Hỗ trợ',
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
            // Banner
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: AppColors.primaryBlue,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primaryBlue.withOpacity(0.3),
                    blurRadius: 20,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Chúng tôi luôn sẵn sàng hỗ trợ bạn',
                    style: TextStyle(
                      fontFamily: 'BalooBhaijaan2',
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Fly Journey cam kết hỗ trợ khách hàng 24/7. Hãy liên hệ với chúng tôi nếu bạn cần trợ giúp.',
                    style: TextStyle(
                      fontFamily: 'BalooBhaijaan2',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () {
                      // Mở trang chat
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: AppColors.primaryBlue,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.chat_bubble_outline),
                        SizedBox(width: 8),
                        Text(
                          'Chat với chúng tôi',
                          style: TextStyle(
                            fontFamily: 'BalooBhaijaan2',
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            // Các cách liên hệ
            const Text(
              'Liên hệ với chúng tôi',
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            
            // Email
            _buildContactItem(
              icon: Icons.email_outlined,
              title: 'Email',
              subtitle: 'support@flyjourney.com',
              color: Colors.blue,
              onTap: () => _launchEmail('support@flyjourney.com'),
            ),
            
            // Điện thoại
            _buildContactItem(
              icon: Icons.phone_outlined,
              title: 'Hotline',
              subtitle: '1900 xxxx xxx',
              color: Colors.green,
              onTap: () => _launchPhone('1900123456'),
            ),
            
            // Văn phòng
            _buildContactItem(
              icon: Icons.location_on_outlined,
              title: 'Văn phòng',
              subtitle: '123 Đường ABC, Quận 1, TP.HCM',
              color: Colors.red,
              onTap: () => _launchUrl('https://maps.google.com/?q=10.7769,106.7009'),
            ),
            
            const SizedBox(height: 24),
            
            // FAQ
            const Text(
              'Câu hỏi thường gặp',
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            
            _buildFaqItem(
              question: 'Làm thế nào để đặt vé máy bay?',
              answer: 'Để đặt vé máy bay, bạn có thể nhập thông tin chuyến bay ở trang chính, chọn chuyến bay phù hợp, điền thông tin hành khách và tiến hành thanh toán.',
              context: context,
            ),
            
            _buildFaqItem(
              question: 'Làm thế nào để hủy hoặc thay đổi vé đã đặt?',
              answer: 'Để hủy hoặc thay đổi vé đã đặt, bạn có thể vào mục "Vé đã đặt" trong trang Hồ sơ, chọn vé cần thay đổi và làm theo hướng dẫn. Lưu ý rằng có thể phát sinh phí hủy hoặc đổi vé tùy theo chính sách của hãng bay.',
              context: context,
            ),
            
            _buildFaqItem(
              question: 'Tôi có thể đặt vé cho nhiều người cùng một lúc không?',
              answer: 'Có, bạn có thể đặt vé cho nhiều người cùng một lúc. Khi tiến hành đặt vé, bạn có thể thêm thông tin cho nhiều hành khách trước khi thanh toán.',
              context: context,
            ),
            
            _buildFaqItem(
              question: 'Làm thế nào để nhận xác nhận đặt vé?',
              answer: 'Sau khi đặt vé thành công, bạn sẽ nhận được email xác nhận và thông báo trong ứng dụng. Bạn cũng có thể kiểm tra vé đã đặt trong mục "Vé đã đặt" trong trang Hồ sơ.',
              context: context,
            ),
            
            _buildFaqItem(
              question: 'Chính sách hoàn tiền như thế nào?',
              answer: 'Chính sách hoàn tiền phụ thuộc vào điều kiện vé và quy định của từng hãng bay. Vé có thể hoàn tiền một phần, toàn phần hoặc không hoàn tiền. Bạn có thể kiểm tra điều kiện vé khi đặt hoặc liên hệ với chúng tôi để biết thêm chi tiết.',
              context: context,
            ),
            
            const SizedBox(height: 24),
            
            // Mạng xã hội
            const Text(
              'Kết nối với chúng tôi',
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 16),
            
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildSocialButton(
                  icon: Icons.facebook,
                  color: const Color(0xFF1877F2),
                  onTap: () => _launchUrl('https://facebook.com'),
                ),
                const SizedBox(width: 16),
                _buildSocialButton(
                  icon: Icons.camera_alt_outlined,
                  color: const Color(0xFFE4405F),
                  onTap: () => _launchUrl('https://instagram.com'),
                ),
                const SizedBox(width: 16),
                _buildSocialButton(
                  icon: Icons.airplane_ticket,
                  color: Colors.blue,
                  onTap: () => _launchUrl('https://flyjourney.com'),
                ),
                const SizedBox(width: 16),
                _buildSocialButton(
                  icon: Icons.phone,
                  color: Colors.green,
                  onTap: () => _launchPhone('1900123456'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
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
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: color,
                  size: 24,
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
                Icons.arrow_forward_ios,
                color: Color(0xFF9CA3AF),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFaqItem({
    required String question,
    required String answer,
    required BuildContext context,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        onTap: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            builder: (context) => Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    question,
                    style: const TextStyle(
                      fontFamily: 'BalooBhaijaan2',
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    answer,
                    style: const TextStyle(
                      fontFamily: 'BalooBhaijaan2',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF64748B),
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.pop(context),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primaryBlue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        elevation: 0,
                      ),
                      child: const Text(
                        'Đóng',
                        style: TextStyle(
                          fontFamily: 'BalooBhaijaan2',
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
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
              Expanded(
                child: Text(
                  question,
                  style: const TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                color: AppColors.primaryBlue,
                size: 24,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Container(
        width: 56,
        height: 56,
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          color: color,
          size: 28,
        ),
      ),
    );
  }
}
