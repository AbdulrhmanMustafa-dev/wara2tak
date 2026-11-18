import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../../analysis/domain/repositories/ai_repository.dart';
import '../../domain/models/translation_model.dart';
import '../../domain/repositories/translation_repository.dart';
import 'translation_state.dart';

/// TranslationCubit manages translation state
class TranslationCubit extends Cubit<TranslationState> {
  final TranslationRepository _translationRepository;
  final AIRepository _aiRepository;

  TranslationCubit(this._translationRepository, this._aiRepository)
      : super(const TranslationInitial());

  /// Load translations for document
  Future<void> loadTranslations(String documentId) async {
    emit(const TranslationLoading());

    final result = await _translationRepository.getTranslations(documentId);

    result.fold(
      (failure) => emit(TranslationError(failure.message, code: failure.code)),
      (translations) => emit(TranslationsLoaded(translations)),
    );
  }

  /// Watch translations for real-time updates
  Stream<List<TranslationModel>> watchTranslations(String documentId) {
    return _translationRepository.watchTranslations(documentId);
  }

  /// Auto-detect source language based on content
  static String detectLanguage(String content) {
    // Check for Arabic characters
    final arabicRegex = RegExp(r'[؀-ۿ]');
    if (arabicRegex.hasMatch(content)) {
      return 'ar';
    }
    return 'en'; // Default to English
  }

  /// Translate content using AI
  Future<void> translate({
    required String documentId,
    required String userId,
    required String sourceLanguage,
    required String targetLanguage,
    required String content,
  }) async {
    emit(const TranslationLoading());

    // Call AI repository for translation
    final result = await _aiRepository.translateDocument(
      documentId: documentId,
      analysisId: '', // Not used for translation
      targetLanguage: targetLanguage,
      content: content,
    );

    result.fold(
      (failure) => emit(TranslationError(failure.message, code: failure.code)),
      (translatedText) async {
        // Create translation model and save to database
        final translation = TranslationModel(
          id: const Uuid().v4(),
          documentId: documentId,
          userId: userId,
          sourceLanguage: sourceLanguage,
          targetLanguage: targetLanguage,
          originalContent: content,
          translatedContent: translatedText,
          createdAt: DateTime.now(),
        );

        // Save to database (non-blocking - don't fail UI if save fails)
        try {
          await _translationRepository.saveTranslation(translation);
        } catch (e) {
          // Log but don't fail - translation still displays
          log('⚠️ Failed to save translation to DB: $e');
        }

        emit(TranslationCompleted(translation));
      },
    );
  }
}