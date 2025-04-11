import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:recipez/features/auth/data/models/user_model.dart';

abstract class AuthRemoteDataSource {
  Stream<firebase.User?> get authStateChanges;
  Future<firebase.User?> signInWithGoogle();
  Future<firebase.User?> signInWithFacebook();
  Future<void> signOut();
  Future<String> getCurrentUserId();
  Future<UserModel> getUser(String uid);
  Future<void> updateUserData(UserModel user);
  Future<void> updateSubscription(
      String uid, bool subscription, String paymentId);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final firebase.FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final GoogleSignIn _googleSignIn;
  final FacebookAuth _facebookAuth;

  AuthRemoteDataSourceImpl({
    required firebase.FirebaseAuth auth,
    required FirebaseFirestore firestore,
    required GoogleSignIn googleSignIn,
    required FacebookAuth facebookAuth,
  })  : _auth = auth,
        _firestore = firestore,
        _googleSignIn = googleSignIn,
        _facebookAuth = facebookAuth;

  @override
  Stream<firebase.User?> get authStateChanges => _auth.authStateChanges();

  @override
  Future<firebase.User?> signInWithGoogle() async {
    final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null;

    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final credential = firebase.GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCredential = await _auth.signInWithCredential(credential);
    return userCredential.user;
  }

  @override
  Future<firebase.User?> signInWithFacebook() async {
    final LoginResult result = await _facebookAuth.login();
    if (result.status != LoginStatus.success) return null;

    final credential = firebase.FacebookAuthProvider.credential(
        result.accessToken!.tokenString);
    final userCredential = await _auth.signInWithCredential(credential);
    return userCredential.user;
  }

  @override
  Future<void> signOut() async {
    await Future.wait([
      _auth.signOut(),
      _googleSignIn.signOut(),
      _facebookAuth.logOut(),
    ]);
  }

  @override
  Future<String> getCurrentUserId() async {
    return _auth.currentUser?.uid ?? '';
  }

  @override
  Future<UserModel> getUser(String uid) async {
    final doc = await _firestore.collection('users').doc(uid).get();
    if (doc.exists) {
      return UserModel.fromJson(doc.data()!);
    }
    return UserModel(
      uid: '',
      name: '',
      email: '',
      photoURL: '',
    );
  }

  @override
  Future<void> updateUserData(UserModel user) async {
    await _firestore.collection('users').doc(user.uid).set(
          user.toJson(),
          SetOptions(merge: true),
        );
  }

  @override
  Future<void> updateSubscription(
      String uid, bool subscription, String paymentId) async {
    await _firestore.collection('users').doc(uid).update({
      'subscription': subscription,
      'idPayment': paymentId,
    });
  }
}
