class PassengerInfo {
  String lastName = '';
  String firstName = '';
  DateTime? dateOfBirth;
  String gender = '';
  String nationality = 'Việt Nam';
  String phoneNumber = '';
  String documentType = '';
  String documentNumber = '';
  DateTime? documentExpiry;
  String extraBaggage = '';
  String passengerType = '';
  bool isBooker;
  
  PassengerInfo({this.isBooker = false});
  
  bool isValid() {
    bool basicValid = lastName.isNotEmpty &&
        firstName.isNotEmpty &&
        dateOfBirth != null &&
        gender.isNotEmpty &&
        nationality.isNotEmpty &&
        documentType.isNotEmpty &&
        documentNumber.isNotEmpty;
    
    if (isBooker) {
      basicValid = basicValid && phoneNumber.isNotEmpty;
    }
    
    if (documentType == 'Hộ chiếu') {
      basicValid = basicValid && documentExpiry != null;
    }
    
    return basicValid;
  }
}

class ContactInfo {
  String address = '';
  String email = '';
  
  bool isValid() {
    return address.isNotEmpty && email.isNotEmpty && email.contains('@');
  }
}
