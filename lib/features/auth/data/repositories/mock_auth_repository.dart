import 'package:dartz/dartz.dart';
import 'dart:async';

import '../../domain/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/errors/failures.dart';

/// Mock Auth Repository for development without Firebase
class MockAuthRepository implements AuthRepository {
  UserModel? _currentUser;
  final StreamController<UserModel?> _authStateController = StreamController<UserModel?>.broadcast();

  MockAuthRepository() {
    // Simulate unauthenticated state initially
    _currentUser = null;
    _authStateController.add(null);
  }

  @override
  Future<Either<Failure, UserModel>> signInWithGoogle() async {
    // Simulate successful sign in after a short delay
    await Future.delayed(const Duration(milliseconds: 500));

    _currentUser = UserModel(
      id: 'mock-user-id',
      email: 'test@example.com',
      displayName: 'Test User',
      photoUrl: null,
      createdAt: DateTime.now(),
      isEmailVerified: true,
    );

    _authStateController.add(_currentUser);
    return Right(_currentUser!);
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _currentUser = null;
    _authStateController.add(null);
    return const Right(null);
  }

  @override
  Future<Either<Failure, UserModel?>> getCurrentUser() async {
    return Right(_currentUser);
  }

  @override
  Stream<UserModel?> get authStateChanges => _authStateController.stream;

  @override
  Future<bool> isAuthenticated() async {
    return _currentUser != null;
  }

  void dispose() {
    _authStateController.close();
  }
}