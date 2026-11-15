import 'package:dartz/dartz.dart';

import '../../domain/models/document_model.dart';
import '../../domain/models/analysis_model.dart';
import '../../../../core/errors/failures.dart';

/// Document repository interface
abstract class DocumentRepository {
  /// Upload a document
  Future<Either<Failure, DocumentModel>> uploadDocument({
    required String userId,
    required String filePath,
    required String fileName,
    required DocumentType type,
    String? title,
  });

  /// Get user's documents
  Future<Either<Failure, List<DocumentModel>>> getUserDocuments(String userId);

  /// Get document by ID
  Future<Either<Failure, DocumentModel?>> getDocument(String documentId);

  /// Update document
  Future<Either<Failure, DocumentModel>> updateDocument(DocumentModel document);

  /// Delete document
  Future<Either<Failure, void>> deleteDocument(String documentId);

  /// Get analysis for document
  Future<Either<Failure, AnalysisModel?>> getAnalysis(String documentId);

  /// Save analysis
  Future<Either<Failure, AnalysisModel>> saveAnalysis(AnalysisModel analysis);

  /// Listen to user's documents
  Stream<List<DocumentModel>> watchUserDocuments(String userId);
}