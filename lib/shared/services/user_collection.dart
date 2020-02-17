import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:strong_buddies_connect/register/user_data/model/register_user.dart';

class UserCollection {
  final Firestore _firestoreInstance = Firestore.instance;
  final String _collection = 'users';

  Future<void> getUserInfo(RegisterUser user) {
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
}
