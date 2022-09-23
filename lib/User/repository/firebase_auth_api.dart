import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FirebaseAuthAPI {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User?> signIn() async {
    GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication? gSA = await googleSignInAccount?.authentication;

    OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: gSA?.idToken,
      accessToken: gSA?.accessToken
    );

    UserCredential authResult = await _auth.signInWithCredential(credential);
    User? user = authResult.user;

    return user;
  }

  signOut() async {
    await _auth.signOut();
    googleSignIn.signOut();
  }

  Future<String> getUid() async {
    return _auth.currentUser!.uid;
  }

}