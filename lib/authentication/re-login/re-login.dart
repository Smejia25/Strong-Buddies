import 'package:flutter/material.dart';
import 'package:strong_buddies_connect/routes.dart';
import 'package:strong_buddies_connect/shared/components/circle_image.dart';
import 'package:strong_buddies_connect/shared/models/current_user_pojo.dart';
import 'package:strong_buddies_connect/shared/services/auth/auth_service.dart';
import 'package:strong_buddies_connect/shared/services/user_collection.dart';

class ReLoginPage extends StatefulWidget {
  ReLoginPage({Key key}) : super(key: key);

  @override
  _reLoginState createState() => _reLoginState();
}

class _reLoginState extends State<ReLoginPage> {
  final _auth = AuthService();
  final _userCollection = UserCollection();

  Future<CurrentUser> getUser() async {
    final user = await _auth.getCurrentUser();
    final ls = await _userCollection.getCurrentUserInfo(user.uid);
    return ls;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          color: Color(0xffF7B0B6),
        ),
        child: Column(
          children: <Widget>[
            Center(
              child: Container(
                width: 100,
                decoration: BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage(
                  "assets/images/dumbell.png",
                ))),
              ),
            ),
            FutureBuilder<CurrentUser>(
                future: getUser(),
                builder: (context, data) {
                  if (!data.hasData) return Container();
                  final user = data.data;

                  return Container(
                      padding: EdgeInsets.fromLTRB(20, 50, 20, 50),
                      child: Column(
                        children: [
                          Container(
                            width: 100,
                            margin: EdgeInsets.only(bottom: 180),
                            child: Image(
                                image: AssetImage('assets/images/dumbell.png')),
                          ),
                          CircleImage(
                            imageUrl: user.photoUrl,
                            width: 120,
                            heigth: 120,
                            radius: 60,
                          ),
                          Container(
                              padding: EdgeInsets.all(20),
                              child: TextButton(
                                onPressed: () => {
                                  _auth.preLogOut(false),
                                  Navigator.pushNamedAndRemoveUntil(
                                      context, Routes.matchPage, (_) => false)
                                },
                                child: Text(
                                  'Log in as ${user.name}',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 55,
                                      fontWeight: FontWeight.w700),
                                  textAlign: TextAlign.center,
                                ),
                              )),
                          Container(
                            margin: EdgeInsets.only(top: 180),
                            child: Column(
                              children: [
                                Text(
                                  'Not ${user.name}?',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w600),
                                  textAlign: TextAlign.center,
                                ),
                                TextButton(
                                    onPressed: () => {
                                          _auth.preLogOut(false),
                                          Navigator.pushNamedAndRemoveUntil(
                                              context,
                                              Routes.loginPage,
                                              (_) => false),
                                          _auth.singOut()
                                        },
                                    child: Text(
                                      'Create or log in with a different account',
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 18,
                                          fontWeight: FontWeight.w200),
                                      textAlign: TextAlign.center,
                                    ))
                              ],
                            ),
                          )
                        ],
                      ));
                })
          ],
        ),
      ),
    );
  }
}
