import 'package:dartz/dartz.dart';
import 'package:recipez/core/errors/failures.dart';
import 'package:recipez/core/usecases/usecase.dart';
import 'package:recipez/features/auth/domain/entities/user.dart';
import 'package:recipez/features/auth/domain/repositories/auth_repository.dart';

class SignInWithGoogle implements UseCase<User, NoParams> {
  final AuthRepository repository;

  SignInWithGoogle(this.repository);

  @override
  Future<Either<Failure, User>> call(NoParams params) {
    return repository.signInWithGoogle();
  }
}