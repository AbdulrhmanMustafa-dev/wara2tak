import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/models/document_model.dart';
import '../../domain/models/analysis_model.dart';
import '../../domain/repositories/document_repository.dart';
import 'document_state.dart';

/// DocumentCubit manages document state
class DocumentCubit extends Cubit<DocumentState> {
  final DocumentRepository _documentRepository;

  // Cached document list for optimistic updates
  List<DocumentModel> _cachedDocuments = [];

  /// Expose cached documents for fallback rendering when state is unexpected
  List<DocumentModel> get cachedDocuments => List.unmodifiable(_cachedDocuments);

  DocumentCubit(this._documentRepository) : super(const DocumentInitial());

  /// Load user's documents (no real-time subscription - uses Pull-to-Refresh)
  Future<void> loadUserDocuments(String userId) async {
    emit(const DocumentLoading());

    final result = await _documentRepository.getUserDocuments(userId);

    result.fold(
      (failure) => emit(DocumentError(failure.message, code: failure.code)),
      (documents) {
        _cachedDocuments = List.unmodifiable(documents);
        emit(DocumentsLoaded(List.unmodifiable(documents)));
      },
    );
  }

  /// Get document by ID (without analysis)
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

  /// Load document with analysis atomically (single state emission)
  /// This prevents race conditions and black screen issues
  Future<void> loadDocumentWithAnalysis(String documentId) async {
    emit(const DocumentLoading());

    try {
      // Fetch both in parallel for speed
      final results = await Future.wait([
        _documentRepository.getDocument(documentId),
        _documentRepository.getAnalysis(documentId),
      ]);

      final documentResult = results[0] as Either<Failure, DocumentModel?>;
      final analysisResult = results[1] as Either<Failure, AnalysisModel?>;

      // Check document first
      final document = documentResult.fold(
        (failure) => throw failure,
        (doc) => doc,
      );

      if (document == null) {
        emit(const DocumentError('Document not found', code: 'not_found'));
        return;
      }

      // Get analysis (optional - can be null if not analyzed yet)
      final analysis = analysisResult.fold(
        (failure) => null, // Analysis not found or error - just continue without it
        (a) => a,
      );

      // Emit single combined state
      emit(DocumentLoaded(document, analysis: analysis));
    } on Failure catch (failure) {
      emit(DocumentError(failure.message, code: failure.code));
    } catch (e) {
      emit(DocumentError('Unexpected error: $e'));
    }
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
      (document) {
        // Optimistic update: prepend new document to cached list
        _cachedDocuments = [document, ..._cachedDocuments];
        emit(DocumentsLoaded(List.unmodifiable(_cachedDocuments)));
      },
    );
  }

  /// Update document
  Future<void> updateDocument(DocumentModel document) async {
    final result = await _documentRepository.updateDocument(document);

    result.fold(
      (failure) => emit(DocumentError(failure.message, code: failure.code)),
      (updatedDocument) => emit(DocumentLoaded(updatedDocument, analysis: null)),
    );
  }

  /// Delete document
  Future<void> deleteDocument(String documentId) async {
    // Don't emit loading to avoid flicker - just do the deletion
    final result = await _documentRepository.deleteDocument(documentId);

    result.fold(
      (failure) => emit(DocumentError(failure.message, code: failure.code)),
      (_) {
        // Create new list without the deleted document (never mutate in-place)
        _cachedDocuments = _cachedDocuments.where((d) => d.id != documentId).toList();
        emit(DocumentsLoaded(List.unmodifiable(_cachedDocuments)));
      },
    );
  }

  /// Get analysis for document (standalone - for refresh)
  Future<void> getAnalysis(String documentId) async {
    // Don't emit loading to avoid flicker - just fetch analysis
    final result = await _documentRepository.getAnalysis(documentId);

    result.fold(
      (failure) => emit(DocumentError(failure.message, code: failure.code)),
      (analysis) {
        if (analysis != null) {
          // Get current document from state if available
          final currentDoc = state is DocumentLoaded ? (state as DocumentLoaded).document : null;
          if (currentDoc != null) {
            emit(DocumentLoaded(currentDoc, analysis: analysis));
          } else {
            emit(DocumentError('Analysis found but document missing', code: 'state_error'));
          }
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
      (savedAnalysis) {
        // Get current document from state if available
        final currentDoc = state is DocumentLoaded ? (state as DocumentLoaded).document : null;
        if (currentDoc != null) {
          emit(DocumentLoaded(currentDoc, analysis: savedAnalysis));
        } else {
          // Fallback - shouldn't happen in normal flow, emit error
          emit(DocumentError('Analysis saved but document context lost', code: 'state_error'));
        }
      },
    );
  }
}