import 'package:strong_buddies_connect/registration/models/user.pojo.dart';

class CreateUserFactory {
  static final UserPojo _user = UserPojo();

  const CreateUserFactory._internal();

  static final CreateUserFactory _createUserFactory =
      const CreateUserFactory._internal();

  factory CreateUserFactory() {
    return _createUserFactory;
  }

  void assignName(String name) {
    _user.name = name;
    
  }

  void assignCategories(List<String> categories) {
    _user.categories = categories;
  }

  void assignGender(String gender) {
    _user.gender = gender;
  }

  void assignTargetGender(String targetGender) {
    _user.targetGender = targetGender;
  }

  void assignWokoutDayTime(String wokoutDayTime) {
    _user.wokoutDayTime = wokoutDayTime;
  }
}
