import 'package:equatable/equatable.dart';

import '../../domain/models/document_model.dart';
import '../../domain/models/analysis_model.dart';

/// Base state for DocumentCubit
abstract class DocumentState extends Equatable {
  const DocumentState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class DocumentInitial extends DocumentState {
  const DocumentInitial();
}

/// Loading state
class DocumentLoading extends DocumentState {
  const DocumentLoading();
}

/// Documents loaded state
class DocumentsLoaded extends DocumentState {
  final List<DocumentModel> documents;

  const DocumentsLoaded(this.documents);

  @override
  List<Object?> get props => [documents];
}

/// Document loaded state
class DocumentLoaded extends DocumentState {
  final DocumentModel document;

  const DocumentLoaded(this.document);

  @override
  List<Object?> get props => [document];
}

/// Analysis loaded state
class AnalysisLoaded extends DocumentState {
  final AnalysisModel analysis;

  const AnalysisLoaded(this.analysis);

  @override
  List<Object?> get props => [analysis];
}

/// Upload progress state
class DocumentUploadProgress extends DocumentState {
  final double progress;

  const DocumentUploadProgress(this.progress);

  @override
  List<Object?> get props => [progress];
}

/// Upload success state
class DocumentUploadSuccess extends DocumentState {
  final DocumentModel document;

  const DocumentUploadSuccess(this.document);

  @override
  List<Object?> get props => [document];
}

/// Analysis progress state
class AnalysisProgressState extends DocumentState {
  final int progress;
  final String? message;

  const AnalysisProgressState(this.progress, {this.message});

  @override
  List<Object?> get props => [progress, message];
}

/// Error state
class DocumentError extends DocumentState {
  final String message;
  final String? code;

  const DocumentError(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}