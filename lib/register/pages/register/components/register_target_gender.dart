import 'package:flutter/material.dart';
import 'package:strong_buddies_connect/register/pages/register/components/shared/selectable_option.dart';
import 'package:strong_buddies_connect/register/pages/register/models/user_pojo.dart';
import 'package:strong_buddies_connect/register/pages/register/utils/update_user_util.dart';
import 'package:strong_buddies_connect/shared/utils/list_utils.dart';

import 'shared/register_card.dart';
import 'shared/register_container_wrapper.dart';

class RegisterTargetGender extends StatefulWidget {
  const RegisterTargetGender({Key key}) : super(key: key);

  @override
  _RegisterTargetGenderState createState() => _RegisterTargetGenderState();
}

class _RegisterTargetGenderState extends State<RegisterTargetGender> {
  final _genders = ['Woman', 'Man', 'Other'];
  final _user = User();
  List<String> _selectedGenders = ['Woman', 'Man', 'Other'];

  @override
  void initState() {
    super.initState();
    getCurrentState(context, (currentState) {
      final currentSelectedGenders = currentState.user.targetGender;
      if (currentSelectedGenders != null) {
        _selectedGenders = _genders;
      }
    });
  }

  void handleTargetCardSelection(bool isSelected, String value, int index) {
    if (isSelected)
      _selectedGenders.add(value);
    else
      _selectedGenders.remove(_genders[index]);

    _user.targetGender = _selectedGenders;
    updateUserInfo(context, _user);
  }

  @override
  Widget build(BuildContext context) {
    return RegisterContainerWrapper(
      labelForInput:
          "Please, select what genders you want to be match with",
      child: Container(
        height: 310,
        child: GridView.count(
          crossAxisCount: 2,
          children: turnListToWidgetList<String>(
            _genders,
            (index, value) => SelectionCard(
              initialValue: _selectedGenders.indexOf(value) != -1,
              onPressed: (isSelected) =>
                  handleTargetCardSelection(isSelected, value, index),
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
