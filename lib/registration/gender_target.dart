import 'package:flutter/material.dart';
import 'package:strong_buddies_connect/registration/providers/user.dart';

import 'components/selective_card.dart';
import 'models/cardGenderINfo.dart';
import 'registration_page.dart';

class GenderTargetPage extends StatefulWidget {
  @override
  _GenderTargetPageState createState() => _GenderTargetPageState();
}

class _GenderTargetPageState extends State<GenderTargetPage> {
  final CreateUserFactory _userService = CreateUserFactory();
  final String user = 'Trevor';
  int _selectedGender;

  final List<CardGenderInfo> _genders = const [
    CardGenderInfo('assets/images/hombregris-04.png', 'Male'),
    CardGenderInfo('assets/images/iconomujergris-03.png', 'Female')
  ];

  List<Expanded> _getListOfGenderCards() {
    return _genders
        .asMap()
        .map((i, f) {
          return MapEntry(
            i,
            Expanded(
              child: SelectiveCard(
                isSelected: _selectedGender == i,
                iconFile: f.iconFile,
                cardLabel: f.cardLabel,
                onPressed: () => _handleCardSelection(i),
              ),
            ),
          );
        })
        .values
        .toList();
  }

  void _handleCardSelection(int selectedGender) {
    _userService.assignTargetGender(selectedGender == 0 ? 'Male' : 'Female');
    setState(() => _selectedGender =
        _selectedGender == selectedGender ? null : selectedGender);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RegistrationBackground(
        childcolumn: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            UserSalute(user: user),
            SizedBox(height: 80),
            LabelForSelection(label: 'Please, select your target gender'),
            SizedBox(height: 86),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _getListOfGenderCards(),
            ),
            Expanded(
              child: SizedBox(),
            ),
            NavigationButtons(
              canNavigationBeDone: _selectedGender != null,
              continueBtnText: 'Next',
              routeName: '/categories_form',
            ),
          ],
        ),
      ),
    );
  }
}
