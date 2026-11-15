import 'package:equatable/equatable.dart';

import '../../domain/models/translation_model.dart';

/// Base state for TranslationCubit
abstract class TranslationState extends Equatable {
  const TranslationState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class TranslationInitial extends TranslationState {
  const TranslationInitial();
}

/// Loading state
class TranslationLoading extends TranslationState {
  const TranslationLoading();
}

/// Translations loaded state
class TranslationsLoaded extends TranslationState {
  final List<TranslationModel> translations;

  const TranslationsLoaded(this.translations);

  @override
  List<Object?> get props => [translations];
}

/// Translation completed state
class TranslationCompleted extends TranslationState {
  final TranslationModel translation;

  const TranslationCompleted(this.translation);

  @override
  List<Object?> get props => [translation];
}

/// Error state
class TranslationError extends TranslationState {
  final String message;
  final String? code;

  const TranslationError(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}