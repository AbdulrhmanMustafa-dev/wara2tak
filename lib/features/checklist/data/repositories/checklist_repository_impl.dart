import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/checklist_model.dart';
import '../../domain/repositories/checklist_repository.dart' as checklist_repo;
import '../../../../core/errors/failures.dart';

/// Checklist repository implementation using Supabase
class ChecklistRepositoryImpl implements checklist_repo.ChecklistRepository {
  final SupabaseClient _client;

  ChecklistRepositoryImpl(this._client);

  String? get _currentUserId => _client.auth.currentUser?.id;

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

      // Prepare items with documentId and userId
      final itemsData = items.map((item) {
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
          .select()
          .single();

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
}