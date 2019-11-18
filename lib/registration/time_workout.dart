import 'package:flutter/material.dart';
import 'package:strong_buddies_connect/registration/providers/user.dart';

import 'components/selective_card.dart';
import 'models/cardGenderINfo.dart';
import 'registration_page.dart';

class WorkoutTimePage extends StatefulWidget {
  @override
  _WorkoutTimePageState createState() => _WorkoutTimePageState();
}

class _WorkoutTimePageState extends State<WorkoutTimePage> {
  final CreateUserFactory _userService = CreateUserFactory();
  final String user = 'Trevor';
  String _selectedTimeDay;

  final List<CardGenderInfo> _workoutTimes = const [
    CardGenderInfo('assets/images/morning-05.png', 'Morning'),
    CardGenderInfo('assets/images/afternoon-06.png', 'Midday'),
    CardGenderInfo('assets/images/night-07.png', 'Evening')
  ];

  void _handleCardSelection(String selectedTimeDay) {
    _userService.assignWokoutDayTime(selectedTimeDay);

    setState(() => _selectedTimeDay =
        _selectedTimeDay == selectedTimeDay ? null : selectedTimeDay);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RegistrationBackground(
        childcolumn: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            UserSalute(user: user),
            SizedBox(height: 40),
            LabelForSelection(label: 'Preferred time of day of workout?'),
            SizedBox(height: 40),
            Expanded(
              child: GridView.count(
                crossAxisSpacing: 10,
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                children: _workoutTimes
                    .asMap()
                    .map(
                      (index, workoutTime) => MapEntry(
                        index,
                        SelectiveCard(
                          isSelected: _selectedTimeDay == workoutTime.cardLabel,
                          iconFile: workoutTime.iconFile,
                          cardLabel: workoutTime.cardLabel,
                          onPressed: () =>
                              _handleCardSelection(workoutTime.cardLabel),
                        ),
                      ),
                    )
                    .values
                    .toList(),
              ),
            ),
            NavigationButtons(
              canNavigationBeDone: _selectedTimeDay != null,
              continueBtnText: 'Finish',
              routeName: '/form',
            ),
          ],
        ),
      ),
    );
  }
}
