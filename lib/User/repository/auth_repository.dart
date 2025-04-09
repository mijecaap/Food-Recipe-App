import 'package:firebase_auth/firebase_auth.dart';
import 'package:recipez/User/repository/firebase_auth_api.dart';

class AuthRepository {
  final _firebaseAuthApi = FirebaseAuthAPI();

  Future<User?> signInFirebase() => _firebaseAuthApi.signIn();

  Future<User?> singInFacebook() => _firebaseAuthApi.singInFacebook();

  signOut() => _firebaseAuthApi.signOut();

  Future<String?> getUserUid() => _firebaseAuthApi.getUid();
}