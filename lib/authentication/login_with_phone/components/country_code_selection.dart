import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:strong_buddies_connect/authentication/login_with_phone/service/country_service.dart';

class CountryCodeSelection extends StatefulWidget {
  final void Function(String) onChange;
  const CountryCodeSelection({
    Key key,
    this.onChange,
  }) : super(key: key);

  @override
  _CountryCodeSelectionState createState() => _CountryCodeSelectionState();
}

class _CountryCodeSelectionState extends State<CountryCodeSelection> {
  final country = CountryService();
  String selectedCountry;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(6),
      ),
      alignment: Alignment.center,
      child: FutureBuilder<List<CountryCode>>(
          future: country.getCountryCodes(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            return DropdownButtonFormField<String>(
              validator: (value) {
                if (value == null || value.isEmpty)
                  return 'Please, select your country code';
                return null;
              },
              isExpanded: true,
              iconEnabledColor: Color(0xfff1806b),
              hint: const Center(child: const Text('Enter your country code')),
              style: TextStyle(
                fontSize: ScreenUtil().setSp(15),
                color: Color(0xfff1806b),
                letterSpacing: 0.5,
              ),
              selectedItemBuilder: (BuildContext context) {
                return snapshot.data
                    .map<Widget>((item) =>
                        Center(child: Text('+${item.callingCodes.first}')))
                    .toList();
              },
              onChanged: (selected) {
                setState(() => selectedCountry = selected);
                widget.onChange(selected);
              },
              value: selectedCountry,
              items: snapshot.data
                  .map((countryCode) => DropdownMenuItem<String>(
                      value: countryCode.callingCodes.first,
                      child: Text(countryCode.name)))
                  .toList(),
            );
          }),
    );
  }
}
