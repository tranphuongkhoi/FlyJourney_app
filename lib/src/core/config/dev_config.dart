class DevConfig {
  // true = production mode (no past dates). false = dev (allow past dates)
  static const bool productionMode = false;

  // Allow selecting dates in the past when not in production
  static bool get allowPastDates => !productionMode;

  // Earliest date allowed in dev
  static DateTime get earliestDate =>
      DateTime.now().subtract(const Duration(days: 365));

  // Passenger constraints
  static const int maxTotalPassengers = 8; // adults + children + infants

  // Show Dev Test helpers in UI (autofill, etc.)
  static bool get showDevTestUI => !productionMode;
}
