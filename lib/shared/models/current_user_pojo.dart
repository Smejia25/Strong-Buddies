import 'package:strong_buddies_connect/shared/utils/models_util.dart';

import 'buddy_pojo.dart';

class CurrentUser extends Buddy {
  List<String> _targetGender;
  String _email;
  String _name;  
  String _token;

  CurrentUser({List<String> targetGender, String email, String name}) {
    this._targetGender = targetGender;
    this._email = email;
    this._name = name;
  }

  List<String> get targetGender => _targetGender;
  set targetGender(List<String> targetGender) => _targetGender = targetGender;
  String get email => _email;
  set email(String email) => _email = email;
  String get name => _name;
  set name(String name) => _name = name;
  set token(String token) => _token = token;

  CurrentUser.fromPublicJson(Map<String, dynamic> json) {
    gender = json['gender'];
    displayName = json['displayName'];
    preferTimeWorkout = json['preferTimeWorkout'];
    gymMemberShip = json['gymMemberShip'];
    pictures = castJsonPropertyToListToList<String>(json, 'pictures');
    workoutTypes = json['workoutTypes'].cast<String>();
  }

  void fromPrivateJson(Map<String, dynamic> json) {
    _targetGender = json['targetGender'].cast<String>();
    _email = json['email'];
    _name = json['name'];
  }

  Map<String, dynamic> publicInfotoJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gender'] = this.gender;
    data['displayName'] = this.displayName;
    data['preferTimeWorkout'] = this.preferTimeWorkout;
    data['gymMemberShip'] = this.gymMemberShip;
    data['pictures'] = this.pictures;
    data['workoutTypes'] = this.workoutTypes;

    return data;
  }

  Map<String, dynamic> privateInfotoJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['targetGender'] = this.targetGender;
    data['email'] = this.email;
    data['name'] = this.name;
    data['token'] = this._token;

    return data;
  }

  mergeData(CurrentUser currentUser) {}
}
