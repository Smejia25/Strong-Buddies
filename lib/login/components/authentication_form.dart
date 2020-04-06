import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strong_buddies_connect/login/bloc/login_bloc.dart';
import 'package:strong_buddies_connect/login/models/user.dart';
import 'package:strong_buddies_connect/shared/utils/form_util.dart';
import 'package:validate/validate.dart';
import 'forget_password/forgot_pass.dart';
import '../../routes.dart';

class AuthenticationForm extends StatefulWidget {
  const AuthenticationForm({
    Key key,
  }) : super(key: key);

  @override
  _AuthenticationFormState createState() => _AuthenticationFormState();
}

class _AuthenticationFormState extends State<AuthenticationForm> {
  static const _spaceBetweenInputs = 15.0;

  LoginBloc _bloc;
  final _formKey = GlobalKey<FormState>();
  final _credentials = LoginCredential();

  String _emalValidator(String value) {
    if (value.isEmpty) return 'Please, enter a valid email';
    try {
      Validate.isEmail(value);
    } catch (e) {
      return 'Enter a valid email';
    }
    return null;
  }

  String _passwordValidator(String value) {
    if (value.isEmpty)
      return 'Please, enter your password';
    else if (value.length < 5) return 'The password is too short';
    return null;
  }

  bool _shouldErrorBeShown(LoginState state) {
    return state is LoginWithError &&
        state.error != null &&
        state.error.isNotEmpty;
  }

  void _loginWithCredentials() {
    if (!_formKey.currentState.validate()) return;

    _formKey.currentState.save();
    _bloc.add(PerformLoginWithCredentials(_credentials.email, _credentials.password));
  }

  @override
  void initState() {
    super.initState();
    _bloc = BlocProvider.of<LoginBloc>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: BlocBuilder(
          bloc: _bloc,
          builder: (context, state) {
            final anAuthProcessIsCurrentlyBeingExecuted =
                (state is PerformingLoading);

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextFormField(
                  enabled: !anAuthProcessIsCurrentlyBeingExecuted,
                  onSaved: (val) => _credentials.email = val,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: _emalValidator,
                ),
                const SizedBox(height: _spaceBetweenInputs),
                TextFormField(
                  enabled: !anAuthProcessIsCurrentlyBeingExecuted,
                  onSaved: (val) => _credentials.password = val,
                  obscureText: true,
                  validator: _passwordValidator,
                  decoration: InputDecoration(labelText: 'Password'),
                ),
                ForgotPassword(),
                const SizedBox(height: _spaceBetweenInputs),
                if (_shouldErrorBeShown(state))
                  Text(
                    state.error,
                    style: const TextStyle(color: Color(0xffC11616)),
                    textAlign: TextAlign.center,
                  ),
                const SizedBox(height: _spaceBetweenInputs),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: RaisedButton(
                        onPressed: FormUtil.getFunctionDependingOnEnableState(
                            anAuthProcessIsCurrentlyBeingExecuted,
                            _loginWithCredentials),
                        child: const Text('Sign In'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).accentColor,
                        textColor: Theme.of(context).primaryColor,
                        onPressed: FormUtil.getFunctionDependingOnEnableState(
                            anAuthProcessIsCurrentlyBeingExecuted,
                            () => Navigator.pushNamed(
                                context, Routes.registerPage)),
                        child: const Text('Go To Register'),
                      ),
                    ),
                  ],
                ),
              ],
            );
          }),
    );
  }
}
