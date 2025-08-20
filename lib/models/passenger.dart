class Passenger {
  final String firstName;
  final String lastName;
  final String idNumber;
  final String idType;
  final DateTime dateOfBirth;
  final String gender;
  final String email;
  final String phone;

  const Passenger({
    required this.firstName,
    required this.lastName,
    required this.idNumber,
    required this.idType,
    required this.dateOfBirth,
    required this.gender,
    required this.email,
    required this.phone,
  });

  String get fullName => '$firstName $lastName';

  factory Passenger.fromJson(Map<String, dynamic> json) => Passenger(
        firstName: json['firstName'],
        lastName: json['lastName'],
        idNumber: json['idNumber'],
        idType: json['idType'],
        dateOfBirth: DateTime.parse(json['dateOfBirth']),
        gender: json['gender'],
        email: json['email'],
        phone: json['phone'],
      );

  Map<String, dynamic> toJson() => {
        'firstName': firstName,
        'lastName': lastName,
        'idNumber': idNumber,
        'idType': idType,
        'dateOfBirth': dateOfBirth.toIso8601String(),
        'gender': gender,
        'email': email,
        'phone': phone,
      };
}