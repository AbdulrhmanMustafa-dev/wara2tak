import 'dart:io';
import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/document_model.dart';
import '../../domain/models/analysis_model.dart';
import '../../domain/repositories/document_repository.dart'
    as document_repo;
import '../../../../core/errors/failures.dart';

/// Document repository implementation using Supabase
class DocumentRepositoryImpl implements document_repo.DocumentRepository {
  final SupabaseClient _client;

  DocumentRepositoryImpl(this._client);

  String _getMimeType(String fileName) {
    final ext = fileName.toLowerCase().split('.').last;
    switch (ext) {
      case 'pdf':
        return 'application/pdf';
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      default:
        return 'application/octet-stream';
    }
  }

  /// Sanitizes a filename for use as a Supabase Storage object key.
  /// Keeps only ASCII alphanumeric, underscores, and hyphens.
  String _sanitizeStorageFilename(String fileName) {
    final hasExtension = fileName.contains('.');
    final extension = hasExtension ? fileName.split('.').last.toLowerCase() : 'pdf';
    final rawBaseName = hasExtension
        ? fileName.substring(0, fileName.lastIndexOf('.'))
        : fileName;

    // Replace any non-ASCII alphanumeric, underscore, or hyphen with underscore
    final safeBaseName = rawBaseName
        .replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_')
        .replaceAll(RegExp(r'_+'), '_')
        .replaceAll(RegExp(r'^_|_$'), '');

    final finalSafeName = safeBaseName.isEmpty ? 'document' : safeBaseName;
    return '$finalSafeName.$extension';
  }

  @override
  Future<Either<Failure, DocumentModel>> uploadDocument({
    required String userId,
    required String filePath,
    required String fileName,
    required DocumentType type,
    String? title,
  }) async {
    try {
      log('📤 Uploading document: $fileName for user: $userId');

      // 1. Read the file and get its size
      final file = File(filePath);
      final fileSize = await file.length();

      // 2. Determine mimeType (use original filename for extension)
      final mimeType = _getMimeType(fileName);

      // 3. Upload to Supabase Storage (sanitize filename for storage key)
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final safeStorageName = _sanitizeStorageFilename(fileName);
      final storagePath = '$userId/${timestamp}_$safeStorageName';

      log('📤 Uploading to storage: $storagePath');
      await _client.storage.from('documents').upload(
            storagePath,
            file,
            fileOptions: FileOptions(
              contentType: mimeType,
              upsert: false,
            ),
          );

      // 4. Insert document record into database
      final now = DateTime.now().toIso8601String();
      final documentData = {
        'userId': userId,
        'title': title ?? fileName,
        'originalFileName': fileName,
        'fileUrl': storagePath,
        'type': type.name,
        'status': DocumentStatus.uploaded.name,
        'pageCount': 1,
        'fileSize': fileSize,
        'mimeType': mimeType,
        'createdAt': now,
      };

      log('📤 Inserting document record');
      final response = await _client
          .from('documents')
          .insert(documentData)
          .select()
          .single();

      log('✅ Document uploaded successfully: ${response['id']}');
      return Right(DocumentModel.fromJson(response));
    } catch (e, stackTrace) {
      log('❌ Upload document failed: $e');
      log('❌ Stack trace: $stackTrace');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<DocumentModel>>> getUserDocuments(
    String userId,
  ) async {
    try {
      log('📥 Fetching documents for user: $userId');
      final response = await _client
          .from('documents')
          .select()
          .eq('userId', userId)
          .order('createdAt', ascending: false);

      final documents = (response as List)
          .map((json) => DocumentModel.fromJson(json as Map<String, dynamic>))
          .toList();

      log('✅ Fetched ${documents.length} documents');
      return Right(documents);
    } catch (e, stackTrace) {
      log('❌ Get user documents failed: $e');
      log('❌ Stack trace: $stackTrace');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DocumentModel?>> getDocument(String documentId) async {
    try {
      log('📥 Fetching document: $documentId');
      final response = await _client
          .from('documents')
          .select()
          .eq('id', documentId)
          .maybeSingle();

      if (response == null) {
        log('⚠️ Document not found: $documentId');
        return const Right(null);
      }

      log('✅ Document fetched');
      return Right(DocumentModel.fromJson(response));
    } catch (e, stackTrace) {
      log('❌ Get document failed: $e');
      log('❌ Stack trace: $stackTrace');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, DocumentModel>> updateDocument(
    DocumentModel document,
  ) async {
    try {
      log('📝 Updating document: ${document.id}');
      final response = await _client
          .from('documents')
          .update(document.toJson())
          .eq('id', document.id)
          .select()
          .single();

      log('✅ Document updated');
      return Right(DocumentModel.fromJson(response));
    } catch (e, stackTrace) {
      log('❌ Update document failed: $e');
      log('❌ Stack trace: $stackTrace');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> deleteDocument(String documentId) async {
    try {
      log('🗑️ Deleting document: $documentId');

      // First, get the document to find the storage path
      final docResult = await getDocument(documentId);
      final doc = docResult.fold(
        (failure) => null,
        (document) => document,
      );

      if (doc != null && doc.fileUrl.isNotEmpty) {
        // Delete from storage (ignore errors if file doesn't exist)
        try {
          log('🗑️ Deleting from storage: ${doc.fileUrl}');
          await _client.storage.from('documents').remove([doc.fileUrl]);
        } catch (e) {
          log('⚠️ Storage delete failed (ignoring): $e');
        }
      }

      // Delete from database
      await _client.from('documents').delete().eq('id', documentId);

      log('✅ Document deleted');
      return const Right(null);
    } catch (e, stackTrace) {
      log('❌ Delete document failed: $e');
      log('❌ Stack trace: $stackTrace');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AnalysisModel?>> getAnalysis(String documentId) async {
    try {
      log('📥 Fetching analysis for document: $documentId');
      final response = await _client
          .from('analyses')
          .select()
          .eq('documentId', documentId)
          .maybeSingle();

      if (response == null) {
        log('⚠️ Analysis not found for document: $documentId');
        return const Right(null);
      }

      log('✅ Analysis fetched');
      return Right(AnalysisModel.fromJson(response));
    } catch (e, stackTrace) {
      log('❌ Get analysis failed: $e');
      log('❌ Stack trace: $stackTrace');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, AnalysisModel>> saveAnalysis(AnalysisModel analysis) async {
    try {
      log('💾 Saving analysis for document: ${analysis.documentId}');
      final response = await _client
          .from('analyses')
          .upsert(analysis.toJson(), onConflict: 'documentId')
          .select()
          .single();

      log('✅ Analysis saved');
      return Right(AnalysisModel.fromJson(response));
    } catch (e, stackTrace) {
      log('❌ Save analysis failed: $e');
      log('❌ Stack trace: $stackTrace');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<DocumentModel>> watchUserDocuments(String userId) {
    log('👀 Watching documents for user: $userId');
    return _client
        .from('documents')
        .stream(primaryKey: ['id'])
        .eq('userId', userId)
        .order('createdAt')
        .map((data) => data
            .map((json) => DocumentModel.fromJson(json))
            .toList());
  }
}