import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:fly_journey/src/features/checkin/data/checkin_repository.dart';
import 'package:fly_journey/src/features/checkin/domain/checkin_models.dart';

class CheckinState {
  final CheckinStep step;
  final bool loading;
  final bool seatMapLoading;
  final bool confirming;
  final CheckinBooking? booking;
  final SeatMapData? seatMap;
  final Map<int, SeatAssignment> seatSelections;
  final int activePassengerIndex;
  final String? errorMessage;
  final String? infoMessage;
  final BoardingPassInfo? boardingPass;
  final bool devSampleActive;

  CheckinState({
    required this.step,
    required this.loading,
    required this.seatMapLoading,
    required this.confirming,
    required this.booking,
    required this.seatMap,
    required this.seatSelections,
    required this.activePassengerIndex,
    required this.errorMessage,
    required this.infoMessage,
    required this.boardingPass,
    required this.devSampleActive,
  });

  factory CheckinState.initial() {
    return CheckinState(
      step: CheckinStep.lookup,
      loading: false,
      seatMapLoading: false,
      confirming: false,
      booking: null,
      seatMap: null,
      seatSelections: const {},
      activePassengerIndex: 0,
      errorMessage: null,
      infoMessage: null,
      boardingPass: null,
      devSampleActive: false,
    );
  }

  CheckinState copyWith({
    CheckinStep? step,
    bool? loading,
    bool? seatMapLoading,
    bool? confirming,
    CheckinBooking? booking,
    SeatMapData? seatMap,
    Map<int, SeatAssignment>? seatSelections,
    int? activePassengerIndex,
    String? errorMessage,
    String? infoMessage,
    BoardingPassInfo? boardingPass,
    bool? devSampleActive,
  }) {
    return CheckinState(
      step: step ?? this.step,
      loading: loading ?? this.loading,
      seatMapLoading: seatMapLoading ?? this.seatMapLoading,
      confirming: confirming ?? this.confirming,
      booking: booking ?? this.booking,
      seatMap: seatMap ?? this.seatMap,
      seatSelections: seatSelections ?? this.seatSelections,
      activePassengerIndex: activePassengerIndex ?? this.activePassengerIndex,
      errorMessage: errorMessage,
      infoMessage: infoMessage,
      boardingPass: boardingPass ?? this.boardingPass,
      devSampleActive: devSampleActive ?? this.devSampleActive,
    );
  }

  CheckinPassenger? get activePassenger {
    if (booking == null ||
        activePassengerIndex < 0 ||
        activePassengerIndex >= booking!.passengers.length) {
      return null;
    }
    return booking!.passengers[activePassengerIndex];
  }

  bool get hasSeatForAllPassengers {
    if (booking == null) return false;
    if (booking!.passengers.isEmpty) return false;
    for (final passenger in booking!.passengers) {
      if (!(seatSelections[passenger.bookingDetailId]?.seatNumber.isNotEmpty ??
          false)) {
        return false;
      }
    }
    return true;
  }

  int get totalSeatFee {
    int total = 0;
    for (final entry in seatSelections.values) {
      total += entry.price;
    }
    return total;
  }
}

class CheckinCubit extends Cubit<CheckinState> {
  CheckinCubit() : super(CheckinState.initial());

