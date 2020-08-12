import 'package:get/get.dart';
import 'package:strong_buddies_connect/authentication/login_with_phone/models/phone_number_pojo.dart';
import 'service/country_service.dart';

class LoginWithPhoneController extends GetxController {
  final CountryService _repository;
  List<CountryCode> _countries;

  var _filteredList = RxList<CountryCode>([]);
  var currentLocale = CountryCode().obs;
  var _phoneNumber = PhoneNumber().obs;

  LoginWithPhoneController(this._repository) : assert(_repository != null);

  @override
  onInit() async {
    _countries = await _repository.getCountryCodes();
    _filteredList.value = _countries;
    _getCountryCodeBasedInCountryCode();
  }

  void _getCountryCodeBasedInCountryCode() {
    final locale = Get.locale?.countryCode ?? 'CO';
    if (locale == null) return;

    try {
      currentLocale.value = _countries.firstWhere(
          (element) => element.alpha2Code.toLowerCase() == locale.toLowerCase(),
          orElse: () {
        return null;
      });
    } catch (e) {
      print(e);
    }

    print(currentLocale.value);
  }

  void filterList(String value) {
    final filteredList = _countries
        .where((element) =>
            element.name.toLowerCase().contains(value.toLowerCase()))
        .toList();

    _filteredList.value = filteredList;
  }

  List<CountryCode> get filteredList => _filteredList.value;

  PhoneNumber get phoneNumber => _phoneNumber.value;
  set phoneNumber(PhoneNumber number) => _phoneNumber.value = number;

  onClose() async {
    currentLocale?.close();
    _filteredList?.close();
    _phoneNumber?.close();
  }
}
