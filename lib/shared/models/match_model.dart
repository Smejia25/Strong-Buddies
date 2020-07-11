import 'package:strong_buddies_connect/shared/utils/models_util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Match {
  String _id;
  String _displayName;
  String _photoUrl;

  Match({
    String id,
    String displayName,
    String photoUrl,
  }) {
    this._displayName = displayName;
    this._photoUrl = photoUrl;
    this._id = id;
  }

  String get displayName => _displayName;
  set displayName(String displayName) => _displayName = displayName;

  String get id => _id;
  set id(String id) => _id = id;

  String get photoUrl => _photoUrl;
  set photoUrl(String photoUrl) => _photoUrl = photoUrl;

  Match.fromJson(Map<String, dynamic> json) {
    _displayName = json['displayName'];
    _photoUrl = json['photoUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['displayName'] = this._displayName;
    data['photoUrl'] = this._photoUrl;
    return data;
  }

  static Match fromSnapshot(DocumentSnapshot snap) {
    return Match(
      id: snap.documentID,
      displayName: snap.data['displayName'],
      photoUrl: snap.data['photoUrl'],
    );
  }
}
