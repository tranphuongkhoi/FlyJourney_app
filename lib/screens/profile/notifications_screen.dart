import 'package:flutter/material.dart';
import 'package:cnh_n/constants/colors.dart';

class NotificationsScreen extends StatefulWidget {
  const NotificationsScreen({super.key});

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  // Ví dụ danh sách thông báo
  final List<Map<String, dynamic>> _notifications = [
    {
      'id': '1',
      'title': 'Xác nhận đặt vé thành công',
      'message': 'Vé máy bay của bạn đã được xác nhận. Mã đặt vé: ABC123',
      'type': 'booking',
      'read': true,
      'time': DateTime.now().subtract(const Duration(hours: 2)),
    },
    {
      'id': '2',
      'title': 'Khuyến mãi mùa thu - Giảm 30%',
      'message': 'Nhận ưu đãi giảm 30% cho các chuyến bay nội địa đến hết tháng 10/2025',
      'type': 'promotion',
      'read': false,
      'time': DateTime.now().subtract(const Duration(days: 1)),
    },
    {
      'id': '3',
      'title': 'Thông báo thay đổi giờ bay',
      'message': 'Chuyến bay VN456 của bạn đã được thay đổi từ 14:00 thành 15:30',
      'type': 'update',
      'read': false,
      'time': DateTime.now().subtract(const Duration(days: 2)),
    },
    {
      'id': '4',
      'title': 'Cập nhật chính sách hành lý',
      'message': 'Fly Journey đã cập nhật chính sách hành lý mới. Vui lòng kiểm tra để biết thêm chi tiết.',
      'type': 'info',
      'read': true,
      'time': DateTime.now().subtract(const Duration(days: 5)),
    },
  ];

  void _markAllAsRead() {
    setState(() {
      for (var notification in _notifications) {
        notification['read'] = true;
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Đã đánh dấu tất cả là đã đọc')),
    );
  }

  void _markAsRead(String id) {
    setState(() {
      final notification = _notifications.firstWhere((n) => n['id'] == id);
      notification['read'] = true;
    });
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);
    
    if (difference.inMinutes < 60) {
      return '${difference.inMinutes} phút trước';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} giờ trước';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} ngày trước';
    } else {
      return '${time.day}/${time.month}/${time.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Đếm số thông báo chưa đọc
    final unreadCount = _notifications.where((n) => n['read'] == false).length;
    
    return Scaffold(
      backgroundColor: const Color(0xFFE0F7FA),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE0F7FA),
        elevation: 0,
        toolbarHeight: 80,
        title: const Text(
          'Thông báo',
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
          if (unreadCount > 0)
            TextButton(
              onPressed: _markAllAsRead,
              child: const Text(
                'Đánh dấu đã đọc',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primaryBlue,
                ),
              ),
            ),
        ],
      ),
      body: _notifications.isEmpty
          ? _buildEmptyState()
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _notifications.length,
              itemBuilder: (context, index) {
                final notification = _notifications[index];
                return _buildNotificationItem(notification);
              },
            ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: AppColors.primaryBlue.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.notifications_none,
                size: 60,
                color: AppColors.primaryBlue,
              ),
            ),
            const SizedBox(height: 24),
            const Text(
              'Không có thông báo nào',
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Bạn sẽ nhận được thông báo khi có cập nhật về chuyến bay, khuyến mãi và các thông tin khác',
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 14,
                fontWeight: FontWeight.w400,
                color: Color(0xFF64748B),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNotificationItem(Map<String, dynamic> notification) {
    IconData iconData;
    Color iconColor;
    
    // Xác định biểu tượng và màu sắc dựa trên loại thông báo
    switch (notification['type']) {
      case 'booking':
        iconData = Icons.confirmation_number_outlined;
        iconColor = Colors.green;
        break;
      case 'promotion':
        iconData = Icons.local_offer_outlined;
        iconColor = Colors.orange;
        break;
      case 'update':
        iconData = Icons.update;
        iconColor = Colors.blue;
        break;
      case 'info':
        iconData = Icons.info_outline;
        iconColor = Colors.purple;
        break;
      default:
        iconData = Icons.notifications_none;
        iconColor = Colors.grey;
    }
    
    return InkWell(
      onTap: () {
        // Đánh dấu là đã đọc khi nhấn vào
        if (notification['read'] == false) {
          _markAsRead(notification['id']);
        }
        
        // Hiển thị dialog thông báo chi tiết
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            contentPadding: const EdgeInsets.all(24),
            title: Text(
              notification['title'],
              style: const TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1E293B),
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  notification['message'],
                  style: const TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  _formatTime(notification['time']),
                  style: const TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 12,
                    fontWeight: FontWeight.w400,
                    color: Color(0xFF9CA3AF),
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  'Đóng',
                  style: TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primaryBlue,
                  ),
                ),
              ),
            ],
          ),
        );
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: notification['read'] ? Colors.white : const Color(0xFFEFF6FF),
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(
                iconData,
                color: iconColor,
                size: 24,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          notification['title'],
                          style: TextStyle(
                            fontFamily: 'BalooBhaijaan2',
                            fontSize: 16,
                            fontWeight: notification['read'] ? FontWeight.w500 : FontWeight.w600,
                            color: const Color(0xFF1E293B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (!notification['read'])
                        Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.primaryBlue,
                            shape: BoxShape.circle,
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    notification['message'],
                    style: const TextStyle(
                      fontFamily: 'BalooBhaijaan2',
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF64748B),
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _formatTime(notification['time']),
                    style: const TextStyle(
                      fontFamily: 'BalooBhaijaan2',
                      fontSize: 12,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF9CA3AF),
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
}
