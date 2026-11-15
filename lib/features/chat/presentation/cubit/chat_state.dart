import 'package:equatable/equatable.dart';

import '../../domain/models/chat_model.dart';

/// Base state for ChatCubit
abstract class ChatState extends Equatable {
  const ChatState();

  @override
  List<Object?> get props => [];
}

/// Initial state
class ChatInitial extends ChatState {
  const ChatInitial();
}

/// Loading state
class ChatLoading extends ChatState {
  const ChatLoading();
}

/// Chat loaded state
class ChatLoaded extends ChatState {
  final List<ChatMessageModel> messages;

  const ChatLoaded(this.messages);

  @override
  List<Object?> get props => [messages];
}

/// Message sent state
class ChatMessageSent extends ChatState {
  final ChatMessageModel userMessage;
  final ChatMessageModel assistantMessage;

  const ChatMessageSent(this.userMessage, this.assistantMessage);

  @override
  List<Object?> get props => [userMessage, assistantMessage];
}

/// Sending message state
class ChatSending extends ChatState {
  const ChatSending();
}

/// Error state
class ChatError extends ChatState {
  final String message;
  final String? code;

  const ChatError(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}