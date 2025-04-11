import 'package:dartz/dartz.dart';
import 'package:recipez/core/errors/failures.dart';
import 'package:recipez/core/usecases/usecase.dart';
import 'package:recipez/features/auth/domain/repositories/auth_repository.dart';

class SignOut implements UseCase<void, NoParams> {
  final AuthRepository repository;

  SignOut(this.repository);

  @override
  Future<Either<Failure, void>> call(NoParams params) {
    return repository.signOut();
  }
}