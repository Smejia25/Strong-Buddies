import 'dart:async';

import 'package:flutter/material.dart';
import 'package:strong_buddies_connect/register/pages/register/components/shared/register_container_wrapper.dart';
import 'package:strong_buddies_connect/register/pages/register/models/user_pojo.dart';
import 'package:strong_buddies_connect/register/pages/register/utils/update_user_util.dart';
import 'package:strong_buddies_connect/shared/utils/list_utils.dart';

import 'shared/register_card.dart';
import 'shared/selectable_option.dart';

class RegsiterGymMembership extends StatefulWidget {
  const RegsiterGymMembership({
    Key key,
  }) : super(key: key);

  @override
  _RegsiterGymMembershipState createState() => _RegsiterGymMembershipState();
}

class _RegsiterGymMembershipState extends State<RegsiterGymMembership> {
  final options = ['Yes', 'No'];
  final _stream = StreamController<void>.broadcast();
  final _user = User();
  int _selectedOption;

  @override
  void initState() {
    super.initState();
    getCurrentState(context, (currentState) {
      final currentMembership = currentState.user.gymMembership;
      if (currentMembership == null) return;
      _selectedOption = options.indexOf(currentMembership);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RegisterContainerWrapper(
      child: Container(
          child: Row(
        children: turnListToWidgetList<String>(
          options,
          (index, value) => Expanded(
            child: SelectionCard.withStreamController(
              stream: _stream.stream,
              condition: () => _selectedOption == index,
              onPressed: (_) {
                _selectedOption = _selectedOption == index ? null : index;
                _stream.add(_selectedOption);

                _user.gymMembership = value;
                updateUserInfo(context, _user);
              },
              child: RegisterCard(
                imageAsset: 'assets/images/demo.png',
                label: value,
              ),
            ),
          ),
        ),
      )),
      labelForInput: 'Do you have a Gym Membership?',
    );
  }
}
