class FareClassDetails {
  final String fareClassCode;
  final String cabinClass;
  final bool refundable;
  final bool changeable;
  final String baggageKg;
  final String description;
  final String refundChangePolicy;

  const FareClassDetails({
    required this.fareClassCode,
    required this.cabinClass,
    required this.refundable,
    required this.changeable,
    required this.baggageKg,
    required this.description,
    required this.refundChangePolicy,
  });

  factory FareClassDetails.fromJson(Map<String, dynamic> json) => FareClassDetails(
        fareClassCode: json['fare_class_code'] ?? '',
        cabinClass: json['cabin_class'] ?? '',
        refundable: json['refundable'] ?? false,
        changeable: json['changeable'] ?? false,
        baggageKg: json['baggage_kg'] ?? '',
        description: json['description'] ?? '',
        refundChangePolicy: json['refund_change_policy'] ?? '',
      );

  Map<String, dynamic> toJson() => {
        'fare_class_code': fareClassCode,
        'cabin_class': cabinClass,
        'refundable': refundable,
        'changeable': changeable,
        'baggage_kg': baggageKg,
        'description': description,
        'refund_change_policy': refundChangePolicy,
      };
}
