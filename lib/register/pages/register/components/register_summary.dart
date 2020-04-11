import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:strong_buddies_connect/register/pages/register/bloc/register_bloc.dart';
import 'package:strong_buddies_connect/register/pages/register/models/registration_user.dart';
import 'package:strong_buddies_connect/shared/utils/form_util.dart';
import 'shared/register_explain.dart';

class RegisterSummary extends StatelessWidget {
  const RegisterSummary({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      child: BlocBuilder<RegisterBloc, RegisterState>(
        builder: (context, state) {
          final RegistrationUser user = state.user;
          final bool wasUserFound = state.userFound;
          return Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const ExplainInput(reason: 'Please, verify the data'),
              const SizedBox(height: 20),
              Expanded(
                  child:
                      ListView(children: getAllUserFields(user, wasUserFound))),
              const SizedBox(height: 15),
              RaisedButton(
                onPressed: FormUtil.getFunctionDependingOnEnableState(
                    !isUserValid(user, wasUserFound),
                    () => BlocProvider.of<RegisterBloc>(context)
                        .add(RegisterEventCreateUser())),
                child: const Text('Create User'),
              )
            ],
          );
        },
      ),
    );
  }

  List<CardInputSummary> getAllUserFields(
      RegistrationUser user, bool wasUserFound) {
    return [
      CardInputSummary(dataName: 'Name', data: user.name),
      CardInputSummary(dataName: 'Public Name', data: user.displayName),
      CardInputSummary(dataName: 'Email Address', data: user.email),
      if (!wasUserFound)
        CardInputSummary(
            dataName: 'Password',
            data:
                user.password == null || user.password.isEmpty ? null : '****'),
      CardInputSummary(
          dataName: 'Prefered Workout Time', data: user.preferTimeWorkout),
      CardInputSummary(dataName: 'Your Gender', data: user.gender),
      CardInputSummary(
          dataName: 'Do you have a Gym Memebership?', data: user.gymMemberShip),
      CardInputSummary(
          data: reduceListIntoString(user.targetGender),
          dataName: "Gender to be match with"),
      CardInputSummary(
          data: reduceListIntoString(user.workoutTypes),
          dataName: "Kind of work you're interested in")
    ];
  }

  String reduceListIntoString(List<String> listToReduceIntoString) {
    if (listToReduceIntoString == null) return null;
    return listToReduceIntoString.join(', ');
  }

  bool isUserValid(RegistrationUser user, bool wasUserFound) {
    return user.name != null &&
        user.email != null &&
        user.preferTimeWorkout != null &&
        user.gender != null &&
        user.gymMemberShip != null &&
        user.targetGender != null &&
        user.workoutTypes != null &&
        user.displayName != null &&
        (user.password != null || wasUserFound);
  }
}

class CardInputSummary extends StatelessWidget {
  const CardInputSummary({
    Key key,
    @required this.dataName,
    this.data = '/',
  }) : super(key: key);

  final String data;
  final String dataName;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 15,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      color: Color(0xff292929),
      child: ConstrainedBox(
        constraints: BoxConstraints(minHeight: 100),
        child: Container(
          padding: const EdgeInsets.all(20),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Align(
                alignment: Alignment.center,
                child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    padding: const EdgeInsets.all(10),
                    child: Image.asset('assets/images/demo.png')),
              ),
              SizedBox(width: 10),
              Flexible(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    const SizedBox(height: 5),
                    Text(
                      '$dataName:',
                      style: const TextStyle(fontSize: 13, color: Colors.white),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      data ?? 'Empty',
                      style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: Colors.white),
                    ),
                    SizedBox(height: 10)
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
