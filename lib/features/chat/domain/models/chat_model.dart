import 'package:equatable/equatable.dart';

/// Chat message model
class ChatMessageModel extends Equatable {
  final String id;
  final String documentId;
  final String userId;
  final String role; // 'user' or 'assistant'
  final String content;
  final List<String>? sources; // Page numbers or clause IDs referenced
  final DateTime timestamp;

  const ChatMessageModel({
    required this.id,
    required this.documentId,
    required this.userId,
    required this.role,
    required this.content,
    this.sources,
    required this.timestamp,
  });

  factory ChatMessageModel.fromJson(Map<String, dynamic> json) {
    return ChatMessageModel(
      id: json['id'] as String,
      documentId: json['documentId'] as String,
      userId: json['userId'] as String,
      role: json['role'] as String,
      content: json['content'] as String,
      sources: (json['sources'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      timestamp: DateTime.parse(json['timestamp'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'userId': userId,
      'role': role,
      'content': content,
      'sources': sources,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  ChatMessageModel copyWith({
    String? id,
    String? documentId,
    String? userId,
    String? role,
    String? content,
    List<String>? sources,
    DateTime? timestamp,
  }) {
    return ChatMessageModel(
      id: id ?? this.id,
      documentId: documentId ?? this.documentId,
      userId: userId ?? this.userId,
      role: role ?? this.role,
      content: content ?? this.content,
      sources: sources ?? this.sources,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  List<Object?> get props => [id, documentId, userId, role, content, sources, timestamp];
}