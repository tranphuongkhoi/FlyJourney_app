import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fly_journey/src/core/constants/colors.dart';
import 'package:fly_journey/src/core/config/dev_config.dart';
import 'package:fly_journey/src/features/checkin/domain/checkin_models.dart';
import 'package:fly_journey/src/features/checkin/presentation/cubit/checkin_cubit.dart';
import 'package:fly_journey/src/features/checkin/presentation/widgets/boarding_pass_view.dart';
import 'package:fly_journey/src/features/checkin/presentation/widgets/checkin_form.dart';
import 'package:fly_journey/src/features/checkin/presentation/widgets/seat_selection_view.dart';

class CheckinScreen extends StatelessWidget {
  const CheckinScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CheckinCubit(),
      child: const _CheckinView(),
    );
  }
}

class _CheckinView extends StatefulWidget {
  const _CheckinView();

  @override
  State<_CheckinView> createState() => _CheckinViewState();
}

class _CheckinViewState extends State<_CheckinView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: const Text(
          'Check-in Online',
          style: TextStyle(
            fontFamily: 'BalooBhaijaan2',
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
          ),
        ),
        centerTitle: false,
      ),
      body: BlocConsumer<CheckinCubit, CheckinState>(
        listenWhen: (previous, current) =>
            previous.errorMessage != current.errorMessage ||
            previous.infoMessage != current.infoMessage,
        listener: (context, state) {
          if (state.errorMessage != null && state.errorMessage!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.errorMessage!),
                backgroundColor: Colors.redAccent,
              ),
            );
          } else if (state.infoMessage != null &&
              state.infoMessage!.isNotEmpty) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.infoMessage!),
                backgroundColor: AppColors.primaryBlue,
              ),
            );
          }
          context.read<CheckinCubit>().clearMessages();
        },
        builder: (context, state) {
          return Stack(
            children: [
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 250),
                child: _buildContentForState(context, state),
              ),
              if (state.loading || state.seatMapLoading || state.confirming)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.05),
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildContentForState(BuildContext context, CheckinState state) {
    switch (state.step) {
      case CheckinStep.lookup:
        return CheckinForm(
          onSubmit: (pnr, email, fullName) =>
              context.read<CheckinCubit>().submitLookup(
                    pnrCode: pnr,
                    email: email,
                    fullName: fullName,
                  ),
          onUseDevSample: DevConfig.showDevTestUI
              ? () => context.read<CheckinCubit>().useDevSample()
              : null,
        );
      case CheckinStep.seatSelection:
        if (state.booking == null) {
          return const _CenteredMessage(
            icon: Icons.info_outline,
            message: 'Không có dữ liệu đặt chỗ. Vui lòng thử lại.',
          );
        }
        return SeatSelectionView(
          booking: state.booking!,
          seatMap: state.seatMap,
          seatSelections: state.seatSelections,
          activePassengerIndex: state.activePassengerIndex,
          onSeatTapped: (seat) => context.read<CheckinCubit>().selectSeat(seat),
          onPassengerChanged: (index) =>
              context.read<CheckinCubit>().changeActivePassenger(index),
          onConfirm: () => context.read<CheckinCubit>().confirmSelection(),
          devSampleActive: state.devSampleActive,
          totalSeatFee: state.totalSeatFee,
          hasSeatsForAllPassengers: state.hasSeatForAllPassengers,
        );
      case CheckinStep.success:
        if (state.boardingPass == null) {
          return const _CenteredMessage(
            icon: Icons.check_circle_outline,
            message: 'Check-in đã hoàn tất!',
          );
        }
        return BoardingPassView(
          boardingPass: state.boardingPass!,
          onDone: () => context.read<CheckinCubit>().reset(),
        );
    }
  }
}

class _CenteredMessage extends StatelessWidget {
  final IconData icon;
  final String message;

  const _CenteredMessage({
    required this.icon,
    required this.message,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: AppColors.primaryBlue),
            const SizedBox(height: 16),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontFamily: 'BalooBhaijaan2',
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
