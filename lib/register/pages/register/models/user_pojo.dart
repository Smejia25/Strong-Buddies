class User {
  String name;
  String email;
  String password;
  String preferTimeToWorkout;
  String gender;
  String gymMembership;
  List<String> pictures;
  List<String> targetGender;
  List<String> workoutType;
  List<String> matches;

  User(
      {this.name,
      this.email,
      this.password,
      this.preferTimeToWorkout,
      this.gender,
      this.gymMembership,
      this.targetGender,
      this.pictures,
      this.matches,
      this.workoutType});

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
    tempUser.pictures = user.pictures ?? this.pictures;
    tempUser.matches = user.matches ?? this.matches;

    return tempUser;
  }

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    preferTimeToWorkout = json['preferTimeToWorkout'];
    gender = json['gender'];
    gymMembership = json['gymMembership'];
    targetGender = json['targetGender'].cast<String>();
    workoutType = json['workoutType'].cast<String>();
    pictures = json['pictures'] != null ? json['pictures'].cast<String>() : [];
    matches = json['matches'] != null ? json['matches'].cast<String>() : [];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['preferTimeToWorkout'] = this.preferTimeToWorkout;
    data['gender'] = this.gender;
    data['gymMembership'] = this.gymMembership;
    data['targetGender'] = this.targetGender;
    data['workoutType'] = this.workoutType;
    data['pictures'] = this.pictures;
    data['matches'] = this.matches;
    return data;
  }
}
