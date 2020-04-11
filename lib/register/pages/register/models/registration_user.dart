import 'package:strong_buddies_connect/shared/models/current_user_pojo.dart';

class RegistrationUser extends CurrentUser {
  String password;

  RegistrationUser mergeUserInfo(
      RegistrationUser registrationUserWithNewDataToBeMerged) {
    RegistrationUser mergedUserInfo = RegistrationUser();

    mergedUserInfo.gender =
        registrationUserWithNewDataToBeMerged.gender ?? this.gender;
    mergedUserInfo.displayName =
        registrationUserWithNewDataToBeMerged.displayName ?? this.displayName;
    mergedUserInfo.preferTimeWorkout =
        registrationUserWithNewDataToBeMerged.preferTimeWorkout ??
            this.preferTimeWorkout;
    mergedUserInfo.gymMemberShip =
        registrationUserWithNewDataToBeMerged.gymMemberShip ??
            this.gymMemberShip;
    mergedUserInfo.pictures =
        registrationUserWithNewDataToBeMerged.pictures ?? this.pictures;
    mergedUserInfo.workoutTypes =
        registrationUserWithNewDataToBeMerged.workoutTypes ?? this.workoutTypes;
    mergedUserInfo.targetGender =
        registrationUserWithNewDataToBeMerged.targetGender ?? this.targetGender;
    mergedUserInfo.email =
        registrationUserWithNewDataToBeMerged.email ?? this.email;
    mergedUserInfo.name =
        registrationUserWithNewDataToBeMerged.name ?? this.name;
    mergedUserInfo.password =
        registrationUserWithNewDataToBeMerged.password ?? this.password;

    return mergedUserInfo;
  }
}
