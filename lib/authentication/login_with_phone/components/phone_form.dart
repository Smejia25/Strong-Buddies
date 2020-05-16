import 'package:firebase_auth/firebase_auth.dart';
import 'package:strong_buddies_connect/authentication/login_with_phone/models/phone_number_pojo.dart';
import 'package:strong_buddies_connect/shared/components/primary_button.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:strong_buddies_connect/shared/services/auth/auth_service.dart';
import 'country_code_selection.dart';

class PhoneForm extends StatefulWidget {
  final void Function(String verificationId) onCodeSent;
  final void Function(AuthResult) onSucessfulLogin;
  final AuthService auth;

  const PhoneForm({
    Key key,
    this.auth,
    this.onCodeSent,
    this.onSucessfulLogin,
  }) : super(key: key);

  @override
  _PhoneFormState createState() => _PhoneFormState();
}

class _PhoneFormState extends State<PhoneForm> {
  final _formkey = GlobalKey<FormState>();
  final _phoneData = PhoneNumber();
  String _error;
  bool _loginInProcess;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Form(
            key: _formkey,
            child: Column(
              children: <Widget>[
                CountryCodeSelection(
                  onChange: (countryCode) =>
                      _phoneData.countryCode = countryCode,
                ),
                SizedBox(height: ScreenUtil().setHeight(10)),
                TextFormField(
                  style: TextStyle(
                    fontSize: ScreenUtil().setSp(15),
                    color: Color(0xfff1806b),
                    letterSpacing: 0.5,
                  ),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.only(
                      bottom: 15,
                      left: 10,
                      right: 10,
                    ),
                  ),
                  textAlignVertical: TextAlignVertical.center,
                  textAlign: TextAlign.center,
                  onSaved: (value) => _phoneData.phoneNumber = value,
                  keyboardType: TextInputType.phone,
                  validator: (value) {
                    if (value.isEmpty) return 'Please, enter your phone number';
                    return null;
                  },
                ),
              ],
            ),
          ),
          SizedBox(height: ScreenUtil().setHeight(40)),
          AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: _error != null
                  ? Text(_error,
                      style: TextStyle(
                          height: 1.29,
                          letterSpacing: -0.41,
                          fontSize: 15,
                          color: Colors.redAccent))
                  : Text(
                      'Please, enter your number. You would recieve a SMS with a code',
                      style: TextStyle(
                          height: 1.29,
                          letterSpacing: -0.41,
                          fontSize: 15,
                          color: Colors.white))),
          SizedBox(height: ScreenUtil().setHeight(40)),
          PrimaryButton.text(
            text: 'Submit your number',
            onTap: () async {
              final FormState form = _formkey.currentState;
              if (!form.validate()) return;

              form.save();
              final phoneNumber = _phoneData.getFullPhone();

              await widget.auth.verifyPhone(
                phoneNumber,
                onLoginSucessful: widget.onSucessfulLogin,
                codeSent: (verificationId, [_]) =>
                    widget.onCodeSent(verificationId),
                codeAutoRetrievalTimeout: (ms) {},
                verificationFailed: (exc) => setState(() => _error =
                    "There was an error sending you the verification code, check your phone is written properly and the code country is the correct one. If the error persist try login with Facebook or google"),
              );
            },
          ),
        ],
      ),
    );
  }
}
