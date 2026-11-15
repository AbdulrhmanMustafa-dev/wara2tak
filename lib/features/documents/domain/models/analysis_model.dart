import 'package:equatable/equatable.dart';

/// Analysis status
enum AnalysisStatus {
  pending,
  processing,
  completed,
  failed,
}

/// Analysis model
class AnalysisModel extends Equatable {
  final String id;
  final String documentId;
  final String userId;
  final AnalysisStatus status;
  final String? summary;
  final List<KeyClauseModel> keyClauses;
  final List<DeadlineModel> deadlines;
  final List<FinancialObligationModel> financialObligations;
  final List<RedFlagModel> redFlags;
  final List<ChecklistItemModel> checklistItems;
  final DateTime createdAt;
  final DateTime? completedAt;
  final String? errorMessage;
  final int progress; // 0-100

  const AnalysisModel({
    required this.id,
    required this.documentId,
    required this.userId,
    required this.status,
    this.summary,
    required this.keyClauses,
    required this.deadlines,
    required this.financialObligations,
    required this.redFlags,
    required this.checklistItems,
    required this.createdAt,
    this.completedAt,
    this.errorMessage,
    required this.progress,
  });

  factory AnalysisModel.fromJson(Map<String, dynamic> json) {
    return AnalysisModel(
      id: json['id'] as String,
      documentId: json['documentId'] as String,
      userId: json['userId'] as String,
      status: AnalysisStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => AnalysisStatus.pending,
      ),
      summary: json['summary'] as String?,
      keyClauses: (json['keyClauses'] as List<dynamic>? ?? [])
          .map((e) => KeyClauseModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      deadlines: (json['deadlines'] as List<dynamic>? ?? [])
          .map((e) => DeadlineModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      financialObligations: (json['financialObligations'] as List<dynamic>? ?? [])
          .map((e) => FinancialObligationModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      redFlags: (json['redFlags'] as List<dynamic>? ?? [])
          .map((e) => RedFlagModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      checklistItems: (json['checklistItems'] as List<dynamic>? ?? [])
          .map((e) => ChecklistItemModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      errorMessage: json['errorMessage'] as String?,
      progress: json['progress'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'documentId': documentId,
      'userId': userId,
      'status': status.name,
      'summary': summary,
      'keyClauses': keyClauses.map((e) => e.toJson()).toList(),
      'deadlines': deadlines.map((e) => e.toJson()).toList(),
      'financialObligations': financialObligations.map((e) => e.toJson()).toList(),
      'redFlags': redFlags.map((e) => e.toJson()).toList(),
      'checklistItems': checklistItems.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'completedAt': completedAt?.toIso8601String(),
      'errorMessage': errorMessage,
      'progress': progress,
    };
  }

  AnalysisModel copyWith({
    String? id,
    String? documentId,
    String? userId,
    AnalysisStatus? status,
    String? summary,
    List<KeyClauseModel>? keyClauses,
    List<DeadlineModel>? deadlines,
    List<FinancialObligationModel>? financialObligations,
    List<RedFlagModel>? redFlags,
    List<ChecklistItemModel>? checklistItems,
    DateTime? createdAt,
    DateTime? completedAt,
    String? errorMessage,
    int? progress,
  }) {
    return AnalysisModel(
      id: id ?? this.id,
      documentId: documentId ?? this.documentId,
      userId: userId ?? this.userId,
      status: status ?? this.status,
      summary: summary ?? this.summary,
      keyClauses: keyClauses ?? this.keyClauses,
      deadlines: deadlines ?? this.deadlines,
      financialObligations: financialObligations ?? this.financialObligations,
      redFlags: redFlags ?? this.redFlags,
      checklistItems: checklistItems ?? this.checklistItems,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      errorMessage: errorMessage ?? this.errorMessage,
      progress: progress ?? this.progress,
    );
  }

  @override
  List<Object?> get props => [
        id,
        documentId,
        userId,
        status,
        summary,
        keyClauses,
        deadlines,
        financialObligations,
        redFlags,
        checklistItems,
        createdAt,
        completedAt,
        errorMessage,
        progress,
      ];
}

/// Key clause model
class KeyClauseModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final String clauseText;
  final int pageNumber;
  final ClauseType type;
  final ClauseImportance importance;

  const KeyClauseModel({
    required this.id,
    required this.title,
    required this.description,
    required this.clauseText,
    required this.pageNumber,
    required this.type,
    required this.importance,
  });

  factory KeyClauseModel.fromJson(Map<String, dynamic> json) {
    return KeyClauseModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      clauseText: json['clauseText'] as String,
      pageNumber: json['pageNumber'] as int,
      type: ClauseType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => ClauseType.other,
      ),
      importance: ClauseImportance.values.firstWhere(
        (e) => e.name == json['importance'],
        orElse: () => ClauseImportance.medium,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'clauseText': clauseText,
      'pageNumber': pageNumber,
      'type': type.name,
      'importance': importance.name,
    };
  }

  @override
  List<Object?> get props => [id, title, description, clauseText, pageNumber, type, importance];
}

/// Clause type
enum ClauseType {
  termination,
  payment,
  liability,
  confidentiality,
  intellectualProperty,
  disputeResolution,
  governingLaw,
  other,
}

/// Clause importance
enum ClauseImportance {
  critical,
  high,
  medium,
  low,
}

/// Deadline model
class DeadlineModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final DateTime dueDate;
  final DeadlineType type;
  final bool isCompleted;
  final int? pageNumber;

  const DeadlineModel({
    required this.id,
    required this.title,
    required this.description,
    required this.dueDate,
    required this.type,
    required this.isCompleted,
    this.pageNumber,
  });

  factory DeadlineModel.fromJson(Map<String, dynamic> json) {
    return DeadlineModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      dueDate: DateTime.parse(json['dueDate'] as String),
      type: DeadlineType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => DeadlineType.other,
      ),
      isCompleted: json['isCompleted'] as bool? ?? false,
      pageNumber: json['pageNumber'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'dueDate': dueDate.toIso8601String(),
      'type': type.name,
      'isCompleted': isCompleted,
      'pageNumber': pageNumber,
    };
  }

  @override
  List<Object?> get props => [id, title, description, dueDate, type, isCompleted, pageNumber];
}

/// Deadline type
enum DeadlineType {
  rentDue,
  noticePeriod,
  renewal,
  termination,
  payment,
  inspection,
  other,
}

/// Financial obligation model
class FinancialObligationModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final double amount;
  final String currency;
  final FinancialObligationType type;
  final DateTime? dueDate;
  final bool isRecurring;
  final String? frequency; // monthly, quarterly, yearly
  final int? pageNumber;

