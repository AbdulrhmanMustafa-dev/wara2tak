import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';

import '../../domain/models/document_model.dart';
import '../../domain/models/analysis_model.dart';
import '../../domain/repositories/document_repository.dart';
import 'document_state.dart';
import '../../../../core/errors/failures.dart';

/// DocumentCubit manages document state
class DocumentCubit extends Cubit<DocumentState> {
  final DocumentRepository _documentRepository;

  DocumentCubit(this._documentRepository) : super(const DocumentInitial());

  /// Load user's documents
  Future<void> loadUserDocuments(String userId) async {
    emit(const DocumentLoading());

    final result = await _documentRepository.getUserDocuments(userId);

    result.fold(
      (failure) => emit(DocumentError(failure.message, code: failure.code)),
      (documents) => emit(DocumentsLoaded(documents)),
    );
  }

  /// Watch user's documents (real-time)
  Stream<List<DocumentModel>> watchUserDocuments(String userId) {
    return _documentRepository.watchUserDocuments(userId);
  }

  /// Get document by ID
  Future<void> getDocument(String documentId) async {
    emit(const DocumentLoading());

    final result = await _documentRepository.getDocument(documentId);

    result.fold(
      (failure) => emit(DocumentError(failure.message, code: failure.code)),
      (document) {
        if (document != null) {
          emit(DocumentLoaded(document));
        } else {
          emit(const DocumentError('Document not found', code: 'not_found'));
        }
      },
    );
  }

  /// Upload document
  Future<void> uploadDocument({
    required String userId,
    required String filePath,
    required String fileName,
    required DocumentType type,
    String? title,
  }) async {
    emit(const DocumentLoading());

    final result = await _documentRepository.uploadDocument(
      userId: userId,
      filePath: filePath,
      fileName: fileName,
      type: type,
      title: title,
    );

    result.fold(
      (failure) => emit(DocumentError(failure.message, code: failure.code)),
      (document) => emit(DocumentUploadSuccess(document)),
    );
  }

  /// Update document
  Future<void> updateDocument(DocumentModel document) async {
    final result = await _documentRepository.updateDocument(document);

    result.fold(
      (failure) => emit(DocumentError(failure.message, code: failure.code)),
      (updatedDocument) => emit(DocumentLoaded(updatedDocument)),
    );
  }

  /// Delete document
  Future<void> deleteDocument(String documentId) async {
    emit(const DocumentLoading());

    final result = await _documentRepository.deleteDocument(documentId);

    result.fold(
      (failure) => emit(DocumentError(failure.message, code: failure.code)),
      (_) => emit(const DocumentInitial()),
    );
  }

  /// Get analysis for document
  Future<void> getAnalysis(String documentId) async {
    emit(const DocumentLoading());

    final result = await _documentRepository.getAnalysis(documentId);

    result.fold(
      (failure) => emit(DocumentError(failure.message, code: failure.code)),
      (analysis) {
        if (analysis != null) {
          emit(AnalysisLoaded(analysis));
        } else {
          emit(const DocumentError('Analysis not found', code: 'not_found'));
        }
      },
    );
  }

  /// Save analysis
  Future<void> saveAnalysis(AnalysisModel analysis) async {
    final result = await _documentRepository.saveAnalysis(analysis);

    result.fold(
      (failure) => emit(DocumentError(failure.message, code: failure.code)),
      (savedAnalysis) => emit(AnalysisLoaded(savedAnalysis)),
    );
  }
}