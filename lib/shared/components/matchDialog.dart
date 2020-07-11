import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:strong_buddies_connect/chat/const.dart';
import 'package:strong_buddies_connect/chat/chat.dart';

class MatchDialog extends StatelessWidget {
  const MatchDialog({Key key, this.buddy}) : super(key: key);

  final Map<dynamic, dynamic> buddy;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      contentPadding: EdgeInsets.all(0.0),
      content: Container(
          height: 400,
          child: Stack(
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    height: 200,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/images/Popup_match.png"),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20)),
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFFFF8960),
                          const Color(0xFFFF62A5),
                        ],
                        stops: [0.5502, 1],
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                      ),
                    ),
                  ),
                  Expanded(
                      child: Container(
                    height: 200,
                    padding: EdgeInsets.only(bottom: 20),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Text(
                        buddy['displayName'],
                        style: TextStyle(fontWeight: FontWeight.w500),
                      ),
                    ),
                  )),
                  RaisedButton(
                    color: Color(0xFFFF8960),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red)),
                    onPressed: () {
                      Navigator.of(context).pop();

                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => Chat(
                                  peerId: buddy['documentID'],
                                  peerAvatar: buddy['photoUrl'],
                                  displayName: buddy['displayName'])));
                    },
                    child: Text(
                      'Send a message',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  OutlineButton(
                    color: Colors.white,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.red)),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    borderSide: BorderSide(style: BorderStyle.none),
                    child: Text(
                      'Keep looking',
                      style: TextStyle(color: Color(0xffC1C0C9)),
                    ),
                  )
                ],
              ),
              Center(
                  child: Padding(
                      padding: EdgeInsets.only(bottom: 150.0),
                      child: Material(
                        child: buddy['photoUrl'] != null
                            ? CachedNetworkImage(
                                placeholder: (context, url) => Container(
                                  child: CircularProgressIndicator(
                                    strokeWidth: 1.0,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        themeColor),
                                  ),
                                  width: 140.0,
                                  height: 140.0,
                                  padding: EdgeInsets.all(15.0),
                                ),
                                imageUrl: buddy['photoUrl'],
                                width: 140.0,
                                height: 140.0,
                                fit: BoxFit.cover,
                              )
                            : Icon(
                                Icons.account_circle,
                                size: 50.0,
                                color: greyColor,
                              ),
                        borderRadius: BorderRadius.all(Radius.circular(100.0)),
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                      ))),
              Center(
                child: Image.asset("assets/images/match.png"),
              )
            ],
          )),
    );
  }
}
