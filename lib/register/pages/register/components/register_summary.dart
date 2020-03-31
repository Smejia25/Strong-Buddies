import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strong_buddies_connect/register/pages/register/bloc/register_bloc.dart';
import 'package:strong_buddies_connect/register/pages/register/models/user_pojo.dart';
import 'shared/register_container_wrapper.dart';

class RegisterSummary extends StatelessWidget {
  const RegisterSummary({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.blueAccent,
      padding: const EdgeInsets.all(20),
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          final User user =
              (state is RegisterDataUpdated) ? state.user : User();
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text('Please, verify the data',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 20)),
              SizedBox(height: 40),
              Text('Name: ${user.name}',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              SizedBox(height: 5),
              Text('Email: ${user.email}',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              SizedBox(height: 5),
              Text('Prefered time to workout: ${user.preferTimeToWorkout}',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              SizedBox(height: 5),
              Text('Gender: ${user.gender}',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              SizedBox(height: 5),
              Text('Do you have a Gym Membership?: ${user.gymMembership}',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              SizedBox(height: 5),
              Text('What genders are you looking for?: ${user.targetGender}',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              SizedBox(height: 5),
              Text(
                  'What kind of work do you like: ${user.workoutType.reduce((accum, current) => '$accum, $current')}',
                  textAlign: TextAlign.left,
                  style: TextStyle(color: Colors.white, fontSize: 18)),
              SizedBox(height: 40),
              RaisedButton(
                onPressed: isUserValid(user) ? () {} : null,
                child: Text('Create User'),
              )
            ],
          );
        },
      ),
    );
  }

  bool isUserValid(User user) {
    return user.name != null &&
        user.email != null &&
        user.preferTimeToWorkout != null &&
        user.gender != null &&
        user.gymMembership != null &&
        user.targetGender != null &&
        user.workoutType != null;
  }
}
