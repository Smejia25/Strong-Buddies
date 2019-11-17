import 'package:flutter/material.dart';
import 'package:strong_buddies_connect/shared/components/custom_background.dart';
import 'package:strong_buddies_connect/shared/components/secndary_button.dart';

import 'components/selective_card.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final String user = 'Trevor';
  int _selectedGender;

  void _handleCardSelection(int selectedGender) {
    setState(() => _selectedGender =
        _selectedGender == selectedGender ? null : selectedGender);
  }

  void _goToNextSection() {
    // Navigator.of(context).push(route)
  }

  @override
  Widget build(BuildContext context) {
    final iconFile = 'assets/images/hombregris-04.png';
    final cardLabel = 'Male';
    return Scaffold(
      body: CustomBackground(
          backgroundColor: Color(0xff414042),
          backgroundImage: 'assets/images/background-login.jpg',
          child: SafeArea(
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 23, vertical: 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  UserSalute(user: user),
                  SizedBox(height: 80),
                  LabelForSelection(),
                  SizedBox(height: 86),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: SelectiveCard(
                          isSelected: _selectedGender == 1,
                          iconFile: iconFile,
                          cardLabel: cardLabel,
                          onPressed: () => _handleCardSelection(1),
                        ),
                      ),
                      SizedBox(width: 20),
                      Expanded(
                        child: SelectiveCard(
                          isSelected: _selectedGender == 2,
                          iconFile: 'assets/images/iconomujergris-03.png',
                          onPressed: () => _handleCardSelection(2),
                          cardLabel: 'Female',
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: SizedBox(),
                  ),
                  NavigationButtons(
                    canNavigationBeDone: true,
                    continueBtnText: 'Next',
                    routeName: '/',
                  ),
                ],
              ),
            ),
          )),
    );
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
            onPressed: () {},
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
  const LabelForSelection({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      'Please, select your gender',
      style: TextStyle(
        fontSize: 20,
        color: Color(0xffCECECE),
      ),
    );
  }
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
          'Hi, $user',
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
