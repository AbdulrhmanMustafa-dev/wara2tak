import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/checklist_model.dart';
import '../../domain/repositories/checklist_repository.dart' as checklist_repo;
import '../../../../core/errors/failures.dart';

/// Checklist repository implementation using Supabase
class ChecklistRepositoryImpl implements checklist_repo.ChecklistRepository {
  final SupabaseClient _client;

  ChecklistRepositoryImpl(this._client);

  String? get _currentUserId => _client.auth.currentUser?.id;

  /// Validates if a string is a valid UUID v4.
  static bool _isValidUuid(String id) {
    final uuidRegex = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
      caseSensitive: false,
    );
    return uuidRegex.hasMatch(id);
  }

  /// Ensures the item has a valid UUID v4. If invalid, generates a new one.
  /// Returns the sanitized item and a flag indicating if the ID was replaced.
  static (ChecklistItemModel, bool) _ensureValidUuid(ChecklistItemModel item) {
    if (_isValidUuid(item.id)) {
      return (item, false);
    }
    final newId = const Uuid().v4();
    log('🔧 [ChecklistRepository] Replacing invalid ID with UUID v4',
        name: 'ChecklistRepository',
        error: {'originalId': item.id, 'newId': newId});
    return (item.copyWith(id: newId), true);
  }

  @override
  Future<Either<Failure, List<ChecklistItemModel>>> getChecklist(
    String documentId,
  ) async {
    try {
      log('📥 Fetching checklist for document: $documentId');
      final response = await _client
          .from('checklist_items')
          .select()
          .eq('documentId', documentId)
          .order('createdAt', ascending: true);

      final items = (response as List)
          .map((json) => ChecklistItemModel.fromJson(json as Map<String, dynamic>))
          .toList();

      log('✅ Fetched ${items.length} checklist items');
      return Right(items);
    } catch (e, stackTrace) {
      log('❌ Get checklist failed: $e');
      log('❌ Stack trace: $stackTrace');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ChecklistItemModel>>> saveChecklist(
    String documentId,
    List<ChecklistItemModel> items,
  ) async {
    try {
      log('💾 Saving ${items.length} checklist items for document: $documentId');
      final userId = _currentUserId;
      if (userId == null) {
        return const Left(AuthFailure('User not authenticated'));
      }

      // Defensive: sanitize all item IDs to valid UUID v4 before sending to Supabase.
      // The `id` column in PostgreSQL is type uuid, so non-UUID strings like "check_1" will fail.
      final sanitizedItems = items.map((item) {
        final (sanitizedItem, wasReplaced) = _ensureValidUuid(item);
        if (wasReplaced) {
          log('🔧 [saveChecklist] Sanitized item ID for document: $documentId',
              name: 'ChecklistRepository',
              error: {'originalId': item.id, 'newId': sanitizedItem.id});
        }
        return sanitizedItem;
      }).toList();

      // Prepare items with documentId and userId
      final itemsData = sanitizedItems.map((item) {
        final json = item.toJson();
        json['documentId'] = documentId;
        json['userId'] = userId;
        return json;
      }).toList();

      // Upsert all items (onConflict: 'id' assumes items have IDs)
      final response = await _client
          .from('checklist_items')
          .upsert(itemsData, onConflict: 'id')
          .select();

      final savedItems = (response as List)
          .map((json) => ChecklistItemModel.fromJson(json as Map<String, dynamic>))
          .toList();

      log('✅ Checklist saved');
      return Right(savedItems);
    } catch (e, stackTrace) {
      log('❌ Save checklist failed: $e');
      log('❌ Stack trace: $stackTrace');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChecklistItemModel>> addChecklistItem(
    String documentId,
    ChecklistItemModel item,
  ) async {
    try {
      // Defensive: sanitize item ID to valid UUID v4 before sending to Supabase.
      final (sanitizedItem, wasReplaced) = _ensureValidUuid(item);
      if (wasReplaced) {
        log('🔧 [addChecklistItem] Sanitized item ID for document: $documentId',
            name: 'ChecklistRepository',
            error: {'originalId': item.id, 'newId': sanitizedItem.id});
      }

      log('➕ Adding checklist item: ${sanitizedItem.id} for document: $documentId');
      final userId = _currentUserId;
      if (userId == null) {
        return const Left(AuthFailure('User not authenticated'));
      }

      final insertData = sanitizedItem.toJson();
      insertData['documentId'] = documentId;
      insertData['userId'] = userId;

      final response = await _client
          .from('checklist_items')
          .insert(insertData)
          .select()
          .maybeSingle();

      if (response == null) {
        log('❌ Add checklist item failed: no rows returned (PGRST116)');
        return Left(ServerFailure(
          'Failed to create checklist item: server returned no data',
          code: 'PGRST116',
        ));
      }

      log('✅ Checklist item added');
      return Right(ChecklistItemModel.fromJson(response));
    } catch (e, stackTrace) {
      log('❌ Add checklist item failed: $e');
      log('❌ Stack trace: $stackTrace');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChecklistItemModel>> updateChecklistItem(
    String documentId,
    ChecklistItemModel item,
  ) async {
    try {
      log('📝 Updating checklist item: ${item.id}');
      final updateData = item.toJson();
      updateData['documentId'] = documentId;
      if (_currentUserId != null) {
        updateData['userId'] = _currentUserId;
      }

      final response = await _client
          .from('checklist_items')
          .update(updateData)
          .eq('id', item.id)
          .eq('documentId', documentId)
          .select()
          .maybeSingle();

      if (response == null) {
        log('❌ Update checklist item failed: no rows returned (PGRST116)');
        return Left(ServerFailure(
          'Failed to update checklist item: item not found',
          code: 'PGRST116',
        ));
      }

      log('✅ Checklist item updated');
      return Right(ChecklistItemModel.fromJson(response));
    } catch (e, stackTrace) {
      log('❌ Update checklist item failed: $e');
      log('❌ Stack trace: $stackTrace');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<ChecklistItemModel>> watchChecklist(String documentId) {
    log('👀 Watching checklist for document: $documentId');
    return _client
        .from('checklist_items')
        .stream(primaryKey: ['id'])
        .eq('documentId', documentId)
        .order('createdAt')
        .map((data) => data
            .map((json) => ChecklistItemModel.fromJson(json))
            .toList());
  }

  @override
  Future<Either<Failure, void>> deleteChecklistItem(
    String documentId,
    String itemId,
  ) async {
    try {
      log('🗑️ Deleting checklist item: $itemId');
      await _client
          .from('checklist_items')
          .delete()
          .eq('id', itemId)
          .eq('documentId', documentId);
      log('✅ Checklist item deleted');
      return const Right(null);
    } catch (e, stackTrace) {
      log('❌ Delete checklist item failed: $e');
      log('❌ Stack trace: $stackTrace');
      return Left(ServerFailure(e.toString()));
    }
  }
}