import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/translation_model.dart';
import '../../domain/repositories/translation_repository.dart' as translation_repo;
import '../../../../core/errors/failures.dart';

/// Translation repository implementation using Supabase
class TranslationRepositoryImpl implements translation_repo.TranslationRepository {
  final SupabaseClient _client;

  TranslationRepositoryImpl(this._client);

  String? get _currentUserId => _client.auth.currentUser?.id;

  @override
  Future<Either<Failure, List<TranslationModel>>> getTranslations(
    String documentId,
  ) async {
    try {
      log('📥 Fetching translations for document: $documentId');
      final response = await _client
          .from('translations')
          .select()
          .eq('documentId', documentId)
          .order('createdAt', ascending: false);

      final translations = (response as List)
          .map((json) => TranslationModel.fromJson(json as Map<String, dynamic>))
          .toList();

      log('✅ Fetched ${translations.length} translations');
      return Right(translations);
    } catch (e, stackTrace) {
      log('❌ Get translations failed: $e');
      log('❌ Stack trace: $stackTrace');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, TranslationModel>> translate({
    required String documentId,
    required String userId,
    required String sourceLanguage,
    required String targetLanguage,
    required String content,
  }) async {
    // This method would typically call an AI service for translation
    // For now, we return a failure as the actual translation logic
    // is handled by AIRepository
    return const Left(ServerFailure('Translation service not implemented'));
  }

  @override
  Future<Either<Failure, TranslationModel>> saveTranslation(
    TranslationModel translation,
  ) async {
    try {
      log('💾 Saving translation for document: ${translation.documentId}');
      final translationData = translation.toJson();
      if (_currentUserId != null) {
        translationData['userId'] = _currentUserId;
      }

      final response = await _client
          .from('translations')
          .insert(translationData)
          .select()
          .single();

      log('✅ Translation saved');
      return Right(TranslationModel.fromJson(response));
    } catch (e, stackTrace) {
      log('❌ Save translation failed: $e');
      log('❌ Stack trace: $stackTrace');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<TranslationModel>> watchTranslations(String documentId) {
    log('👀 Watching translations for document: $documentId');
    return _client
        .from('translations')
        .stream(primaryKey: ['id'])
        .eq('documentId', documentId)
        .order('createdAt', ascending: false)
        .map((data) => data
            .map((json) => TranslationModel.fromJson(json))
            .toList());
  }
}