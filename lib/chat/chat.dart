import 'package:flutter/material.dart';
import 'package:strong_buddies_connect/chat/chat.state.dart';
import 'package:strong_buddies_connect/buddyDetail/buddyDetail.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:strong_buddies_connect/chat/const.dart';

const PrimaryColor = const Color(0xFF151026);

class Chat extends StatelessWidget {
  final String peerId;
  final String peerAvatar;
  final String displayName;

  Chat(
      {Key key,
      @required this.peerId,
      @required this.peerAvatar,
      @required this.displayName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        iconTheme: IconThemeData(
          color: Colors.black, //change your color here
        ),
        backgroundColor: greyColor2,
        title: new Text(
          'Message',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        centerTitle: true,
        actions: <Widget>[
          Padding(
              padding: EdgeInsets.only(right: 20.0, top: 8, bottom: 8),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BuddyDetail(
                                peerId: this.peerId,
                                peerAvatar: this.peerAvatar,
                              )));
                },
                child: Material(
                  child: CachedNetworkImage(
                    placeholder: (context, url) => Container(
                      child: CircularProgressIndicator(
                        strokeWidth: 1.0,
                        valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                      ),
                      width: 40.0,
                      height: 40.0,
                      padding: EdgeInsets.all(15.0),
                    ),
                    imageUrl: peerAvatar,
                    width: 40.0,
                    height: 40.0,
                    fit: BoxFit.cover,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(25.0)),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                ),
              )),
        ],
      ),
      body: new ChatScreen(
        peerId: peerId,
        peerAvatar: peerAvatar,
        displayName: displayName,
      ),
    );
  }
}

class ChatScreen extends StatefulWidget {
  final String peerId;
  final String peerAvatar;
  final String displayName;

  ChatScreen(
      {Key key,
      @required this.peerId,
      @required this.peerAvatar,
      @required this.displayName})
      : super(key: key);

  @override
  State createState() => new ChatScreenState(
      peerId: peerId, peerAvatar: peerAvatar, displayName: displayName);
}
