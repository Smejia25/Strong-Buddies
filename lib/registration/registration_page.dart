import 'package:flutter/material.dart';
import 'package:strong_buddies_connect/registration/providers/user.dart';

import 'package:strong_buddies_connect/shared/components/custom_background.dart';
import 'package:strong_buddies_connect/shared/components/secndary_button.dart';

import 'components/selective_card.dart';
import 'models/cardGenderINfo.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
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
              ));
        })
        .values
        .toList();
  }

  void _handleCardSelection(int selectedGender) {
    _userService.assignGender(selectedGender == 0 ? 'Male' : 'Female');
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
            LabelForSelection(label: 'Please, select your gender'),
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
              routeName: '/gender_target_form',
            ),
          ],
        ),
      ),
    );
  }
}

class RegistrationBackground extends StatelessWidget {
  const RegistrationBackground({
    Key key,
    @required this.childcolumn,
  }) : super(key: key);

  final Column childcolumn;

  @override
  Widget build(BuildContext context) {
    return CustomBackground(
        backgroundColor: Color(0xff414042),
        backgroundImage: 'assets/images/background-login.jpg',
        child: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 23, vertical: 5),
            child: childcolumn,
          ),
        ));
  }
}

class NavigationButtons extends StatelessWidget {
  const NavigationButtons({
    Key key,
    @required bool canNavigationBeDone,
    @required this.routeName,
    @required this.continueBtnText,
  })  : _canNavigationBeDone = canNavigationBeDone,
        super(key: key);

  final bool _canNavigationBeDone;
  final routeName /*  = '/gender_target' */;
  final continueBtnText /* = 'Next' */;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: SecondaryButton(
            onPressed: () {
              Navigator.of(context).pushNamed('/');
            },
            child: Text('Cancel'),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: RaisedButton(
            disabledColor: Colors.grey,
            onPressed: _canNavigationBeDone
                ? () => Navigator.pushNamed(context, routeName)
                : null,
            child: Text(continueBtnText),
          ),
        ),
      ],
    );
  }
}

class LabelForSelection extends StatelessWidget {
  const LabelForSelection({Key key, this.label}) : super(key: key);
  final String label;

  @override
  Widget build(BuildContext context) => Text(
        label,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 20,
          color: Color(0xffCECECE),
        ),
      );
}

class UserSalute extends StatelessWidget {
  const UserSalute({
    Key key,
    @required this.user,
  }) : super(key: key);

  final String user;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ArrowBack(),
        SizedBox(height: 24),
        Text(
          'Hi, buddy',
          style: TextStyle(
            fontSize: 28,
            color: Color(0xffCECECE),
          ),
        ),
      ],
    );
  }
}

class ArrowBack extends StatelessWidget {
  const ArrowBack({Key key}) : super(key: key);

  void _goToPreviousStep(BuildContext context) => Navigator.pop(context);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
            borderRadius: BorderRadius.all(Radius.circular(100)),
            child: Container(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.arrow_back,
                color: Colors.white,
              ),
            ),
            onTap: () => _goToPreviousStep(context)),
      ),
    );
  }
}
