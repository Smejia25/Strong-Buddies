import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:strong_buddies_connect/chat/chat.dart';
import 'package:strong_buddies_connect/chat/const.dart';
import 'package:intl/intl.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:strong_buddies_connect/shared/services/auth_service.dart';

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
  }

  void onItemMenuPress(Choice choice) {
    if (choice.title == 'Log out') {
      handleSignOut();
    } else {}
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
        /*    actions: <Widget>[
          PopupMenuButton<Choice>(
            onSelected: onItemMenuPress,
            itemBuilder: (BuildContext context) {
              return choices.map((Choice choice) {
                return PopupMenuItem<Choice>(
                    value: choice,
                    child: Row(
                      children: <Widget>[
                        Icon(
                          choice.icon,
                          color: primaryColor,
                        ),
                        Container(
                          width: 10.0,
                        ),
                        Text(
                          choice.title,
                          style: TextStyle(color: primaryColor),
                        ),
                      ],
                    ));
              }).toList();
            },
          ),
        ], */
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
                                  height: 105,
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

  Widget buildContact(BuildContext context, DocumentSnapshot document) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Stack(children: <Widget>[
            Container(
                margin: const EdgeInsets.only(bottom: 5.0),
                child: Material(
                  child: document.data['photoUrl'] != null
                      ? CachedNetworkImage(
                          placeholder: (context, url) => Container(
                            child: CircularProgressIndicator(
                              strokeWidth: 1.0,
                              valueColor:
                                  AlwaysStoppedAnimation<Color>(themeColor),
                            ),
                            width: 50.0,
                            height: 50.0,
                            padding: EdgeInsets.all(15.0),
                          ),
                          imageUrl: document.data['photoUrl'],
                          width: 50.0,
                          height: 50.0,
                          fit: BoxFit.cover,
                        )
                      : Icon(
                          Icons.account_circle,
                          size: 50.0,
                          color: greyColor,
                        ),
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  clipBehavior: Clip.antiAlias,
                )),
            Positioned(
                bottom: 8,
                left: 40,
                child: ClipOval(
                  child: Material(
                    color: Colors.lightGreenAccent, // button color
                    child: InkWell(
                      splashColor: Colors.red, // inkwell color
                      child: SizedBox(
                        width: 10,
                        height: 10,
                      ),
                      onTap: () {},
                    ),
                  ),
                ))
          ]),
          SizedBox(
            width: 40, // hard coding child width

            child: Text(
              '${document.data['displayName']}',
              textAlign: TextAlign.center,
              style: TextStyle(color: Color(0xFF4A4A4A), fontSize: 13,fontWeight: FontWeight.w500),
            ),
          )
        ],
      ),
    );
  }

  Widget buildItem(BuildContext context, DocumentSnapshot document) {
    double c_width = MediaQuery.of(context).size.width * 0.45;

    return Container(
      child: OutlineButton(
        child: Row(
          children: <Widget>[
            Stack(children: <Widget>[
              Material(
                child: document.data['photoUrl'] != null
                    ? CachedNetworkImage(
                        placeholder: (context, url) => Container(
                          child: CircularProgressIndicator(
                            strokeWidth: 1.0,
                            valueColor:
                                AlwaysStoppedAnimation<Color>(themeColor),
                          ),
                          width: 50.0,
                          height: 50.0,
                          padding: EdgeInsets.all(15.0),
                        ),
                        imageUrl: document.data['photoUrl'],
                        width: 50.0,
                        height: 50.0,
                        fit: BoxFit.cover,
                      )
                    : Icon(
                        Icons.account_circle,
                        size: 50.0,
                        color: greyColor,
                      ),
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                clipBehavior: Clip.hardEdge,
              ),
              Positioned(
                  bottom: 5,
                  left: 40,
                  child: ClipOval(
                    child: Material(
                      color: Colors.lightGreenAccent, // button color
                      child: InkWell(
                        splashColor: Colors.red, // inkwell color
                        child: SizedBox(
                          width: 10,
                          height: 10,
                        ),
                        onTap: () {},
                      ),
                    ),
                  ))
            ]),
            Flexible(
              child: Container(
                padding: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  border: Border(
                    bottom: BorderSide(width: 1.0, color: Color(0xFFEFEFEF)),
                  ),
                  color: Colors.white,
                ),
                child: Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                            child: Container(
                          child: Text(
                            '${document.data['displayName']}',
                            style: TextStyle(
                                color: Color(0xFF4A4A4A), fontSize: 17),
                          ),
                          alignment: Alignment.centerLeft,
                          margin: EdgeInsets.fromLTRB(5.0, 0.0, 0.0, 5.0),
                        )),
                        ConstrainedBox(
                          constraints: new BoxConstraints(
                            minWidth: 80,
                          ),
                          child: Text(
                            DateFormat('dd MMM kk:mm').format(
                                DateTime.fromMillisecondsSinceEpoch(
                                    int.parse(document['timestamp']))),
                            style: TextStyle(
                              color: greyColor,
                              fontSize: 12.0,
                            ),
                          ),
                        )
                      ],
                    ),
                    Container(
                      child: Text(
                        '${document['lastMessage'] ?? 'Not available'}',
                        style:
                            TextStyle(color: Color(0xFFC1C0C9), fontSize: 13),
                      ),
                      alignment: Alignment.centerLeft,
                      margin: EdgeInsets.fromLTRB(10.0, 0.0, 0.0, 0.0),
                    )
                  ],
                ),
                margin: EdgeInsets.only(left: 20.0),
              ),
            ),
          ],
        ),
        onPressed: () {
          print(document.documentID);
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Chat(
                      peerId: document.documentID,
                      peerAvatar: document['photoUrl'],
                      displayName: document.data['displayName'])));
        },
        padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
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
