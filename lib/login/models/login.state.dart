enum LoginState { Ready, Unable }

class LoginStateData {
  final LoginState loginState;
  String message;

  LoginStateData(this.loginState, {String mesage = ''}) {
    this.message = mesage;
  }
}
