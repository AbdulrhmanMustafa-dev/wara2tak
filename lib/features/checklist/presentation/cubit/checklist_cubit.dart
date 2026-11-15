import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dartz/dartz.dart';

import '../../domain/models/checklist_model.dart';
import '../../domain/repositories/checklist_repository.dart';
import 'checklist_state.dart';
import '../../../../core/errors/failures.dart';

/// ChecklistCubit manages checklist state
class ChecklistCubit extends Cubit<ChecklistState> {
  final ChecklistRepository _checklistRepository;

  ChecklistCubit(this._checklistRepository) : super(const ChecklistInitial());

  /// Load checklist for document
  Future<void> loadChecklist(String documentId) async {
    emit(const ChecklistLoading());

    final result = await _checklistRepository.getChecklist(documentId);

    result.fold(
      (failure) => emit(ChecklistError(failure.message, code: failure.code)),
      (items) => emit(ChecklistLoaded(items)),
    );
  }

  /// Watch checklist for real-time updates
  Stream<List<ChecklistItemModel>> watchChecklist(String documentId) {
    return _checklistRepository.watchChecklist(documentId);
  }

  /// Toggle checklist item completion
  Future<void> toggleItem(ChecklistItemModel item) async {
    final updatedItem = item.copyWith(
      isCompleted: !item.isCompleted,
      completedAt: !item.isCompleted ? DateTime.now() : null,
    );

    final result = await _checklistRepository.updateChecklistItem(
      item.id,
      updatedItem,
    );

    result.fold(
      (failure) => emit(ChecklistError(failure.message, code: failure.code)),
      (updated) => emit(ChecklistItemUpdated(updated)),
    );
  }

  /// Update checklist item
  Future<void> updateItem(ChecklistItemModel item) async {
    final result = await _checklistRepository.updateChecklistItem(
      item.id,
      item,
    );

    result.fold(
      (failure) => emit(ChecklistError(failure.message, code: failure.code)),
      (updated) => emit(ChecklistItemUpdated(updated)),
    );
  }

  /// Save entire checklist
  Future<void> saveChecklist(String documentId, List<ChecklistItemModel> items) async {
    final result = await _checklistRepository.saveChecklist(documentId, items);

    result.fold(
      (failure) => emit(ChecklistError(failure.message, code: failure.code)),
      (saved) => emit(ChecklistLoaded(saved)),
    );
  }
}