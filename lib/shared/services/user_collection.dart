import 'package:cloud_firestore/cloud_firestore.dart';
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

  Future<Buddy> getUser(String email) async {
    final userDocument =
        await _firestoreInstance.collection(_collection).document(email).get();
    if (userDocument == null || !userDocument.exists) return null;

    return Buddy.fromJson(userDocument.data);
  }

  Future<void> updateUserPictures(String userId, List<String> pictures) {
    return _firestoreInstance
        .collection(_collection)
        .document(userId)
        .setData({'pictures': pictures}, merge: true);
  }

  Future<List<Buddy>> getBuddies() async {
    /* return (await _firestoreInstance.collection(_collection).getDocuments())
        .documents
        .map((document) => User.fromJson(document.data))
        .toList(); */
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
    CurrentUser currentUser,
    String rejectedBuddyEmail,
  ) {
    /* return _firestoreInstance
        .collection(_collection)
        .document(currentUser.email)
        .setData({
      'matches': [...currentUser.matches, rejectedBuddyEmail]
    }, merge: true); */
  }
}
