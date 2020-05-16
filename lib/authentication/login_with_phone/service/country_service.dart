import 'package:http/http.dart' as http;
import 'dart:convert';

class CountryCode {
  String name;
  List<String> callingCodes;

  CountryCode({this.name, this.callingCodes});

  CountryCode.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    callingCodes = json['callingCodes'].cast<String>();
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['callingCodes'] = this.callingCodes;
    return data;
  }
}

class CountryService {
  List<CountryCode> countryCodes;

  CountryService();

  Future<List<CountryCode>> getCountryCodes() async {
    if (countryCodes != null) return Future.value(countryCodes);
    final response = await http
        .get('https://restcountries.eu/rest/v2/all?fields=name;callingCodes');
    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      countryCodes = list.map((model) => CountryCode.fromJson(model)).toList();
      return countryCodes;
    } else {
      return [];
    }
  }
}
