import 'package:equatable/equatable.dart';

/// Translation model
class TranslationModel extends Equatable {
  final String id;
  final String documentId;
  final String userId;
  final String sourceLanguage;
  final String targetLanguage;
  final String originalContent;
  final String translatedContent;
  final DateTime createdAt;

  const TranslationModel({
    required this.id,
    required this.documentId,
    required this.userId,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.originalContent,
    required this.translatedContent,
    required this.createdAt,
  });

  factory TranslationModel.fromJson(Map<String, dynamic> json) {
    return TranslationModel(
      id: json['id'] as String,
      documentId: json['documentId'] as String,
      userId: json['userId'] as String,
      sourceLanguage: json['sourceLanguage'] as String,
      targetLanguage: json['targetLanguage'] as String,
      originalContent: json['originalContent'] as String,
      translatedContent: json['translatedContent'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'userId': userId,
      'sourceLanguage': sourceLanguage,
      'targetLanguage': targetLanguage,
      'originalContent': originalContent,
      'translatedContent': translatedContent,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [
        id,
        documentId,
        userId,
        sourceLanguage,
        targetLanguage,
        originalContent,
        translatedContent,
        createdAt,
      ];
}

/// Supported languages
class SupportedLanguages {
  static const Map<String, String> languages = {
    'ar': 'Arabic',
    'en': 'English',
    'fr': 'French',
    'es': 'Spanish',
    'de': 'German',
    'zh': 'Chinese',
    'hi': 'Hindi',
    'ur': 'Urdu',
    'tr': 'Turkish',
    'fa': 'Persian',
  };

  static String getLanguageName(String code) {
    return languages[code] ?? code.toUpperCase();
  }

  static bool isRTL(String code) {
    return ['ar', 'ur', 'fa'].contains(code);
  }
}