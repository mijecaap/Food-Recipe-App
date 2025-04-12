import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:flutter/foundation.dart';
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
    String uid,
    bool subscription,
    String paymentId,
  );
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
  }) : _auth = auth,
       _firestore = firestore,
       _googleSignIn = googleSignIn,
       _facebookAuth = facebookAuth;

  @override
  Stream<firebase.User?> get authStateChanges => _auth.authStateChanges();

  @override
  Future<firebase.User?> signInWithGoogle() async {
    try {
      // Mover la operación pesada a un compute
      final googleUser = await compute(_signInWithGoogle, _googleSignIn);
      if (googleUser == null) return null;

      final googleAuth = await googleUser.authentication;
      final credential = firebase.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print('Error en signInWithGoogle: $e');
      return null;
    }
  }

  @override
  Future<firebase.User?> signInWithFacebook() async {
    try {
      // Mover la operación pesada a un compute
      final result = await compute(_signInWithFacebook, _facebookAuth);
      if (result == null) return null;

      final credential = firebase.FacebookAuthProvider.credential(result);
      final userCredential = await _auth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print('Error en signInWithFacebook: $e');
      return null;
    }
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
    try {
      final doc = await _firestore.collection('users').doc(uid).get();
      if (doc.exists) {
        return UserModel.fromJson(doc.data()!);
      }
      return UserModel(uid: '', name: '', email: '', photoURL: '');
    } catch (e) {
      print('Error en getUser: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateUserData(UserModel user) async {
    try {
      final batch = _firestore.batch();
      final userRef = _firestore.collection('users').doc(user.uid);
      batch.set(userRef, user.toJson(), SetOptions(merge: true));
      await batch.commit();
    } catch (e) {
      print('Error en updateUserData: $e');
      rethrow;
    }
  }

  @override
  Future<void> updateSubscription(
    String uid,
    bool subscription,
    String paymentId,
  ) async {
    await _firestore.collection('users').doc(uid).update({
      'subscription': subscription,
      'idPayment': paymentId,
    });
  }
}

// Funciones auxiliares para compute
Future<GoogleSignInAccount?> _signInWithGoogle(
  GoogleSignIn googleSignIn,
) async {
  return await googleSignIn.signIn();
}

Future<String?> _signInWithFacebook(FacebookAuth facebookAuth) async {
  final result = await facebookAuth.login();
  if (result.status != LoginStatus.success) return null;
  return result.accessToken?.tokenString;
}
