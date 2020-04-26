import 'package:flutter/material.dart';
import 'package:strong_buddies_connect/buddyDetail/buddyDetail.state.dart';

class BuddyDetail extends StatelessWidget {
  final String peerId;
  final String peerAvatar;

  BuddyDetail({Key key, @required this.peerId, @required this.peerAvatar})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(
          'StrongBuddiesConnect',
          style:
              TextStyle(color: Color(0xFFFFFFFF), fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: new BuddyScreen(
        peerId: peerId,
        peerAvatar: peerAvatar,
      ),
    );
  }
}

class BuddyScreen extends StatefulWidget {
  final String peerId;
  final String peerAvatar;

  BuddyScreen({Key key, @required this.peerId, @required this.peerAvatar})
      : super(key: key);

  @override
  State createState() =>
      new BuddyScreenState(peerId: peerId, peerAvatar: peerAvatar);
}
