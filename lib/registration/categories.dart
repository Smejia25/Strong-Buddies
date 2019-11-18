import 'package:flutter/material.dart';

import 'components/selective_card.dart';
import 'models/card_info.dart';
import 'providers/user.dart';
import 'registration_page.dart';

class CategoriesPage extends StatefulWidget {
  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  final CreateUserFactory _userService = CreateUserFactory();
  final String user = 'Trevor';
  List<String> selectedCategories = [];

  void _handleCardSelection(String categorie) {
    final List<String> tempList = []..addAll(selectedCategories);
    final int indexOfCategorySelected = tempList.indexOf(categorie);

    bool wasCategoryAlreadySelected = indexOfCategorySelected != -1;

    if (wasCategoryAlreadySelected) {
      tempList.removeAt(indexOfCategorySelected);
    } else {
      tempList.add(categorie);
    }

    _userService.assignCategories(selectedCategories);

    setState(() => selectedCategories = tempList);
  }

  List<CardInfo> _categories = [
    CardInfo('assets/images/Elementos deportivos-01.png', 'Running'),
    CardInfo('assets/images/Elementos deportivos-02.png', 'Free Weights'),
    CardInfo('assets/images/Elementos deportivos-03.png', 'Powerlifting'),
    CardInfo('assets/images/Elementos deportivos-04.png', 'Bodybuilding'),
    CardInfo('assets/images/Elementos deportivos-05.png', 'Swimming'),
    CardInfo('assets/images/Elementos deportivos-06.png', 'Tennis'),
    CardInfo('assets/images/Elementos deportivos-07.png', 'Soccer'),
    CardInfo('assets/images/Elementos deportivos-08.png', 'Basketball'),
    CardInfo('assets/images/Elementos deportivos-09.png', 'Crossfit'),
    CardInfo('assets/images/Elementos deportivos-10.png', 'Golf'),
    CardInfo('assets/images/Elementos deportivos-11.png', 'Gymnastics'),
    /* CardInfo('assets/images/hombregris-04.png', 'Football'),
    CardInfo('assets/images/hombregris-04.png', 'Circuit Training'),
    CardInfo('assets/images/hombregris-04.png', 'Indoor Cardio'),
    CardInfo('assets/images/hombregris-04.png', 'Yoga'),
    CardInfo('assets/images/hombregris-04.png', 'Martial Arts'),
    CardInfo('assets/images/hombregris-04.png', 'Brazilian Jiu-Jitsu'),
    CardInfo('assets/images/hombregris-04.png', 'Outdoor Events'),
    CardInfo('assets/images/hombregris-04.png', 'Hiking'),
    CardInfo('assets/images/hombregris-04.png', 'Outdoor Biking'),
    CardInfo('assets/images/hombregris-04.png', 'Spin Class'),
    CardInfo('assets/images/hombregris-04.png', 'Rowing') */
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RegistrationBackground(
        childcolumn: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            UserSalute(user: user),
            SizedBox(height: 40),
            LabelForSelection(label: 'Please, select your favorite workouts'),
            SizedBox(height: 40),
            Expanded(
              child: GridView.count(
                crossAxisSpacing: 10,
                crossAxisCount: 2,
                childAspectRatio: 0.8,
                children: _categories
                    .asMap()
                    .map(
                      (i, f) => MapEntry(
                        i,
                        SelectiveCard(
                          isSelected: selectedCategories.indexOf(f.label) != -1,
                          iconFile: f.iconName,
                          cardLabel: f.label,
                          onPressed: () => _handleCardSelection(f.label),
                        ),
                      ),
                    )
                    .values
                    .toList(),
              ),
            ),
            SizedBox(height: 20),
            NavigationButtons(
              canNavigationBeDone: selectedCategories.length != 0,
              continueBtnText: 'Next',
              routeName: '/workout_time_form',
            ),
          ],
        ),
      ),
    );
  }
}
