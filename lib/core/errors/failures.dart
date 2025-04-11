import 'package:equatable/equatable.dart';

abstract class Failure extends Equatable {
  @override
  List<Object> get props => [];
}

// Fallos generales
class ServerFailure extends Failure {}
class CacheFailure extends Failure {}

// Fallos específicos de autenticación
class AuthenticationFailure extends Failure {
  final String message;
  
  AuthenticationFailure(this.message);
  
  @override
  List<Object> get props => [message];
}

class NetworkFailure extends Failure {}