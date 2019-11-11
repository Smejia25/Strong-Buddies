import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:rxdart/rxdart.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Observable<FirebaseUser> user;

  AuthService() {
    user = Observable(_auth.onAuthStateChanged);
  }

  Future<void> singOut() async {
    await _auth.signOut();
  }

  Future<FirebaseUser> login(String email, String passwod) async {
    final reuslt =
        await _auth.signInWithEmailAndPassword(email: email, password: passwod);
    if (!reuslt.user.isEmailVerified) {
      singOut();
      throw Exception();
    }
    return reuslt.user;
  }

  Future<void> registerUser(String email, String passwod) async {
    final authresult = await _auth.createUserWithEmailAndPassword(
        email: email, password: passwod);
    await authresult.user.sendEmailVerification();
  }

  Future<void> forgetPassword(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<FirebaseUser> loginWithGoogle() async {
    final GoogleSignInAccount googleUser = await _googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final FirebaseUser user =
        (await _auth.signInWithCredential(credential)).user;

    return user;
  }

  Future<FirebaseUser> loginWithFacebook() async {
    final facebookLogin = FacebookLogin();
    final result = await facebookLogin.logIn(['email']);
    final fbAuthCredential = FacebookAuthProvider.getCredential(
        accessToken: result.accessToken.token);
    final cosa = (await _auth.signInWithCredential(fbAuthCredential)).user;
    print(cosa);
    return cosa;

    /* switch (result.status) {
      case FacebookLoginStatus.loggedIn:
        _sendTokenToServer(result.accessToken.token);
        _showLoggedInUI();
        break;
      case FacebookLoginStatus.cancelledByUser:
        _showCancelledMessage();
        break;
      case FacebookLoginStatus.error:
        _showErrorOnUI(result.errorMessage);
        break;
    } */
  }
}
