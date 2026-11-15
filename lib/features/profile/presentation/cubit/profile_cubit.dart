import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';

import '../../domain/models/profile_model.dart';
import '../../domain/repositories/profile_repository.dart';
import 'profile_state.dart';
import '../../../../core/errors/failures.dart';

/// ProfileCubit manages profile state
class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository _profileRepository;

  ProfileCubit(this._profileRepository) : super(const ProfileInitial());

  /// Load user profile
  Future<void> loadProfile(String userId) async {
    emit(const ProfileLoading());

    final result = await _profileRepository.getProfile(userId);

    result.fold(
      (failure) => emit(ProfileError(failure.message, code: failure.code)),
      (profile) {
        if (profile != null) {
          emit(ProfileLoaded(profile));
        } else {
          emit(const ProfileError('Profile not found', code: 'not_found'));
        }
      },
    );
  }

  /// Watch profile for real-time updates
  Stream<ProfileModel?> watchProfile(String userId) {
    return _profileRepository.watchProfile(userId);
  }

  /// Update profile
  Future<void> updateProfile(ProfileModel profile) async {
    emit(const ProfileLoading());

    final result = await _profileRepository.updateProfile(profile);

    result.fold(
      (failure) => emit(ProfileError(failure.message, code: failure.code)),
      (updatedProfile) => emit(ProfileUpdated(updatedProfile)),
    );
  }

  /// Update theme preference
  Future<void> updateThemePreference(String userId, bool isDarkMode) async {
    final result = await _profileRepository.updateThemePreference(userId, isDarkMode);

    result.fold(
      (failure) => emit(ProfileError(failure.message, code: failure.code)),
      (_) {
        // Update current profile state
        if (state is ProfileLoaded) {
          final currentProfile = (state as ProfileLoaded).profile;
          emit(ProfileLoaded(currentProfile.copyWith(isDarkMode: isDarkMode)));
        }
      },
    );
  }

  /// Update notification preference
  Future<void> updateNotificationPreference(String userId, bool enabled) async {
    final result = await _profileRepository.updateNotificationPreference(userId, enabled);

    result.fold(
      (failure) => emit(ProfileError(failure.message, code: failure.code)),
      (_) {
        if (state is ProfileLoaded) {
          final currentProfile = (state as ProfileLoaded).profile;
          emit(ProfileLoaded(currentProfile.copyWith(notificationsEnabled: enabled)));
        }
      },
    );
  }

  /// Update language preference
  Future<void> updateLanguagePreference(String userId, String language) async {
    final result = await _profileRepository.updateLanguagePreference(userId, language);

    result.fold(
      (failure) => emit(ProfileError(failure.message, code: failure.code)),
      (_) {
        if (state is ProfileLoaded) {
          final currentProfile = (state as ProfileLoaded).profile;
          emit(ProfileLoaded(currentProfile.copyWith(preferredLanguage: language)));
        }
      },
    );
  }

  /// Delete account
  Future<void> deleteAccount(String userId) async {
    emit(const ProfileLoading());

    final result = await _profileRepository.deleteAccount(userId);

    result.fold(
      (failure) => emit(ProfileError(failure.message, code: failure.code)),
      (_) => emit(const ProfileInitial()),
    );
  }
}