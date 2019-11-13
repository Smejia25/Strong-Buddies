import 'package:flutter/material.dart';
import 'package:strong_buddies_connect/shared/components/custom_background.dart';
import 'package:strong_buddies_connect/shared/components/secndary_button.dart';

import 'components/selective_card.dart';

class GenderTargetPage extends StatefulWidget {
  @override
  _GenderTargetPageState createState() => _GenderTargetPageState();
}

class _GenderTargetPageState extends State<GenderTargetPage> {
  final String user = 'Trevor';
  int _selectedGender;

  void _handleCardSelection(int selectedGender) {
    setState(() => _selectedGender =
        _selectedGender == selectedGender ? null : selectedGender);
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
                  SizedBox(height: 24),
                  Text(
                    'Hi, $user',
                    style: TextStyle(
                      fontSize: 28,
                      color: Color(0xffCECECE),
                    ),
                  ),
                  SizedBox(height: 86),
                  Text(
                    'Which gender are you seeking?',
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xffCECECE),
                    ),
                  ),
                  SizedBox(height: 86),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      SelectiveCard(
                        isSelected: _selectedGender == 1,
                        iconFile: iconFile,
                        cardLabel: cardLabel,
                        onPressed: () => _handleCardSelection(1),
                      ),
                      SizedBox(width: 20),
                      SelectiveCard(
                        isSelected: _selectedGender == 2,
                        iconFile: 'assets/images/iconomujergris-03.png',
                        onPressed: () => _handleCardSelection(2),
                        cardLabel: 'Female',
                      ),
                    ],
                  ),
                  Expanded(child: SizedBox()),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: SecondaryButton(
                            onPressed: () {}, child: Text('Cancel')),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: RaisedButton(
                            disabledColor: Colors.grey,
                            onPressed: _selectedGender != null
                                ? () {
                                    Navigator.pushNamed(context, '');
                                  }
                                : null,
                            child: Text('Next')),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )),
    );
  }
}
