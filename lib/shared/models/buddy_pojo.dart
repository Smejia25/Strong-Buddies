import 'package:strong_buddies_connect/shared/utils/models_util.dart';

class Buddy {
  String _id;
  String _gender;
  String _displayName;
  String _preferTimeWorkout;
  String _gymMemberShip;
  List<String> _pictures;
  List<String> _workoutTypes;
  String _photoUrl;
  String aboutMe;

  Buddy({
    String id,
    String gender,
    String displayName,
    String preferTimeWorkout,
    String gymMemberShip,
    List<String> pictures,
    List<String> workoutTypes,
  }) {
    this._gender = gender;
    this._displayName = displayName;
    this._preferTimeWorkout = preferTimeWorkout;
    this._gymMemberShip = gymMemberShip;
    this._pictures = pictures;
    this._workoutTypes = workoutTypes;
    this._id = id;
  }

  String get gender => _gender;
  set gender(String gender) => _gender = gender;

  String get displayName => _displayName;
  set displayName(String displayName) => _displayName = displayName;

  String get preferTimeWorkout => _preferTimeWorkout;
  set preferTimeWorkout(String preferTimeWorkout) =>
      _preferTimeWorkout = preferTimeWorkout;

  String get gymMemberShip => _gymMemberShip;
  set gymMemberShip(String gymMemberShip) => _gymMemberShip = gymMemberShip;

  List<String> get pictures => _pictures;
  set pictures(List<String> pictures) => _pictures = pictures;

  List<String> get workoutTypes => _workoutTypes;
  set workoutTypes(List<String> workoutTypes) => _workoutTypes = workoutTypes;

  String get id => _id;
  set id(String id) => _id = id;

  String get photoUrl => _photoUrl;
  set photoUrl(String photoUrl) => _photoUrl = photoUrl;

  Buddy.fromJson(Map<String, dynamic> json) {
    _gender = json['gender'];
    _displayName = json['displayName'];
    _preferTimeWorkout = json['preferTimeWorkout'];
    _gymMemberShip = json['gymMemberShip'];
    _pictures = castJsonPropertyToListToList(json,'pictures');
    _workoutTypes = castJsonPropertyToListToList(json,'workoutTypes');
    _photoUrl = json['photoUrl'];
    aboutMe = json['aboutMe'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['gender'] = this._gender;
    data['displayName'] = this._displayName;
    data['preferTimeWorkout'] = this._preferTimeWorkout;
    data['gymMemberShip'] = this._gymMemberShip;
    data['pictures'] = this._pictures;
    data['workoutTypes'] = this._workoutTypes;
    data['photoUrl'] = this._photoUrl;
    data['aboutMe'] = this.aboutMe;
    return data;
  }
}
