import 'package:equatable/equatable.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object?> get props => [];
}

class SignInWithGooglePressed extends AuthEvent {}

class SignInWithFacebookPressed extends AuthEvent {}

class SignOutPressed extends AuthEvent {}

class GetCurrentUser extends AuthEvent {
  final String uid;
  
  const GetCurrentUser(this.uid);

  @override
  List<Object?> get props => [uid];
}

class UpdateUserSubscription extends AuthEvent {
  final String uid;
  final bool subscription;
  final String paymentId;

  const UpdateUserSubscription({
    required this.uid,
    required this.subscription,
    required this.paymentId,
  });

  @override
  List<Object?> get props => [uid, subscription, paymentId];
}