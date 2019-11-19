import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:strong_buddies_connect/registration/registration_page.dart';

class UserInfoPage extends StatefulWidget {
  UserInfoPage({Key key}) : super(key: key);

  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  void _goToPreviousStep(BuildContext context) =>
      Navigator.pushNamed(context, '/');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RegistrationBackground(
          childcolumn: Column(
        children: <Widget>[
          Container(
            child: Align(
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
            ),
          ),
          SizedBox(height: 10,),
          Expanded(
            child: Column(
              children: <Widget>[
                Expanded(
                    child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: Container(
                          height: 20,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xffA1A1A1),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          )),
                    ),
                    Positioned.fill(
                      top: 7,
                      child: Container(
                          height: 20,
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xffC4C4C4),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(10))),
                          )),
                    ),
                    Positioned.fill(
                      child: Padding(
                        padding: EdgeInsets.only(top: 15),
                        child: Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                alignment: Alignment.center,
                                fit: BoxFit.cover,
                                image: ExactAssetImage(
                                    'assets/images/people-2592247_1920.jpg'),
                              ),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                          padding: EdgeInsets.all(1),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: CardBuddy(),
                    )
                  ],
                )),
                Container(
                  height: 120,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 70,
                          height: 70,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              onTap: () {
                                Fluttertoast.showToast(msg: "Dislike");
                              },
                              child: Center(
                                  child: Icon(
                                Icons.cancel,
                                color: Colors.red,
                                size: 40,
                              )),
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                        ),
                        SizedBox(width: 55),
                        Container(
                          width: 70,
                          height: 70,
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                              onTap: () {
                                Fluttertoast.showToast(msg: "Like");
                              },
                              child: Center(
                                  child: Icon(
                                Icons.favorite,
                                color: Colors.green,
                                size: 40,
                              )),
                            ),
                          ),
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100))),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      )),
    );
  }
}

class CardBuddy extends StatelessWidget {
  const CardBuddy({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(
          Radius.circular(10),
        ),
      ),
      width: double.infinity,
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Lindsay, 26',
            style: TextStyle(
                color: Color(0xff5E2F94),
                fontWeight: FontWeight.w500,
                fontSize: 20),
          ),
          SizedBox(
            height: 10,
          ),
          Text(
            'Push-ups, squad, dead weight, joggin',
            style: TextStyle(color: Color(0xff8B779B), fontSize: 14),
          )
        ],
      ),
    );
  }
}
