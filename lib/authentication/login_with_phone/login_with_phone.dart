import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import 'package:strong_buddies_connect/authentication/login/components/logo.dart';
import 'package:strong_buddies_connect/shared/components/tappable_wrapper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:strong_buddies_connect/shared/services/auth/auth_service.dart';
import 'package:strong_buddies_connect/shared/services/user_collection.dart';
import 'package:strong_buddies_connect/shared/utils/navigation_util.dart';

import 'login_with_phone.controller.dart';
import 'models/phone_number_pojo.dart';
import 'service/country_service.dart';

class LoginWithPhoneNumberPage extends StatefulWidget {
  LoginWithPhoneNumberPage({Key key}) : super(key: key);

  @override
  _LoginWithPhoneNumberPageState createState() =>
      _LoginWithPhoneNumberPageState();
}

class _LoginWithPhoneNumberPageState extends State<LoginWithPhoneNumberPage> {
  LoginWithPhoneController controller;
  final pageViewController = PageController();
  final AuthService _auth = Get.find();
  final UserCollection userRespository = Get.find();
  final FirebaseMessaging _firebaseMessaging = Get.find();

  String _verificationId = '';

  @override
  void initState() {
    super.initState();
    controller = Get.put(LoginWithPhoneController(CountryService(context)));
  }

  Future<void> submitCode(String code) async {
    final result = await _auth.signInWithPhoneNumber(_verificationId, code);
    await handleSucessfulLogin(result);
  }

  Future<void> handleSucessfulLogin(AuthResult result) async {
    final user = await userRespository.getCurrentUserInfo(result.user.uid);
    if (user != null) {
      final token = await _firebaseMessaging.getToken();
      await userRespository.updateNotificationTokens(
        token,
        result.user.uid,
      );
    }
    final routeToNavigateNext = getNavigationRouteBasedOnUserState(user);
    Navigator.pushNamedAndRemoveUntil(
        context, routeToNavigateNext, (_) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Theme(
        data: Theme.of(context).copyWith(
          textTheme: Typography.blackCupertino.copyWith(
            subtitle1: TextStyle(
              fontFamily: 'Ubuntu',
              fontSize: 20,
              height: 1,
              color: Color(0xff4a4a4a),
            ),
            headline3: TextStyle(
              fontFamily: 'Ubuntu',
              color: Color(0xff4a4a4a),
              fontSize: 20,
              height: 1.2,
              fontWeight: FontWeight.bold,
              letterSpacing: -1,
            ),
          ),
          inputDecorationTheme: InputDecorationTheme(
            isDense: true,
            border: InputBorder.none,
            enabledBorder: InputBorder.none,
            focusedBorder: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 7, bottom: 3),
          ),
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Column(children: [
            const ImageLogo(),
            Expanded(
              child: PageView(
                physics: NeverScrollableScrollPhysics(),
                controller: pageViewController,
                children: [
                  PhoneNumberCollector(
                    onSubmitCode: (fullnumber, onError) {
                      controller.phoneNumber = fullnumber;
                      _auth.verifyPhone(
                        fullnumber.getFullPhone(),
                        codeSent: (verificationId, [a]) {
                          _verificationId = verificationId;
                          pageViewController.nextPage(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.easeIn,
                          );
                        },
                        onLoginSucessful: (result) async =>
                            await handleSucessfulLogin(result),
                        verificationFailed: onError,
                      );
                    },
                  ),
                  CodeCollector(
                    onSubmitCode: (code, callbackError) async {
                      try {
                        await submitCode(code);
                      } catch (e) {
                        callbackError(e);
                      }
                    },
                    onResendCode: () {
                      pageViewController.previousPage(
                        duration: Duration(milliseconds: 300),
                        curve: Curves.easeIn,
                      );
                    },
                  )
                ],
              ),
            ),
          ]),
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/summerfield-336672_1920.jpg'),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}

class CodeCollector extends StatefulWidget {
  final void Function(String, void Function(PlatformException err))
      onSubmitCode;
  final VoidCallback onResendCode;

  const CodeCollector({
    Key key,
    this.onSubmitCode,
    this.onResendCode,
  }) : super(key: key);

  @override
  _CodeCollectorState createState() => _CodeCollectorState();
}

class _CodeCollectorState extends State<CodeCollector> {
  final LoginWithPhoneController _controller = Get.find();
  var _code = '';
  var _errorMessage;

  @override
  Widget build(BuildContext context) {
    return LoginWithPhoneCard(
      cardTitle: 'Submit the code',
      errorMessage: _errorMessage,
      hintText:
          'Enter the CODE you recieved by sms on the phone ${_controller.phoneNumber.getFormattedPhone()}',
      input: LoginInput(
          label: 'Code',
          child: TextFormField(
            onChanged: (newValue) {
              _code = newValue;
              if (_errorMessage != null)
                setState(() {
                  _errorMessage = null;
                });
            },
            style: TextStyle(fontSize: 20, height: 1, fontFamily: 'Ubuntu'),
            keyboardType: TextInputType.number,
          )),
      actions: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          FlatButton(
            onPressed: widget.onResendCode,
            child: Text(
              'Resend Code',
              style: TextStyle(color: Colors.red),
            ),
          ),
          FlatButton(
            shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Color(0xffFF689A)),
              borderRadius: BorderRadius.circular(22),
            ),
            onPressed: () {
              if (_code.isEmpty)
                return setState(() {
                  _errorMessage = 'Please, enter the code';
                });
              widget.onSubmitCode(
                _code,
                (err) => setState(() => _errorMessage = 'The code is invalid'),
              );
            },
            child: Text(
              'Submit Code',
              style: TextStyle(color: Color(0xffFF689A)),
            ),
          ),
        ],
      ),
    );
  }
}

