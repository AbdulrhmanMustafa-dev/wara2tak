import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/translation_model.dart';
import '../../domain/repositories/translation_repository.dart';
import 'translation_state.dart';

/// TranslationCubit manages translation state
class TranslationCubit extends Cubit<TranslationState> {
  final TranslationRepository _translationRepository;

  TranslationCubit(this._translationRepository) : super(const TranslationInitial());

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

  /// Translate content
  Future<void> translate({
    required String documentId,
    required String userId,
    required String sourceLanguage,
    required String targetLanguage,
    required String content,
  }) async {
    emit(const TranslationLoading());

    final result = await _translationRepository.translate(
      documentId: documentId,
      userId: userId,
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
      content: content,
    );

    result.fold(
      (failure) => emit(TranslationError(failure.message, code: failure.code)),
      (translation) => emit(TranslationCompleted(translation)),
    );
  }
}