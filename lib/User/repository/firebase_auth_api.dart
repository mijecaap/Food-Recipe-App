import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'dart:developer';

class FirebaseAuthAPI {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User?> signIn() async {
  try {
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();
    if (googleSignInAccount == null) return null;
    
    final GoogleSignInAuthentication gSA = await googleSignInAccount.authentication;
    
    final OAuthCredential credential = GoogleAuthProvider.credential(
      idToken: gSA.idToken,
      accessToken: gSA.accessToken
    );

    final UserCredential authResult = await _auth.signInWithCredential(credential);
    return authResult.user;
    
  } catch (error) {
    print('Error en el inicio de sesión con Google: $error');
    return null;
  }
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

  Future<String?> getUid() async {
    final user = _auth.currentUser;
    if (user == null) {
      return null;
    }
    return user.uid;
  }

}