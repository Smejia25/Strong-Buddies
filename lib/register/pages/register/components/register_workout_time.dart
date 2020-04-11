import 'dart:async';
import 'package:flutter/material.dart';
import 'package:strong_buddies_connect/register/pages/register/models/registration_user.dart';
import 'package:strong_buddies_connect/register/pages/register/utils/update_user_util.dart';
import 'package:strong_buddies_connect/shared/utils/list_utils.dart';
import 'shared/register_card.dart';
import 'shared/register_container_wrapper.dart';
import 'shared/selectable_option.dart';

class RegisterWorkoutTime extends StatefulWidget {
  const RegisterWorkoutTime({Key key}) : super(key: key);

  @override
  _RegisterWorkoutTimeState createState() => _RegisterWorkoutTimeState();
}

class _RegisterWorkoutTimeState extends State<RegisterWorkoutTime> {
  final workoutTimes = ['Morning', 'Midday', 'Night'];
  final _stream = StreamController<void>.broadcast();
  final _user = RegistrationUser();
  int _selectedOption;

  @override
  void initState() {
    super.initState();
    getCurrentState(context, (currentState) {
      final currentWorkoutTime = currentState.user.preferTimeWorkout;
      if (currentWorkoutTime == null) return;
      _selectedOption = workoutTimes.indexOf(currentWorkoutTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RegisterContainerWrapper(
      labelForInput: "Please, select your preffered time to workout",
      child: Container(
        height: 310,
        child: GridView.count(
          crossAxisCount: 2,
          children: turnListToWidgetList<String>(
            workoutTimes,
            (index, value) => SelectionCard.withStreamController(
              stream: _stream.stream,
              condition: () => _selectedOption == index,
              onPressed: (_) {
                _selectedOption = _selectedOption == index ? null : index;
                _stream.add(null);
                _user.preferTimeWorkout = value;
                updateUserInfo(context, _user);
              },
              child: RegisterCard(
                imageAsset: 'assets/images/demo_image.jpg',
                label: value,
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _stream.close();
    super.dispose();
  }
}
