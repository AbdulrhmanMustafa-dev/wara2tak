import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../domain/models/chat_model.dart';
import '../../domain/repositories/chat_repository.dart' as chat_repo;
import '../../../../core/errors/failures.dart';

/// Chat repository implementation using Supabase
class ChatRepositoryImpl implements chat_repo.ChatRepository {
  final SupabaseClient _client;

  ChatRepositoryImpl(this._client);

  String? get _currentUserId => _client.auth.currentUser?.id;

  @override
  Future<Either<Failure, List<ChatMessageModel>>> getChatHistory(
    String documentId,
  ) async {
    try {
      log('📥 Fetching chat history for document: $documentId');
      final response = await _client
          .from('chat_messages')
          .select()
          .eq('documentId', documentId)
          .order('timestamp', ascending: true);

      final messages = (response as List)
          .map((json) => ChatMessageModel.fromJson(json as Map<String, dynamic>))
          .toList();

      log('✅ Fetched ${messages.length} chat messages');
      return Right(messages);
    } catch (e, stackTrace) {
      log('❌ Get chat history failed: $e');
      log('❌ Stack trace: $stackTrace');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatMessageModel>> sendMessage({
    required String documentId,
    required String userId,
    required String message,
    required List<ChatMessageModel> history,
  }) async {
    // This method is typically used for AI responses
    // For now, we just save the user message
    // The AI response would be handled by AIRepository
    try {
      log('💾 Sending message for document: $documentId');
      final userMessage = ChatMessageModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        documentId: documentId,
        userId: userId,
        role: 'user',
        content: message,
        timestamp: DateTime.now(),
      );

      final savedMessage = await saveMessage(userMessage);
      return savedMessage;
    } catch (e, stackTrace) {
      log('❌ Send message failed: $e');
      log('❌ Stack trace: $stackTrace');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, ChatMessageModel>> saveMessage(
    ChatMessageModel message,
  ) async {
    try {
      log('💾 Saving chat message: ${message.id}');
      final messageData = message.toJson();
      if (_currentUserId != null) {
        messageData['userId'] = _currentUserId;
      }

      final response = await _client
          .from('chat_messages')
          .insert(messageData)
          .select()
          .single();

      log('✅ Chat message saved');
      return Right(ChatMessageModel.fromJson(response));
    } catch (e, stackTrace) {
      log('❌ Save message failed: $e');
      log('❌ Stack trace: $stackTrace');
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Stream<List<ChatMessageModel>> watchChat(String documentId) {
    log('👀 Watching chat for document: $documentId');
    return _client
        .from('chat_messages')
        .stream(primaryKey: ['id'])
        .eq('documentId', documentId)
        .order('timestamp')
        .map((data) => data
            .map((json) => ChatMessageModel.fromJson(json))
            .toList());
  }

  @override
  Future<Either<Failure, void>> clearChat(String documentId) async {
    try {
      log('🗑️ Clearing chat for document: $documentId');
      await _client.from('chat_messages').delete().eq('documentId', documentId);
      log('✅ Chat cleared');
      return const Right(null);
    } catch (e, stackTrace) {
      log('❌ Clear chat failed: $e');
      log('❌ Stack trace: $stackTrace');
      return Left(ServerFailure(e.toString()));
    }
  }
}