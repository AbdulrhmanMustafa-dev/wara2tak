import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';

import '../../domain/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';
import 'auth_state.dart';
import '../../../../core/errors/failures.dart';

/// AuthCubit manages authentication state
class AuthCubit extends Cubit<AuthState> {
  final AuthRepository _authRepository;

  AuthCubit(this._authRepository) : super(const AuthInitial()) {
    _listenToAuthChanges();
    _checkInitialAuthState();
  }

  /// Listen to auth state changes from repository
  void _listenToAuthChanges() {
    _authRepository.authStateChanges.listen((user) {
      if (user != null) {
        emit(AuthAuthenticated(user));
      } else {
        emit(const AuthUnauthenticated());
      }
    });
  }

  /// Check initial auth state on app start
  Future<void> _checkInitialAuthState() async {
    final result = await _authRepository.getCurrentUser();
    result.fold(
      (failure) => emit(const AuthUnauthenticated()),
      (user) {
        if (user != null) {
          emit(AuthAuthenticated(user));
        } else {
          emit(const AuthUnauthenticated());
        }
      },
    );
  }

  /// Sign in with Google
  Future<void> signInWithGoogle() async {
    emit(const AuthLoading());

    final result = await _authRepository.signInWithGoogle();

    result.fold(
      (failure) => emit(AuthError(failure.message, code: failure.code)),
      (user) => emit(AuthAuthenticated(user)),
    );
  }

  /// Sign out
  Future<void> signOut() async {
    emit(const AuthLoading());

    final result = await _authRepository.signOut();

    result.fold(
      (failure) => emit(AuthError(failure.message, code: failure.code)),
      (_) => emit(const AuthUnauthenticated()),
    );
  }

  /// Get current user
  Future<Either<Failure, UserModel?>> getCurrentUser() async {
    return await _authRepository.getCurrentUser();
  }

  /// Check if authenticated
  Future<bool> isAuthenticated() async {
    return await _authRepository.isAuthenticated();
  }
}