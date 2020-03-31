import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strong_buddies_connect/register/pages/register/bloc/register_bloc.dart';
import 'package:strong_buddies_connect/register/pages/register/components/register_password.dart';
import 'package:strong_buddies_connect/shared/services/auth_service.dart';
import 'components/register_email.dart';
import 'components/register_gender.dart';
import 'components/register_membership.dart';
import 'components/register_name.dart';
import 'components/register_summary.dart';
import 'components/register_target_gender.dart';
import 'components/register_workout_time.dart';
import 'components/register_workout_type.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _controller = PageController();
  RegisterBloc _bloc;
  StreamSubscription _subscription;
  List<Widget> _inputs = [
    const RegisterEmail(),
    const RegisterPassword(),
    const RegisterName(),
    const RegisterWorkoutTime(),
    const RegisterGender(),
    const RegisterTargetGender(),
    const RegsiterGymMembership(),
    const RegisterWorkoutType(),
  ];

  @override
  void initState() {
    super.initState();
    _bloc = RegisterBloc(AuthService());
    _subscription = _bloc.listen((state) {
      if ((state is RegisterDataUpdated)) {
        _subscription.cancel();
        _subscription = null;
        getChildrenBasedOnLogedInUser(state.userFound);
      }
    });
    _bloc.add(RegisterEventGetUserInfo());
  }

  void getChildrenBasedOnLogedInUser(bool wasUserFound) {
    setState(() {
      _inputs = [
        const RegisterEmail(),
        if (!wasUserFound) const RegisterPassword(),
        const RegisterName(),
        const RegisterGender(),
        const RegisterTargetGender(),
        const RegsiterGymMembership(),
        const RegisterWorkoutTime(),
        const RegisterWorkoutType(),
        const RegisterSummary()
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider.value(
          value: _bloc,
          child: PageView(
            controller: _controller,
            children: _inputs,
          )),
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}
