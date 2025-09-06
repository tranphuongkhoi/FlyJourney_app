class Pricing {
  final BasePrices basePrices;
  final TotalPrices totalPrices;
  final Map<String, double> taxes;
  final double grandTotal;
  final String currency;

  const Pricing({
    required this.basePrices,
    required this.totalPrices,
    required this.taxes,
    required this.grandTotal,
    required this.currency,
  });

  factory Pricing.fromJson(Map<String, dynamic> json) => Pricing(
        basePrices: BasePrices.fromJson(json['base_prices'] ?? {}),
        totalPrices: TotalPrices.fromJson(json['total_prices'] ?? {}),
        taxes: Map<String, double>.from(
          (json['taxes'] ?? {}).map((key, value) => MapEntry(key, value?.toDouble() ?? 0.0))
        ),
        grandTotal: (json['grand_total'] ?? 0).toDouble(),
        currency: json['currency'] ?? 'VND',
      );

  Map<String, dynamic> toJson() => {
        'base_prices': basePrices.toJson(),
        'total_prices': totalPrices.toJson(),
        'taxes': taxes,
        'grand_total': grandTotal,
        'currency': currency,
      };
}

class BasePrices {
  final double adult;
  final double child;
  final double infant;

  const BasePrices({
    required this.adult,
    required this.child,
    required this.infant,
  });

  factory BasePrices.fromJson(Map<String, dynamic> json) => BasePrices(
        adult: (json['adult'] ?? 0).toDouble(),
        child: (json['child'] ?? 0).toDouble(),
        infant: (json['infant'] ?? 0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'adult': adult,
        'child': child,
        'infant': infant,
      };
}

class TotalPrices {
  final double adult;
  final double child;
  final double infant;

  const TotalPrices({
    required this.adult,
    required this.child,
    required this.infant,
  });

  factory TotalPrices.fromJson(Map<String, dynamic> json) => TotalPrices(
        adult: (json['adult'] ?? 0).toDouble(),
        child: (json['child'] ?? 0).toDouble(),
        infant: (json['infant'] ?? 0).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'adult': adult,
        'child': child,
        'infant': infant,
      };
}
