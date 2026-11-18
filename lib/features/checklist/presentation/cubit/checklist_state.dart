import 'package:equatable/equatable.dart';

import '../../domain/models/checklist_model.dart';

/// Base state for ChecklistCubit
abstract class ChecklistState extends Equatable {
  const ChecklistState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ChecklistInitial extends ChecklistState {
  const ChecklistInitial();
}

/// Loading state
class ChecklistLoading extends ChecklistState {
  const ChecklistLoading();
}

/// Checklist loaded state
class ChecklistLoaded extends ChecklistState {
  final List<ChecklistItemModel> items;
  final String? errorMessage; // Non-destructive error for SnackBar (keeps list visible)

  const ChecklistLoaded(this.items, {this.errorMessage});

  @override
  List<Object?> get props => [items, errorMessage];
}

/// Checklist item updated state
class ChecklistItemUpdated extends ChecklistState {
  final ChecklistItemModel item;

  const ChecklistItemUpdated(this.item);

  @override
  List<Object?> get props => [item];
}

/// Error state
class ChecklistError extends ChecklistState {
  final String message;
  final String? code;

  const ChecklistError(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}