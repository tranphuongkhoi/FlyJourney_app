class BaggageOption {
  final String id;
  final String label;
  final int extraKg;
  final int price; // VND, per passenger

  const BaggageOption({
    required this.id,
    required this.label,
    required this.extraKg,
    required this.price,
  });
}

class BaggageOptions {
  // Synced with smt.md
  static const List<BaggageOption> all = [
    BaggageOption(id: 'none', label: 'Không mua thêm', extraKg: 0, price: 0),
    BaggageOption(id: 'bg10', label: '+10kg ký gửi', extraKg: 10, price: 190000),
    BaggageOption(id: 'bg15', label: '+15kg ký gửi', extraKg: 15, price: 260000),
    BaggageOption(id: 'bg20', label: '+20kg ký gửi', extraKg: 20, price: 330000),
  ];

  static BaggageOption byId(String id) =>
      all.firstWhere((o) => o.id == id, orElse: () => all.first);
}

