import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:wara2tak/core/errors/failures.dart';
import 'package:wara2tak/features/checklist/domain/models/checklist_model.dart';
import 'package:wara2tak/features/checklist/domain/repositories/checklist_repository.dart';
import 'package:wara2tak/features/checklist/presentation/cubit/checklist_cubit.dart';
import 'package:wara2tak/features/checklist/presentation/cubit/checklist_state.dart';

// Mock classes
class MockChecklistRepository extends Mock implements ChecklistRepository {}

// Fake classes for fallback values
class FakeChecklistItemModel extends Fake implements ChecklistItemModel {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeChecklistItemModel());
  });

  group('ChecklistCubit', () {
    late MockChecklistRepository mockRepository;
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
      mockRepository = MockChecklistRepository();
      cubit = ChecklistCubit(mockRepository);
    });

    tearDown(() {
      cubit.close();
    });

    group('loadChecklist', () {
      blocTest<ChecklistCubit, ChecklistState>(
        'emits ChecklistLoading then ChecklistLoaded on success',
        build: () {
          when(() => mockRepository.getChecklist(testDocumentId))
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
          when(() => mockRepository.getChecklist(testDocumentId))
              .thenAnswer((_) async => const Left(ServerFailure('Failed to load')));
          return cubit;
        },
        act: (cubit) => cubit.loadChecklist(testDocumentId),
        expect: () => [
          isA<ChecklistLoading>(),
          isA<ChecklistError>(),
        ],
      );
    });

    group('toggleItem (optimistic update)', () {
      blocTest<ChecklistCubit, ChecklistState>(
        'emits ChecklistLoaded immediately with toggled item (optimistic), '
        'then emits ChecklistLoaded with synced item on success',
        build: () {
          when(() => mockRepository.getChecklist(testDocumentId))
              .thenAnswer((_) async => Right([testItem]));
          when(() => mockRepository.updateChecklistItem(
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
          verify(() => mockRepository.updateChecklistItem(
            testDocumentId,
            any(that: isA<ChecklistItemModel>()),
          )).called(1);
        },
      );

      blocTest<ChecklistCubit, ChecklistState>(
        'rolls back on failure and emits ChecklistLoaded with errorMessage',
        build: () {
          when(() => mockRepository.getChecklist(testDocumentId))
              .thenAnswer((_) async => Right([testItem]));
          when(() => mockRepository.updateChecklistItem(
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
          verify(() => mockRepository.updateChecklistItem(
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
          when(() => mockRepository.getChecklist(testDocumentId))
              .thenAnswer((_) async => Right([testItem]));
          when(() => mockRepository.addChecklistItem(
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
          when(() => mockRepository.getChecklist(testDocumentId))
              .thenAnswer((_) async => Right([testItem]));
          when(() => mockRepository.addChecklistItem(
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
          when(() => mockRepository.getChecklist(testDocumentId))
              .thenAnswer((_) async => Right([testItem]));
          when(() => mockRepository.deleteChecklistItem(testDocumentId, testItem.id))
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
          verify(() => mockRepository.deleteChecklistItem(testDocumentId, testItem.id))
              .called(1);
        },
      );

      blocTest<ChecklistCubit, ChecklistState>(
        'rolls back on failure and emits ChecklistLoaded with errorMessage',
        build: () {
          when(() => mockRepository.getChecklist(testDocumentId))
              .thenAnswer((_) async => Right([testItem]));
          when(() => mockRepository.deleteChecklistItem(testDocumentId, testItem.id))
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
          when(() => mockRepository.getChecklist(testDocumentId))
              .thenAnswer((_) async => Right([testItem]));
          when(() => mockRepository.updateChecklistItem(
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
          when(() => mockRepository.getChecklist(testDocumentId))
              .thenAnswer((_) async => Right([testItem]));
          when(() => mockRepository.saveChecklist(
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