import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';

import '../../domain/repositories/ai_repository.dart';
import '../../../documents/domain/models/document_model.dart'
    show DocumentModel, DocumentStatus;
import '../../../documents/domain/models/analysis_model.dart'
    show AnalysisModel, AnalysisStatus, ChecklistItemModel;
import 'analysis_state.dart';
import '../../../../core/errors/failures.dart';

/// AnalysisCubit manages AI analysis state
class AnalysisCubit extends Cubit<AnalysisState> {
  final AIRepository _aiRepository;

  AnalysisCubit(this._aiRepository) : super(const AnalysisInitial());

  /// Analyze a document
  Future<void> analyzeDocument({
    required DocumentModel document,
    required String userId,
  }) async {
    emit(const AnalysisProgress(0, message: 'Starting analysis...'));

    final result = await _aiRepository.analyzeDocument(
      document: document,
      userId: userId,
      onProgress: (progress, message) {
        emit(AnalysisProgress(progress, message: message));
      },
    );

    result.fold(
      (failure) => emit(AnalysisError(failure.message, code: failure.code)),
      (analysis) => emit(AnalysisCompleted(analysis)),
    );
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