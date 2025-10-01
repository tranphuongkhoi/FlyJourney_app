import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:fly_journey/src/core/constants/colors.dart';
import 'package:fly_journey/src/features/checkin/domain/checkin_models.dart';
import 'package:fly_journey/src/features/checkin/presentation/widgets/forbidden_items_panel.dart';
import 'package:fly_journey/src/features/checkin/presentation/widgets/seat_legend.dart';

class SeatSelectionView extends StatelessWidget {
  final CheckinBooking booking;
  final SeatMapData? seatMap;
  final Map<int, SeatAssignment> seatSelections;
  final int activePassengerIndex;
  final ValueChanged<int> onPassengerChanged;
  final ValueChanged<SeatInfo> onSeatTapped;
  final VoidCallback onConfirm;
  final bool devSampleActive;
  final int totalSeatFee;
  final bool hasSeatsForAllPassengers;

  const SeatSelectionView({
    super.key,
    required this.booking,
    required this.seatMap,
    required this.seatSelections,
    required this.activePassengerIndex,
    required this.onPassengerChanged,
    required this.onSeatTapped,
    required this.onConfirm,
    required this.devSampleActive,
    required this.totalSeatFee,
    required this.hasSeatsForAllPassengers,
  });

  @override
  Widget build(BuildContext context) {
    final passengerCount = booking.passengers.length;
    if (passengerCount == 0) {
      return const _SeatSelectionEmptyState();
    }
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _FlightOverviewCard(
              booking: booking, devSampleActive: devSampleActive),
          const SizedBox(height: 24),
          _PassengerSelector(
            passengers: booking.passengers,
            activeIndex: activePassengerIndex,
            seatSelections: seatSelections,
            onChanged: onPassengerChanged,
          ),
          const SizedBox(height: 24),
          _SeatMapCard(
            seatMap: seatMap,
            activePassenger: booking.passengers[activePassengerIndex],
            seatSelections: seatSelections,
            onSeatTapped: onSeatTapped,
          ),
          const SizedBox(height: 24),
          SeatLegend(passengerCount: passengerCount),
          const SizedBox(height: 16),
          _SeatSummaryCard(
            booking: booking,
            seatSelections: seatSelections,
            totalSeatFee: totalSeatFee,
          ),
          const SizedBox(height: 24),
          const ForbiddenItemsPanel(),
          const SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: ElevatedButton(
              onPressed: hasSeatsForAllPassengers ? onConfirm : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryBlue,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
              child: Text(
                hasSeatsForAllPassengers
                    ? 'Xác nhận ghế và nhận thẻ lên máy bay'
                    : 'Chọn ghế cho tất cả hành khách (${passengerCount})',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
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

class _FlightOverviewCard extends StatelessWidget {
  final CheckinBooking booking;
  final bool devSampleActive;

  const _FlightOverviewCard({
    required this.booking,
    required this.devSampleActive,
  });

  @override
  Widget build(BuildContext context) {
    final formatter = DateFormat('HH:mm');
    final dateFormatter = DateFormat('dd/MM/yyyy');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 25,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.airplane_ticket,
                  color: AppColors.primaryBlueDark, size: 28),
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
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Text(
                      'Chuyến bay ${booking.flightNumber} · Hạng ${booking.flightClass}',
                      style: const TextStyle(
                        fontFamily: 'BalooBhaijaan2',
                        fontSize: 13,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
              if (devSampleActive)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.orange.shade100,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'DEV MODE',
                    style: TextStyle(
                      fontFamily: 'BalooBhaijaan2',
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.orange.shade800,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              _AirportColumn(
                label: 'Khởi hành',
                airport: booking.departureAirport,
                time: formatter.format(booking.departureTime.toLocal()),
                date: dateFormatter.format(booking.departureTime.toLocal()),
              ),
              Expanded(
                child: Column(
                  children: const [
                    Divider(color: AppColors.border, thickness: 1.2),
                    Icon(Icons.flight_takeoff,
                        color: AppColors.primaryBlue, size: 24),
                    Divider(color: AppColors.border, thickness: 1.2),
                  ],
                ),
              ),
              _AirportColumn(
                label: 'Hạ cánh',
                airport: booking.arrivalAirport,
                time: formatter.format(booking.arrivalTime.toLocal()),
                date: dateFormatter.format(booking.arrivalTime.toLocal()),
                textAlign: TextAlign.right,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AirportColumn extends StatelessWidget {
  final String label;
  final String airport;
  final String time;
  final String date;
  final TextAlign textAlign;

  const _AirportColumn({
    required this.label,
    required this.airport,
    required this.time,
    required this.date,
    this.textAlign = TextAlign.left,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.35,
      child: Column(
        crossAxisAlignment: textAlign == TextAlign.left
            ? CrossAxisAlignment.start
            : CrossAxisAlignment.end,
        children: [
          Text(
            label,
            textAlign: textAlign,
            style: const TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 12,
              color: AppColors.grey500,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            airport,
            textAlign: textAlign,
            style: const TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            textAlign: textAlign,
            style: const TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: AppColors.primaryBlue,
            ),
          ),
          Text(
            date,
            textAlign: textAlign,
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

class _PassengerSelector extends StatelessWidget {
  final List<CheckinPassenger> passengers;
  final int activeIndex;
  final Map<int, SeatAssignment> seatSelections;
  final ValueChanged<int> onChanged;

  const _PassengerSelector({
    required this.passengers,
    required this.activeIndex,
    required this.seatSelections,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Chọn hành khách',
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: [
            for (int index = 0; index < passengers.length; index++)
              _PassengerChip(
                passenger: passengers[index],
                selected: index == activeIndex,
                seat: seatSelections[passengers[index].bookingDetailId]
                    ?.seatNumber,
                onTap: () => onChanged(index),
              ),
          ],
        ),
      ],
    );
  }
}

class _PassengerChip extends StatelessWidget {
  final CheckinPassenger passenger;
  final bool selected;
  final String? seat;
  final VoidCallback onTap;

  const _PassengerChip({
    required this.passenger,
    required this.selected,
    required this.seat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? AppColors.primaryBlue : AppColors.grey200;
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color:
              selected ? AppColors.primaryBlue.withOpacity(0.08) : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color, width: selected ? 2 : 1),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: AppColors.primaryBlue.withOpacity(0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.person_pin, color: color),
            const SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  passenger.passengerName,
                  style: TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: selected
                        ? AppColors.primaryBlue
                        : AppColors.textPrimary,
                  ),
                ),
                Text(
                  seat != null ? 'Ghế: $seat' : 'Chưa chọn ghế',
                  style: const TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontSize: 12,
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SeatMapCard extends StatelessWidget {
  final SeatMapData? seatMap;
  final CheckinPassenger activePassenger;
  final Map<int, SeatAssignment> seatSelections;
  final ValueChanged<SeatInfo> onSeatTapped;

  const _SeatMapCard({
    required this.seatMap,
    required this.activePassenger,
    required this.seatSelections,
    required this.onSeatTapped,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.event_seat, color: AppColors.primaryBlueDark),
              const SizedBox(width: 8),
              Text(
                'Chọn ghế cho ${activePassenger.passengerName}',
                style: const TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (seatMap == null)
            const Center(
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40),
                child: CircularProgressIndicator(),
              ),
            )
          else
            _SeatGrid(
              seatMap: seatMap!,
              activePassenger: activePassenger,
              seatSelections: seatSelections,
              onSeatTapped: onSeatTapped,
            ),
        ],
      ),
    );
  }
}

class _SeatGrid extends StatelessWidget {
  final SeatMapData seatMap;
  final CheckinPassenger activePassenger;
  final Map<int, SeatAssignment> seatSelections;
  final ValueChanged<SeatInfo> onSeatTapped;

  const _SeatGrid({
    required this.seatMap,
    required this.activePassenger,
    required this.seatSelections,
    required this.onSeatTapped,
  });

  @override
  Widget build(BuildContext context) {
    final assignedSeatNumbers = seatSelections.values
        .map((assignment) => assignment.seatNumber)
        .toSet();
    final activeSeat =
        seatSelections[activePassenger.bookingDetailId]?.seatNumber;
    final NumberFormat priceFormat = NumberFormat('#,##0', 'vi_VN');
    final List<Widget> children = [];

    for (final row in seatMap.rows) {
      final String? sectionTitle = _sectionLabelForRow(row.rowNumber);
      if (sectionTitle != null) {
        children.add(
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                sectionTitle,
                style: const TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
          ),
        );
      }

      children.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 40,
                child: Text(
                  row.rowNumber.toString(),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontFamily: 'BalooBhaijaan2',
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    _buildSeatSide(
                      seats: row.seats.take(3).toList(),
                      activeSeat: activeSeat,
                      assignedSeatNumbers: assignedSeatNumbers,
                      priceFormat: priceFormat,
                      onSeatTapped: onSeatTapped,
                    ),
                    const SizedBox(width: 20),
                    _buildSeatSide(
                      seats: row.seats.skip(3).toList(),
                      activeSeat: activeSeat,
                      assignedSeatNumbers: assignedSeatNumbers,
                      priceFormat: priceFormat,
                      onSeatTapped: onSeatTapped,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(children: children);
  }

  String? _sectionLabelForRow(int rowNumber) {
    if (rowNumber == 1) return 'Hạng Nhất';
    if (rowNumber == 4) return 'Hạng Thương gia';
    if (rowNumber == 9) return 'Phổ thông cao cấp';
    if (rowNumber == 16) return 'Phổ thông';
    return null;
  }
}

class _SeatButton extends StatelessWidget {
  final SeatInfo seat;
  final bool isActiveSeat;
  final bool isSelectedByOther;
  final NumberFormat priceFormat;
  final VoidCallback onTap;

  const _SeatButton({
    required this.seat,
    required this.isActiveSeat,
    required this.isSelectedByOther,
    required this.priceFormat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final bool disabled = seat.status == SeatStatus.occupied ||
        seat.status == SeatStatus.unavailable;

    Gradient? gradient;
    Color background = Colors.white;
    Color borderColor = AppColors.border;
    Color textColor = AppColors.textPrimary;
    Color priceTextColor = AppColors.primaryBlueDark;
    Color? classIconColor;

    if (disabled) {
      background = AppColors.grey300;
      borderColor = AppColors.grey400;
      textColor = Colors.white;
      priceTextColor = Colors.white;
      classIconColor = Colors.white;
    } else if (isActiveSeat) {
      background = AppColors.primaryBlue;
      borderColor = AppColors.primaryBlueDark;
      textColor = Colors.white;
      priceTextColor = Colors.white;
      classIconColor = Colors.white;
    } else if (isSelectedByOther) {
      background = const Color(0xFFFFF7ED);
      borderColor = const Color(0xFFF97316);
      textColor = const Color(0xFF9A3412);
      priceTextColor = const Color(0xFF9A3412);
      classIconColor = textColor;
    } else {
      final _SeatPalette palette = _SeatPalette.fromSeatClass(seat.seatClass);
      gradient = palette.gradient;
      background = palette.backgroundColor;
      borderColor = palette.borderColor;
      textColor = palette.textColor;
      priceTextColor = palette.priceColor;
      classIconColor = palette.classIconColor;
    }

    if (!disabled && !isSelectedByOther && !isActiveSeat) {
      if (seat.isExitRow) {
        borderColor = Colors.green.shade400;
      }
      if (seat.isExtraLegroom) {
        borderColor = Colors.indigo.shade400;
      }
    }

    final String seatPriceText = '${priceFormat.format(seat.price)}₫';
    final IconData? classIcon =
        _SeatPalette.classIconForSeatClass(seat.seatClass);
    classIconColor ??= textColor;

    final Color exitIconColor =
        isActiveSeat ? Colors.white : Colors.green.shade500;
    final Color legroomIconColor =
        isActiveSeat ? Colors.white : Colors.indigo.shade500;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: GestureDetector(
        onTap: disabled ? null : onTap,
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: gradient == null ? background : null,
            gradient: gradient,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: borderColor, width: 1.5),
            boxShadow: isActiveSeat
                ? [
                    BoxShadow(
                      color: AppColors.primaryBlue.withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if (classIcon != null)
                    Padding(
                      padding: const EdgeInsets.only(right: 4),
                      child: Icon(
                        classIcon,
                        size: 16,
                        color: classIconColor,
                      ),
                    ),
                  Text(
                    seat.seatLetter,
                    style: TextStyle(
                      fontFamily: 'BalooBhaijaan2',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: textColor,
                    ),
                  ),
                  if (seat.isExitRow)
                    Padding(
                      padding: const EdgeInsets.only(left: 4),
                      child: Icon(
                        Icons.door_sliding,
                        size: 16,
                        color: exitIconColor,
                      ),
                    ),
                  if (seat.isExtraLegroom)
                    Padding(
                      padding: const EdgeInsets.only(left: 2),
                      child: Icon(
                        Icons.airline_seat_legroom_extra,
                        size: 16,
                        color: legroomIconColor,
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                seatPriceText,
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: priceTextColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SeatPalette {
  final Gradient? gradient;
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;
  final Color priceColor;
  final Color classIconColor;

  const _SeatPalette({
    required this.gradient,
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
    required this.priceColor,
    required this.classIconColor,
  });

  factory _SeatPalette.fromSeatClass(SeatCabinClass seatClass) {
    switch (seatClass) {
      case SeatCabinClass.first:
        return _SeatPalette(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFF7E0), Color(0xFFFFECB3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          backgroundColor: const Color(0xFFFFF7E0),
          borderColor: const Color(0xFFF59E0B),
          textColor: const Color(0xFFB45309),
          priceColor: const Color(0xFFB45309),
          classIconColor: const Color(0xFFD97706),
        );
      case SeatCabinClass.business:
        return _SeatPalette(
          gradient: const LinearGradient(
            colors: [Color(0xFFD1FAE5), Color(0xFFA7F3D0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          backgroundColor: const Color(0xFFD1FAE5),
          borderColor: const Color(0xFF10B981),
          textColor: const Color(0xFF047857),
          priceColor: const Color(0xFF047857),
          classIconColor: const Color(0xFF059669),
        );
      case SeatCabinClass.premium:
        return _SeatPalette(
          gradient: const LinearGradient(
            colors: [Color(0xFFEDE9FE), Color(0xFFD8B4FE)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          backgroundColor: const Color(0xFFEDE9FE),
          borderColor: const Color(0xFF8B5CF6),
          textColor: const Color(0xFF6D28D9),
          priceColor: const Color(0xFF6D28D9),
          classIconColor: const Color(0xFF7C3AED),
        );
      case SeatCabinClass.economy:
        return _SeatPalette(
          gradient: const LinearGradient(
            colors: [Color(0xFFF1F5F9), Color(0xFFE2E8F0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          backgroundColor: const Color(0xFFF1F5F9),
          borderColor: const Color(0xFF94A3B8),
          textColor: const Color(0xFF475569),
          priceColor: const Color(0xFF475569),
          classIconColor: const Color(0xFF475569),
        );
    }
  }

  static IconData? classIconForSeatClass(SeatCabinClass seatClass) {
    switch (seatClass) {
      case SeatCabinClass.first:
        return Icons.workspace_premium;
      case SeatCabinClass.business:
        return Icons.workspace_premium_outlined;
      case SeatCabinClass.premium:
        return Icons.airline_seat_recline_extra;
      case SeatCabinClass.economy:
        return null;
    }
  }
}

Widget _buildSeatSide({
  required List<SeatInfo> seats,
  required String? activeSeat,
  required Set<String> assignedSeatNumbers,
  required NumberFormat priceFormat,
  required ValueChanged<SeatInfo> onSeatTapped,
}) {
  return Expanded(
    child: Row(
      children: [
        for (int index = 0; index < seats.length; index++) ...[
          Expanded(
            child: _SeatButton(
              seat: seats[index],
              isActiveSeat: seats[index].seatNumber == activeSeat,
              isSelectedByOther:
                  assignedSeatNumbers.contains(seats[index].seatNumber) &&
                      seats[index].seatNumber != activeSeat,
              priceFormat: priceFormat,
              onTap: () => onSeatTapped(seats[index]),
            ),
          ),
          if (index < seats.length - 1) const SizedBox(width: 8),
        ],
      ],
    ),
  );
}

class _SeatSummaryCard extends StatelessWidget {
  final CheckinBooking booking;
  final Map<int, SeatAssignment> seatSelections;
  final int totalSeatFee;

  const _SeatSummaryCard({
    required this.booking,
    required this.seatSelections,
    required this.totalSeatFee,
  });

  @override
  Widget build(BuildContext context) {
    final currencyFormat = NumberFormat.currency(locale: 'vi_VN', symbol: '₫');
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Tóm tắt ghế ngồi',
            style: TextStyle(
              fontFamily: 'BalooBhaijaan2',
              fontWeight: FontWeight.w700,
              fontSize: 16,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 16),
          for (final passenger in booking.passengers)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      passenger.passengerName,
                      style: const TextStyle(
                        fontFamily: 'BalooBhaijaan2',
                        fontSize: 14,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                  Text(
                    seatSelections[passenger.bookingDetailId]?.seatNumber ??
                        '--',
                    style: const TextStyle(
                      fontFamily: 'BalooBhaijaan2',
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    seatSelections[passenger.bookingDetailId] != null
                        ? currencyFormat.format(
                            seatSelections[passenger.bookingDetailId]!.price)
                        : '-',
                    style: const TextStyle(
                      fontFamily: 'BalooBhaijaan2',
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Phụ thu ghế (tổng)',
                style: TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                currencyFormat.format(totalSeatFee),
                style: const TextStyle(
                  fontFamily: 'BalooBhaijaan2',
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.primaryBlueDark,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SeatSelectionEmptyState extends StatelessWidget {
  const _SeatSelectionEmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Icon(Icons.warning_amber, size: 48, color: AppColors.primaryBlue),
            SizedBox(height: 16),
            Text(
              'Không tìm thấy thông tin hành khách cho mã đặt chỗ này. Vui lòng liên hệ bộ phận hỗ trợ.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
