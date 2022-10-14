import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:generic_bloc_provider/generic_bloc_provider.dart';
import 'package:recipez/User/repository/auth_repository.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../model/user.dart';
import '../repository/cloud_firestore_repository.dart';

class UserBloc implements Bloc {

  final _auth_repository = AuthRepository();

  // Flujo de datos - Streams
  // Stream - Firebase
  // StreamController
  Stream<User?> streamFirebase = FirebaseAuth.instance.authStateChanges();
  Future<AccessToken?> futureAccessToken = FacebookAuth.instance.accessToken;
  Stream<User?> get authStatus => streamFirebase;

  // Casos de usa
  // 1. Sign In a la aplicación Google
  Future<User?> signIn() {
    return _auth_repository.signInFirebase();
  }

  Future<User?> singInFacebook() {
    return _auth_repository.singInFacebook();
  }

  // 2. Sign Out de la aplicación
  signOut() {
    _auth_repository.signOut();
    FacebookAuth.instance.logOut();
  }

  // 3. Register user in DB
  final _cloudFirestoreRepository = CloudFirestoreRepository();
  void updateUserData(UserModel user) => _cloudFirestoreRepository.updateUserDataFirestore(user);

  // 4. Conseguir uid del usuario
  Future<String> getUserId() => _auth_repository.getUserUid();

  // 5. Conseguir favorites and my recipes
  Future<UserModel> readUser(String uid) => _cloudFirestoreRepository.readUserData(uid);

  void updateSubscriptionData(String uid, bool subscription) => _cloudFirestoreRepository.updateSubscriptionData(uid, subscription);

  @override
  void dispose() {
    // TODO: implement dispose
  }

}