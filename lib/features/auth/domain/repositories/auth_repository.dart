import 'package:dartz/dartz.dart';

import '../../domain/models/user_model.dart';
import '../../../../core/errors/failures.dart';

/// Auth repository interface
abstract class AuthRepository {
  /// Sign in with Google
  Future<Either<Failure, UserModel>> signInWithGoogle();

  /// Sign out
  Future<Either<Failure, void>> signOut();

  /// Get current user
  Future<Either<Failure, UserModel?>> getCurrentUser();

  /// Listen to auth state changes
  Stream<UserModel?> get authStateChanges;

  /// Check if user is authenticated
  Future<bool> isAuthenticated();
}