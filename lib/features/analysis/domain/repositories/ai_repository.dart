import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';

import '../../../documents/domain/models/analysis_model.dart';
import '../../../documents/domain/models/document_model.dart';
import '../../../../core/errors/failures.dart';

/// AI repository interface for document analysis
abstract class AIRepository {
  /// Analyze a document using Gemini AI
  Future<Either<Failure, AnalysisModel>> analyzeDocument({
    required DocumentModel document,
    required String localFilePath,
    required String userId,
    required Function(int progress, String? message) onProgress,
  });

  /// Chat with document (RAG)
  Future<Either<Failure, String>> chatWithDocument({
    required String documentId,
    required String analysisId,
    required String question,
    required List<AIChatMessage> history,
  });

  /// Translate document
  Future<Either<Failure, String>> translateDocument({
    required String documentId,
    required String analysisId,
    required String targetLanguage,
    required String content,
  });

  /// Generate checklist from analysis
  Future<Either<Failure, List<ChecklistItemModel>>> generateChecklist({
    required AnalysisModel analysis,
  });
}

/// Chat message model for AI repository
class AIChatMessage extends Equatable {
  final String id;
  final String role; // 'user' or 'assistant'
  final String content;
  final DateTime timestamp;

  const AIChatMessage({
    required this.id,
    required this.role,
    required this.content,
    required this.timestamp,
  });

  factory AIChatMessage.fromJson(Map<String, dynamic> json) {
    return AIChatMessage(
      id: json['id'] as String,
      role: json['role'] as String,
      content: json['content'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'role': role,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  @override
  List<Object?> get props => [id, role, content, timestamp];
}