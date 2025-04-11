import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:recipez/core/errors/failures.dart';
import 'package:recipez/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:recipez/features/auth/data/models/user_model.dart';
import 'package:recipez/features/auth/domain/entities/user.dart';
import 'package:recipez/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Stream<firebase.User?> get authStateChanges => remoteDataSource.authStateChanges;

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    try {
      final firebaseUser = await remoteDataSource.signInWithGoogle();
      if (firebaseUser == null) {
        return Left(AuthenticationFailure('Google sign in failed'));
      }

      final user = await remoteDataSource.getUser(firebaseUser.uid);
      if (user.uid.isEmpty) {
        // Crear nuevo usuario si no existe
        final newUser = UserModel(
          uid: firebaseUser.uid,
          name: firebaseUser.displayName ?? '',
          email: firebaseUser.email ?? '',
          photoURL: firebaseUser.photoURL ?? '',
        );
        await remoteDataSource.updateUserData(newUser);
        return Right(newUser);
      }

      return Right(user);
    } catch (e) {
      return Left(AuthenticationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithFacebook() async {
    try {
      final firebaseUser = await remoteDataSource.signInWithFacebook();
      if (firebaseUser == null) {
        return Left(AuthenticationFailure('Facebook sign in failed'));
      }

      final user = await remoteDataSource.getUser(firebaseUser.uid);
      if (user.uid.isEmpty) {
        // Crear nuevo usuario si no existe
        final newUser = UserModel(
          uid: firebaseUser.uid,
          name: firebaseUser.displayName ?? '',
          email: firebaseUser.email ?? '',
          photoURL: firebaseUser.photoURL ?? '',
        );
        await remoteDataSource.updateUserData(newUser);
        return Right(newUser);
      }

      return Right(user);
    } catch (e) {
      return Left(AuthenticationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(AuthenticationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, String>> getCurrentUserId() async {
    try {
      final uid = await remoteDataSource.getCurrentUserId();
      return Right(uid);
    } catch (e) {
      return Left(AuthenticationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, User>> getUser(String uid) async {
    try {
      final user = await remoteDataSource.getUser(uid);
      return Right(user);
    } catch (e) {
      return Left(AuthenticationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateUserData(User user) async {
    try {
      await remoteDataSource.updateUserData(user as UserModel);
      return const Right(null);
    } catch (e) {
      return Left(AuthenticationFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateSubscription(
    String uid,
    bool subscription,
    String paymentId,
  ) async {
    try {
      await remoteDataSource.updateSubscription(uid, subscription, paymentId);
      return const Right(null);
    } catch (e) {
      return Left(AuthenticationFailure(e.toString()));
    }
  }
}