import 'package:equatable/equatable.dart';

/// User profile model
class ProfileModel extends Equatable {
  final String id;
  final String email;
  final String? displayName;
  final String? photoUrl;
  final String? phoneNumber;
  final String? preferredLanguage;
  final String? defaultTranslationLanguage;
  final bool isDarkMode;
  final bool notificationsEnabled;
  final bool biometricEnabled;
  final DateTime createdAt;
  final DateTime? updatedAt;

  const ProfileModel({
    required this.id,
    required this.email,
    this.displayName,
    this.photoUrl,
    this.phoneNumber,
    this.preferredLanguage,
    this.defaultTranslationLanguage,
    this.isDarkMode = false,
    this.notificationsEnabled = true,
    this.biometricEnabled = false,
    required this.createdAt,
    this.updatedAt,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String?,
      photoUrl: json['photoUrl'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      preferredLanguage: json['preferredLanguage'] as String?,
      defaultTranslationLanguage: json['defaultTranslationLanguage'] as String?,
      isDarkMode: json['isDarkMode'] as bool? ?? false,
      notificationsEnabled: json['notificationsEnabled'] as bool? ?? true,
      biometricEnabled: json['biometricEnabled'] as bool? ?? false,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'displayName': displayName,
      'photoUrl': photoUrl,
      'phoneNumber': phoneNumber,
      'preferredLanguage': preferredLanguage,
      'defaultTranslationLanguage': defaultTranslationLanguage,
      'isDarkMode': isDarkMode,
      'notificationsEnabled': notificationsEnabled,
      'biometricEnabled': biometricEnabled,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
    };
  }

  ProfileModel copyWith({
    String? id,
    String? email,
    String? displayName,
    String? photoUrl,
    String? phoneNumber,
    String? preferredLanguage,
    String? defaultTranslationLanguage,
    bool? isDarkMode,
    bool? notificationsEnabled,
    bool? biometricEnabled,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProfileModel(
      id: id ?? this.id,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoUrl: photoUrl ?? this.photoUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      preferredLanguage: preferredLanguage ?? this.preferredLanguage,
      defaultTranslationLanguage:
          defaultTranslationLanguage ?? this.defaultTranslationLanguage,
      isDarkMode: isDarkMode ?? this.isDarkMode,
      notificationsEnabled: notificationsEnabled ?? this.notificationsEnabled,
      biometricEnabled: biometricEnabled ?? this.biometricEnabled,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        photoUrl,
        phoneNumber,
        preferredLanguage,
        defaultTranslationLanguage,
        isDarkMode,
        notificationsEnabled,
        biometricEnabled,
        createdAt,
        updatedAt,
      ];
}