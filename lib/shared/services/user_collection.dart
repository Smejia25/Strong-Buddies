import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:strong_buddies_connect/register/pages/register/models/user_pojo.dart';

class UserCollection {
  final Firestore _firestoreInstance = Firestore.instance;
  final String _collection = 'users';

  Future<void> setUserInfo(User user) {
    return _firestoreInstance
        .collection(_collection)
        .document(user.email)
        .setData(user.toJson());
  }

  Future<User> getUser(String email) async {
    return User.fromJson(
        (await _firestoreInstance.collection(_collection).document(email).get())
            .data);
  }

  Future<void> updateUserPictures(String userEmail, List<String> pictures) {
    return _firestoreInstance
        .collection(_collection)
        .document(userEmail)
        .setData({'pictures': pictures}, merge: true);
  }

  Future<List<User>> getBuddies() async {
    return (await _firestoreInstance.collection(_collection).getDocuments())
        .documents
        .map((document) => User.fromJson(document.data))
        .toList();
  }

  Future<bool> doesTheUserExistInTheDataBase(String email) async {
    final user = await getUser(email);
    return user != null;
  }

  Future<bool> doesTheUserHavePictures(String email) async {
    final user = await getUser(email);
    return user.pictures != null;
  }

  Future<void> setBuddyInTheRejectionList(
    User currentUser,
    String rejectedBuddyEmail,
  ) {
    return _firestoreInstance
        .collection(_collection)
        .document(currentUser.email)
        .setData({
      'matches': [...currentUser.matches, rejectedBuddyEmail]
    }, merge: true);
  }
}
