import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:strong_buddies_connect/shared/components/primary_button.dart';
import 'package:strong_buddies_connect/shared/services/auth/auth_service.dart';
import 'package:strong_buddies_connect/shared/utils/list_utils.dart';

class CodeForm extends StatefulWidget {
  final String verificationId;
  final Future<void> Function(AuthResult) onSucessfulLogin;
  final AuthService auth;

  const CodeForm({
    Key key,
    @required this.onSucessfulLogin,
    @required this.auth,
    @required this.verificationId,
  }) : super(key: key);

  @override
  _CodeFormState createState() => _CodeFormState();
}

class _CodeFormState extends State<CodeForm> {
  final _formkey = GlobalKey<FormState>();
  List<String> _code;
  List<Widget> _codeInputs;
  String _error;

  @override
  void initState() {
    super.initState();
    buildInputs();
  }

  void buildInputs() {
    final list = new List(6);
    _code = list.map((_) => '').toList();
    final focusNodes = list.map((_) => FocusNode()).toList();
    _codeInputs = turnListToWidgetList(list, (i, _) {
      final focusnode = focusNodes[i];
      return Expanded(
        child: Padding(
            padding: const EdgeInsets.all(3.0),
            child: AspectRatio(
              aspectRatio: 1,
              child: Center(
                child: TextFormField(
                    focusNode: focusnode,
                    textInputAction: TextInputAction.next,
                    onChanged: (val) {
                      _code[i] = val;
                      if (val == null || val.isEmpty) return;

                      final next = i + 1;
                      if (next >= focusNodes.length || next < 0) return;
                      focusNodes[next].requestFocus();
                    },
                    decoration: InputDecoration(
                        contentPadding: EdgeInsets.only(left: 2.5)),
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 20, color: Color(0xfff1806b)),
                    inputFormatters: [LengthLimitingTextInputFormatter(1)]),
              ),
            )),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      child: Column(
        children: <Widget>[
          Form(key: _formkey, child: Row(children: _codeInputs)),
          SizedBox(height: ScreenUtil().setHeight(40)),
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: _error != null
                ? Text(_error,
                    style: TextStyle(
                        height: 1.29,
                        letterSpacing: -0.41,
                        fontSize: 15,
                        color: Colors.redAccent,),)
                : Text(
                    'Please, enter the code you recieved on your phone',
                    style: TextStyle(
                      height: 1.29,
                      letterSpacing: -0.41,
                      fontSize: 15,
                      color: Colors.white,
                    ),
                  ),
          ),
          SizedBox(height: ScreenUtil().setHeight(40)),
          PrimaryButton.text(
              text: 'Submit code',
              onTap: () async {
                final isAnySpaceEmpty =
                    _code.any((element) => element == null || element.isEmpty);
                if (isAnySpaceEmpty) return;

                final code = _code.join();

                try {
                  final user = await widget.auth
                      .signInWithPhoneNumber(widget.verificationId, code);
                  await widget.onSucessfulLogin(user);
                } catch (e) {
                  setState(() => _error = "This is not code, if you didn't recieve the code resend the code");
                }
              })
        ],
      ),
    );
  }
}
