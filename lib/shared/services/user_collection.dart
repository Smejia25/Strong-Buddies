import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:strong_buddies_connect/matching/models/matched_buddy_pojo.dart';
import 'package:strong_buddies_connect/shared/models/buddy_pojo.dart';
import 'package:strong_buddies_connect/shared/models/current_user_pojo.dart';

class UserCollection {
  final Firestore _firestoreInstance = Firestore.instance;
  final String _collection = 'users';
  CurrentUser currentUserInfo;

  Future<void> setUserInfo(CurrentUser user) async {
    final document =
        _firestoreInstance.collection(_collection).document(user.id);
    await document.setData(user.publicInfotoJson(), merge: true);
    await document
        .collection('private_info')
        .document('private')
        .setData(user.privateInfotoJson());
  }

  Future<CurrentUser> getCurrentUserInfo(String id) async {
    if (currentUserInfo != null) return currentUserInfo;

    final documentRef = _firestoreInstance.collection(_collection).document(id);

    final publicDataPromise = documentRef.get();
    final privateDataPromise =
        documentRef.collection('private_info').document('private').get();

    final result = await Future.wait<DocumentSnapshot>(
        [publicDataPromise, privateDataPromise]);

    if (result.any((doc) => doc == null || !doc.exists)) return null;

    CurrentUser currentUser = CurrentUser.fromPublicJson(result[0].data);
    currentUser.fromPrivateJson(result[1].data);
    currentUser.id = id;

    return currentUserInfo = currentUser;
  }

  Future<void> updateNotificationTokens(String token, String userId) {
    return _firestoreInstance
        .collection(_collection)
        .document(userId)
        .setData({'token': token}, merge: true);
  }

  Future<Buddy> getUser(String email) async {
    final userDocument =
        await _firestoreInstance.collection(_collection).document(email).get();
    if (userDocument == null || !userDocument.exists) return null;

    return Buddy.fromJson(userDocument.data);
  }

  Future<void> updateUserPictures(
    String userId,
    List<String> pictures,
    int indexOfProfilePic,
  ) {
    return _firestoreInstance.collection(_collection).document(userId).setData(
        {'pictures': pictures, 'photoUrl': pictures[indexOfProfilePic]},
        merge: true);
  }

  Future<List<Buddy>> getBuddies() async {
    return (await _firestoreInstance.collection(_collection).getDocuments())
        .documents
        .where((doc) => doc.exists)
        .map((document) =>
            Buddy.fromJson(document.data)..id = document.documentID)
        .toList();
  }

  Future<List<String>> getAlreadyAnalizedBuddies(String userId) async {
    return (await _firestoreInstance
            .collection(_collection)
            .document(userId)
            .collection('analyzed_buddies')
            .getDocuments())
        .documents
        .where((doc) => doc.exists)
        .map((doc) => doc.documentID)
        .toList();
  }

  StreamSubscription<QuerySnapshot> listenToChanges(
    String userId,
    void Function(List<MatchedBuddy>) callback,
  ) {
    bool isFisrtTime = true;
    return _firestoreInstance
        .collection(_collection)
        .document(userId)
        .collection('matches')
        .snapshots()
        .listen((data) {
      if (isFisrtTime) {
        isFisrtTime = false;
        return;
      }
      callback(data.documentChanges
          .where((d) => d.document.exists)
          .map((x) => MatchedBuddy.fromJson(x.document.data))
          .toList());
    });
  }

  Future<bool> doesTheUserExistInTheDataBase(String email) async {
    /* final user = await getUser('dcNYpK545cxIA35iVjkb');
    return user != null; */
  }

  Future<bool> doesTheUserHavePictures(String email) async {
    /* final user = await getUser(email);
    return user.pictures != null; */
  }

  Future<void> setBuddyInTheRejectionList(
    String currentUserId,
    String buddyId,
    bool wasAMatch,
  ) {
    return _firestoreInstance
        .collection(_collection)
        .document(currentUserId)
        .collection('analyzed_buddies')
        .document(buddyId)
        .setData({'wasAMatch': wasAMatch}, merge: false);
  }
}
