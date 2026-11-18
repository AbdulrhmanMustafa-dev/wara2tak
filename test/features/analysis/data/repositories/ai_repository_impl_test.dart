import 'package:flutter_test/flutter_test.dart';

import 'package:wara2tak/core/errors/failures.dart';
import 'package:wara2tak/features/analysis/data/repositories/ai_repository_impl.dart';
import 'package:wara2tak/features/documents/domain/models/analysis_model.dart';
import 'package:wara2tak/features/documents/domain/models/document_model.dart';

void main() {
  group('AIRepositoryImpl', () {
    // Test data
    final testDocument = DocumentModel(
      id: 'doc-123',
      userId: 'user-123',
      title: 'Test Document',
      originalFileName: 'test.pdf',
      fileUrl: 'storage/path/test.pdf',
      type: DocumentType.other,
      status: DocumentStatus.uploaded,
      pageCount: 5,
      fileSize: 1024,
      mimeType: 'application/pdf',
      createdAt: DateTime(2024, 1, 1),
    );

    const testUserId = 'user-123';

    group('analyzeDocument', () {
      test('returns ServerFailure when file cannot be read', () async {
        final repository = AIRepositoryImpl(geminiApiKey: 'test-key');

        // Test with non-existent file
        final result = await repository.analyzeDocument(
          document: testDocument,
          localFilePath: '/non/existent/path.pdf',
          userId: testUserId,
          onProgress: (_, _) {},
        );

        expect(result.isLeft(), isTrue);
        result.fold(
          (failure) => expect(failure, isA<ServerFailure>()),
          (_) => fail('Expected failure'),
        );
      });

      test('generateChecklist returns checklist items from analysis', () async {
        final repository = AIRepositoryImpl(geminiApiKey: 'test-key');

        final analysis = AnalysisModel(
          id: 'analysis-1',
          documentId: 'doc-1',
          userId: 'user-1',
          status: AnalysisStatus.completed,
          summary: 'Test',
          keyClauses: [],
          deadlines: [],
          financialObligations: [],
          redFlags: [],
          checklistItems: [
            ChecklistItemModel(
              id: 'item-1',
              title: 'Test Item',
              description: 'Description',
              isCompleted: false,
              category: ChecklistCategory.beforeSigning,
              priority: 1,
              dueDate: DateTime(2024, 12, 31),
            ),
          ],
          createdAt: DateTime.now(),
          completedAt: DateTime.now(),
          progress: 100,
        );

        final result = await repository.generateChecklist(analysis: analysis);

        expect(result.isRight(), isTrue);
        result.fold(
          (_) => fail('Expected success'),
          (items) {
            expect(items.length, equals(1));
            expect(items.first.title, equals('Test Item'));
          },
        );
      });
    });
  });
}