  Future<void> submitLookup({
    required String pnrCode,
    required String email,
    required String fullName,
  }) async {
    emit(state.copyWith(loading: true, errorMessage: null, infoMessage: null));

    try {
      final booking = await CheckinRepository.validateBooking(
        pnrCode: pnrCode,
        email: email,
        fullName: fullName,
      );

      emit(state.copyWith(
        step: CheckinStep.seatSelection,
        loading: false,
        booking: booking,
        seatSelections: {},
        activePassengerIndex: 0,
        devSampleActive: false,
        infoMessage: 'Vui lòng chọn ghế cho hành khách',
      ));

      await _loadSeatMap(booking.flightId);
    } catch (e) {
      emit(state.copyWith(
        loading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> useDevSample() async {
    emit(state.copyWith(loading: true, errorMessage: null, infoMessage: null));

    try {
      final booking = await CheckinRepository.loadDevSampleBooking();
      emit(state.copyWith(
        step: CheckinStep.seatSelection,
        loading: false,
        booking: booking,
        seatSelections: {},
        activePassengerIndex: 0,
        devSampleActive: true,
        infoMessage: 'Đang sử dụng dữ liệu mẫu cho kiểm thử',
      ));
      await _loadSeatMap(booking.flightId);
    } catch (e) {
      emit(state.copyWith(
        loading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  Future<void> _loadSeatMap(int flightId) async {
    emit(state.copyWith(seatMapLoading: true, errorMessage: null));
    try {
      final seatMap = await CheckinRepository.fetchSeatMap(flightId);
      emit(state.copyWith(
        seatMap: seatMap,
        seatMapLoading: false,
        infoMessage: 'Hãy chọn ghế phù hợp cho từng hành khách',
      ));
    } catch (e) {
      emit(state.copyWith(
        seatMapLoading: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void changeActivePassenger(int index) {
    if (state.booking == null) return;
    if (index < 0 || index >= state.booking!.passengers.length) return;
    emit(state.copyWith(
        activePassengerIndex: index, infoMessage: null, errorMessage: null));
  }

  void selectSeat(SeatInfo seat) {
    if (state.step != CheckinStep.seatSelection) return;
    final booking = state.booking;
    final SeatMapData? seatMap = state.seatMap;
    if (booking == null || seatMap == null) return;

    final passenger = state.activePassenger;
    if (passenger == null) {
      emit(state.copyWith(errorMessage: 'Không tìm thấy thông tin hành khách'));
      return;
    }

    if (seat.status == SeatStatus.occupied ||
        seat.status == SeatStatus.unavailable) {
      emit(state.copyWith(
          errorMessage: 'Ghế này đã được chọn hoặc không khả dụng'));
      return;
    }

    final alreadyAssignedToOther = state.seatSelections.entries.any((entry) {
      return entry.value.seatNumber == seat.seatNumber &&
          entry.key != passenger.bookingDetailId;
    });

    if (alreadyAssignedToOther) {
      emit(state.copyWith(
          errorMessage: 'Ghế này đã được chọn cho hành khách khác'));
      return;
    }

    final currentAssignment = state.seatSelections[passenger.bookingDetailId];

    Map<int, SeatAssignment> updatedSelections =
        Map<int, SeatAssignment>.from(state.seatSelections);

    if (currentAssignment?.seatNumber == seat.seatNumber) {
      updatedSelections.remove(passenger.bookingDetailId);
      emit(state.copyWith(
        seatSelections: updatedSelections,
        infoMessage: 'Đã bỏ chọn ghế ${seat.seatNumber}',
        errorMessage: null,
      ));
      return;
    }

    final price = seatMap.seatPrices[seat.seatNumber] ?? seat.price;
    updatedSelections[passenger.bookingDetailId] = SeatAssignment(
      bookingDetailId: passenger.bookingDetailId,
      seatNumber: seat.seatNumber,
      price: price,
    );

    emit(state.copyWith(
      seatSelections: updatedSelections,
      infoMessage:
          'Đã chọn ghế ${seat.seatNumber} cho ${passenger.passengerName}',
      errorMessage: null,
    ));
  }

  Future<void> confirmSelection() async {
    if (state.booking == null) {
      emit(state.copyWith(errorMessage: 'Không có thông tin đặt chỗ'));
      return;
    }

    if (!state.hasSeatForAllPassengers) {
      emit(state.copyWith(
          errorMessage: 'Vui lòng chọn ghế cho tất cả hành khách'));
      return;
    }

    emit(state.copyWith(
        confirming: true, errorMessage: null, infoMessage: null));

    try {
      final assignments = state.seatSelections.values.toList();
      for (final assignment in assignments) {
        await CheckinRepository.confirmSeat(
          pnrCode: state.booking!.bookingCode,
          seat: assignment,
        );
      }

      final updatedPassengers = state.booking!.passengers.map((passenger) {
        final assignment = state.seatSelections[passenger.bookingDetailId];
        if (assignment == null) return passenger;
        return passenger.copyWith(
          seatNumber: assignment.seatNumber,
          isCheckedIn: true,
        );
      }).toList();

      final updatedBooking =
          state.booking!.copyWith(passengers: updatedPassengers);

      final boardingPass = BoardingPassInfo(
        booking: updatedBooking,
        seats: assignments,
      );

      emit(state.copyWith(
        confirming: false,
        step: CheckinStep.success,
        boardingPass: boardingPass,
        booking: updatedBooking,
        infoMessage: 'Check-in thành công',
      ));
    } catch (e) {
      emit(state.copyWith(
        confirming: false,
        errorMessage: e.toString(),
      ));
    }
  }

  void reset() {
    emit(CheckinState.initial());
  }

  void clearMessages() {
    if (state.errorMessage != null || state.infoMessage != null) {
      emit(state.copyWith(errorMessage: null, infoMessage: null));
    }
  }
}
