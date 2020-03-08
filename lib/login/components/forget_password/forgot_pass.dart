import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strong_buddies_connect/shared/services/auth_service.dart';
import 'package:strong_buddies_connect/shared/utils/form_util.dart';
import 'bloc/forgotpass_bloc.dart';

class ForgotPassword extends StatelessWidget {
  ForgotPassword({
    Key key,
  }) : super(key: key);

  final _formKeyForDialog = GlobalKey<FormState>();
  final TextEditingController _textFieldController = TextEditingController();
  final ForgotpassBloc bloc = ForgotpassBloc(AuthService());

  String _emailValidator(value) {
    if (value.isEmpty) {
      return 'Please, enter your email';
    } else if (!FormUtil.isEmailValid(value)) {
      return 'Please, enter a valid email';
    }
    return null;
  }

  void _showForgetPassDialog(BuildContext mainContext) {
    showDialog(
        context: mainContext,
        builder: (context) {
          return BlocListener<ForgotpassBloc, ForgotpassState>(
            bloc: bloc,
            listener: (context, state) {
              if (state is ForgotpassProcessFinished) {
                Scaffold.of(mainContext).showSnackBar(
                  SnackBar(
                    content: Text(
                        'Please, check your email to continue the process'),
                  ),
                );
                Navigator.of(mainContext).pop();
              }
            },
            child: BlocBuilder(
              bloc: bloc,
              builder: (context, state) => _createDialog(
                context,
                isProcessLoaging: (state is ForgotpassInProcess),
                error: (state is ForgotpassWithError) ? state.error : null,
              ),
            ),
          );
        });
  }

  Widget _createDialog(BuildContext context,
      {bool isProcessLoaging, String error}) {
    return AlertDialog(
      title: const Text('Forgot password'),
      content: Form(
        key: _formKeyForDialog,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            TextFormField(
                enabled: !isProcessLoaging,
                validator: _emailValidator,
                controller: _textFieldController,
                decoration: InputDecoration(labelText: "Enter your email")),
            SizedBox(height: 10),
            if (error != null && error.isNotEmpty)
              Text(
                error,
                style: TextStyle(color: Color(0xffC11616)),
                textAlign: TextAlign.center,
              )
          ],
        ),
      ),
      actions: <Widget>[
        FlatButton(
            disabledColor: Colors.grey,
            child: Text('Cancel',
                style: TextStyle(color: Theme.of(context).primaryColor)),
            onPressed: FormUtil.getFunctionDependingOnEnableState(
                isProcessLoaging, () => Navigator.of(context).pop())),
        RaisedButton(
            color: Theme.of(context).primaryColor,
            padding: EdgeInsets.symmetric(vertical: 5, horizontal: 20),
            textColor: Colors.white,
            child: const Text('Submit'),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            onPressed: FormUtil.getFunctionDependingOnEnableState(
                isProcessLoaging, () => _performForgotPassProcess(context))),
      ],
    );
  }

  void _performForgotPassProcess(BuildContext context) async {
    if (!_formKeyForDialog.currentState.validate()) return;
    bloc.add(StartForgetPasswordProcess(_textFieldController.text));
  }

  @override
  Widget build(BuildContext context) {
    var container = Container(
      margin: EdgeInsets.only(top: 5),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () => _showForgetPassDialog(context),
          child: const Padding(
            padding: EdgeInsets.all(10),
            child: const Text('Forgot the password?',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500)),
          ),
        ),
      ),
    );
    return container;
  }
}
