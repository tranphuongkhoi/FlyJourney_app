import 'package:flutter/material.dart';

import 'package:fly_journey/src/core/constants/colors.dart';

class SeatLegend extends StatelessWidget {
  final int passengerCount;

  const SeatLegend({super.key, required this.passengerCount});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Chú thích ghế ngồi (Tối đa $passengerCount ghế)',
            style: const TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontWeight: FontWeight.w600,
              fontSize: 14,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Hạng ghế',
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              _LegendChip(
                gradient: const [Color(0xFFFFF7E0), Color(0xFFFFECB3)],
                borderColor: const Color(0xFFF59E0B),
                icon: Icons.workspace_premium,
                iconColor: const Color(0xFFD97706),
                label: 'Hạng Nhất (1-3)',
              ),
              _LegendChip(
                gradient: const [Color(0xFFD1FAE5), Color(0xFFA7F3D0)],
                borderColor: const Color(0xFF10B981),
                icon: Icons.workspace_premium_outlined,
                iconColor: const Color(0xFF059669),
                label: 'Thương gia (4-8)',
              ),
              _LegendChip(
                gradient: const [Color(0xFFEDE9FE), Color(0xFFD8B4FE)],
                borderColor: const Color(0xFF8B5CF6),
                icon: Icons.airline_seat_recline_extra,
                iconColor: const Color(0xFF7C3AED),
                label: 'Phổ thông cao cấp (9-15)',
              ),
              _LegendChip(
                gradient: const [Color(0xFFF1F5F9), Color(0xFFE2E8F0)],
                borderColor: const Color(0xFF94A3B8),
                label: 'Phổ thông (16-30)',
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Text(
            'Trạng thái & tiện ích',
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 16,
            runSpacing: 12,
            children: [
              _LegendChip(
                color: AppColors.primaryBlue,
                borderColor: AppColors.primaryBlueDark,
                icon: Icons.check,
                iconColor: Colors.white,
                label: 'Ghế bạn chọn',
              ),
              _LegendChip(
                color: const Color(0xFFFFF7ED),
                borderColor: const Color(0xFFF97316),
                icon: Icons.timer_outlined,
                iconColor: const Color(0xFF9A3412),
                label: 'Đang giữ cho hành khách khác',
              ),
              _LegendChip(
                color: const Color(0xFFEF4444),
                borderColor: const Color(0xFFB91C1C),
                icon: Icons.close,
                iconColor: Colors.white,
                label: 'Đã có người',
              ),
              _LegendChip(
                color: const Color(0xFF9CA3AF),
                borderColor: const Color(0xFF6B7280),
                icon: Icons.build_outlined,
                iconColor: Colors.white,
                label: 'Không khả dụng / bảo trì',
              ),
              _LegendChip(
                color: Colors.white,
                borderColor: const Color(0xFF22C55E),
                icon: Icons.door_sliding,
                iconColor: const Color(0xFF22C55E),
                label: 'Lối thoát hiểm',
              ),
              _LegendChip(
                color: Colors.white,
                borderColor: const Color(0xFF6366F1),
                icon: Icons.airline_seat_legroom_extra,
                iconColor: const Color(0xFF6366F1),
                label: 'Ghế rộng chân',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LegendChip extends StatelessWidget {
  final List<Color>? gradient;
  final Color? color;
  final Color borderColor;
  final String label;
  final IconData? icon;
  final Color? iconColor;

  const _LegendChip({
    this.gradient,
    this.color,
    required this.borderColor,
    required this.label,
    this.icon,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    assert(gradient != null || color != null,
        'Legend chip requires either a gradient or a solid color');
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            color: gradient == null ? color : null,
            gradient:
                gradient != null ? LinearGradient(colors: gradient!) : null,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: borderColor, width: 1.5),
          ),
          child: icon != null
              ? Icon(
                  icon,
                  size: 14,
                  color: iconColor ?? borderColor,
                )
              : null,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontSize: 12,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }
}
