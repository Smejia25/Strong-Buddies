import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strong_buddies_connect/register/pages/register/bloc/register_bloc.dart';
import 'package:strong_buddies_connect/shared/utils/string_util.dart';

class Salute extends StatelessWidget {
  const Salute({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String userName = '';
    return BlocBuilder<RegisterBloc, RegisterState>(
      condition: (previousState, currentState) =>
          currentState is RegisterDataUpdated &&
          currentState.user.name != null &&
          currentState.user.name != userName,
      builder: (context, state) {
        userName = 'buddy';
        if (state is RegisterDataUpdated)
          userName =
              stringIsNullOrEmpty(state.user.name) ? userName : state.user.name;
        return Text(
          'Hi, $userName',
          textAlign: TextAlign.center,
          style: TextStyle(
              fontSize: 24,
              color: Color(0xFFCECECE),
              fontWeight: FontWeight.w400),
        );
      },
    );
  }
}
