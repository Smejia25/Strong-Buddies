import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strong_buddies_connect/register/pages/register/bloc/register_bloc.dart';
import 'package:strong_buddies_connect/register/pages/register/models/user_pojo.dart';

void updateUserInfo(BuildContext context, User user) {
  final bloc = BlocProvider.of<RegisterBloc>(context);
  bloc.add(RegisterEventUpdateUserData(user));
}

void getCurrentState(
    BuildContext context, void Function(RegisterDataUpdated state) callback) {
  RegisterBloc bloc = BlocProvider.of<RegisterBloc>(context);
  RegisterState currentState = bloc.state;

  if (currentState is RegisterDataUpdated) {
    callback(currentState);
  }
}
