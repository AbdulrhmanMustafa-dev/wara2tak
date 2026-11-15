import 'package:equatable/equatable.dart';

import '../../../documents/domain/models/analysis_model.dart';

/// Base state for AnalysisCubit
abstract class AnalysisState extends Equatable {
  const AnalysisState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class AnalysisInitial extends AnalysisState {
  const AnalysisInitial();
}

/// Analysis progress state
class AnalysisProgress extends AnalysisState {
  final int progress;
  final String? message;

  const AnalysisProgress(this.progress, {this.message});

  @override
  List<Object?> get props => [progress, message];
}

/// Analysis completed state
class AnalysisCompleted extends AnalysisState {
  final AnalysisModel analysis;

  const AnalysisCompleted(this.analysis);

  @override
  List<Object?> get props => [analysis];
}

/// Chat loading state
class ChatLoading extends AnalysisState {
  const ChatLoading();
}

/// Chat response state
class ChatResponse extends AnalysisState {
  final String response;

  const ChatResponse(this.response);

  @override
  List<Object?> get props => [response];
}

/// Chat error state
class ChatError extends AnalysisState {
  final String message;
  final String? code;

  const ChatError(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}

/// Translation loading state
class TranslationLoading extends AnalysisState {
  const TranslationLoading();
}

/// Translation completed state
class TranslationCompleted extends AnalysisState {
  final String translation;

  const TranslationCompleted(this.translation);

  @override
  List<Object?> get props => [translation];
}

/// Translation error state
class TranslationError extends AnalysisState {
  final String message;
  final String? code;

  const TranslationError(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}

/// Checklist loading state
class ChecklistLoading extends AnalysisState {
  const ChecklistLoading();
}

/// Checklist generated state
class ChecklistGenerated extends AnalysisState {
  final List<ChecklistItemModel> checklist;

  const ChecklistGenerated(this.checklist);

  @override
  List<Object?> get props => [checklist];
}

/// Checklist error state
class ChecklistError extends AnalysisState {
  final String message;
  final String? code;

  const ChecklistError(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}

/// General analysis error state
class AnalysisError extends AnalysisState {
  final String message;
  final String? code;

  const AnalysisError(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}