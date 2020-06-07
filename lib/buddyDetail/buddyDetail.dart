import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:strong_buddies_connect/matching/components/match_button.dart';
import 'package:strong_buddies_connect/matching/components/match_card.dart';
import 'package:strong_buddies_connect/register/pages/newRegister/register_page.dart';
import 'package:strong_buddies_connect/shared/models/buddy_pojo.dart';
import 'package:strong_buddies_connect/shared/models/current_user_notifier.dart';

class BuddyDetail extends StatelessWidget {
  BuddyDetail({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final currentUser =
        Provider.of<CurrentUserNotifier>(context, listen: false).user;
    final Buddy potentialBuddy = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            ListView(
              children: <Widget>[
                Container(
                  height: ScreenUtil().setHeight(567),
                  child: Hero(
                    tag: 'images',
                    child: PictureCarousel(pictures: potentialBuddy.pictures),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 17, horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Hero(
                        tag: 'displayNameProperty',
                        child: Text(
                          potentialBuddy.displayName ?? '',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: ScreenUtil().setSp(20),
                              color: Color(0xff4A4A4A),
                              letterSpacing: 0.225882),
                        ),
                      ),
                      SizedBox(height: 10),
                      Hero(
                        tag: 'inCommon',
                        child: Text('Colombia, Medellín',
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(15),
                                color: Color(0xffC1C0C9),
                                letterSpacing: -0.36)),
                      )
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 17, horizontal: 16),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        const TitleOption(title: 'About'),
                        SizedBox(height: 7),
                        Text(potentialBuddy.aboutMe ?? '',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(16),
                              letterSpacing: -0.41,
                              height: 1.29,
                            )),
                        SizedBox(height: 30),
                        const TitleOption(title: 'Intereresting'),
                        SizedBox(height: 15),
                        Wrap(
                          alignment: WrapAlignment.start,
                          spacing: 10,
                          runSpacing: 10,
                          children: potentialBuddy.workoutTypes == null
                              ? []
                              : potentialBuddy.workoutTypes
                                  .map((workType) => SelectOption(
                                        name: workType,
                                        isItemSelected: currentUser.workoutTypes
                                            .contains(workType),
                                        onTap: (_) {},
                                      ))
                                  .toList(),
                        ),
                        SizedBox(height: 30),
                        const TitleOption(title: 'Gender'),
                        SizedBox(height: 10),
                        Text(potentialBuddy.gender ?? '',
                            style: TextStyle(
                              color: currentUser.targetGender
                                      .contains(potentialBuddy.gender)
                                  ? Color(0xffff689a)
                                  : null,
                              fontSize: ScreenUtil().setSp(16),
                              letterSpacing: -0.41,
                              height: 1.29,
                            )),
                        SizedBox(height: 30),
                        const TitleOption(title: 'Own Gym Membership?'),
                        SizedBox(height: 10),
                        Text(potentialBuddy.gymMemberShip ?? '',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(16),
                              color: currentUser.gymMemberShip ==
                                      potentialBuddy.gymMemberShip
                                  ? Color(0xffff689a)
                                  : null,
                              letterSpacing: -0.41,
                              height: 1.29,
                            )),
                        SizedBox(height: 30),
                        const TitleOption(title: 'Prefered time to workout'),
                        SizedBox(height: 10),
                        Text(potentialBuddy.preferTimeWorkout ?? '',
                            style: TextStyle(
                              fontSize: ScreenUtil().setSp(16),
                              letterSpacing: -0.41,
                              color: currentUser.preferTimeWorkout ==
                                      potentialBuddy.preferTimeWorkout
                                  ? Color(0xffff689a)
                                  : null,
                              height: 1.29,
                            )),
                        SizedBox(height: 60)
                      ]),
                )
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Color(0xffffffff),
                      Color.fromRGBO(216, 216, 216, 0.0001)
                    ],
                    stops: [0.1679, 1.0524],
                    begin: Alignment.bottomLeft,
                    end: Alignment.topLeft,
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Hero(
                  tag: 'matchButtons',
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      MatchButton(
                        onPressed: () => Navigator.of(context).pop<bool>(false),
                        icon: Icon(
                          Icons.close,
                          color: Color(0xffC1C0C9),
                        ),
                      ),
                      SizedBox(width: ScreenUtil().setWidth(30)),
                      MatchButton(
                        onPressed: () => Navigator.of(context).pop<bool>(true),
                        icon: Icon(
                          Icons.favorite,
                          color: Color(0xffFF8960),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                height: 40,
                width: 40,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(40),
                  child: Material(
                    elevation: 1,
                    shape: CircleBorder(),
                    color: Color.fromRGBO(255, 255, 255, 0.1),
                    child: IconButton(
                        splashColor: Colors.white,
                        color: Color.fromRGBO(255, 255, 255, 0.1),
                        icon: Icon(Icons.close, color: Colors.white),
                        iconSize: 20,
                        padding: EdgeInsets.zero,
                        onPressed: () => Navigator.of(context).pop()),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class TitleOption extends StatelessWidget {
  const TitleOption({
    Key key,
    @required this.title,
  }) : super(key: key);

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(title,
        style: TextStyle(
            color: Color(0xff4a4a4a),
            fontSize: ScreenUtil().setSp(18),
            fontWeight: FontWeight.bold,
            letterSpacing: 0.225882));
  }
}
