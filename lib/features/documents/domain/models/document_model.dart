import 'package:equatable/equatable.dart';

/// Document status
enum DocumentStatus {
  uploaded,
  analyzing,
  analyzed,
  failed,
}

/// Document type
enum DocumentType {
  rentalContract,
  employmentContract,
  termsOfService,
  privacyPolicy,
  other,
}

/// Document model
class DocumentModel extends Equatable {
  final String id;
  final String userId;
  final String title;
  final String originalFileName;
  final String fileUrl;
  final String? thumbnailUrl;
  final DocumentType type;
  final DocumentStatus status;
  final int pageCount;
  final int fileSize;
  final String? mimeType;
  final DateTime createdAt;
  final DateTime? updatedAt;
  final DateTime? analyzedAt;
  final String? analysisId;
  final Map<String, dynamic>? metadata;

  const DocumentModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.originalFileName,
    required this.fileUrl,
    this.thumbnailUrl,
    required this.type,
    required this.status,
    required this.pageCount,
    required this.fileSize,
    this.mimeType,
    required this.createdAt,
    this.updatedAt,
    this.analyzedAt,
    this.analysisId,
    this.metadata,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    return DocumentModel(
      id: json['id'] as String,
      userId: json['userId'] as String,
      title: json['title'] as String,
      originalFileName: json['originalFileName'] as String,
      fileUrl: json['fileUrl'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      type: DocumentType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => DocumentType.other,
      ),
      status: DocumentStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => DocumentStatus.uploaded,
      ),
      pageCount: json['pageCount'] as int? ?? 0,
      fileSize: json['fileSize'] as int? ?? 0,
      mimeType: json['mimeType'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(json['updatedAt'] as String)
          : null,
      analyzedAt: json['analyzedAt'] != null
          ? DateTime.parse(json['analyzedAt'] as String)
          : null,
      analysisId: json['analysisId'] as String?,
      metadata: json['metadata'] as Map<String, dynamic>?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'originalFileName': originalFileName,
      'fileUrl': fileUrl,
      'thumbnailUrl': thumbnailUrl,
      'type': type.name,
      'status': status.name,
      'pageCount': pageCount,
      'fileSize': fileSize,
      'mimeType': mimeType,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'analyzedAt': analyzedAt?.toIso8601String(),
      'analysisId': analysisId,
      'metadata': metadata,
    };
  }

  DocumentModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? originalFileName,
    String? fileUrl,
    String? thumbnailUrl,
    DocumentType? type,
    DocumentStatus? status,
    int? pageCount,
    int? fileSize,
    String? mimeType,
    DateTime? createdAt,
    DateTime? updatedAt,
    DateTime? analyzedAt,
    String? analysisId,
    Map<String, dynamic>? metadata,
  }) {
    return DocumentModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      originalFileName: originalFileName ?? this.originalFileName,
      fileUrl: fileUrl ?? this.fileUrl,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      type: type ?? this.type,
      status: status ?? this.status,
      pageCount: pageCount ?? this.pageCount,
      fileSize: fileSize ?? this.fileSize,
      mimeType: mimeType ?? this.mimeType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      analyzedAt: analyzedAt ?? this.analyzedAt,
      analysisId: analysisId ?? this.analysisId,
      metadata: metadata ?? this.metadata,
    );
  }

  String get formattedFileSize {
    if (fileSize < 1024) return '$fileSize B';
    if (fileSize < 1024 * 1024) return '${(fileSize / 1024).toStringAsFixed(1)} KB';
    return '${(fileSize / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  String get typeLabel {
    switch (type) {
      case DocumentType.rentalContract:
        return 'Rental Contract';
      case DocumentType.employmentContract:
        return 'Employment Contract';
      case DocumentType.termsOfService:
        return 'Terms of Service';
      case DocumentType.privacyPolicy:
        return 'Privacy Policy';
      case DocumentType.other:
        return 'Other';
    }
  }

  String get statusLabel {
    switch (status) {
      case DocumentStatus.uploaded:
        return 'Uploaded';
      case DocumentStatus.analyzing:
        return 'Analyzing';
      case DocumentStatus.analyzed:
        return 'Analyzed';
      case DocumentStatus.failed:
        return 'Failed';
    }
  }

  @override
  List<Object?> get props => [
        id,
        userId,
        title,
        originalFileName,
        fileUrl,
        thumbnailUrl,
        type,
        status,
        pageCount,
        fileSize,
        mimeType,
        createdAt,
        updatedAt,
        analyzedAt,
        analysisId,
        metadata,
      ];
}