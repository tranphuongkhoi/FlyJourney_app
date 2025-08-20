import 'package:flutter/material.dart';
import 'package:cnh_n/models/flight.dart';
import 'package:cnh_n/utils/format.dart';

class FlightCard extends StatelessWidget {
  final Flight flight;
  final VoidCallback? onTap;
  final bool dense;

  const FlightCard({
    super.key,
    required this.flight,
    this.onTap,
    this.dense = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    Widget pricePill = Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: cs.primaryContainer,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        formatVND(flight.price),
        style: Theme.of(context).textTheme.labelLarge?.copyWith(
              color: cs.onPrimaryContainer,
              fontWeight: FontWeight.w800,
            ),
      ),
    );

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Ink(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 6),
            )
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 18,
                    backgroundColor: cs.primaryContainer,
                    child: Text(
                      flight.airline.isNotEmpty ? flight.airline[0] : 'A',
                      style: TextStyle(color: cs.onPrimaryContainer, fontWeight: FontWeight.w800),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      flight.airline,
                      style: Theme.of(context).textTheme.titleMedium,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  pricePill,
                ],
              ),
              const SizedBox(height: 16),
              _routeRow(context),
              const SizedBox(height: 12),
              _metaRow(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _routeRow(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        _timeAndCode(context, formatTime(flight.departureTime), flight.departure.code),
        Expanded(
          child: Column(
            children: [
              Container(height: 2, decoration: BoxDecoration(color: cs.outline.withOpacity(.5), borderRadius: BorderRadius.circular(2))),
              const SizedBox(height: 2),
              Text(formatDuration(flight.arrivalTime.difference(flight.departureTime)), style: Theme.of(context).textTheme.bodyMedium),
            ],
          ),
        ),
        _timeAndCode(context, formatTime(flight.arrivalTime), flight.arrival.code),
      ],
    );
  }

  Widget _timeAndCode(BuildContext context, String time, String code) {
    final t = Theme.of(context);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(time, style: t.textTheme.headlineMedium?.copyWith(letterSpacing: -0.4)),
        const SizedBox(height: 2),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: t.colorScheme.secondaryContainer,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(code, style: t.textTheme.labelLarge),
        ),
      ],
    );
  }

  Widget _metaRow(BuildContext context) {
    final t = Theme.of(context);
    return Row(
      children: [
        _chip(context, Icons.event, DateFormat('EEE, dd MMM', 'vi_VN').format(flight.departureTime)),
        const SizedBox(width: 8),
        _chip(context, Icons.airline_seat_recline_normal, '${flight.seatsLeft} chỗ còn lại'),
        const SizedBox(width: 8),
        if (flight.stops > 0) _chip(context, Icons.route, '${flight.stops} điểm dừng') else _chip(context, Icons.bolt, 'Bay thẳng'),
      ],
    );
  }

  Widget _chip(BuildContext context, IconData icon, String label) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: cs.surface,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: cs.outline.withOpacity(.4)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: cs.onSurface.withOpacity(.7)),
          const SizedBox(width: 6),
          Text(label, style: Theme.of(context).textTheme.labelLarge),
        ],
      ),
    );
  }
}
