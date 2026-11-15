import 'package:dartz/dartz.dart';

import '../models/translation_model.dart';
import '../../../../core/errors/failures.dart';

/// Translation repository interface
abstract class TranslationRepository {
  /// Get translation history for document
  Future<Either<Failure, List<TranslationModel>>> getTranslations(String documentId);

  /// Translate content
  Future<Either<Failure, TranslationModel>> translate({
    required String documentId,
    required String userId,
    required String sourceLanguage,
    required String targetLanguage,
    required String content,
  });

  /// Save translation
  Future<Either<Failure, TranslationModel>> saveTranslation(TranslationModel translation);

  /// Listen to translations
  Stream<List<TranslationModel>> watchTranslations(String documentId);
}