import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:strong_buddies_connect/chat/chat.dart';
import 'package:strong_buddies_connect/chat/const.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:strong_buddies_connect/chatList/components/buildChatItem.dart';
import 'package:strong_buddies_connect/chatList/components/buildContact.dart';
import 'package:strong_buddies_connect/shared/components/circle_image.dart';
import 'package:strong_buddies_connect/shared/components/status_circle.dart';
import 'package:strong_buddies_connect/shared/services/auth/auth_service.dart';

class ChatList extends StatefulWidget {
  ChatList({Key key}) : super(key: key);

  @override
  State createState() => ChatListState();
}

class ChatListState extends State<ChatList> {
  ChatListState({Key key});
  final TextEditingController textEditingController =
      new TextEditingController();
  final FocusNode focusNode = new FocusNode();
  String currentUserId;
  final FirebaseMessaging firebaseMessaging = new FirebaseMessaging();
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final auth = AuthService();
  

  bool isLoading = false;
  List<Choice> choices = const <Choice>[
    const Choice(title: 'Settings', icon: Icons.settings),
    const Choice(title: 'Log out', icon: Icons.exit_to_app),
  ];

  @override
  void initState() {
    super.initState();
        textEditingController.addListener(_printLatestValue);

  }

  void onItemMenuPress(Choice choice) {
    if (choice.title == 'Log out') {
      handleSignOut();
    } else {}
  }

  _printLatestValue() {
    print("Second text field: ${textEditingController.text}");
  }

  Future<bool> onBackPress() {
    // return Future.value(false);
  }

  Future<Null> handleSignOut() async {
    this.setState(() {
      isLoading = true;
    });

    await FirebaseAuth.instance.signOut();
    await googleSignIn.disconnect();
    await googleSignIn.signOut();

    this.setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottomOpacity: 0.0,
        elevation: 0.0,
        backgroundColor: Color(0xFFF8F8F8),
        title: Text(
          'Message',
          style: TextStyle(
              color: Color(0xFF262628),
              fontWeight: FontWeight.bold,
              fontSize: 25),
        ),
        centerTitle: false,
      ),
      body: Stack(
        children: <Widget>[
          // List
          Container(
              child: Column(
            children: <Widget>[
              buildInput(),
              FutureBuilder<FirebaseUser>(
                future: auth.getCurrentUser(),
                builder: (context, userData) {
                  if (userData.hasData)
                    return StreamBuilder(
                      stream: Firestore.instance
                          .collection('users')
                          .document(userData.data.uid)
                          .collection('matches')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(themeColor),
                            ),
                          );
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: <Widget>[
                              Container(
                                decoration: BoxDecoration(color: Colors.white),
                                padding: EdgeInsets.all(15),
                                child: Text(
                                  'MATCHES',
                                  textAlign: TextAlign.start,
                                  style: TextStyle(
                                      color: Color(0xFFC1C0C9), fontSize: 15),
                                ),
                              ),
                              Container(
                                  height: 130,
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, index) =>
                                        buildContact(context,
                                            snapshot.data.documents[index]),
                                    itemCount: snapshot.data.documents.length,
                                  ))
                            ],
                          );
                        }
                      },
                    );
                  else
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                      ),
                    );
                },
              ),
              Container(
                height: 10,
                decoration: BoxDecoration(color: Color(0xFFF7F7F7)),
              ),
              FutureBuilder<FirebaseUser>(
                future: auth.getCurrentUser(),
                builder: (context, userData) {
                  if (userData.hasData)
                    return StreamBuilder(
                      stream: Firestore.instance
                          .collection('users')
                          .document(userData.data.uid)
                          .collection('chattingWith')
                          .snapshots(),
                      builder: (context, snapshot) {
                        if (!snapshot.hasData) {
                          return Center(
                            child: CircularProgressIndicator(
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(themeColor),
                            ),
                          );
                        } else {
                          return Expanded(
                              child: Container(
                                  decoration:
                                      BoxDecoration(color: Colors.white),
                                  child: ListView.builder(
                                    itemBuilder: (context, index) => buildItem(
                                        context,
                                        snapshot.data.documents[index]),
                                    itemCount: snapshot.data.documents.length,
                                  )));
                        }
                      },
                    );
                  else
                    return Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                      ),
                    );
                },
              ),
            ],
          )),

          // Loading
          Positioned(
            child: isLoading
                ? Container(
                    child: Center(
                      child: CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(themeColor)),
                    ),
                    color: Colors.white.withOpacity(0.8),
                  )
                : Container(),
          )
        ],
      ),
    );
  }

  Widget buildInput() {
    return Container(
      padding: EdgeInsets.all(10),
      child: Row(
        children: <Widget>[
          // Button send image

          // Edit text
          Flexible(
            child: Container(
              height: 50,
              child: TextField(
                onChanged: (text) {
                  print("First text field: $text");
                },
                style: TextStyle(
                  color: Color(0xFF9B9B9B),
                  fontSize: 15.0,
                ),
                controller: textEditingController,
                decoration: InputDecoration(
                  fillColor: Color(0xFFE6E6E6),
                  prefixIcon: Icon(Icons.search, color: Color(0xFFC1C0C9)),
                  hintText: 'Search...',
                  enabledBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(5.0),
                    ),
                    borderSide:
                        BorderSide(color: Color(0xffE9E9E9), width: 1.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                    borderSide:
                        BorderSide(color: Color(0xffE9E9E9), width: 1.0),
                  ),
                  errorBorder: InputBorder.none,
                  border: OutlineInputBorder(
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(10.0),
                    ),
                    borderSide:
                        BorderSide(color: Color(0xffE9E9E9), width: 1.0),
                  ),
                  contentPadding:
                      EdgeInsets.only(left: 15, bottom: 0, top: 0, right: 15),
                ),
                focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
        ],
      ),
      width: double.infinity,
      height: 55.0,
      decoration: new BoxDecoration(
          border:
              new Border(top: new BorderSide(color: greyColor2, width: 0.5)),
          color: Color(0xFFF8F8F8)),
    );
  }
}

class Choice {
  const Choice({this.title, this.icon});

  final String title;
  final IconData icon;
}
