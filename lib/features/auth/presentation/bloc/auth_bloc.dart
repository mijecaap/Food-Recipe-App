import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:recipez/core/usecases/usecase.dart';
import 'package:recipez/features/auth/domain/usecases/sign_in_with_google.dart';
import 'package:recipez/features/auth/domain/usecases/sign_in_with_facebook.dart';
import 'package:recipez/features/auth/domain/usecases/sign_out.dart';
import 'package:recipez/features/auth/domain/repositories/auth_repository.dart';
import './auth_event.dart';
import './auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithGoogle signInWithGoogle;
  final SignInWithFacebook signInWithFacebook;
  final SignOut signOut;
  final AuthRepository repository;
  late StreamSubscription<firebase.User?> _authStateSubscription;

  AuthBloc({
    required this.signInWithGoogle,
    required this.signInWithFacebook,
    required this.signOut,
    required this.repository,
  }) : super(AuthInitial()) {
    on<SignInWithGooglePressed>(_onSignInWithGooglePressed);
    on<SignInWithFacebookPressed>(_onSignInWithFacebookPressed);
    on<SignOutPressed>(_onSignOutPressed);
    on<GetCurrentUser>(_onGetCurrentUser);
    on<UpdateUserSubscription>(_onUpdateUserSubscription);

    _authStateSubscription = repository.authStateChanges.listen((user) {
      if (user == null) {
        add(SignOutPressed());
      }
    });
  }

  Future<void> _onSignInWithGooglePressed(
    SignInWithGooglePressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await signInWithGoogle(NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onSignInWithFacebookPressed(
    SignInWithFacebookPressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await signInWithFacebook(NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onSignOutPressed(
    SignOutPressed event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await signOut(NoParams());
    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (_) => emit(const Unauthenticated()),
    );
  }

  Future<void> _onGetCurrentUser(
    GetCurrentUser event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    final result = await repository.getUser(event.uid);
    result.fold(
      (failure) => emit(AuthError(failure.toString())),
      (user) => emit(Authenticated(user)),
    );
  }

  Future<void> _onUpdateUserSubscription(
    UpdateUserSubscription event,
    Emitter<AuthState> emit,
  ) async {
    final currentState = state;
    if (currentState is Authenticated) {
      emit(AuthLoading());
      final result = await repository.updateSubscription(
        event.uid,
        event.subscription,
        event.paymentId,
      );
      result.fold(
        (failure) => emit(AuthError(failure.toString())),
        (_) async {
          final userResult = await repository.getUser(event.uid);
          userResult.fold(
            (failure) => emit(AuthError(failure.toString())),
            (user) => emit(Authenticated(user)),
          );
        },
      );
    }
  }

  @override
  Future<void> close() {
    _authStateSubscription.cancel();
    return super.close();
  }
}