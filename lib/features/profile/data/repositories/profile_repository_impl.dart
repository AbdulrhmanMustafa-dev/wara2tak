import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/profile_model.dart';
import '../../domain/repositories/profile_repository.dart' as profile_repo;
import '../../../../core/errors/failures.dart';

/// Profile repository implementation using Supabase
class ProfileRepositoryImpl implements profile_repo.ProfileRepository {
  final SupabaseClient _client;

  ProfileRepositoryImpl(this._client);

  @override
  Future<Either<Failure, ProfileModel?>> getProfile(String userId) async {
    try {
      log('📥 Fetching profile for user: $userId');
      final response = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) {
        log('⚠️ Profile not found, creating default from auth user');
        // Fallback: create default profile from auth user
        final authUser = _client.auth.currentUser;
        if (authUser == null) {
          log('⚠️ No authenticated user found');
          return const Right(null);
        }

        final userMetadata = authUser.userMetadata;
        final defaultProfile = ProfileModel(
          id: userId,
          email: authUser.email ?? '',
          displayName: userMetadata?['full_name'] as String? ??
              userMetadata?['name'] as String?,
          photoUrl: userMetadata?['avatar_url'] as String?,
          preferredLanguage: 'en',
          isDarkMode: false,
          notificationsEnabled: true,
          biometricEnabled: false,
          createdAt: DateTime.now(),
        );

        // Upsert the default profile
        try {
          await _client
              .from('profiles')
              .upsert(defaultProfile.toJson())
              .select()
              .single();
          log('✅ Default profile created');
        } catch (e) {
          log('⚠️ Failed to create default profile (may already exist): $e');
        }

        return Right(defaultProfile);
      }

      log('✅ Profile fetched');
      return Right(ProfileModel.fromJson(response));
    } catch (e, stackTrace) {
      log('❌ Get profile failed: $e');
      log('❌ Stack trace: $stackTrace');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ProfileModel>> updateProfile(ProfileModel profile) async {
    try {
      log('📝 Updating profile: ${profile.id}');
      final updateData = profile.toJson();
      updateData['updatedAt'] = DateTime.now().toIso8601String();

      final response = await _client
          .from('profiles')
          .update(updateData)
          .eq('id', profile.id)
          .select()
          .single();

      log('✅ Profile updated');
      return Right(ProfileModel.fromJson(response));
    } catch (e, stackTrace) {
      log('❌ Update profile failed: $e');
      log('❌ Stack trace: $stackTrace');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateThemePreference(
    String userId,
    bool isDarkMode,
  ) async {
    try {
      log('📝 Updating theme preference for user: $userId');
      await _client.from('profiles').update({
        'isDarkMode': isDarkMode,
        'updatedAt': DateTime.now().toIso8601String(),
      }).eq('id', userId);

      log('✅ Theme preference updated');
      return const Right(null);
    } catch (e, stackTrace) {
      log('❌ Update theme preference failed: $e');
      log('❌ Stack trace: $stackTrace');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateNotificationPreference(
    String userId,
    bool enabled,
  ) async {
    try {
      log('📝 Updating notification preference for user: $userId');
      await _client.from('profiles').update({
        'notificationsEnabled': enabled,
        'updatedAt': DateTime.now().toIso8601String(),
      }).eq('id', userId);

      log('✅ Notification preference updated');
      return const Right(null);
    } catch (e, stackTrace) {
      log('❌ Update notification preference failed: $e');
      log('❌ Stack trace: $stackTrace');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateLanguagePreference(
    String userId,
    String language,
  ) async {
    try {
      log('📝 Updating language preference for user: $userId');
      await _client.from('profiles').update({
        'preferredLanguage': language,
        'updatedAt': DateTime.now().toIso8601String(),
      }).eq('id', userId);

      log('✅ Language preference updated');
      return const Right(null);
    } catch (e, stackTrace) {
      log('❌ Update language preference failed: $e');
      log('❌ Stack trace: $stackTrace');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateTranslationLanguagePreference(
    String userId,
    String language,
  ) async {
    try {
      log('📝 Updating translation language preference for user: $userId');
      await _client.from('profiles').update({
        'defaultTranslationLanguage': language,
        'updatedAt': DateTime.now().toIso8601String(),
      }).eq('id', userId);

      log('✅ Translation language preference updated');
      return const Right(null);
    } catch (e, stackTrace) {
      log('❌ Update translation language preference failed: $e');
      log('❌ Stack trace: $stackTrace');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteAccount(String userId) async {
    try {
      log('🗑️ Deleting account for user: $userId');
      await _client.from('profiles').delete().eq('id', userId);
      await _client.auth.signOut();

      log('✅ Account deleted');
      return const Right(null);
    } catch (e, stackTrace) {
      log('❌ Delete account failed: $e');
      log('❌ Stack trace: $stackTrace');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<ProfileModel?> watchProfile(String userId) {
    log('👀 Watching profile for user: $userId');
    return _client
        .from('profiles')
        .stream(primaryKey: ['id'])
        .eq('id', userId)
        .map((data) {
      if (data.isEmpty) return null;
      return ProfileModel.fromJson(data.first);
    });
  }
}