import 'package:flutter/material.dart';
import 'dart:convert';

class CountryCode {
  String flag;
  String name;
  String alpha2Code;
  List<String> callingCodes;

  CountryCode({this.flag, this.name, this.alpha2Code, this.callingCodes});

  CountryCode.fromJson(Map<String, dynamic> json) {
    flag = json['flag'];
    name = json['name'];
    alpha2Code = json['alpha2Code'];
    callingCodes = List<String>.from(json['callingCodes']);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['flag'] = this.flag;
    data['name'] = this.name;
    data['alpha2Code'] = this.alpha2Code;
    data['callingCodes'] = this.callingCodes;
    return data;
  }
}

class CountryService {
  final _assetLocation = 'assets/json/country.json';
  final BuildContext _context;

  List<CountryCode> _countryCodes;

  CountryService(this._context);

  Future<List<CountryCode>> getCountryCodes() async {
    if (_countryCodes != null) return _countryCodes;

    try {
      final countriesData =
          await DefaultAssetBundle.of(_context).loadString(_assetLocation);

      final jsonResult = json.decode(countriesData);
      _countryCodes = List<Map>.from(jsonResult)
          .map((e) => CountryCode.fromJson(e))
          .where((element) => element.callingCodes.first.isNotEmpty)
          .toList();
      return _countryCodes;
    } catch (e) {
      return [];
    }
  }
}
