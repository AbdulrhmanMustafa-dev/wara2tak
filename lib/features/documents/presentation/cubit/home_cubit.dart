import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/models/document_model.dart';
import '../../domain/repositories/document_repository.dart';

/// Home state for dashboard
abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {
  const HomeInitial();
}

class HomeLoading extends HomeState {
  const HomeLoading();
}

class HomeLoaded extends HomeState {
  final List<DocumentModel> recentDocuments;
  final List<DocumentModel> analyzingDocuments;
  final int totalDocuments;
  final int analyzedCount;

  const HomeLoaded({
    required this.recentDocuments,
    required this.analyzingDocuments,
    required this.totalDocuments,
    required this.analyzedCount,
  });

  @override
  List<Object?> get props => [
        recentDocuments,
        analyzingDocuments,
        totalDocuments,
        analyzedCount,
      ];
}

class HomeError extends HomeState {
  final String message;
  final String? code;

  const HomeError(this.message, {this.code});

  @override
  List<Object?> get props => [message, code];
}

/// HomeCubit for dashboard
class HomeCubit extends Cubit<HomeState> {
  final DocumentRepository _documentRepository;

  HomeCubit(this._documentRepository) : super(const HomeInitial());

  /// Load home dashboard data (no real-time subscription - uses Pull-to-Refresh)
  Future<void> loadDashboard(String userId) async {
    emit(const HomeLoading());

    final result = await _documentRepository.getUserDocuments(userId);

    result.fold(
      (failure) => emit(HomeError(failure.message, code: failure.code)),
      (documents) => _emitLoaded(documents),
    );
  }

  void _emitLoaded(List<DocumentModel> documents) {
    // Sort by createdAt descending for recent documents
    final sortedDocs = List<DocumentModel>.from(documents)
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

    // Recent documents: show ALL documents regardless of status, take 5
    final recentDocuments = sortedDocs.take(5).toList();
    final analyzingDocuments = documents
        .where((d) => d.status == DocumentStatus.analyzing)
        .toList();
    final totalDocuments = documents.length;
    final analyzedCount = documents
        .where((d) => d.status == DocumentStatus.analyzed)
        .length;

    emit(HomeLoaded(
      recentDocuments: recentDocuments,
      analyzingDocuments: analyzingDocuments,
      totalDocuments: totalDocuments,
      analyzedCount: analyzedCount,
    ));
  }
}

