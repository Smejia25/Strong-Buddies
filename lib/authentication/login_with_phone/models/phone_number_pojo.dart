class PhoneNumber {
  String phoneNumber;
  String countryCode;

  String getFullPhone() {
    return '+$countryCode$phoneNumber';
  }
}
