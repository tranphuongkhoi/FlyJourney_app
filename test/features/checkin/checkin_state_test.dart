import 'package:flutter_test/flutter_test.dart';

import 'package:fly_journey/src/features/checkin/domain/checkin_models.dart';
import 'package:fly_journey/src/features/checkin/presentation/cubit/checkin_cubit.dart';

void main() {
  group('CheckinState', () {
    test('hasSeatForAllPassengers returns false when booking is null', () {
      final state = CheckinState.initial();
      expect(state.hasSeatForAllPassengers, isFalse);
    });

    test('hasSeatForAllPassengers returns true when every passenger has a seat',
        () {
      final booking = CheckinBooking(
        bookingCode: 'PNR123',
        flightId: 1,
        flightNumber: 'FJ101',
        departureTime: DateTime.utc(2025, 8, 20, 14, 45),
        arrivalTime: DateTime.utc(2025, 8, 20, 17, 0),
        departureAirport: 'HAN',
        arrivalAirport: 'SGN',
        airlineName: 'Fly Journey',
        flightClass: 'economy',
        passengers: [
          CheckinPassenger(
            bookingDetailId: 1,
            passengerName: 'Passenger 1',
            passengerAge: 25,
            passengerGender: 'male',
            flightClassName: 'economy',
            seatNumber: null,
            isCheckedIn: false,
            idNumber: '123',
            idType: 'citizen_id',
          ),
          CheckinPassenger(
            bookingDetailId: 2,
            passengerName: 'Passenger 2',
            passengerAge: 24,
            passengerGender: 'female',
            flightClassName: 'economy',
            seatNumber: null,
            isCheckedIn: false,
            idNumber: '456',
            idType: 'citizen_id',
          ),
        ],
      );

      final state = CheckinState.initial().copyWith(
        booking: booking,
        seatSelections: {
          1: const SeatAssignment(
              bookingDetailId: 1, seatNumber: '12A', price: 150000),
          2: const SeatAssignment(
              bookingDetailId: 2, seatNumber: '12B', price: 150000),
        },
      );

      expect(state.hasSeatForAllPassengers, isTrue);
    });

    test('totalSeatFee sums seat assignment prices', () {
      final state = CheckinState.initial().copyWith(
        seatSelections: {
          1: const SeatAssignment(
              bookingDetailId: 1, seatNumber: '12A', price: 150000),
          2: const SeatAssignment(
              bookingDetailId: 2, seatNumber: '12B', price: 180000),
        },
      );
      expect(state.totalSeatFee, 330000);
    });
  });
}
