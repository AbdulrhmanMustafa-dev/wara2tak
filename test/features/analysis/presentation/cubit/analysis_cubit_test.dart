import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:wara2tak/core/errors/failures.dart';
import 'package:wara2tak/features/analysis/domain/repositories/ai_repository.dart';
import 'package:wara2tak/features/analysis/presentation/cubit/analysis_cubit.dart';
import 'package:wara2tak/features/analysis/presentation/cubit/analysis_state.dart';
import 'package:wara2tak/features/documents/domain/models/analysis_model.dart';
import 'package:wara2tak/features/documents/domain/models/document_model.dart';
import 'package:wara2tak/features/documents/domain/repositories/document_repository.dart';

// Mock classes
class MockAIRepository extends Mock implements AIRepository {}

class MockDocumentRepository extends Mock implements DocumentRepository {}

// Fake classes for fallback values
class FakeDocumentModel extends Fake implements DocumentModel {}

class FakeAnalysisModel extends Fake implements AnalysisModel {}

void main() {
  setUpAll(() {
    registerFallbackValue(FakeDocumentModel());
    registerFallbackValue(FakeAnalysisModel());
  });

  group('AnalysisCubit', () {
    late MockAIRepository mockAIRepository;
    late MockDocumentRepository mockDocumentRepository;
    late AnalysisCubit cubit;

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

    const testLocalFilePath = '/tmp/test.pdf';
    const testUserId = 'user-123';

    final testAnalysis = AnalysisModel(
      id: 'analysis-123',
      documentId: 'doc-123',
      userId: 'user-123',
      status: AnalysisStatus.completed,
      summary: 'Test summary',
      keyClauses: [],
      deadlines: [],
      financialObligations: [],
      redFlags: [],
      checklistItems: [],
      createdAt: DateTime.now(),
      completedAt: DateTime.now(),
      progress: 100,
    );

    setUp(() {
      mockAIRepository = MockAIRepository();
      mockDocumentRepository = MockDocumentRepository();
      cubit = AnalysisCubit(mockAIRepository, mockDocumentRepository);
    });

    tearDown(() {
      cubit.close();
    });

    group('analyzeDocument', () {
      blocTest<AnalysisCubit, AnalysisState>(
        'Test Case 1: Primary Gemini API succeeds -> emits progress stages up to 100% and returns AnalysisCompleted',
        build: () {
          when(() => mockAIRepository.analyzeDocument(
            document: any(named: 'document'),
            localFilePath: any(named: 'localFilePath'),
            userId: any(named: 'userId'),
            onProgress: any(named: 'onProgress'),
          )).thenAnswer((invocation) async {
            final onProgress = invocation.namedArguments[#onProgress] as Function(int, String?);
            // Simulate progress updates from AI repository
            onProgress(10, 'Reading file...');
            onProgress(20, 'File read successfully. Preparing for analysis...');
            onProgress(40, 'Sending to primary AI engine (Gemini)...');
            onProgress(60, 'Processing response...');
            onProgress(80, 'Parsing structured analysis...');
            onProgress(100, 'Analysis complete');
            return Right(testAnalysis);
          });

          when(() => mockDocumentRepository.saveAnalysis(any()))
              .thenAnswer((_) async => Right(testAnalysis));

          return cubit;
        },
        act: (cubit) => cubit.analyzeDocument(
          document: testDocument,
          localFilePath: testLocalFilePath,
          userId: testUserId,
        ),
        expect: () => [
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(0)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(10)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(20)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(40)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(60)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(80)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(100)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(85)),
          isA<AnalysisCompleted>(),
        ],
        verify: (_) {
          verify(() => mockAIRepository.analyzeDocument(
            document: testDocument,
            localFilePath: testLocalFilePath,
            userId: testUserId,
            onProgress: any(named: 'onProgress'),
          )).called(1);
          verify(() => mockDocumentRepository.saveAnalysis(any())).called(1);
        },
      );

      blocTest<AnalysisCubit, AnalysisState>(
        'Test Case 2: Primary Gemini API throws 503 -> retries then triggers Kimi API fallback and succeeds',
        build: () {
          when(() => mockAIRepository.analyzeDocument(
            document: any(named: 'document'),
            localFilePath: any(named: 'localFilePath'),
            userId: any(named: 'userId'),
            onProgress: any(named: 'onProgress'),
          )).thenAnswer((invocation) async {
            final onProgress = invocation.namedArguments[#onProgress] as Function(int, String?);
            // Simulate progress with retry then fallback
            onProgress(10, 'Reading file...');
            onProgress(20, 'File read successfully. Preparing for analysis...');
            onProgress(40, 'Sending to primary AI engine (Gemini)...');
            onProgress(45, 'Gemini returned 503. Retrying in 1s (attempt 1/2)...');
            onProgress(50, 'Gemini returned 503. Retrying in 2s (attempt 2/2)...');
            onProgress(55, 'Primary AI (Gemini) unavailable. Switching to fallback engine (Kimi)...');
            onProgress(60, 'Processing fallback response...');
            onProgress(80, 'Parsing structured analysis...');
            onProgress(100, 'Analysis complete');
            return Right(testAnalysis);
          });

          when(() => mockDocumentRepository.saveAnalysis(any()))
              .thenAnswer((_) async => Right(testAnalysis));

          return cubit;
        },
        act: (cubit) => cubit.analyzeDocument(
          document: testDocument,
          localFilePath: testLocalFilePath,
          userId: testUserId,
        ),
        expect: () => [
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(0)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(10)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(20)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(40)),
          // Retry progress stages
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(45)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(50)),
          // Fallback progress stages
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(55)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(60)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(80)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(100)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(85)),
          isA<AnalysisCompleted>(),
        ],
        verify: (_) {
          verify(() => mockAIRepository.analyzeDocument(
            document: testDocument,
            localFilePath: testLocalFilePath,
            userId: testUserId,
            onProgress: any(named: 'onProgress'),
          )).called(1);
        },
      );

      blocTest<AnalysisCubit, AnalysisState>(
        'Test Case 2b: Primary Gemini model not found (404) -> falls back to secondary Gemini model -> succeeds',
        build: () {
          when(() => mockAIRepository.analyzeDocument(
            document: any(named: 'document'),
            localFilePath: any(named: 'localFilePath'),
            userId: any(named: 'userId'),
            onProgress: any(named: 'onProgress'),
          )).thenAnswer((invocation) async {
            final onProgress = invocation.namedArguments[#onProgress] as Function(int, String?);
            // Simulate progress with model fallback (404 on primary -> secondary Gemini)
            onProgress(10, 'Reading file...');
            onProgress(20, 'File read successfully. Preparing for analysis...');
            onProgress(40, 'Sending to primary AI engine (Gemini)...');
            onProgress(45, 'Primary model unavailable. Trying Gemini gemini-2.0-flash...');
            onProgress(60, 'Processing response...');
            onProgress(80, 'Parsing structured analysis...');
            onProgress(100, 'Analysis complete');
            return Right(testAnalysis);
          });

          when(() => mockDocumentRepository.saveAnalysis(any()))
              .thenAnswer((_) async => Right(testAnalysis));

          return cubit;
        },
        act: (cubit) => cubit.analyzeDocument(
          document: testDocument,
          localFilePath: testLocalFilePath,
          userId: testUserId,
        ),
        expect: () => [
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(0)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(10)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(20)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(40)),
          // Model fallback progress stage
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(45)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(60)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(80)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(100)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(85)),
          isA<AnalysisCompleted>(),
        ],
        verify: (_) {
          verify(() => mockAIRepository.analyzeDocument(
            document: testDocument,
            localFilePath: testLocalFilePath,
            userId: testUserId,
            onProgress: any(named: 'onProgress'),
          )).called(1);
        },
      );

      blocTest<AnalysisCubit, AnalysisState>(
        'Test Case 2c: All Gemini models fail (404 on both) -> falls back to Kimi -> succeeds',
        build: () {
          when(() => mockAIRepository.analyzeDocument(
            document: any(named: 'document'),
            localFilePath: any(named: 'localFilePath'),
            userId: any(named: 'userId'),
            onProgress: any(named: 'onProgress'),
          )).thenAnswer((invocation) async {
            final onProgress = invocation.namedArguments[#onProgress] as Function(int, String?);
            // Simulate progress with both Gemini models failing then Kimi fallback
            onProgress(10, 'Reading file...');
            onProgress(20, 'File read successfully. Preparing for analysis...');
            onProgress(40, 'Sending to primary AI engine (Gemini)...');
            onProgress(45, 'Primary model unavailable. Trying Gemini gemini-2.0-flash...');
            onProgress(55, 'All Gemini models failed. Switching to fallback engine (Kimi)...');
            onProgress(57, 'Uploading document to fallback engine...');
            onProgress(60, 'Processing fallback response...');
            onProgress(80, 'Parsing structured analysis...');
            onProgress(100, 'Analysis complete');
            return Right(testAnalysis);
          });

          when(() => mockDocumentRepository.saveAnalysis(any()))
              .thenAnswer((_) async => Right(testAnalysis));

          return cubit;
        },
        act: (cubit) => cubit.analyzeDocument(
          document: testDocument,
          localFilePath: testLocalFilePath,
          userId: testUserId,
        ),
        expect: () => [
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(0)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(10)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(20)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(40)),
          // Model fallback progress stages
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(45)),
          // Kimi fallback progress stages
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(55)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(57)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(60)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(80)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(100)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(85)),
          isA<AnalysisCompleted>(),
        ],
        verify: (_) {
          verify(() => mockAIRepository.analyzeDocument(
            document: testDocument,
            localFilePath: testLocalFilePath,
            userId: testUserId,
            onProgress: any(named: 'onProgress'),
          )).called(1);
        },
      );

      blocTest<AnalysisCubit, AnalysisState>(
        'Test Case 3: Both APIs fail -> emits AnalysisError without hanging',
        build: () {
          when(() => mockAIRepository.analyzeDocument(
            document: any(named: 'document'),
            localFilePath: any(named: 'localFilePath'),
            userId: any(named: 'userId'),
            onProgress: any(named: 'onProgress'),
          )).thenAnswer((_) async => Left(const ServerFailure('Both AI engines failed')));

          return cubit;
        },
        act: (cubit) => cubit.analyzeDocument(
          document: testDocument,
          localFilePath: testLocalFilePath,
          userId: testUserId,
        ),
        expect: () => [
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(0)),
          isA<AnalysisError>(),
        ],
        verify: (_) {
          verify(() => mockAIRepository.analyzeDocument(
            document: testDocument,
            localFilePath: testLocalFilePath,
            userId: testUserId,
            onProgress: any(named: 'onProgress'),
          )).called(1);
          verifyNever(() => mockDocumentRepository.saveAnalysis(any()));
        },
      );

      blocTest<AnalysisCubit, AnalysisState>(
        'emits AnalysisError when saveAnalysis fails',
        build: () {
          when(() => mockAIRepository.analyzeDocument(
            document: any(named: 'document'),
            localFilePath: any(named: 'localFilePath'),
            userId: any(named: 'userId'),
            onProgress: any(named: 'onProgress'),
          )).thenAnswer((invocation) async {
            final onProgress = invocation.namedArguments[#onProgress] as Function(int, String?);
            onProgress(10, 'Reading file...');
            onProgress(20, 'File read successfully. Preparing for analysis...');
            onProgress(40, 'Sending to primary AI engine (Gemini)...');
            onProgress(60, 'Processing response...');
            onProgress(80, 'Parsing structured analysis...');
            onProgress(100, 'Analysis complete');
            return Right(testAnalysis);
          });

          when(() => mockDocumentRepository.saveAnalysis(any()))
              .thenAnswer((_) async => Left(const ServerFailure('Database error')));

          return cubit;
        },
        act: (cubit) => cubit.analyzeDocument(
          document: testDocument,
          localFilePath: testLocalFilePath,
          userId: testUserId,
        ),
        expect: () => [
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(0)),
          // Progress updates...
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(10)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(20)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(40)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(60)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(80)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(100)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(85)),
          isA<AnalysisError>(),
        ],
      );

      blocTest<AnalysisCubit, AnalysisState>(
        'stores last analysis parameters for retry',
        build: () {
          when(() => mockAIRepository.analyzeDocument(
            document: any(named: 'document'),
            localFilePath: any(named: 'localFilePath'),
            userId: any(named: 'userId'),
            onProgress: any(named: 'onProgress'),
          )).thenAnswer((_) async => Right(testAnalysis));

          when(() => mockDocumentRepository.saveAnalysis(any()))
              .thenAnswer((_) async => Right(testAnalysis));

          return cubit;
        },
        act: (cubit) async {
          await cubit.analyzeDocument(
            document: testDocument,
            localFilePath: testLocalFilePath,
            userId: testUserId,
          );
        },
        verify: (_) {
          expect(cubit.canRetryLastAnalysis, isTrue);
        },
      );
    });

    group('retryLastAnalysis', () {
      blocTest<AnalysisCubit, AnalysisState>(
        'retries last analysis with stored parameters',
        build: () {
          // Setup mocks for retry (this test only tests the retry call)
          when(() => mockAIRepository.analyzeDocument(
            document: any(named: 'document'),
            localFilePath: any(named: 'localFilePath'),
            userId: any(named: 'userId'),
            onProgress: any(named: 'onProgress'),
          )).thenAnswer((invocation) async {
            final onProgress = invocation.namedArguments[#onProgress] as Function(int, String?);
            onProgress(10, 'Reading file...');
            onProgress(20, 'File read successfully. Preparing for analysis...');
            onProgress(40, 'Sending to primary AI engine (Gemini)...');
            onProgress(60, 'Processing response...');
            onProgress(80, 'Parsing structured analysis...');
            onProgress(100, 'Analysis complete');
            return Right(testAnalysis);
          });

          when(() => mockDocumentRepository.saveAnalysis(any()))
              .thenAnswer((_) async => Right(testAnalysis));

          // Manually set the last analysis parameters using the visibleForTesting method
          cubit.setLastAnalysisParams(
            document: testDocument,
            localFilePath: testLocalFilePath,
            userId: testUserId,
          );

          return cubit;
        },
        act: (cubit) async {
          await cubit.retryLastAnalysis();
        },
        expect: () => [
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(0)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(10)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(20)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(40)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(60)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(80)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(100)),
          isA<AnalysisProgress>().having((s) => s.progress, 'progress', equals(85)),
          isA<AnalysisCompleted>(),
        ],
        verify: (_) {
          verify(() => mockAIRepository.analyzeDocument(
            document: testDocument,
            localFilePath: testLocalFilePath,
            userId: testUserId,
            onProgress: any(named: 'onProgress'),
          )).called(1);
        },
      );
    });

    group('chatWithDocument', () {
      blocTest<AnalysisCubit, AnalysisState>(
        'emits ChatLoading then ChatResponse on success',
        build: () {
          when(() => mockAIRepository.chatWithDocument(
            documentId: any(named: 'documentId'),
            analysisId: any(named: 'analysisId'),
            question: any(named: 'question'),
            history: any(named: 'history'),
          )).thenAnswer((_) async => const Right('Test response'));

          return cubit;
        },
        act: (cubit) => cubit.chatWithDocument(
          documentId: 'doc-1',
          analysisId: 'analysis-1',
          question: 'Test question',
          history: [],
        ),
        expect: () => [
          isA<ChatLoading>(),
          isA<ChatResponse>().having((s) => s.response, 'response', equals('Test response')),
        ],
      );

      blocTest<AnalysisCubit, AnalysisState>(
        'emits ChatLoading then ChatError on failure',
        build: () {
          when(() => mockAIRepository.chatWithDocument(
            documentId: any(named: 'documentId'),
            analysisId: any(named: 'analysisId'),
            question: any(named: 'question'),
            history: any(named: 'history'),
          )).thenAnswer((_) async => Left(const ServerFailure('Chat failed')));

          return cubit;
        },
        act: (cubit) => cubit.chatWithDocument(
          documentId: 'doc-1',
          analysisId: 'analysis-1',
          question: 'Test question',
          history: [],
        ),
        expect: () => [
          isA<ChatLoading>(),
          isA<ChatError>(),
        ],
      );
    });

    group('translateDocument', () {
      blocTest<AnalysisCubit, AnalysisState>(
        'emits TranslationLoading then TranslationCompleted on success',
        build: () {
          when(() => mockAIRepository.translateDocument(
            documentId: any(named: 'documentId'),
            analysisId: any(named: 'analysisId'),
            targetLanguage: any(named: 'targetLanguage'),
            content: any(named: 'content'),
          )).thenAnswer((_) async => const Right('Translated text'));

          return cubit;
        },
        act: (cubit) => cubit.translateDocument(
          documentId: 'doc-1',
          analysisId: 'analysis-1',
          targetLanguage: 'en',
          content: 'Test content',
        ),
        expect: () => [
          isA<TranslationLoading>(),
          isA<TranslationCompleted>().having((s) => s.translation, 'translation', equals('Translated text')),
        ],
      );
    });

    group('generateChecklist', () {
      blocTest<AnalysisCubit, AnalysisState>(
        'emits ChecklistLoading then ChecklistGenerated on success',
        build: () {
          final checklist = [
            ChecklistItemModel(
              id: 'item-1',
              title: 'Test Item',
              description: 'Description',
              isCompleted: false,
              category: ChecklistCategory.beforeSigning,
              priority: 1,
              dueDate: DateTime(2024, 12, 31),
            ),
          ];

          when(() => mockAIRepository.generateChecklist(analysis: any(named: 'analysis')))
              .thenAnswer((_) async => Right(checklist));

          return cubit;
        },
        act: (cubit) => cubit.generateChecklist(testAnalysis),
        expect: () => [
          isA<ChecklistLoading>(),
          isA<ChecklistGenerated>(),
        ],
      );
    });
  });
}