  const FinancialObligationModel({
    required this.id,
    required this.title,
    required this.description,
    required this.amount,
    required this.currency,
    required this.type,
    this.dueDate,
    required this.isRecurring,
    this.frequency,
    this.pageNumber,
  });

  factory FinancialObligationModel.fromJson(Map<String, dynamic> json) {
    return FinancialObligationModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      amount: (json['amount'] as num).toDouble(),
      currency: json['currency'] as String? ?? 'USD',
      type: FinancialObligationType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => FinancialObligationType.other,
      ),
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
      isRecurring: json['isRecurring'] as bool? ?? false,
      frequency: json['frequency'] as String?,
      pageNumber: json['pageNumber'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'amount': amount,
      'currency': currency,
      'type': type.name,
      'dueDate': dueDate?.toIso8601String(),
      'isRecurring': isRecurring,
      'frequency': frequency,
      'pageNumber': pageNumber,
    };
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        amount,
        currency,
        type,
        dueDate,
        isRecurring,
        frequency,
        pageNumber,
      ];
}

/// Financial obligation type
enum FinancialObligationType {
  rent,
  deposit,
  utility,
  maintenance,
  penalty,
  fee,
  other,
}

/// Red flag model
class RedFlagModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final RedFlagSeverity severity;
  final String recommendation;
  final int? pageNumber;

  const RedFlagModel({
    required this.id,
    required this.title,
    required this.description,
    required this.severity,
    required this.recommendation,
    this.pageNumber,
  });

  factory RedFlagModel.fromJson(Map<String, dynamic> json) {
    return RedFlagModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      severity: RedFlagSeverity.values.firstWhere(
        (e) => e.name == json['severity'],
        orElse: () => RedFlagSeverity.medium,
      ),
      recommendation: json['recommendation'] as String,
      pageNumber: json['pageNumber'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'severity': severity.name,
      'recommendation': recommendation,
      'pageNumber': pageNumber,
    };
  }

  @override
  List<Object?> get props => [id, title, description, severity, recommendation, pageNumber];
}

/// Red flag severity
enum RedFlagSeverity {
  critical,
  high,
  medium,
  low,
}

/// Checklist item model
class ChecklistItemModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final ChecklistCategory category;
  final int? priority; // 1-5
  final DateTime? dueDate;

  const ChecklistItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.category,
    this.priority,
    this.dueDate,
  });

  factory ChecklistItemModel.fromJson(Map<String, dynamic> json) {
    return ChecklistItemModel(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      isCompleted: json['isCompleted'] as bool? ?? false,
      category: ChecklistCategory.values.firstWhere(
        (e) => e.name == json['category'],
        orElse: () => ChecklistCategory.other,
      ),
      priority: json['priority'] as int?,
      dueDate: json['dueDate'] != null
          ? DateTime.parse(json['dueDate'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'isCompleted': isCompleted,
      'category': category.name,
      'priority': priority,
      'dueDate': dueDate?.toIso8601String(),
    };
  }

  ChecklistItemModel copyWith({
    String? id,
    String? title,
    String? description,
    bool? isCompleted,
    ChecklistCategory? category,
    int? priority,
    DateTime? dueDate,
  }) {
    return ChecklistItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
    );
  }

  @override
  List<Object?> get props => [id, title, description, isCompleted, category, priority, dueDate];
}

/// Checklist category
enum ChecklistCategory {
  beforeSigning,
  afterSigning,
  ongoing,
  legal,
  financial,
  other,
}