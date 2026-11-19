import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:wara2tak/core/errors/failures.dart';
import 'package:wara2tak/features/checklist/domain/models/checklist_model.dart';
import 'package:wara2tak/features/checklist/domain/repositories/checklist_repository.dart';
import 'package:wara2tak/features/checklist/presentation/cubit/checklist_cubit.dart';
import 'package:wara2tak/features/checklist/presentation/cubit/checklist_state.dart';
import 'package:wara2tak/features/documents/domain/models/analysis_model.dart' as doc_models;
import 'package:wara2tak/features/documents/domain/repositories/document_repository.dart';

// Mock classes
class MockChecklistRepository extends Mock implements ChecklistRepository {}
class MockDocumentRepository extends Mock implements DocumentRepository {}

// Fake classes for fallback values
class FakeChecklistItemModel extends Fake implements ChecklistItemModel {}
class FakeAnalysisModel extends Fake implements doc_models.AnalysisModel {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeChecklistItemModel());
    registerFallbackValue(FakeAnalysisModel());
  });

  group('ChecklistCubit', () {
    late MockChecklistRepository mockChecklistRepository;
    late MockDocumentRepository mockDocumentRepository;
    late ChecklistCubit cubit;

    const testDocumentId = 'doc-123';
    final testItem = ChecklistItemModel(
      id: 'item-1',
      title: 'Test Item',
      description: 'Test Description',
      isCompleted: false,
      category: ChecklistCategory.other,
      priority: 1,
    );

    final testItemCompleted = testItem.copyWith(
      isCompleted: true,
      completedAt: DateTime(2024, 1, 2),
    );

    setUp(() {
      mockChecklistRepository = MockChecklistRepository();
      mockDocumentRepository = MockDocumentRepository();
      cubit = ChecklistCubit(mockChecklistRepository, mockDocumentRepository);
    });

    tearDown(() {
      cubit.close();
    });

    group('loadChecklist', () {
      blocTest<ChecklistCubit, ChecklistState>(
        'emits ChecklistLoading then ChecklistLoaded on success',
        build: () {
          when(() => mockChecklistRepository.getChecklist(testDocumentId))
              .thenAnswer((_) async => Right([testItem]));
          return cubit;
        },
        act: (cubit) => cubit.loadChecklist(testDocumentId),
        expect: () => [
          isA<ChecklistLoading>(),
          isA<ChecklistLoaded>(),
        ],
      );

      blocTest<ChecklistCubit, ChecklistState>(
        'emits ChecklistLoading then ChecklistError on failure',
        build: () {
          when(() => mockChecklistRepository.getChecklist(testDocumentId))
              .thenAnswer((_) async => const Left(ServerFailure('Failed to load')));
          return cubit;
        },
        act: (cubit) => cubit.loadChecklist(testDocumentId),
        expect: () => [
          isA<ChecklistLoading>(),
          isA<ChecklistError>(),
        ],
      );

      blocTest<ChecklistCubit, ChecklistState>(
        'auto-populates from analysis when checklist is empty (idempotent)',
        build: () {
          // Empty checklist from Supabase
          when(() => mockChecklistRepository.getChecklist(testDocumentId))
              .thenAnswer((_) async => Right(<ChecklistItemModel>[]));

          // Analysis with checklist items (from analysis_model.dart)
          final analysisItem = doc_models.ChecklistItemModel(
            id: 'analysis-item-1',
            title: 'Review summary',
            description: 'Review the document summary',
            isCompleted: false,
            category: doc_models.ChecklistCategory.beforeSigning,
            priority: 1,
            dueDate: null,
          );
          final analysis = doc_models.AnalysisModel(
            id: 'analysis-1',
            documentId: testDocumentId,
            userId: 'user-1',
            status: doc_models.AnalysisStatus.completed,
            summary: 'Test summary',
            keyClauses: [],
            deadlines: [],
            financialObligations: [],
            redFlags: [],
            checklistItems: [analysisItem],
            createdAt: DateTime.now(),
            progress: 100,
          );
          when(() => mockDocumentRepository.getAnalysis(testDocumentId))
              .thenAnswer((_) async => Right(analysis));

          // Save checklist returns the converted items
          when(() => mockChecklistRepository.saveChecklist(
            testDocumentId,
            any(that: isA<List<ChecklistItemModel>>()),
          )).thenAnswer((invocation) async {
            final items = invocation.positionalArguments[1] as List<ChecklistItemModel>;
            return Right(items);
          });

          return cubit;
        },
        act: (cubit) => cubit.loadChecklist(testDocumentId),
        expect: () => [
          isA<ChecklistLoading>(),
          // First ChecklistLoaded with empty list
          isA<ChecklistLoaded>(),
          // Second ChecklistLoaded with auto-generated items
          isA<ChecklistLoaded>(),
        ],
        verify: (_) {
          verify(() => mockChecklistRepository.getChecklist(testDocumentId)).called(1);
          verify(() => mockDocumentRepository.getAnalysis(testDocumentId)).called(1);
          verify(() => mockChecklistRepository.saveChecklist(
            testDocumentId,
            any(that: isA<List<ChecklistItemModel>>()),
          )).called(1);
        },
      );

      blocTest<ChecklistCubit, ChecklistState>(
        'auto-generates valid UUID v4 for items with non-UUID IDs from analysis',
        build: () {
          // Empty checklist from Supabase
          when(() => mockChecklistRepository.getChecklist(testDocumentId))
              .thenAnswer((_) async => Right(<ChecklistItemModel>[]));

          // Analysis with checklist items that have NON-UUID IDs (like "check_1", "check_2")
          // This simulates the real AI response that causes PostgrestException
          final analysisItem1 = doc_models.ChecklistItemModel(
            id: 'check_1', // Non-UUID ID from AI
            title: 'Review summary',
            description: 'Review the document summary',
            isCompleted: false,
            category: doc_models.ChecklistCategory.beforeSigning,
            priority: 1,
            dueDate: null,
          );
          final analysisItem2 = doc_models.ChecklistItemModel(
            id: 'check_2', // Another non-UUID ID
            title: 'Sign document',
            description: 'Sign the contract',
            isCompleted: false,
            category: doc_models.ChecklistCategory.afterSigning,
            priority: 2,
            dueDate: null,
          );
          final analysis = doc_models.AnalysisModel(
            id: 'analysis-1',
            documentId: testDocumentId,
            userId: 'user-1',
            status: doc_models.AnalysisStatus.completed,
            summary: 'Test summary',
            keyClauses: [],
            deadlines: [],
            financialObligations: [],
            redFlags: [],
            checklistItems: [analysisItem1, analysisItem2],
            createdAt: DateTime.now(),
            progress: 100,
          );
          when(() => mockDocumentRepository.getAnalysis(testDocumentId))
              .thenAnswer((_) async => Right(analysis));

          // Capture the items passed to saveChecklist and verify they have valid UUIDs
          when(() => mockChecklistRepository.saveChecklist(
            testDocumentId,
            any(that: isA<List<ChecklistItemModel>>()),
          )).thenAnswer((invocation) async {
            final items = invocation.positionalArguments[1] as List<ChecklistItemModel>;
            // Verify all items have valid UUID v4 format
            final uuidRegex = RegExp(
              r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$',
              caseSensitive: false,
            );
            for (final item in items) {
              expect(uuidRegex.hasMatch(item.id), isTrue,
                  reason: 'Item ID "${item.id}" must be a valid UUID v4, not "check_1"');
            }
            return Right(items);
          });

          return cubit;
        },
        act: (cubit) => cubit.loadChecklist(testDocumentId),
        expect: () => [
          isA<ChecklistLoading>(),
          // First ChecklistLoaded with empty list
          isA<ChecklistLoaded>(),
          // Second ChecklistLoaded with auto-generated items (valid UUIDs)
          isA<ChecklistLoaded>(),
        ],
        verify: (_) {
          verify(() => mockChecklistRepository.getChecklist(testDocumentId)).called(1);
          verify(() => mockDocumentRepository.getAnalysis(testDocumentId)).called(1);
          verify(() => mockChecklistRepository.saveChecklist(
            testDocumentId,
            any(that: isA<List<ChecklistItemModel>>()),
          )).called(1);
        },
      );

      blocTest<ChecklistCubit, ChecklistState>(
        'does not re-generate on subsequent loads (idempotent)',
        build: () {
          // Empty checklist from Supabase
          when(() => mockChecklistRepository.getChecklist(testDocumentId))
              .thenAnswer((_) async => Right(<ChecklistItemModel>[]));

          // Analysis with checklist items
          final analysisItem = doc_models.ChecklistItemModel(
            id: 'analysis-item-1',
            title: 'Review summary',
            description: 'Review the document summary',
            isCompleted: false,
            category: doc_models.ChecklistCategory.beforeSigning,
            priority: 1,
            dueDate: null,
          );
          final analysis = doc_models.AnalysisModel(
            id: 'analysis-1',
            documentId: testDocumentId,
            userId: 'user-1',
            status: doc_models.AnalysisStatus.completed,
            summary: 'Test summary',
            keyClauses: [],
            deadlines: [],
            financialObligations: [],
            redFlags: [],
            checklistItems: [analysisItem],
            createdAt: DateTime.now(),
            progress: 100,
          );
          when(() => mockDocumentRepository.getAnalysis(testDocumentId))
              .thenAnswer((_) async => Right(analysis));

          when(() => mockChecklistRepository.saveChecklist(
            testDocumentId,
            any(that: isA<List<ChecklistItemModel>>()),
          )).thenAnswer((invocation) async {
            final items = invocation.positionalArguments[1] as List<ChecklistItemModel>;
            return Right(items);
          });

          return cubit;
        },
        act: (cubit) async {
          // First load - should auto-generate
          await cubit.loadChecklist(testDocumentId);
          // Second load - should NOT re-generate (idempotent)
          await cubit.loadChecklist(testDocumentId);
        },
        expect: () => [
          isA<ChecklistLoading>(),
          isA<ChecklistLoaded>(), // empty
          isA<ChecklistLoaded>(), // populated
          // Second load
          isA<ChecklistLoading>(),
          isA<ChecklistLoaded>(), // already populated, no re-generation
        ],
        verify: (_) {
          // getChecklist called twice (once per load)
          verify(() => mockChecklistRepository.getChecklist(testDocumentId)).called(2);
          // getAnalysis called only ONCE (first load)
          verify(() => mockDocumentRepository.getAnalysis(testDocumentId)).called(1);
          // saveChecklist called only ONCE (first load)
          verify(() => mockChecklistRepository.saveChecklist(
            testDocumentId,
            any(that: isA<List<ChecklistItemModel>>()),
          )).called(1);
        },
      );
    });

    group('toggleItem (optimistic update)', () {
      blocTest<ChecklistCubit, ChecklistState>(
        'emits ChecklistLoaded immediately with toggled item (optimistic), '
        'then emits ChecklistLoaded with synced item on success',
        build: () {
          when(() => mockChecklistRepository.getChecklist(testDocumentId))
              .thenAnswer((_) async => Right([testItem]));
          when(() => mockChecklistRepository.updateChecklistItem(
            testDocumentId,
            any(that: isA<ChecklistItemModel>()),
          )).thenAnswer((_) async => Right(testItemCompleted));
          return cubit;
        },
        act: (cubit) async {
          await cubit.loadChecklist(testDocumentId);
          await cubit.toggleItem(testItem);
        },
        expect: () => [
          isA<ChecklistLoading>(),
          isA<ChecklistLoaded>(),
          isA<ChecklistLoaded>(),
          isA<ChecklistLoaded>(),
        ],
        verify: (_) {
          verify(() => mockChecklistRepository.updateChecklistItem(
            testDocumentId,
            any(that: isA<ChecklistItemModel>()),
          )).called(1);
        },
      );

      blocTest<ChecklistCubit, ChecklistState>(
        'rolls back on failure and emits ChecklistLoaded with errorMessage',
        build: () {
          when(() => mockChecklistRepository.getChecklist(testDocumentId))
              .thenAnswer((_) async => Right([testItem]));
          when(() => mockChecklistRepository.updateChecklistItem(
            testDocumentId,
            any(that: isA<ChecklistItemModel>()),
          )).thenAnswer((_) async => const Left(ServerFailure('Network error')));
          return cubit;
        },
        act: (cubit) async {
          await cubit.loadChecklist(testDocumentId);
          await cubit.toggleItem(testItem);
        },
        expect: () => [
          isA<ChecklistLoading>(),
          isA<ChecklistLoaded>(),
          isA<ChecklistLoaded>(),
          // Rollback - ChecklistLoaded with original item and errorMessage
          isA<ChecklistLoaded>(),
        ],
        verify: (_) {
          verify(() => mockChecklistRepository.updateChecklistItem(
            testDocumentId,
            any(that: isA<ChecklistItemModel>()),
          )).called(1);
        },
      );

      blocTest<ChecklistCubit, ChecklistState>(
        'emits error when no document loaded',
        build: () => cubit,
        act: (cubit) => cubit.toggleItem(testItem),
        expect: () => [
          isA<ChecklistError>(),
        ],
      );
    });

    group('addItem (optimistic update)', () {
      final newItem = ChecklistItemModel(
        id: 'item-2',
        title: 'New Item',
        description: 'New Description',
        isCompleted: false,
        category: ChecklistCategory.other,
        priority: 2,
      );

      blocTest<ChecklistCubit, ChecklistState>(
        'emits ChecklistLoaded immediately with new item (optimistic), '
        'server sync does not emit new state if data identical',
        build: () {
          when(() => mockChecklistRepository.getChecklist(testDocumentId))
              .thenAnswer((_) async => Right([testItem]));
          when(() => mockChecklistRepository.addChecklistItem(
            testDocumentId,
            any(that: isA<ChecklistItemModel>()),
          )).thenAnswer((_) async => Right(newItem));
          return cubit;
        },
        act: (cubit) async {
          await cubit.loadChecklist(testDocumentId);
          await cubit.addItem(newItem);
        },
        expect: () => [
          isA<ChecklistLoading>(),
          isA<ChecklistLoaded>(),
          // Optimistic update
          isA<ChecklistLoaded>(),
          // Server sync does NOT emit new state (identical data)
        ],
      );

      blocTest<ChecklistCubit, ChecklistState>(
        'rolls back on failure and emits ChecklistLoaded with errorMessage',
        build: () {
          when(() => mockChecklistRepository.getChecklist(testDocumentId))
              .thenAnswer((_) async => Right([testItem]));
          when(() => mockChecklistRepository.addChecklistItem(
            testDocumentId,
            any(that: isA<ChecklistItemModel>()),
          )).thenAnswer((_) async => const Left(ServerFailure('Network error')));
          return cubit;
        },
        act: (cubit) async {
          await cubit.loadChecklist(testDocumentId);
          await cubit.addItem(newItem);
        },
        expect: () => [
          isA<ChecklistLoading>(),
          isA<ChecklistLoaded>(),
          // Optimistic update
          isA<ChecklistLoaded>(),
          // Rollback with errorMessage
          isA<ChecklistLoaded>(),
        ],
      );
    });

    group('deleteItem (optimistic update)', () {
      blocTest<ChecklistCubit, ChecklistState>(
        'emits ChecklistLoaded immediately without deleted item (optimistic), '
        'then confirms deletion on success',
        build: () {
          when(() => mockChecklistRepository.getChecklist(testDocumentId))
              .thenAnswer((_) async => Right([testItem]));
          when(() => mockChecklistRepository.deleteChecklistItem(testDocumentId, testItem.id))
              .thenAnswer((_) async => const Right(null));
          return cubit;
        },
        act: (cubit) async {
          await cubit.loadChecklist(testDocumentId);
          await cubit.deleteItem(testItem.id);
        },
        expect: () => [
          isA<ChecklistLoading>(),
          isA<ChecklistLoaded>(),
          // Optimistic update - item removed
          isA<ChecklistLoaded>(),
          // Server sync success - no additional emission (already correct)
        ],
        verify: (_) {
          verify(() => mockChecklistRepository.deleteChecklistItem(testDocumentId, testItem.id))
              .called(1);
        },
      );

      blocTest<ChecklistCubit, ChecklistState>(
        'rolls back on failure and emits ChecklistLoaded with errorMessage',
        build: () {
          when(() => mockChecklistRepository.getChecklist(testDocumentId))
              .thenAnswer((_) async => Right([testItem]));
          when(() => mockChecklistRepository.deleteChecklistItem(testDocumentId, testItem.id))
              .thenAnswer((_) async => const Left(ServerFailure('Network error')));
          return cubit;
        },
        act: (cubit) async {
          await cubit.loadChecklist(testDocumentId);
          await cubit.deleteItem(testItem.id);
        },
        expect: () => [
          isA<ChecklistLoading>(),
          isA<ChecklistLoaded>(),
          // Optimistic update - item removed
          isA<ChecklistLoaded>(),
          // Rollback - item restored with errorMessage
          isA<ChecklistLoaded>(),
        ],
      );
    });

    group('updateItem (optimistic update)', () {
      final updatedItem = testItem.copyWith(title: 'Updated Title');

      blocTest<ChecklistCubit, ChecklistState>(
        'emits ChecklistLoaded immediately with updated item (optimistic), '
        'server sync does not emit new state if data identical',
        build: () {
          when(() => mockChecklistRepository.getChecklist(testDocumentId))
              .thenAnswer((_) async => Right([testItem]));
          when(() => mockChecklistRepository.updateChecklistItem(
            testDocumentId,
            any(that: isA<ChecklistItemModel>()),
          )).thenAnswer((_) async => Right(updatedItem));
          return cubit;
        },
        act: (cubit) async {
          await cubit.loadChecklist(testDocumentId);
          await cubit.updateItem(updatedItem);
        },
        expect: () => [
          isA<ChecklistLoading>(),
          isA<ChecklistLoaded>(),
          // Optimistic update
          isA<ChecklistLoaded>(),
          // Server sync does NOT emit new state (identical data)
        ],
      );
    });

    group('saveChecklist (optimistic update)', () {
      final newItems = <ChecklistItemModel>[
        testItem,
        testItem.copyWith(id: 'item-2', title: 'Second Item'),
      ];

      blocTest<ChecklistCubit, ChecklistState>(
        'emits ChecklistLoaded immediately with new list (optimistic), '
        'server sync does not emit new state if data identical',
        build: () {
          when(() => mockChecklistRepository.getChecklist(testDocumentId))
              .thenAnswer((_) async => Right([testItem]));
          when(() => mockChecklistRepository.saveChecklist(
            testDocumentId,
            any(that: isA<List<ChecklistItemModel>>()),
          )).thenAnswer((_) async => Right(newItems));
          return cubit;
        },
        act: (cubit) async {
          await cubit.loadChecklist(testDocumentId);
          await cubit.saveChecklist(testDocumentId, newItems);
        },
        expect: () => [
          isA<ChecklistLoading>(),
          isA<ChecklistLoaded>(),
          // Optimistic update
          isA<ChecklistLoaded>(),
          // Server sync does NOT emit new state (identical data)
        ],
      );
    });
  });
}