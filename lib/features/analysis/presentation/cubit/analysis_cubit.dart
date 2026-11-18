import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:meta/meta.dart';

import '../../domain/repositories/ai_repository.dart';
import '../../../documents/domain/models/document_model.dart'
    show DocumentModel;
import '../../../documents/domain/models/analysis_model.dart'
    show AnalysisModel;
import '../../../documents/domain/repositories/document_repository.dart';
import 'analysis_state.dart';

/// AnalysisCubit manages AI analysis state with granular progress tracking
class AnalysisCubit extends Cubit<AnalysisState> {
  final AIRepository _aiRepository;
  final DocumentRepository _documentRepository;
  DocumentModel? _lastDocument;
  String? _lastLocalFilePath;
  String? _lastUserId;

  AnalysisCubit(this._aiRepository, this._documentRepository)
    : super(const AnalysisInitial());

  bool get canRetryLastAnalysis =>
      _lastDocument != null &&
      _lastLocalFilePath != null &&
      _lastUserId != null;

  /// For testing purposes - sets the last analysis parameters
  @visibleForTesting
  void setLastAnalysisParams({
    required DocumentModel document,
    required String localFilePath,
    required String userId,
  }) {
    _lastDocument = document;
    _lastLocalFilePath = localFilePath;
    _lastUserId = userId;
  }

  Future<void> retryLastAnalysis() async {
    final document = _lastDocument;
    final localFilePath = _lastLocalFilePath;
    final userId = _lastUserId;
    if (document == null || localFilePath == null || userId == null) return;

    await analyzeDocument(
      document: document,
      localFilePath: localFilePath,
      userId: userId,
    );
  }

  /// Analyze a document with granular progress updates
  /// Progress stages: 0% -> 20% (Reading) -> 40% (Gemini) -> 60% (Fallback/Parsing) -> 80% (Saving) -> 100% (Complete)
  Future<void> analyzeDocument({
    required DocumentModel document,
    required String localFilePath,
    required String userId,
  }) async {
    _lastDocument = document;
    _lastLocalFilePath = localFilePath;
    _lastUserId = userId;

    try {
      // Stage 0: Starting
      emit(const AnalysisProgress(0, message: 'Starting analysis...'));

      // Stage 1: Reading file (0-20%) - handled by AIRepository
      // Stage 2: Sending to primary AI (Gemini) (20-40%) - handled by AIRepository
      // Stage 3: Fallback to Kimi if needed (40-60%) - handled by AIRepository
      // Stage 4: Parsing results (60-80%) - handled by AIRepository
      // Stage 5: Saving to database (80-95%)
      // Stage 6: Complete (100%)

      final result = await _aiRepository.analyzeDocument(
        document: document,
        localFilePath: localFilePath,
        userId: userId,
        onProgress: (progress, message) {
          emit(AnalysisProgress(progress, message: message));
        },
      );

      await result.fold<Future<void>>(
        (failure) async {
          // Error occurred - emit error state with retry capability
          emit(AnalysisError(failure.message, code: failure.code));
        },
        (analysis) async {
          // Stage 5: Saving to database (80-95%)
          emit(const AnalysisProgress(85, message: 'Saving results to database...'));

          final saveResult = await _documentRepository.saveAnalysis(analysis);
          saveResult.fold(
            (failure) => emit(AnalysisError(failure.message, code: failure.code)),
            (savedAnalysis) {
              // Stage 6: Complete (100%)
              emit(AnalysisCompleted(savedAnalysis));
            },
          );
        },
      );
    } catch (e) {
      // Catch any unexpected errors that weren't handled by the repository
      emit(AnalysisError('Unexpected error: $e', code: 'UNEXPECTED_ERROR'));
    }
  }

  /// Chat with document
  Future<void> chatWithDocument({
    required String documentId,
    required String analysisId,
    required String question,
    required List<AIChatMessage> history,
  }) async {
    emit(const ChatLoading());

    final result = await _aiRepository.chatWithDocument(
      documentId: documentId,
      analysisId: analysisId,
      question: question,
      history: history,
    );

    result.fold(
      (failure) => emit(ChatError(failure.message, code: failure.code)),
      (response) => emit(ChatResponse(response)),
    );
  }

  /// Translate document
  Future<void> translateDocument({
    required String documentId,
    required String analysisId,
    required String targetLanguage,
    required String content,
  }) async {
    emit(const TranslationLoading());

    final result = await _aiRepository.translateDocument(
      documentId: documentId,
      analysisId: analysisId,
      targetLanguage: targetLanguage,
      content: content,
    );

    result.fold(
      (failure) => emit(TranslationError(failure.message, code: failure.code)),
      (translation) => emit(TranslationCompleted(translation)),
    );
  }

  /// Generate checklist
  Future<void> generateChecklist(AnalysisModel analysis) async {
    emit(const ChecklistLoading());

    final result = await _aiRepository.generateChecklist(analysis: analysis);

    result.fold(
      (failure) => emit(ChecklistError(failure.message, code: failure.code)),
      (checklist) => emit(ChecklistGenerated(checklist)),
    );
  }
}
