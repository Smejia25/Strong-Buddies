import 'package:flutter/material.dart';
import 'package:strong_buddies_connect/shared/components/custom_background.dart';
import 'package:strong_buddies_connect/shared/components/secndary_button.dart';

import 'components/selective_card.dart';
import 'models/card_info.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final String user = 'Trevor';
  int _selectedGender;

  void _handleCardSelection(int selectedGender) {
    setState(() => _selectedGender =
        _selectedGender == selectedGender ? null : selectedGender);
  }

  List<CardInfo> _categories = [
    CardInfo('assets/images/hombregris-04.png', 'KK'),
    CardInfo('assets/images/hombregris-04.png', 'KK'),
    CardInfo('assets/images/hombregris-04.png', 'KK'),
    CardInfo('assets/images/hombregris-04.png', 'KK'),
    CardInfo('assets/images/hombregris-04.png', 'KK'),
    CardInfo('assets/images/hombregris-04.png', 'KK')
  ];

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
                    'Pick the catgeories you are most interested in',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      color: Color(0xffCECECE),
                    ),
                  ),
                  SizedBox(height: 86),
                  Expanded(
                    child: GridView.count(
                      crossAxisSpacing: 10,
                      crossAxisCount: 2,
                      childAspectRatio: 0.8,
                      children: _categories
                          .map((cat) => SelectiveCard(
                                isSelected: _selectedGender == 1,
                                iconFile: cat.iconName,
                                cardLabel: cat.label,
                                onPressed: () => _handleCardSelection(1),
                              ))
                          .toList(),
                    ),
                  ),
                  SizedBox(height: 10),
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
