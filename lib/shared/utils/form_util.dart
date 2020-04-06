import 'package:validate/validate.dart';

class FormUtil {
  static bool isEmailValid(String emailToBeAnalyzed) {
    bool isEmailValid = true;
    try {
      Validate.isEmail(emailToBeAnalyzed);
    } catch (e) {
      isEmailValid = false;
    }
    return isEmailValid;
  }

  static Function getFunctionDependingOnEnableState(
    bool isButtonDisabled,
    Function onButtonTap,
  ) {
    return isButtonDisabled ? null : onButtonTap;
  }
}
