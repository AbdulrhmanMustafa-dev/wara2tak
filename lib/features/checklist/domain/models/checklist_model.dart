import 'package:equatable/equatable.dart';

/// Checklist item model
class ChecklistItemModel extends Equatable {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;
  final ChecklistCategory category;
  final int? priority; // 1-5
  final DateTime? dueDate;
  final DateTime? completedAt;
  final int? pageNumber;
  final String? relatedClauseId;

  const ChecklistItemModel({
    required this.id,
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.category,
    this.priority,
    this.dueDate,
    this.completedAt,
    this.pageNumber,
    this.relatedClauseId,
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
      completedAt: json['completedAt'] != null
          ? DateTime.parse(json['completedAt'] as String)
          : null,
      pageNumber: json['pageNumber'] as int?,
      relatedClauseId: json['relatedClauseId'] as String?,
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
      'completedAt': completedAt?.toIso8601String(),
      'pageNumber': pageNumber,
      'relatedClauseId': relatedClauseId,
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
    DateTime? completedAt,
    int? pageNumber,
    String? relatedClauseId,
  }) {
    return ChecklistItemModel(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      dueDate: dueDate ?? this.dueDate,
      completedAt: completedAt ?? this.completedAt,
      pageNumber: pageNumber ?? this.pageNumber,
      relatedClauseId: relatedClauseId ?? this.relatedClauseId,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        description,
        isCompleted,
        category,
        priority,
        dueDate,
        completedAt,
        pageNumber,
        relatedClauseId,
      ];
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