class PhoneNumberCollector extends StatefulWidget {
  final void Function(PhoneNumber, void Function(AuthException)) onSubmitCode;

  PhoneNumberCollector({
    Key key,
    this.onSubmitCode,
  }) : super(key: key);

  @override
  _PhoneNumberCollectorState createState() => _PhoneNumberCollectorState();
}

class _PhoneNumberCollectorState extends State<PhoneNumberCollector>
    with AutomaticKeepAliveClientMixin {
  final LoginWithPhoneController _controller = Get.find();
  final PhoneNumber _phone = PhoneNumber();
  var _errorMessage;

  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);

    return LoginWithPhoneCard(
        cardTitle: 'Submit your phone number',
        errorMessage: _errorMessage,
        input: Row(
          children: [
            SizedBox(
              width: 120,
              child: LoginInput(
                label: 'Code Country',
                child: PhoneCodeSelector(onChange: (a) {
                  _phone.countryCode = a;
                  if (_errorMessage != null)
                    setState(() => _errorMessage = null);
                }),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              flex: 3,
              child: LoginInput(
                label: 'Phone',
                child: TextFormField(
                  onChanged: (newValue) {
                    _phone.phoneNumber = newValue;
                    if (_errorMessage != null)
                      setState(() => _errorMessage = null);
                  },
                  initialValue: _controller.phoneNumber?.phoneNumber,
                  style: TextStyle(
                    fontSize: 20,
                    height: 1,
                    fontFamily: 'Ubuntu',
                  ),
                  keyboardType: TextInputType.phone,
                ),
              ),
            )
          ],
        ),
        hintText: 'An SMS will be sent to your phone with a 6 digits code',
        actions: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            FlatButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(
                'Cancel',
                style: TextStyle(color: Colors.redAccent, fontFamily: 'Ubuntu'),
              ),
            ),
            FlatButton(
              shape: RoundedRectangleBorder(
                side: BorderSide(width: 1, color: Color(0xffFF689A)),
                borderRadius: BorderRadius.circular(22),
              ),
              onPressed: () {
                if (!_phone.isValid())
                  return setState(() =>
                      _errorMessage = 'Please, enter a valid phone number');

                widget.onSubmitCode(
                  _phone,
                  (error) {
                    if (error.message ==
                        'The interaction was cancelled by the user.') {
                    } else if (error.code == 'invalidPhoneNumber') {
                      setState(() => _errorMessage =
                          'The Phone has a wrong format for the selected country');
                    } else {
                      setState(() => _errorMessage = error.message);
                    }
                  },
                );
              },
              child: Text(
                'Send Code',
                style: TextStyle(
                  color: Color(0xffFF689A),
                  fontFamily: 'Ubuntu',
                ),
              ),
            ),
          ],
        ));
  }
}

class LoginWithPhoneCard extends StatelessWidget {
  const LoginWithPhoneCard({
    Key key,
    @required this.cardTitle,
    @required this.input,
    @required this.hintText,
    @required this.actions,
    this.errorMessage,
  }) : super(key: key);

  final String cardTitle;
  final Widget input;
  final String hintText;
  final Widget actions;
  final String errorMessage;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topCenter,
        child: Card(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          elevation: 2,
          child: Container(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(cardTitle, style: Theme.of(context).textTheme.headline3),
                  SizedBox(height: 29),
                  input,
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 300),
                    child: errorMessage != null && errorMessage.isNotEmpty
                        ? Column(
                            children: [
                              SizedBox(height: 5),
                              Text(
                                errorMessage,
                                style: TextStyle(
                                  fontFamily: 'Ubuntu',
                                  color: Colors.redAccent,
                                  fontSize: ScreenUtil().setSp(17),
                                  height: 1.29,
                                  letterSpacing: -1,
                                ),
                              )
                            ],
                          )
                        : SizedBox(),
                  ),
                  SizedBox(height: 25),
                  Text(hintText,
                      textAlign: TextAlign.justify,
                      style: TextStyle(
                        fontFamily: 'Ubuntu',
                        color: Color(0xffbababa),
                        fontSize: ScreenUtil().setSp(17),
                        height: 1.29,
                        letterSpacing: -1,
                      )),
                  SizedBox(height: 24),
                  actions
                ]),
            padding: EdgeInsets.fromLTRB(18, 25, 18, 18),
            width: double.infinity,
          ),
        ),
      ),
    );
  }
}

