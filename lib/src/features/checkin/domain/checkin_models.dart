enum CheckinStep { lookup, seatSelection, success }

enum SeatStatus { available, selected, occupied, unavailable }

enum SeatCabinClass { economy, premium, business, first }

class CheckinPassenger {
  final int bookingDetailId;
  final String passengerName;
  final int passengerAge;
  final String passengerGender;
  final String flightClassName;
  final String? seatNumber;
  final bool isCheckedIn;
  final String idNumber;
  final String idType;

  CheckinPassenger({
    required this.bookingDetailId,
    required this.passengerName,
    required this.passengerAge,
    required this.passengerGender,
    required this.flightClassName,
    required this.seatNumber,
    required this.isCheckedIn,
    required this.idNumber,
    required this.idType,
  });

  CheckinPassenger copyWith({
    String? seatNumber,
    bool? isCheckedIn,
  }) {
    return CheckinPassenger(
      bookingDetailId: bookingDetailId,
      passengerName: passengerName,
      passengerAge: passengerAge,
      passengerGender: passengerGender,
      flightClassName: flightClassName,
      seatNumber: seatNumber ?? this.seatNumber,
      isCheckedIn: isCheckedIn ?? this.isCheckedIn,
      idNumber: idNumber,
      idType: idType,
    );
  }
}

class CheckinBooking {
  final String bookingCode;
  final int flightId;
  final String flightNumber;
  final DateTime departureTime;
  final DateTime arrivalTime;
  final String departureAirport;
  final String arrivalAirport;
  final String airlineName;
  final String flightClass;
  final List<CheckinPassenger> passengers;

  const CheckinBooking({
    required this.bookingCode,
    required this.flightId,
    required this.flightNumber,
    required this.departureTime,
    required this.arrivalTime,
    required this.departureAirport,
    required this.arrivalAirport,
    required this.airlineName,
    required this.flightClass,
    required this.passengers,
  });

  CheckinPassenger? passengerById(int bookingDetailId) {
    for (final passenger in passengers) {
      if (passenger.bookingDetailId == bookingDetailId) {
        return passenger;
      }
    }
    return null;
  }

  CheckinBooking copyWith({
    List<CheckinPassenger>? passengers,
  }) {
    return CheckinBooking(
      bookingCode: bookingCode,
      flightId: flightId,
      flightNumber: flightNumber,
      departureTime: departureTime,
      arrivalTime: arrivalTime,
      departureAirport: departureAirport,
      arrivalAirport: arrivalAirport,
      airlineName: airlineName,
      flightClass: flightClass,
      passengers: passengers ?? this.passengers,
    );
  }
}

class SeatInfo {
  final int row;
  final String seatLetter;
  final SeatStatus status;
  final int price;
  final SeatCabinClass seatClass;
  final bool isExitRow;
  final bool isExtraLegroom;
  final bool isBlocked;

  SeatInfo({
    required this.row,
    required this.seatLetter,
    required this.status,
    required this.price,
    required this.seatClass,
    required this.isExitRow,
    required this.isExtraLegroom,
    required this.isBlocked,
  });

  String get seatNumber => '${row.toString()}$seatLetter';

  SeatInfo copyWith({
    SeatStatus? status,
    int? price,
  }) {
    return SeatInfo(
      row: row,
      seatLetter: seatLetter,
      status: status ?? this.status,
      price: price ?? this.price,
      seatClass: seatClass,
      isExitRow: isExitRow,
      isExtraLegroom: isExtraLegroom,
      isBlocked: isBlocked,
    );
  }
}

class SeatRow {
  final int rowNumber;
  final List<SeatInfo> seats;

  SeatRow({
    required this.rowNumber,
    required this.seats,
  });
}

class SeatMapData {
  final List<SeatRow> rows;
  final Set<String> confirmedSeats;
  final Map<String, int> seatPrices;

  SeatMapData({
    required this.rows,
    required this.confirmedSeats,
    required this.seatPrices,
  });

  SeatInfo? seatByNumber(String seatNumber) {
    for (final row in rows) {
      for (final seat in row.seats) {
        if (seat.seatNumber == seatNumber) {
          return seat;
        }
      }
    }
    return null;
  }
}

class SeatAssignment {
  final int bookingDetailId;
  final String seatNumber;
  final int price;

  const SeatAssignment({
    required this.bookingDetailId,
    required this.seatNumber,
    required this.price,
  });
}

class BoardingPassInfo {
  final CheckinBooking booking;
  final List<SeatAssignment> seats;

  BoardingPassInfo({
    required this.booking,
    required this.seats,
  });

  String get flightRoute =>
      '${booking.departureAirport} → ${booking.arrivalAirport}';
  String get airline => booking.airlineName;
  String get flightNumber => booking.flightNumber;
}
