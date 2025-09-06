String formatPrice(double price) {
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
  print('Test price formatting:');
  print('1590000 -> ${formatPrice(1590000)}');
  print('3500000 -> ${formatPrice(3500000)}');
  print('5280000 -> ${formatPrice(5280000)}');
  print('10000000 -> ${formatPrice(10000000)}');
}
