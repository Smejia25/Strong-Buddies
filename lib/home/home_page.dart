import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:strong_buddies_connect/chatList/chatList.dart';
import 'package:strong_buddies_connect/matching/matching_page.dart';
import 'package:strong_buddies_connect/profile/profile_page.dart';

class HomePage extends StatefulWidget {
  HomePage({Key key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  int current = 0;
  final widgets = [MatchComponent(), ChatList(), ProfilePage()];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        bottomNavigationBar: BottomNavigationBar(
            currentIndex: current,
            onTap: (selected) => setState(() => current = selected),
            items: [
              BottomNavigationBarItem(
                  title: SizedBox(),
                  icon: Icon(
                    FontAwesomeIcons.dumbbell,
                    color: Color(0xffC1C0C9),
                    size: 27,
                  ),
                  activeIcon: Icon(
                    FontAwesomeIcons.dumbbell,
                    color: Color(0xffFF8960),
                    size: 27,
                  )),
              BottomNavigationBarItem(
                  title: SizedBox(),
                  icon: Icon(
                    FontAwesomeIcons.comments,
                    color: Color(0xffC1C0C9),
                    size: 27,
                  ),
                  activeIcon: Icon(
                    FontAwesomeIcons.comments,
                    color: Color(0xffFF8960),
                    size: 27,
                  )),
              BottomNavigationBarItem(
                  title: SizedBox(),
                  icon: Icon(
                    FontAwesomeIcons.userAlt,
                    color: Color(0xffC1C0C9),
                    size: 27,
                  ),
                  activeIcon: Icon(
                    FontAwesomeIcons.userAlt,
                    color: Color(0xffFF8960),
                    size: 27,
                  )),
            ]),
        body: IndexedStack(index: current, children: widgets));
  }
}
