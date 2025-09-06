String formatPrice(num price) {
  // Convert to int to avoid decimal issues
  int priceInt = price.round();
  
  // Format with Vietnamese number format: 1.590.000 VND
  String priceString = priceInt.toString();
  
  // Add dots every 3 digits from the right
  String formatted = '';
  for (int i = 0; i < priceString.length; i++) {
    if (i > 0 && (priceString.length - i) % 3 == 0) {
      formatted += '.';
    }
    formatted += priceString[i];
  }
  
  return '$formatted VND';
}

void main() {
  print('Test price formatting with int and double:');
  
  // Test with int
  int intPrice = 1590000;
  print('int: $intPrice -> ${formatPrice(intPrice)}');
  
  // Test with double
  double doublePrice = 1590000.0;
  print('double: $doublePrice -> ${formatPrice(doublePrice)}');
  
  // Test with calculation result (int * int)
  int basePrice = 1590000;
  int passengers = 2;
  int totalPrice = basePrice * passengers;
  print('calculation (int * int): $totalPrice -> ${formatPrice(totalPrice)}');
}
