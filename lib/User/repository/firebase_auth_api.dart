import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'dart:developer';

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

  Future<User?> singInFacebook() async {
    // Trigger the sign-in flow
    final LoginResult loginResult = await FacebookAuth.instance.login();

    // Create a credential from the access token
    final OAuthCredential facebookAuthCredential = FacebookAuthProvider.credential(loginResult.accessToken!.token);

    // Once signed in, return the UserCredential
    UserCredential authResult = await _auth.signInWithCredential(facebookAuthCredential);
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