import 'package:dartz/dartz.dart';

import '../../features/analysis/domain/repositories/ai_repository.dart';
import '../../features/chat/domain/models/chat_model.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/checklist/domain/models/checklist_model.dart'
    as checklist;
import '../../features/checklist/domain/repositories/checklist_repository.dart';
import '../../features/documents/domain/models/analysis_model.dart';
import '../../features/documents/domain/models/document_model.dart';
import '../../features/documents/domain/repositories/document_repository.dart';
import '../../features/profile/domain/models/profile_model.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/translation/domain/models/translation_model.dart';
import '../../features/translation/domain/repositories/translation_repository.dart';
import '../errors/failures.dart';

class MockDocumentRepository implements DocumentRepository {
  @override
  Future<Either<Failure, void>> deleteDocument(String documentId) async =>
      const Right(null);

  @override
  Future<Either<Failure, AnalysisModel?>> getAnalysis(
    String documentId,
  ) async => const Right(null);

  @override
  Future<Either<Failure, DocumentModel?>> getDocument(
    String documentId,
  ) async => const Right(null);

  @override
  Future<Either<Failure, List<DocumentModel>>> getUserDocuments(
    String userId,
  ) async => const Right([]);

  @override
  Future<Either<Failure, AnalysisModel>> saveAnalysis(
    AnalysisModel analysis,
  ) async => Right(analysis);

  @override
  Future<Either<Failure, DocumentModel>> updateDocument(
    DocumentModel document,
  ) async => Right(document);

  @override
  Future<Either<Failure, DocumentModel>> uploadDocument({
    required String userId,
    required String filePath,
    required String fileName,
    required DocumentType type,
    String? title,
  }) async {
    final doc = DocumentModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      userId: userId,
      title: title ?? fileName,
      originalFileName: fileName,
      fileUrl: filePath,
      type: type,
      status: DocumentStatus.uploaded,
      pageCount: 1,
      fileSize: 1024,
      createdAt: DateTime.now(),
    );
    return Right(doc);
  }

  @override
  Stream<List<DocumentModel>> watchUserDocuments(String userId) =>
      Stream.value([]);
}

class MockAIRepository implements AIRepository {
  @override
  Future<Either<Failure, AnalysisModel>> analyzeDocument({
    required DocumentModel document,
    required String localFilePath,
    required String userId,
    required Function(int progress, String? message) onProgress,
  }) async => const Left(ServerFailure('AI not connected yet'));

  @override
  Future<Either<Failure, String>> chatWithDocument({
    required String documentId,
    required String analysisId,
    required String question,
    required List<AIChatMessage> history,
  }) async => const Right('Mock AI response');

  @override
  Future<Either<Failure, List<ChecklistItemModel>>> generateChecklist({
    required AnalysisModel analysis,
  }) async => const Right([]);

  @override
  Future<Either<Failure, String>> translateDocument({
    required String documentId,
    required String analysisId,
    required String targetLanguage,
    required String content,
  }) async => const Right('Mock translated text');
}

class MockChecklistRepository implements ChecklistRepository {
  @override
  Future<Either<Failure, List<checklist.ChecklistItemModel>>> getChecklist(
    String documentId,
  ) async => const Right([]);

  @override
  Future<Either<Failure, checklist.ChecklistItemModel>> addChecklistItem(
    String documentId,
    checklist.ChecklistItemModel item,
  ) async => Right(item);

  @override
  Future<Either<Failure, List<checklist.ChecklistItemModel>>> saveChecklist(
    String documentId,
    List<checklist.ChecklistItemModel> items,
  ) async => Right(items);

  @override
  Future<Either<Failure, checklist.ChecklistItemModel>> updateChecklistItem(
    String documentId,
    checklist.ChecklistItemModel item,
  ) async => Right(item);

  @override
  Future<Either<Failure, void>> deleteChecklistItem(
    String documentId,
    String itemId,
  ) async => const Right(null);

  @override
  Stream<List<checklist.ChecklistItemModel>> watchChecklist(
    String documentId,
  ) => Stream.value([]);
}

class MockChatRepository implements ChatRepository {
  @override
  Future<Either<Failure, void>> clearChat(String documentId) async =>
      const Right(null);

  @override
  Future<Either<Failure, List<ChatMessageModel>>> getChatHistory(
    String documentId,
  ) async => const Right([]);

  @override
  Future<Either<Failure, ChatMessageModel>> saveMessage(
    ChatMessageModel message,
  ) async => Right(message);

  @override
  Future<Either<Failure, ChatMessageModel>> sendMessage({
    required String documentId,
    required String userId,
    required String message,
    required List<ChatMessageModel> history,
  }) async => Left(const ServerFailure('Not implemented'));

  @override
  Stream<List<ChatMessageModel>> watchChat(String documentId) =>
      Stream.value([]);
}

class MockTranslationRepository implements TranslationRepository {
  @override
  Future<Either<Failure, List<TranslationModel>>> getTranslations(
    String documentId,
  ) async => const Right([]);

  @override
  Future<Either<Failure, TranslationModel>> saveTranslation(
    TranslationModel translation,
  ) async => Right(translation);

  @override
  Future<Either<Failure, TranslationModel>> translate({
    required String documentId,
    required String userId,
    required String sourceLanguage,
    required String targetLanguage,
    required String content,
  }) async => Left(const ServerFailure('Not implemented'));

  @override
  Stream<List<TranslationModel>> watchTranslations(String documentId) =>
      Stream.value([]);
}

class MockProfileRepository implements ProfileRepository {
  @override
  Future<Either<Failure, void>> deleteAccount(String userId) async =>
      const Right(null);

  @override
  Future<Either<Failure, ProfileModel?>> getProfile(String userId) async {
    return Right(
      ProfileModel(
        id: userId,
        email: 'user@wara2tak.com',
        displayName: 'Wara2tak User',
        createdAt: DateTime.now(),
      ),
    );
  }

  @override
  Future<Either<Failure, void>> updateLanguagePreference(
    String userId,
    String language,
  ) async => const Right(null);

  @override
  Future<Either<Failure, void>> updateNotificationPreference(
    String userId,
    bool enabled,
  ) async => const Right(null);

  @override
  Future<Either<Failure, ProfileModel>> updateProfile(
    ProfileModel profile,
  ) async => Right(profile);

  @override
  Future<Either<Failure, void>> updateThemePreference(
    String userId,
    bool isDarkMode,
  ) async => const Right(null);

  @override
  Future<Either<Failure, void>> updateTranslationLanguagePreference(
    String userId,
    String language,
  ) async => const Right(null);

  @override
  Stream<ProfileModel?> watchProfile(String userId) => const Stream.empty();
}
