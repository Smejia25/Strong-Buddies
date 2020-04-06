import 'dart:async';

import 'package:flutter/material.dart';
import 'package:strong_buddies_connect/register/pages/register/components/shared/selectable_option.dart';
import 'package:strong_buddies_connect/register/pages/register/models/user_pojo.dart';
import 'package:strong_buddies_connect/register/pages/register/utils/update_user_util.dart';
import 'package:strong_buddies_connect/shared/utils/list_utils.dart';

import 'shared/register_card.dart';
import 'shared/register_container_wrapper.dart';

class RegisterGender extends StatefulWidget {
  const RegisterGender({Key key}) : super(key: key);

  @override
  _RegisterGenderState createState() => _RegisterGenderState();
}

class _RegisterGenderState extends State<RegisterGender> {
  final workoutTimes = ['Woman', 'Man', 'Other'];
  final _user = User();
  final _stream = StreamController<void>.broadcast();
  int _selectedOption;

  @override
  void initState() {
    super.initState();
    getCurrentState(context, (currentState) {
      final currentGender = currentState.user.gender;
      if (currentGender == null) return;
      _selectedOption = workoutTimes.indexOf(currentGender);
    });
  }

  void _updateGenderInfo(int index, String value, BuildContext context) {
    _selectedOption = _selectedOption == index ? null : index;
    _stream.add(_selectedOption);
    _user.gender = value;
    updateUserInfo(context, _user);
  }

  @override
  Widget build(BuildContext context) {
    return RegisterContainerWrapper(
      labelForInput: "Let us know your gender",
      child: Container(
        height: 400,
        child: GridView.count(
          crossAxisCount: 2,
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          children: turnListToWidgetList<String>(
            workoutTimes,
            (index, value) => SelectionCard.withStreamController(
              stream: _stream.stream,
              condition: () => _selectedOption == index,
              onPressed: (_) => _updateGenderInfo(index, value, context),
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
}
