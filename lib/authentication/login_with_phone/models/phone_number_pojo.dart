class PhoneNumber {
  String phoneNumber;
  String countryCode;
  final _reg = RegExp(r"^\d+$");

  bool _isValidNumber() => phoneNumber != null && _reg.hasMatch(phoneNumber);
  bool _isValidCode() => countryCode != null && countryCode.isNotEmpty;
  bool isValid() => _isValidCode() && _isValidNumber();

  String getFullPhone() => '+$countryCode$phoneNumber';
  String getFormattedPhone() => '+$countryCode-$phoneNumber';
}
