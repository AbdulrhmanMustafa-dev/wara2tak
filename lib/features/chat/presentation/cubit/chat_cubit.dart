import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';

import '../../domain/models/chat_model.dart';
import '../../domain/repositories/chat_repository.dart';
import 'chat_state.dart';

/// ChatCubit manages chat state
class ChatCubit extends Cubit<ChatState> {
  final ChatRepository _chatRepository;
  final Uuid _uuid = const Uuid();

  ChatCubit(this._chatRepository) : super(const ChatInitial());

  /// Load chat history for document
  Future<void> loadChatHistory(String documentId) async {
    emit(const ChatLoading());

    final result = await _chatRepository.getChatHistory(documentId);

    result.fold(
      (failure) => emit(ChatError(failure.message, code: failure.code)),
      (messages) => emit(ChatLoaded(messages)),
    );
  }

  /// Watch chat for real-time updates
  Stream<List<ChatMessageModel>> watchChat(String documentId) {
    return _chatRepository.watchChat(documentId);
  }

  /// Send message
  Future<void> sendMessage({
    required String documentId,
    required String userId,
    required String message,
    required List<ChatMessageModel> history,
  }) async {
    emit(const ChatSending());

    // Create user message
    final userMessage = ChatMessageModel(
      id: _uuid.v4(),
      documentId: documentId,
      userId: userId,
      role: 'user',
      content: message,
      timestamp: DateTime.now(),
    );

    // Save user message
    final saveResult = await _chatRepository.saveMessage(userMessage);
    saveResult.fold(
      (failure) => emit(ChatError(failure.message, code: failure.code)),
      (savedUserMessage) async {
        // Get AI response (this would call the AI repository)
        // For now, we'll emit a placeholder response
        final assistantMessage = ChatMessageModel(
          id: _uuid.v4(),
          documentId: documentId,
          userId: userId,
          role: 'assistant',
          content: 'This is a placeholder AI response. The actual implementation would call the AI repository.',
          timestamp: DateTime.now(),
        );

        // Save assistant message
        await _chatRepository.saveMessage(assistantMessage);

        emit(ChatMessageSent(savedUserMessage, assistantMessage));
      },
    );
  }

  /// Clear chat history
  Future<void> clearChat(String documentId) async {
    final result = await _chatRepository.clearChat(documentId);

    result.fold(
      (failure) => emit(ChatError(failure.message, code: failure.code)),
      (_) => emit(const ChatLoaded([])),
    );
  }
}