class Airport {
  final String code;
  final String name;
  final String city;
  final String country;

  const Airport({
    required this.code,
    required this.name,
    required this.city,
    required this.country,
  });

  factory Airport.fromJson(Map<String, dynamic> json) => Airport(
        code: json['code'],
        name: json['name'],
        city: json['city'],
        country: json['country'],
      );

  Map<String, dynamic> toJson() => {
        'code': code,
        'name': name,
        'city': city,
        'country': country,
      };
}
