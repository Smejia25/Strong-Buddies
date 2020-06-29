import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:strong_buddies_connect/chat/chat.dart';
import 'package:strong_buddies_connect/chat/const.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:strong_buddies_connect/shared/components/circle_image.dart';
import 'package:strong_buddies_connect/shared/components/status_circle.dart';

Widget buildItem(BuildContext context, DocumentSnapshot document) {

    return Container(
      child: OutlineButton(
        child: Row(
          children: <Widget>[
            Stack(children: <Widget>[
              CircleImage(
                  heigth: 50.00,
                  width: 50,
                  imageUrl: document.data['photoUrl']),
              Positioned(
                  bottom: 5,
                  left: 40,
                  child: StatusCircle(color: Colors.lightGreenAccent,size: 10,))
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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => Chat(
                      peerId: document.documentID,
                      peerAvatar: document['photoUrl'],
                      displayName: document.data['displayName'])));
        },
        padding: EdgeInsets.fromLTRB(25.0, 10.0, 25.0, 10.0),
        borderSide: BorderSide(style: BorderStyle.none),
      ),
    );
  }