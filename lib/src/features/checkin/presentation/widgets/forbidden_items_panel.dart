import 'package:flutter/material.dart';

import 'package:fly_journey/src/core/constants/colors.dart';

class ForbiddenItemsPanel extends StatelessWidget {
  const ForbiddenItemsPanel({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'Lưu ý khi mang hành lý xách tay',
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontWeight: FontWeight.w700,
              fontSize: 15,
              color: AppColors.textPrimary,
            ),
          ),
          SizedBox(height: 12),
          _ForbiddenRow(
            icon: Icons.block,
            title: 'Không mang theo các vật sắc nhọn, chất nổ, chất dễ cháy',
          ),
          _ForbiddenRow(
            icon: Icons.liquor,
            title: 'Dung dịch trên 100ml cần ký gửi theo quy định của hãng bay',
          ),
          _ForbiddenRow(
            icon: Icons.warning_amber,
            title:
                'Tuân thủ hướng dẫn an toàn của phi hành đoàn trong suốt chuyến bay',
          ),
        ],
      ),
    );
  }
}

class _ForbiddenRow extends StatelessWidget {
  final IconData icon;
  final String title;

  const _ForbiddenRow({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.redAccent, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
