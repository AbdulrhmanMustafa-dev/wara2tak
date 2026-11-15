import 'package:dartz/dartz.dart';

import '../models/chat_model.dart';
import '../../../../core/errors/failures.dart';

/// Chat repository interface
abstract class ChatRepository {
  /// Get chat history for document
  Future<Either<Failure, List<ChatMessageModel>>> getChatHistory(String documentId);

  /// Send message and get response
  Future<Either<Failure, ChatMessageModel>> sendMessage({
    required String documentId,
    required String userId,
    required String message,
    required List<ChatMessageModel> history,
  });

  /// Save chat message
  Future<Either<Failure, ChatMessageModel>> saveMessage(ChatMessageModel message);

  /// Listen to chat messages
  Stream<List<ChatMessageModel>> watchChat(String documentId);

  /// Clear chat history
  Future<Either<Failure, void>> clearChat(String documentId);
}