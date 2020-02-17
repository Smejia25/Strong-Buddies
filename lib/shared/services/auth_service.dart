import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:rxdart/rxdart.dart';

class AuthService {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Stream<FirebaseUser> user;

  AuthService() {
    user = _auth.onAuthStateChanged;
  }

  Future<void> singOut() async {
    await _auth.signOut();
  }

  Future<FirebaseUser> login(String email, String passwod) async {
    final reuslt =
        await _auth.signInWithEmailAndPassword(email: email, password: passwod);
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
    if (googleUser == null) throw Exception('');

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

    switch (result.status) {
      case FacebookLoginStatus.cancelledByUser:
        throw Exception('');
        break;
      case FacebookLoginStatus.error:
        throw FormatException(result.errorMessage);
        break;
      default:
        break;
    }
    final fbAuthCredential = FacebookAuthProvider.getCredential(
        accessToken: result.accessToken.token);
    final userInfo = (await _auth.signInWithCredential(fbAuthCredential)).user;
    return userInfo;
  }
}