class LoginInput extends StatelessWidget {
  final labelStyle = TextStyle(
    color: Color(0xff4a4a4a),
    fontSize: ScreenUtil().setSp(17),
    height: 1.2,
    fontWeight: FontWeight.bold,
    letterSpacing: -1,
  );

  LoginInput({
    Key key,
    @required this.label,
    @required this.child,
  }) : super(key: key);

  final Widget child;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: labelStyle, maxLines: 1),
        Container(
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xff9B9B9B), width: 2),
            ),
          ),
          child: child,
        ),
      ],
    );
  }
}

class PhoneCodeSelector extends StatefulWidget {
  final void Function(String) onChange;

  const PhoneCodeSelector({Key key, this.onChange}) : super(key: key);

  @override
  _PhoneCodeSelectorState createState() => _PhoneCodeSelectorState();
}

class _PhoneCodeSelectorState extends State<PhoneCodeSelector> {
  final LoginWithPhoneController _controller = Get.find();
  TextEditingController _inputController;
  StreamSubscription _subscription;

  @override
  void initState() {
    super.initState();

    _inputController = TextEditingController(
        text: _controller.currentLocale.value?.callingCodes?.first);

    widget.onChange(_controller.currentLocale.value?.callingCodes?.first);

    _subscription = _controller.currentLocale.listen((a) {
      _inputController.text = a.callingCodes.first;
      widget.onChange(a.callingCodes.first);
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    _inputController?.dispose();
    super.dispose();
  }

  void _showDialog() {
    showDialog<CountryCode>(
        context: context,
        builder: (BuildContext context) {
          LoginWithPhoneController controller = Get.find();
          return AlertDialog(
            contentPadding: EdgeInsets.zero,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            content: Container(
              width: MediaQuery.of(context).size.width * .90,
              height: MediaQuery.of(context).size.height * .50,
              child: Column(children: [
                Container(
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                  decoration: BoxDecoration(
                    border: Border(
                      bottom: BorderSide(color: Colors.black),
                    ),
                  ),
                  child: TextFormField(
                    autofocus: true,
                    onChanged: controller.filterList,
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: 'Ubuntu'),
                    decoration: InputDecoration(
                      prefixIcon: Padding(
                        padding: const EdgeInsets.only(right: 10, top: 3),
                        child: Icon(
                          Icons.search,
                          size: 16,
                          color: Colors.grey,
                        ),
                      ),
                      prefixIconConstraints: BoxConstraints(
                        maxWidth: 24,
                        maxHeight: 24,
                      ),
                      hintText: 'Search country',
                      hintStyle: TextStyle(
                        color: Colors.grey,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Obx(() => ListView.builder(
                      itemBuilder: (context, i) {
                        final code =
                            controller.filteredList[i].callingCodes.first;
                        final countryName = controller.filteredList[i].name;
                        return FlatButton(
                          shape: ContinuousRectangleBorder(),
                          splashColor: Color(0xffd9d9d9),
                          onPressed: () {
                            controller.currentLocale.value =
                                controller.filteredList[i];
                            Navigator.pop(context);
                          },
                          child: Container(
                            padding: EdgeInsets.only(left: 40),
                            decoration: BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color(0xffefefef),
                                ),
                              ),
                            ),
                            child: Row(children: [
                              Text(
                                '+$code',
                                style: TextStyle(
                                    color: Color(0xff454545),
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: -1),
                              ),
                              SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  countryName,
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Color(0xff454545),
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: -1),
                                ),
                              )
                            ]),
                            width: double.infinity,
                            height: 60,
                            // color: i.isEven ? Colors.yellow : Colors.black,
                          ),
                        );
                      },
                      itemCount: controller.filteredList.length)),
                )
              ]),
            ),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() => TappableWrapper(
          onTap: _showDialog,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              FlagImg(flagUrl: _controller.currentLocale.value.flag),
              Expanded(
                child: TextFormField(
                  enabled: false,
                  onChanged: widget.onChange,
                  controller: _inputController,
                  style:
                      TextStyle(fontSize: 20, height: 1, fontFamily: 'Ubuntu'),
                  decoration: InputDecoration(
                    prefix: SizedBox(
                      width: 20,
                      height: 20,
                      child: Center(
                        child: Text(
                          '+',
                          style: TextStyle(fontSize: 20, color: Colors.black),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}

class FlagImg extends StatelessWidget {
  final String flagUrl;
  final iconSize = 20.0;

  const FlagImg({
    Key key,
    @required this.flagUrl,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: iconSize,
          height: iconSize,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Color(0xff969696), width: 1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: flagUrl == null
                ? Container()
                : SvgPicture.network(
                    flagUrl,
                    placeholderBuilder: (BuildContext context) => Container(
                        padding: const EdgeInsets.all(30.0),
                        child: const CircularProgressIndicator()),
                    fit: BoxFit.cover,
                  ),
          ),
        ),
        Icon(
          Icons.arrow_drop_down,
          color: Color(0xffDBDBDB),
        ),
      ],
    );
  }
}
