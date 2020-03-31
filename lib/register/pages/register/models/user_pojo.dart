class User {
  String name;
  String email;
  String password;
  String preferTimeToWorkout;
  String gender;
  String gymMembership;
  List<String> targetGender;
  List<String> workoutType;

  User mergeUserInfo(User user) {
    User tempUser = User();

    tempUser.name = user.name ?? this.name;
    tempUser.email = user.email ?? this.email;
    tempUser.password = user.password ?? this.password;
    tempUser.preferTimeToWorkout =
        user.preferTimeToWorkout ?? this.preferTimeToWorkout;
    tempUser.gender = user.gender ?? this.gender;
    tempUser.targetGender = user.targetGender ?? this.targetGender;
    tempUser.gymMembership = user.gymMembership ?? this.gymMembership;
    tempUser.workoutType = user.workoutType ?? this.workoutType;

    return tempUser;
  }
}
