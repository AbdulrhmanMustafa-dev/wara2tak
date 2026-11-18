import 'package:dartz/dartz.dart';

import '../models/checklist_model.dart';
import '../../../../core/errors/failures.dart';

/// Checklist repository interface
abstract class ChecklistRepository {
  /// Get checklist for document
  Future<Either<Failure, List<ChecklistItemModel>>> getChecklist(String documentId);

  /// Add new checklist item
  Future<Either<Failure, ChecklistItemModel>> addChecklistItem(
    String documentId,
    ChecklistItemModel item,
  );

  /// Save checklist
  Future<Either<Failure, List<ChecklistItemModel>>> saveChecklist(
    String documentId,
    List<ChecklistItemModel> items,
  );

  /// Update checklist item
  Future<Either<Failure, ChecklistItemModel>> updateChecklistItem(
    String documentId,
    ChecklistItemModel item,
  );

  /// Delete checklist item
  Future<Either<Failure, void>> deleteChecklistItem(
    String documentId,
    String itemId,
  );

  /// Listen to checklist changes
  Stream<List<ChecklistItemModel>> watchChecklist(String documentId);
}