import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:strong_buddies_connect/register/user_data/model/register_user.dart';

class UserCollection {
  final Firestore _firestoreInstance = Firestore.instance;
  final String _collection = 'users';

  Future<void> setUserInfo(RegisterUser user) {
    return _firestoreInstance
        .collection(_collection)
        .document(user.email)
        .setData({
      'firstName': user.firstName,
      'lastName': user.lastName,
      'email': user.email,
      'preferTimeToWorkout': user.preferTimeToWorkout,
      'gender': user.gender,
      'targetGender': user.targetGender,
      'workoutType': user.workoutType,
    });
  }

  Future<DocumentSnapshot> getUser(String email) {
    return _firestoreInstance.collection(_collection).document(email).get();
  }

  Future<void> updateUserPictures(String userEmail, List<String> pictures) {
    return _firestoreInstance
        .collection(_collection)
        .document(userEmail)
        .setData({'pictures': pictures}, merge: true);
  }

  Future<QuerySnapshot> getBuddies() {
    return _firestoreInstance.collection(_collection).getDocuments();
  }
}
