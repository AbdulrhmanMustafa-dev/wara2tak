import 'package:dartz/dartz.dart';

import '../models/profile_model.dart';
import '../../../../core/errors/failures.dart';

/// Profile repository interface
abstract class ProfileRepository {
  /// Get user profile
  Future<Either<Failure, ProfileModel?>> getProfile(String userId);

  /// Update user profile
  Future<Either<Failure, ProfileModel>> updateProfile(ProfileModel profile);

  /// Update theme preference
  Future<Either<Failure, void>> updateThemePreference(String userId, bool isDarkMode);

  /// Update notification preference
  Future<Either<Failure, void>> updateNotificationPreference(String userId, bool enabled);

  /// Update language preference (App UI Language: en/ar)
  Future<Either<Failure, void>> updateLanguagePreference(String userId, String language);

  /// Update default translation language preference (10 languages)
  Future<Either<Failure, void>> updateTranslationLanguagePreference(
      String userId, String language);

  /// Delete account
  Future<Either<Failure, void>> deleteAccount(String userId);

  /// Listen to profile changes
  Stream<ProfileModel?> watchProfile(String userId);
}