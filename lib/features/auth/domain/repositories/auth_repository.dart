import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:recipez/core/errors/failures.dart';
import 'package:recipez/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Stream<firebase.User?> get authStateChanges;
  Future<Either<Failure, User>> signInWithGoogle();
  Future<Either<Failure, User>> signInWithFacebook();
  Future<Either<Failure, void>> signOut();
  Future<Either<Failure, String>> getCurrentUserId();
  Future<Either<Failure, User>> getUser(String uid);
  Future<Either<Failure, void>> updateUserData(User user);
  Future<Either<Failure, void>> updateSubscription(String uid, bool subscription, String paymentId);
}