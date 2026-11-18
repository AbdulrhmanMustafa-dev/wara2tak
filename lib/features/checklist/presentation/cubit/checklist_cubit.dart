import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/checklist_model.dart';
import '../../domain/repositories/checklist_repository.dart';
import 'checklist_state.dart';

/// ChecklistCubit manages checklist state with optimistic updates
class ChecklistCubit extends Cubit<ChecklistState> {
  final ChecklistRepository _checklistRepository;

  // Store the current documentId for mutations
  String? _currentDocumentId;

  // Cached items for optimistic updates
  List<ChecklistItemModel> _cachedItems = [];

  ChecklistCubit(this._checklistRepository) : super(const ChecklistInitial());

  /// Load checklist for document
  Future<void> loadChecklist(String documentId) async {
    _currentDocumentId = documentId;
    emit(const ChecklistLoading());

    final result = await _checklistRepository.getChecklist(documentId);

    result.fold(
      (failure) => emit(ChecklistError(failure.message, code: failure.code)),
      (items) {
        _cachedItems = List.unmodifiable(items);
        emit(ChecklistLoaded(List.unmodifiable(items)));
      },
    );
  }

  /// Watch checklist for real-time updates
  Stream<List<ChecklistItemModel>> watchChecklist(String documentId) {
    _currentDocumentId = documentId;
    return _checklistRepository.watchChecklist(documentId);
  }

  /// Toggle checklist item completion (optimistic update)
  Future<void> toggleItem(ChecklistItemModel item) async {
    if (_currentDocumentId == null) {
      emit(const ChecklistError('No document loaded', code: 'no_document'));
      return;
    }

    // Store previous state for rollback on failure
    final previousItems = List<ChecklistItemModel>.from(_cachedItems);

    // Optimistic update: immediately update local state
    final updatedItem = item.copyWith(
      isCompleted: !item.isCompleted,
      completedAt: !item.isCompleted ? DateTime.now() : null,
    );

    _cachedItems = _cachedItems
        .map((i) => i.id == item.id ? updatedItem : i)
        .toList();

    // Emit updated list immediately (no loading state)
    emit(ChecklistLoaded(List.unmodifiable(_cachedItems)));

    // Background sync to server
    final result = await _checklistRepository.updateChecklistItem(
      _currentDocumentId!,
      updatedItem,
    );

    result.fold(
      (failure) {
        // Rollback on failure - keep list visible, show error via errorMessage
        _cachedItems = previousItems;
        emit(ChecklistLoaded(
          List.unmodifiable(_cachedItems),
          errorMessage: failure.message,
        ));
      },
      (synced) {
        // Ensure local state matches server (in case of any differences)
        _cachedItems = _cachedItems
            .map((i) => i.id == synced.id ? synced : i)
            .toList();
        emit(ChecklistLoaded(List.unmodifiable(_cachedItems)));
      },
    );
  }

  /// Update checklist item (optimistic update)
  Future<void> updateItem(ChecklistItemModel item) async {
    if (_currentDocumentId == null) {
      emit(const ChecklistError('No document loaded', code: 'no_document'));
      return;
    }

    // Store previous state for rollback on failure
    final previousItems = List<ChecklistItemModel>.from(_cachedItems);

    // Optimistic update
    _cachedItems = _cachedItems
        .map((i) => i.id == item.id ? item : i)
        .toList();

    emit(ChecklistLoaded(List.unmodifiable(_cachedItems)));

    // Background sync to server
    final result = await _checklistRepository.updateChecklistItem(
      _currentDocumentId!,
      item,
    );

    result.fold(
      (failure) {
        _cachedItems = previousItems;
        emit(ChecklistLoaded(
          List.unmodifiable(_cachedItems),
          errorMessage: failure.message,
        ));
      },
      (synced) {
        _cachedItems = _cachedItems
            .map((i) => i.id == synced.id ? synced : i)
            .toList();
        emit(ChecklistLoaded(List.unmodifiable(_cachedItems)));
      },
    );
  }

  /// Add new checklist item (optimistic update)
  Future<void> addItem(ChecklistItemModel item) async {
    if (_currentDocumentId == null) {
      emit(const ChecklistError('No document loaded', code: 'no_document'));
      return;
    }

    final previousItems = List<ChecklistItemModel>.from(_cachedItems);

    _cachedItems = [..._cachedItems, item];
    emit(ChecklistLoaded(List.unmodifiable(_cachedItems)));

    final result = await _checklistRepository.addChecklistItem(
      _currentDocumentId!,
      item,
    );

    result.fold(
      (failure) {
        _cachedItems = previousItems;
        emit(ChecklistLoaded(
          List.unmodifiable(_cachedItems),
          errorMessage: failure.message,
        ));
      },
      (synced) {
        _cachedItems = _cachedItems
            .map((i) => i.id == synced.id ? synced : i)
            .toList();
        emit(ChecklistLoaded(List.unmodifiable(_cachedItems)));
      },
    );
  }

  /// Delete checklist item (optimistic update)
  Future<void> deleteItem(String itemId) async {
    if (_currentDocumentId == null) {
      emit(const ChecklistError('No document loaded', code: 'no_document'));
      return;
    }

    final previousItems = List<ChecklistItemModel>.from(_cachedItems);

    _cachedItems = _cachedItems.where((i) => i.id != itemId).toList();
    emit(ChecklistLoaded(List.unmodifiable(_cachedItems)));

    final result = await _checklistRepository.deleteChecklistItem(
      _currentDocumentId!,
      itemId,
    );

    result.fold(
      (failure) {
        _cachedItems = previousItems;
        emit(ChecklistLoaded(
          List.unmodifiable(_cachedItems),
          errorMessage: failure.message,
        ));
      },
      (_) {
        // Successfully deleted on server
      },
    );
  }

  /// Save entire checklist (replaces all items)
  Future<void> saveChecklist(String documentId, List<ChecklistItemModel> items) async {
    _currentDocumentId = documentId;

    final previousItems = List<ChecklistItemModel>.from(_cachedItems);

    // Optimistic update
    _cachedItems = List.unmodifiable(items);
    emit(ChecklistLoaded(List.unmodifiable(_cachedItems)));

    final result = await _checklistRepository.saveChecklist(documentId, items);

    result.fold(
      (failure) {
        _cachedItems = previousItems;
        emit(ChecklistLoaded(
          List.unmodifiable(_cachedItems),
          errorMessage: failure.message,
        ));
      },
      (saved) {
        _cachedItems = List.unmodifiable(saved);
        emit(ChecklistLoaded(List.unmodifiable(_cachedItems)));
      },
    );
  }
}