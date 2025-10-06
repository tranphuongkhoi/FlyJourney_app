class Airline {
  final int id;
  final String name;
  final String logo; // Flutter asset path under assets/airlines

  const Airline({required this.id, required this.name, required this.logo});
}

// Centralized list of airlines, mirroring FE's airlines.ts
const List<Airline> kAirlines = [
  Airline(id: 1, name: 'Vietnam Airlines', logo: 'assets/airlines/vietnam-airlines.png'),
  Airline(id: 2, name: 'VietJet Air', logo: 'assets/airlines/vietjet-airlines.png'),
  Airline(id: 3, name: 'Pacific Airlines', logo: 'assets/airlines/pacific-airlines.png'),
  Airline(id: 4, name: 'Bamboo Airways', logo: 'assets/airlines/bamboo-airlines.png'),
  Airline(id: 5, name: 'Vietravel Airlines', logo: 'assets/airlines/vietravel-airlines.png'),
  Airline(id: 6, name: 'AirAsia', logo: 'assets/airlines/airasia-airlines.png'),
];

// Quick helpers
Airline? findAirlineByName(String name) {
  try {
    return kAirlines.firstWhere((a) => a.name.toLowerCase() == name.toLowerCase());
  } catch (_) {
    return null;
  }
}

Airline? findAirlineById(int id) {
  try {
    return kAirlines.firstWhere((a) => a.id == id);
  } catch (_) {
    return null;
  }
}
