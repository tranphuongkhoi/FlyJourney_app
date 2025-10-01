import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:fly_journey/src/core/constants/colors.dart';
import 'package:fly_journey/src/features/checkin/domain/checkin_models.dart';

class BoardingPassView extends StatelessWidget {
  final BoardingPassInfo boardingPass;
  final VoidCallback onDone;

  const BoardingPassView({
    super.key,
    required this.boardingPass,
    required this.onDone,
  });

  @override
  Widget build(BuildContext context) {
    final timeFormatter = DateFormat('HH:mm');
    final dateFormatter = DateFormat('dd/MM/yyyy');

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 16),
          const Icon(Icons.check_circle, color: Colors.green, size: 64),
          const SizedBox(height: 16),
          const Text(
            'Check-in thành công!',
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Thẻ lên máy bay của bạn đã sẵn sàng. Vui lòng lưu lại hoặc chụp màn hình.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 24),
          _BoardingPassCard(
            boardingPass: boardingPass,
            timeFormatter: timeFormatter,
            dateFormatter: dateFormatter,
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.file_download_outlined),
                label: const Text('Tải về (sắp ra mắt)'),
              ),
              const SizedBox(width: 12),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.share_outlined),
                label: const Text('Chia sẻ (sắp ra mắt)'),
              ),
            ],
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: onDone,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Quay lại trang chủ',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _BoardingPassCard extends StatelessWidget {
  final BoardingPassInfo boardingPass;
  final DateFormat timeFormatter;
  final DateFormat dateFormatter;

  const _BoardingPassCard({
    required this.boardingPass,
    required this.timeFormatter,
    required this.dateFormatter,
  });

  @override
  Widget build(BuildContext context) {
    final booking = boardingPass.booking;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 30,
            offset: const Offset(0, 20),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(24),
            decoration: const BoxDecoration(
              color: AppColors.primaryBlue,
              borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
            ),
            child: Row(
              children: [
                const Icon(Icons.flight_takeoff, color: Colors.white, size: 32),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        booking.airlineName,
                        style: const TextStyle(
                          fontFamily: 'BalooBhaijaan2',
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        'Chuyến bay ${booking.flightNumber}',
                        style: const TextStyle(
                          fontFamily: 'BalooBhaijaan2',
                          fontSize: 14,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  booking.bookingCode,
                  style: const TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                Row(
                  children: [
                    _BoardingInfoTile(
                      label: 'Khởi hành',
                      value: booking.departureAirport,
                      emphasis:
                          timeFormatter.format(booking.departureTime.toLocal()),
                      subValue:
                          dateFormatter.format(booking.departureTime.toLocal()),
                    ),
                    const SizedBox(width: 12),
                    const Icon(Icons.airlines,
                        color: AppColors.primaryBlueDark),
                    const SizedBox(width: 12),
                    _BoardingInfoTile(
                      label: 'Hạ cánh',
                      value: booking.arrivalAirport,
                      emphasis:
                          timeFormatter.format(booking.arrivalTime.toLocal()),
                      subValue:
                          dateFormatter.format(booking.arrivalTime.toLocal()),
                      alignRight: true,
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                const Divider(),
                const SizedBox(height: 16),
                Column(
                  children: [
                    for (final seat in boardingPass.seats)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                booking
                                        .passengerById(seat.bookingDetailId)
                                        ?.passengerName ??
                                    'Hành khách',
                                style: const TextStyle(
                                  fontFamily: 'BalooBhaijaan2',
                                  fontSize: 14,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 10),
                              decoration: BoxDecoration(
                                color: AppColors.primaryBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(14),
                                border: Border.all(
                                    color: AppColors.primaryBlueDark),
                              ),
                              child: Text(
                                'Ghế ${seat.seatNumber}',
                                style: const TextStyle(
                                  fontFamily: 'BalooBhaijaan2',
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryBlueDark,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BoardingInfoTile extends StatelessWidget {
  final String label;
  final String value;
  final String emphasis;
  final String subValue;
  final bool alignRight;

  const _BoardingInfoTile({
    required this.label,
    required this.value,
    required this.emphasis,
    required this.subValue,
    this.alignRight = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment:
            alignRight ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            textAlign: alignRight ? TextAlign.right : TextAlign.left,
            style: const TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            emphasis,
            textAlign: alignRight ? TextAlign.right : TextAlign.left,
            style: const TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryBlueDark,
            ),
          ),
          Text(
            subValue,
            textAlign: alignRight ? TextAlign.right : TextAlign.left,
            style: const TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
