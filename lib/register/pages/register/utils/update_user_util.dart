import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strong_buddies_connect/register/pages/register/bloc/register_bloc.dart';
import 'package:strong_buddies_connect/register/pages/register/models/registration_user.dart';

void updateUserInfo(BuildContext context, RegistrationUser user) {
  final bloc = BlocProvider.of<RegisterBloc>(context);
  bloc.add(RegisterEventUpdateUserData(user));
}

void getCurrentState(
    BuildContext context, void Function(RegisterState state) callback) {
  RegisterBloc bloc = BlocProvider.of<RegisterBloc>(context);
  RegisterState currentState = bloc.state;
  callback(currentState);
}

RegistrationUser getCurrentUserState(BuildContext context) {
  RegisterBloc bloc = BlocProvider.of<RegisterBloc>(context);
  RegisterState currentState = bloc.state;
  return currentState.user;
}
