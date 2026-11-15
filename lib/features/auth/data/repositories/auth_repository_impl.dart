import 'package:dartz/dartz.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:developer';

import '../../domain/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/errors/failures.dart';

/// Auth repository implementation using Supabase Auth
class AuthRepositoryImpl implements AuthRepository {
  final SupabaseClient _supabaseClient;
  final GoogleSignIn _googleSignIn;

  AuthRepositoryImpl({
    required SupabaseClient supabaseClient,
    required GoogleSignIn googleSignIn,
  })  : _supabaseClient = supabaseClient,
        _googleSignIn = googleSignIn;

  @override
  Future<Either<Failure, UserModel>> signInWithGoogle() async {
    try {
      log('🔐 Starting Google Sign-In flow');

      // Trigger Google Sign-In
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      log('🔐 Google Sign-In result: ${googleUser != null ? "Success" : "Cancelled"}');

      if (googleUser == null) {
        return const Left(AuthFailure('Google sign in cancelled'));
      }

      log('🔐 Google User: ${googleUser.email}, ${googleUser.displayName}');

      // Get auth details
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      log('🔐 ID Token present: ${googleAuth.idToken != null}');
      log('🔐 Access Token present: ${googleAuth.accessToken != null}');

      if (googleAuth.idToken == null) {
        log('❌ No ID token received from Google');
        return const Left(AuthFailure('No ID token received from Google. Check serverClientId configuration.'));
      }

      // Sign in to Supabase with Google credential
      log('🔐 Signing in to Supabase with Google ID token...');
      final AuthResponse response = await _supabaseClient.auth.signInWithIdToken(
        provider: OAuthProvider.google,
        idToken: googleAuth.idToken!,
        accessToken: googleAuth.accessToken,
      );

      log('🔐 Supabase response: ${response.user != null ? "Success" : "No user"}');

      final supabaseUser = response.user;

      if (supabaseUser == null) {
        log('❌ Supabase returned no user');
        return const Left(AuthFailure('Failed to get user after sign in'));
      }

      log('✅ Supabase user: ${supabaseUser.email}');
      return Right(UserModel.fromSupabase(supabaseUser));
    } on AuthException catch (e) {
      log('❌ Supabase AuthException: ${e.message} (code: ${e.code})');
      return Left(AuthFailure(e.message, code: e.code));
    } catch (e, stackTrace) {
      log('❌ Google sign in failed: $e');
      log('❌ Stack trace: $stackTrace');
      return Left(AuthFailure('Google sign in failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await Future.wait([
        _supabaseClient.auth.signOut(),
        _googleSignIn.signOut(),
      ]);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } catch (e) {
      return Left(AuthFailure('Sign out failed: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, UserModel?>> getCurrentUser() async {
    try {
      final supabaseUser = _supabaseClient.auth.currentUser;
      if (supabaseUser == null) {
        return const Right(null);
      }
      return Right(UserModel.fromSupabase(supabaseUser));
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message, code: e.code));
    } catch (e) {
      return Left(AuthFailure('Failed to get current user: ${e.toString()}'));
    }
  }

  @override
  Stream<UserModel?> get authStateChanges {
    return _supabaseClient.auth.onAuthStateChange.map((data) {
      final session = data.session;
      if (session == null || session.user == null) return null;
      return UserModel.fromSupabase(session.user!);
    });
  }

  @override
  Future<bool> isAuthenticated() async {
    final user = _supabaseClient.auth.currentUser;
    return user != null;
  }
}