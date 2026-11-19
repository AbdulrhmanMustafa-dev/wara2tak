import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';
import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:http/http.dart' as http;
import 'package:uuid/uuid.dart';

import '../../../../core/errors/failures.dart';
import '../../../../supabase_config.dart';
import '../../domain/repositories/ai_repository.dart';
import '../../../documents/domain/models/analysis_model.dart'
    show
        AnalysisModel,
        AnalysisStatus,
        ChecklistItemModel,
        DeadlineModel,
        FinancialObligationModel,
        KeyClauseModel,
        RedFlagModel;
import '../../../documents/domain/models/document_model.dart';

/// Real implementation of AIRepository using Gemini API with internal model fallback,
/// Kimi (Moonshot AI) fallback, and Cerebras ultra-fast inference.
/// Uses a SEQUENTIAL FAILOVER CHAIN: Gemini models → Kimi → Cerebras (not parallel race).
/// This avoids the Future.any() bug where a fast 404 error would abort all other providers.
class AIRepositoryImpl implements AIRepository {
  // Timeouts
  // Reduced from 90s to 45s per attempt with max 1 retry (total max 90s) so failover
  // to gemini-3.5-flash-lite / Kimi / Cerebras doesn't stall the user for 1.5+ minutes.
  static const Duration _geminiAnalysisTimeout = Duration(seconds: 45);
  static const Duration _geminiInteractiveTimeout = Duration(seconds: 45);
  static const Duration _kimiTimeout = Duration(seconds: 60);
  static const Duration _cerebrasTimeout = Duration(seconds: 30); // Cerebras is ultra-fast
  static const int _maxRetries = 1; // Max 1 retry on 503/429 before fallback (was 2)

  // Provider models
  static const List<String> _geminiModels = [
    'gemini-3-flash-preview',
    'gemini-3.5-flash-lite',
    'gemini-3.1-pro-preview',
  ];
  static const String _kimiModel = 'kimi-k2-0711-preview';
  static const String _cerebrasModel = 'llama-3.3-70b'; // Cerebras default model

  final String _geminiApiKey;
  final String _kimiApiKey;
  final String _cerebrasApiKey;

  AIRepositoryImpl({
    String? geminiApiKey,
    String? kimiApiKey,
    String? cerebrasApiKey,
  })  : _geminiApiKey = geminiApiKey ?? SupabaseConfig.geminiApiKey,
        _kimiApiKey = (kimiApiKey ?? SupabaseConfig.kimiApiKey).trim(),
        _cerebrasApiKey = cerebrasApiKey ?? SupabaseConfig.cerebrasApiKey;

  /// Creates a GenerativeModel for the given model name with analysis schema
  GenerativeModel _createAnalyzerModel(String model) {
    return GenerativeModel(
      model: model,
      apiKey: _geminiApiKey,
      generationConfig: GenerationConfig(
        responseMimeType: 'application/json',
        responseSchema: Schema.object(
          properties: {
            'summary': Schema.string(
              description: 'Plain-language summary of the document in Arabic',
            ),
            'keyClauses': Schema.array(
              items: Schema.object(
                properties: {
                  'id': Schema.string(),
                  'title': Schema.string(),
                  'description': Schema.string(),
                  'clauseText': Schema.string(),
                  'pageNumber': Schema.integer(),
                  'type': Schema.enumString(
                    enumValues: [
                      'termination',
                      'payment',
                      'liability',
                      'confidentiality',
                      'intellectualProperty',
                      'disputeResolution',
                      'governingLaw',
                      'other',
                    ],
                  ),
                  'importance': Schema.enumString(
                    enumValues: ['critical', 'high', 'medium', 'low'],
                  ),
                },
                requiredProperties: [
                  'id',
                  'title',
                  'description',
                  'clauseText',
                  'pageNumber',
                  'type',
                  'importance',
                ],
              ),
            ),
            'deadlines': Schema.array(
              items: Schema.object(
                properties: {
                  'id': Schema.string(),
                  'title': Schema.string(),
                  'description': Schema.string(),
                  'dueDate': Schema.string(),
                  'type': Schema.enumString(
                    enumValues: [
                      'rentDue',
                      'noticePeriod',
                      'renewal',
                      'termination',
                      'payment',
                      'inspection',
                      'other',
                    ],
                  ),
                  'isCompleted': Schema.boolean(),
                  'pageNumber': Schema.integer(),
                },
                requiredProperties: [
                  'id',
                  'title',
                  'description',
                  'dueDate',
                  'type',
                  'isCompleted',
                ],
              ),
            ),
            'financialObligations': Schema.array(
              items: Schema.object(
                properties: {
                  'id': Schema.string(),
                  'title': Schema.string(),
                  'description': Schema.string(),
                  'amount': Schema.number(),
                  'currency': Schema.string(),
                  'type': Schema.enumString(
                    enumValues: [
                      'rent',
                      'deposit',
                      'utility',
                      'maintenance',
                      'penalty',
                      'fee',
                      'other',
                    ],
                  ),
                  'dueDate': Schema.string(),
                  'isRecurring': Schema.boolean(),
                  'frequency': Schema.string(),
                  'pageNumber': Schema.integer(),
                },
                requiredProperties: [
                  'id',
                  'title',
                  'description',
                  'amount',
                  'currency',
                  'type',
                  'isRecurring',
                ],
              ),
            ),
            'redFlags': Schema.array(
              items: Schema.object(
                properties: {
                  'id': Schema.string(),
                  'title': Schema.string(),
                  'description': Schema.string(),
                  'severity': Schema.enumString(
                    enumValues: ['critical', 'high', 'medium', 'low'],
                  ),
                  'recommendation': Schema.string(),
                  'pageNumber': Schema.integer(),
                },
                requiredProperties: [
                  'id',
                  'title',
                  'description',
                  'severity',
                  'recommendation',
                ],
              ),
            ),
            'checklistItems': Schema.array(
              items: Schema.object(
                properties: {
                  'id': Schema.string(),
                  'title': Schema.string(),
                  'description': Schema.string(),
                  'isCompleted': Schema.boolean(),
                  'category': Schema.enumString(
                    enumValues: [
                      'beforeSigning',
                      'afterSigning',
                      'ongoing',
                      'legal',
                      'financial',
                      'other',
                    ],
                  ),
                  'priority': Schema.integer(),
                  'dueDate': Schema.string(),
                },
                requiredProperties: [
                  'id',
                  'title',
                  'description',
                  'isCompleted',
                  'category',
                ],
              ),
            ),
          },
          requiredProperties: [
            'summary',
            'keyClauses',
            'deadlines',
            'financialObligations',
            'redFlags',
            'checklistItems',
          ],
        ),
        maxOutputTokens: 8192,
      ),
      systemInstruction: Content.system(
        'أنت محامٍ خبير في تحليل العقود والمستندات القانونية. '
        'مهمتك هي استخراج المعلومات بدقة تامة من المستند المقدم دون أي تخمين أو افتراض. '
        'قواعد صارمة: '
        '1. أخرج الرد باللغة العربية فقط. '
        '2. إذا كانت معلومة غير موجودة في المستند، ضعها كـ null أو قائمة فارغة - لا تخترع أبداً. '
        '3. لكل معلومة مستخرجة، يجب ذكر رقم الصفحة (pageNumber) من أين أتت. '
        '4. لا تُلخص - استخرج النص الحرفي للمواد والبنود المهمة. '
        '5. استخدم enum values المحددة في الـ schema فقط. '
        '6. إذا لم تجد بنوداً من نوع معين، أرجع قائمة فارغة []. '
        '7. الـ deadline يجب أن يكون بتاريخ كامل (ISO 8601). '
        '8. الأهمية: critical للمواد التي تنهي العقد أو تفرض عقوبات، high للمواد المالية، medium للباقي، low للملاحظات. '
        '9. نوع البند (type): اختر من القائمة المحددة فقط. '
        '10. التقويم: استخدم التاريخ الميلادي. '
        '11. العملة: استخرج كما وردت في المستند (USD, SAR, EUR، إلخ). ',
      ),
    );
  }

  /// Creates a GenerativeModel for the given model name for chat/translation
  GenerativeModel _createChatModel(String model) {
    return GenerativeModel(
      model: model,
      apiKey: _geminiApiKey,
      generationConfig: GenerationConfig(maxOutputTokens: 4096),
      systemInstruction: Content.system(
        'أنت مساعد ذكي متخصص في شرح العقود والمستندات للمستخدمين. '
        'قواعد: '
        '1. أجب باللغة العربية فقط. '
        '2. اعتمد فقط على سياق المستند المقدم (AnalysisModel). '
        '3. إذا كانت الإجابة غير موجودة في السياق، قل حرفياً: "هذه المعلومة غير موجودة في المستند المرفوع". '
        '4. لا تضف معلومات من خارج المستند. '
        '5. اذكر رقم الصفحة عند الإشارة لمعلومة من المستند. ',
      ),
    );
  }

  @override
  Future<Either<Failure, AnalysisModel>> analyzeDocument({
    required DocumentModel document,
    required String localFilePath,
    required String userId,
    required Function(int progress, String? message) onProgress,
  }) async {
    try {
      // Step 1: Reading file (0-20%)
      onProgress(10, 'Reading file...');

      final fileBytes = await _readLocalFileBytes(localFilePath);
      if (fileBytes == null) {
        return Left(
          const ServerFailure('Could not read document file from local path'),
        );
      }
      onProgress(20, 'File read successfully. Preparing for analysis...');

      // Step 2: Determine MIME type
      final mimeType = _getMimeTypeFromPath(localFilePath);
      final filePart = DataPart(mimeType, Uint8List.fromList(fileBytes));

      // Step 3: AI Analysis with race pattern - progress 40%
      onProgress(40, 'Sending to AI engines (Gemini, Kimi, Cerebras)...');

      // Build prompt as string for all providers
      const promptText =
          'Analyze this document strictly according to the schema. Extract all key clauses, deadlines, financial obligations, red flags, and generate a checklist. Return ONLY valid JSON matching the schema.';

      final prompt = Content.multi([
        TextPart(promptText),
        filePart,
      ]);

      final response = await _generateContentWithSequentialFallback(
        geminiFactory: (model) => _createAnalyzerModel(model)
            .generateContent([prompt])
            .timeout(_geminiAnalysisTimeout),
        onProgress: onProgress,
        kimiPrompt: promptText,
        kimiModel: _kimiModel,
        kimiTemperature: 0.1,
        kimiMaxTokens: 8192,
        isAnalysis: true,
        mimeType: mimeType,
        fileBytes: fileBytes,
      );

      // Step 4: Parse results (80%)
      onProgress(80, 'Parsing structured analysis...');

      final jsonText = response.text;
      if (jsonText == null || jsonText.trim().isEmpty) {
        return Left(
          ServerFailure(
            'AI returned an empty response'
            '${response.promptFeedback?.blockReason != null ? ': ${response.promptFeedback!.blockReason}' : ''}',
          ),
        );
      }
      final jsonMap = json.decode(jsonText) as Map<String, dynamic>;

      // Create AnalysisModel from parsed JSON
      final analysisId = const Uuid().v4();
      final now = DateTime.now();

      final analysis = AnalysisModel(
        id: analysisId,
        documentId: document.id,
        userId: userId,
        status: AnalysisStatus.completed,
        summary: jsonMap['summary'] as String?,
        keyClauses: (jsonMap['keyClauses'] as List<dynamic>? ?? [])
            .map((e) => KeyClauseModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        deadlines: (jsonMap['deadlines'] as List<dynamic>? ?? [])
            .map((e) => DeadlineModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        financialObligations:
            (jsonMap['financialObligations'] as List<dynamic>? ?? [])
                .map(
                  (e) => FinancialObligationModel.fromJson(
                    e as Map<String, dynamic>,
                  ),
                )
                .toList(),
        redFlags: (jsonMap['redFlags'] as List<dynamic>? ?? [])
            .map((e) => RedFlagModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        checklistItems: (jsonMap['checklistItems'] as List<dynamic>? ?? [])
            .map((e) => ChecklistItemModel.fromJson(e as Map<String, dynamic>))
            .toList(),
        createdAt: now,
        completedAt: now,
        progress: 100,
      );

      onProgress(100, 'Analysis complete');
      return Right(analysis);
    } on TimeoutException catch (e) {
      return Left(NetworkFailure('Request timed out: $e'));
    } on SocketException catch (e) {
      return Left(NetworkFailure('Network error: $e'));
    } on FormatException catch (e) {
      return Left(ServerFailure('Failed to parse AI response: $e'));
    } on GenerativeAIException catch (e) {
      return Left(ServerFailure('AI analysis failed: ${e.message}'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error during analysis: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> chatWithDocument({
    required String documentId,
    required String analysisId,
    required String question,
    required List<AIChatMessage> history,
  }) async {
    try {
      // Build context from history
      final historyText = history
          .map((msg) => '${msg.role}: ${msg.content}')
          .join('\n');

      final prompt =
          '''
السياق: تم تحليل مستند واستخراج المعلومات التالية. استخدم هذه المعلومات فقط للإجابة.

سؤال المستخدم: $question

تاريخ المحادثة:
$historyText

قاعدة صارمة: إذا كانت الإجابة غير موجودة في السياق أعلاه، قل حرفياً: "هذه المعلومة غير موجودة في المستند المرفوع".
''';

      final response = await _generateContentWithSequentialFallback(
        geminiFactory: (model) => _createChatModel(model)
            .generateContent([Content.text(prompt)])
            .timeout(_geminiInteractiveTimeout),
        kimiPrompt: prompt,
        kimiModel: _kimiModel,
        kimiTemperature: 0.3,
        kimiMaxTokens: 4096,
      );

      return Right(response.text ?? 'لا توجد إجابة');
    } on TimeoutException catch (e) {
      return Left(NetworkFailure('Request timed out: $e'));
    } on SocketException catch (e) {
      return Left(NetworkFailure('Network error: $e'));
    } on GenerativeAIException catch (e) {
      return Left(ServerFailure('Chat failed: ${e.message}'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error during chat: $e'));
    }
  }

  @override
  Future<Either<Failure, String>> translateDocument({
    required String documentId,
    required String analysisId,
    required String targetLanguage,
    required String content,
  }) async {
    try {
      final prompt =
          '''
Translate the following content from its original language to $targetLanguage.
Translate accurately without summarizing, preserving all details, numbers, dates, and legal terms.
Return ONLY the translation, no additional text.

Content to translate:
$content
''';

      final response = await _generateContentWithSequentialFallback(
        geminiFactory: (model) => _createChatModel(model)
            .generateContent([Content.text(prompt)])
            .timeout(_geminiInteractiveTimeout),
        kimiPrompt: prompt,
        kimiModel: _kimiModel,
        kimiTemperature: 0.2,
        kimiMaxTokens: 4096,
      );

      return Right(response.text ?? 'Translation failed');
    } on TimeoutException catch (e) {
      return Left(NetworkFailure('Request timed out: $e'));
    } on SocketException catch (e) {
      return Left(NetworkFailure('Network error: $e'));
    } on GenerativeAIException catch (e) {
      return Left(ServerFailure('Translation failed: ${e.message}'));
    } catch (e) {
      return Left(ServerFailure('Unexpected error during translation: $e'));
    }
  }

  @override
  Future<Either<Failure, List<ChecklistItemModel>>> generateChecklist({
    required AnalysisModel analysis,
  }) async {
    // The checklist items are already extracted during analysis
    return Right(analysis.checklistItems);
  }

  /// Generate content with Gemini with timeout, retries, and exponential backoff for a specific model
  Future<GenerateContentResponse> _generateContentWithRetry(
    Future<GenerateContentResponse> Function() request, {
    void Function(int attempt, String message)? onProgress,
  }) async {
    var timeoutRetries = 0;
    for (var attempt = 1; attempt <= _maxRetries + 1; attempt++) {
      try {
        return await request();
      } catch (error) {
        final isRetryable = _isRetryableGeminiError(error);
        final shouldStopRetryingTimeout =
            error is TimeoutException && timeoutRetries >= 1;
        final isLastAttempt = attempt > _maxRetries;

        if (isLastAttempt || !isRetryable || shouldStopRetryingTimeout) {
          developer.log('Gemini failed (attempt $attempt/${_maxRetries + 1}): $error');
          rethrow;
        }
        if (error is TimeoutException) timeoutRetries++;

        // Exponential backoff: 1s, 2s, 4s...
        final delay = Duration(seconds: 1 << (attempt - 1));
        final message = 'Gemini returned ${_extractStatusCode(error) ?? 'error'}. Retrying in ${delay.inSeconds}s (attempt $attempt/$_maxRetries)...';
        developer.log(message);
        onProgress?.call(attempt, message);
        await Future<void>.delayed(delay);
      }
    }
    // This should never be reached due to the rethrow above
    throw StateError('Unexpected retry loop exit');
  }

  /// Check if a Gemini error is retryable (503, 429, 500, 502, 504, UNAVAILABLE, RESOURCE_EXHAUSTED)
  /// Returns false for non-retryable errors like 404/model not found, 400, 401, 403, QUOTA_EXCEEDED
  bool _isRetryableGeminiError(Object error) {
    if (error is TimeoutException || error is SocketException) return true;
    final message = error.toString().toUpperCase();

    // Don't retry these non-retryable errors
    if (message.contains('QUOTA_EXCEEDED')) return false;
    if (message.contains('INVALID_ARGUMENT')) return false;
    if (message.contains('PERMISSION_DENIED')) return false;
    if (message.contains('NOT_FOUND')) return false; // 404 - model not found
    if (message.contains('MODEL NOT FOUND')) return false;
    if (message.contains('UNSUPPORTED')) return false;
    if (RegExp(r'\b(400|401|403|404)\b').hasMatch(message)) return false;

    // Retry on these conditions
    return message.contains('UNAVAILABLE') ||
        message.contains('RESOURCE_EXHAUSTED') ||
        RegExp(r'\b(429|500|502|503|504)\b').hasMatch(message);
  }

  /// Extract HTTP status code from error message if present
  String? _extractStatusCode(Object error) {
    final message = error.toString();
    final match = RegExp(r'\b(4\d{2}|5\d{2})\b').firstMatch(message);
    return match?.group(0);
  }

  /// Upload file to Moonshot AI (Kimi) files endpoint for PDF processing
  /// Returns the file ID if successful, null otherwise
  Future<String?> _uploadFileToKimi({
    required List<int> fileBytes,
    required String mimeType,
    required String fileName,
  }) async {
    if (_kimiApiKey.isEmpty) {
      developer.log('Kimi API key not configured, skipping file upload');
      return null;
    }

    try {
      final url = Uri.parse('${SupabaseConfig.kimiBaseUrl}/files');

      final request = http.MultipartRequest('POST', url)
        ..headers['Authorization'] = 'Bearer ${_kimiApiKey.trim()}'
        ..fields['purpose'] = 'file-extract'
        ..files.add(
          http.MultipartFile.fromBytes(
            'file',
            fileBytes,
            filename: fileName,
          ),
        );

      final streamedResponse = await request.send().timeout(_kimiTimeout);
      final response = await http.Response.fromStream(streamedResponse);

      if (response.statusCode != 200) {
        developer.log('Kimi file upload HTTP error: ${response.statusCode} - ${response.body}');
        return null;
      }

      final responseBody = utf8.decode(response.bodyBytes);
      final jsonResponse = json.decode(responseBody) as Map<String, dynamic>;

      final fileId = jsonResponse['id'] as String?;
      if (fileId != null && fileId.isNotEmpty) {
        developer.log('Kimi file upload successful: $fileId');
        return fileId;
      }

      developer.log('Kimi file upload missing file ID. Body: $responseBody');
      return null;
    } on TimeoutException catch (e) {
      developer.log('Kimi file upload timeout: $e');
      return null;
    } on SocketException catch (e) {
      developer.log('Kimi file upload network error: $e');
      return null;
    } catch (e) {
      developer.log('Kimi file upload exception: $e');
      return null;
    }
  }

  /// Call Kimi (Moonshot AI) API with optional file attachment for PDF/image processing
  Future<String?> _callKimiApi({
    required String prompt,
    required String model,
    required double temperature,
    int maxTokens = 4096,
    Schema? responseSchema,
    String? fileId,
  }) async {
    if (_kimiApiKey.isEmpty) {
      developer.log('Kimi API key not configured, skipping fallback');
      return null;
    }

    try {
      final url = Uri.parse('${SupabaseConfig.kimiBaseUrl}/chat/completions');

      // Build messages - if fileId is provided, use file content extraction
      List<Map<String, dynamic>> messages;
      if (fileId != null) {
        // For file-extract purpose, the file content is automatically included
        messages = [
          {'role': 'user', 'content': prompt},
        ];
      } else {
        messages = [
          {'role': 'user', 'content': prompt},
        ];
      }

      final body = {
        'model': model,
        'messages': messages,
        'temperature': temperature,
        'max_tokens': maxTokens,
        'response_format': responseSchema != null ? {'type': 'json_object'} : {'type': 'text'},
      };

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $_kimiApiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      ).timeout(_kimiTimeout);

      // Handle non-200 HTTP status codes
      if (response.statusCode != 200) {
        developer.log('Kimi API HTTP error: ${response.statusCode} - ${response.body}');
        return null;
      }

      // Safely decode response body using utf8 to handle encoding issues
      final responseBody = utf8.decode(response.bodyBytes);

      // Parse the outer API response
      Map<String, dynamic> jsonResponse;
      try {
        jsonResponse = json.decode(responseBody) as Map<String, dynamic>;
      } on FormatException catch (e) {
        developer.log('Kimi API response JSON parse error: $e. Body: $responseBody');
        return null;
      }

      // Validate response structure
      if (jsonResponse['choices'] == null ||
          jsonResponse['choices'] is! List ||
          (jsonResponse['choices'] as List).isEmpty) {
        developer.log('Kimi API invalid response structure: missing or empty choices. Body: $responseBody');
        return null;
      }

      final choices = jsonResponse['choices'] as List;
      final firstChoice = choices[0];
      if (firstChoice is! Map || firstChoice['message'] == null) {
        developer.log('Kimi API invalid choice structure. Body: $responseBody');
        return null;
      }

      final message = firstChoice['message'];
      if (message is! Map || message['content'] == null) {
        developer.log('Kimi API missing message content. Body: $responseBody');
        return null;
      }

      final content = message['content'] as String?;
      if (content == null || content.trim().isEmpty) {
        developer.log('Kimi API empty content. Body: $responseBody');
        return null;
      }

      developer.log('Kimi API call successful');
      return content;
    } on TimeoutException catch (e) {
      developer.log('Kimi API timeout: $e');
      return null;
    } on SocketException catch (e) {
      developer.log('Kimi API network error: $e');
      return null;
    } catch (e) {
      developer.log('Kimi API exception: $e');
      return null;
    }
  }

  /// Call Cerebras API (OpenAI-compatible) for ultra-fast inference
  Future<String?> _callCerebrasApi({
    required String prompt,
    required String model,
    required double temperature,
    int maxTokens = 4096,
    Schema? responseSchema,
  }) async {
    if (_cerebrasApiKey.isEmpty) {
      developer.log('Cerebras API key not configured, skipping');
      return null;
    }

    try {
      final url = Uri.parse('${SupabaseConfig.cerebrasBaseUrl}/chat/completions');

      final body = {
        'model': model,
        'messages': [
          {'role': 'user', 'content': prompt},
        ],
        'temperature': temperature,
        'max_tokens': maxTokens,
        'response_format': responseSchema != null ? {'type': 'json_object'} : {'type': 'text'},
      };

      final response = await http.post(
        url,
        headers: {
          'Authorization': 'Bearer $_cerebrasApiKey',
          'Content-Type': 'application/json',
        },
        body: json.encode(body),
      ).timeout(_cerebrasTimeout);

      // Handle non-200 HTTP status codes
      if (response.statusCode != 200) {
        developer.log('Cerebras API HTTP error: ${response.statusCode} - ${response.body}');
        return null;
      }

      // Safely decode response body using utf8
      final responseBody = utf8.decode(response.bodyBytes);

      // Parse the outer API response
      Map<String, dynamic> jsonResponse;
      try {
        jsonResponse = json.decode(responseBody) as Map<String, dynamic>;
      } on FormatException catch (e) {
        developer.log('Cerebras API response JSON parse error: $e. Body: $responseBody');
        return null;
      }

      // Validate response structure
      if (jsonResponse['choices'] == null ||
          jsonResponse['choices'] is! List ||
          (jsonResponse['choices'] as List).isEmpty) {
        developer.log('Cerebras API invalid response structure: missing or empty choices. Body: $responseBody');
        return null;
      }

      final choices = jsonResponse['choices'] as List;
      final firstChoice = choices[0];
      if (firstChoice is! Map || firstChoice['message'] == null) {
        developer.log('Cerebras API invalid choice structure. Body: $responseBody');
        return null;
      }

      final message = firstChoice['message'];
      if (message is! Map || message['content'] == null) {
        developer.log('Cerebras API missing message content. Body: $responseBody');
        return null;
      }

      final content = message['content'] as String?;
      if (content == null || content.trim().isEmpty) {
        developer.log('Cerebras API empty content. Body: $responseBody');
        return null;
      }

      developer.log('Cerebras API call successful (ultra-fast)');
      return content;
    } on TimeoutException catch (e) {
      developer.log('Cerebras API timeout: $e');
      return null;
    } on SocketException catch (e) {
      developer.log('Cerebras API network error: $e');
      return null;
    } catch (e) {
      developer.log('Cerebras API exception: $e');
      return null;
    }
  }

  /// Safely extracts JSON from AI response that might be wrapped in markdown code blocks
  String _extractJsonFromResponse(String content) {
    String cleanJsonStr = content.trim();

    // Handle ```json ... ``` markdown code blocks
    if (cleanJsonStr.contains('```json')) {
      final parts = cleanJsonStr.split('```json');
      if (parts.length > 1) {
        cleanJsonStr = parts[1].split('```')[0].trim();
      }
    }
    // Handle generic ``` ... ``` code blocks
    else if (cleanJsonStr.contains('```')) {
      final parts = cleanJsonStr.split('```');
      if (parts.length > 1) {
        cleanJsonStr = parts[1].trim();
      }
    }

    return cleanJsonStr;
  }

  /// Parses JSON safely with detailed error logging
  Map<String, dynamic>? _parseJsonSafely(String jsonStr, String context) {
    try {
      final cleanJson = _extractJsonFromResponse(jsonStr);
      return json.decode(cleanJson) as Map<String, dynamic>;
    } on FormatException catch (e) {
      developer.log('$context JSON parse error: $e. Raw content: $jsonStr');
      return null;
    }
  }

  /// Generate content with SEQUENTIAL FAILOVER CHAIN (not parallel race).
  /// Order: Gemini models (with internal fallback) → Kimi → Cerebras
  /// This avoids the Future.any() bug where a fast 404 error would abort all other providers.
  Future<dynamic> _generateContentWithSequentialFallback({
    required Future<GenerateContentResponse> Function(String model) geminiFactory,
    void Function(int attempt, String message)? onProgress,
    String? kimiPrompt,
    String kimiModel = 'kimi-k2-0711-preview',
    double kimiTemperature = 0.1,
    int kimiMaxTokens = 8192,
    Schema? kimiResponseSchema,
    bool isAnalysis = false,
    String? mimeType,
    List<int>? fileBytes,
  }) async {
    final errors = <String, String>{};

    // ===== STEP 1: Try Gemini model chain (sequential internal fallback) =====
    onProgress?.call(40, 'Sending to primary AI engine (Gemini)...');
    final geminiResult = await _runGeminiWithFallback(
      geminiFactory,
      onProgress: onProgress,
      onProviderError: (provider, error) {
        errors[provider] = error.toString();
      },
    );
    if (geminiResult != null) {
      developer.log('🏆 Sequential winner: Gemini');
      onProgress?.call(60, 'Gemini succeeded. Processing response...');
      return geminiResult;
    }
    developer.log('⚠️ All Gemini models failed: $errors');

    // ===== STEP 2: Try Kimi fallback (if configured) =====
    if (kimiPrompt != null && _kimiApiKey.isNotEmpty) {
      onProgress?.call(55, 'All Gemini models failed. Switching to fallback engine (Kimi)...');
      final kimiResult = await _runKimi(
        kimiPrompt,
        model: kimiModel,
        temperature: kimiTemperature,
        maxTokens: kimiMaxTokens,
        responseSchema: kimiResponseSchema,
        isAnalysis: isAnalysis,
        mimeType: mimeType,
        fileBytes: fileBytes,
        onProgress: onProgress,
        onProviderError: (provider, error) {
          errors[provider] = error.toString();
        },
      );
      if (kimiResult != null) {
        developer.log('🏆 Sequential winner: Kimi');
        onProgress?.call(60, 'Kimi succeeded. Processing response...');
        return kimiResult;
      }
      developer.log('⚠️ Kimi failed: ${errors['Kimi'] ?? 'unknown error'}');
    } else {
      final reason = kimiPrompt == null ? 'No prompt provided' : 'API key empty';
      errors['Kimi'] = 'Skipped ($reason)';
      developer.log('⏭️ Kimi skipped: $reason');
      onProgress?.call(55, 'Kimi skipped ($reason). Trying Cerebras...');
    }

    // ===== STEP 3: Try Cerebras fallback (if configured) =====
    if (kimiPrompt != null && _cerebrasApiKey.isNotEmpty) {
      onProgress?.call(58, 'Kimi failed. Trying Cerebras ultra-fast inference...');
      final cerebrasResult = await _runCerebras(
        kimiPrompt,
        model: _cerebrasModel,
        temperature: kimiTemperature,
        maxTokens: kimiMaxTokens,
        responseSchema: kimiResponseSchema,
        isAnalysis: isAnalysis,
        onProviderError: (provider, error) {
          errors[provider] = error.toString();
        },
      );
      if (cerebrasResult != null) {
        developer.log('🏆 Sequential winner: Cerebras');
        onProgress?.call(60, 'Cerebras succeeded. Processing response...');
        return cerebrasResult;
      }
      developer.log('⚠️ Cerebras failed: ${errors['Cerebras'] ?? 'unknown error'}');
    } else {
      final reason = kimiPrompt == null ? 'No prompt provided' : 'API key empty';
      errors['Cerebras'] = 'Skipped ($reason)';
      developer.log('⏭️ Cerebras skipped: $reason');
    }

    // ===== ALL PROVIDERS FAILED =====
    final errorSummary = errors.entries.map((e) => '${e.key}: ${e.value}').join('; ');
    developer.log('❌ All AI providers failed: $errorSummary');
    throw ServerException('All AI providers failed: $errorSummary');
  }

  /// Run Gemini with internal model fallback chain (sequential)
  /// Returns null if all models fail (doesn't throw)
  Future<dynamic> _runGeminiWithFallback(
    Future<GenerateContentResponse> Function(String model) geminiFactory, {
    void Function(int attempt, String message)? onProgress,
    void Function(String provider, Object error)? onProviderError,
  }) async {
    for (var modelIndex = 0; modelIndex < _geminiModels.length; modelIndex++) {
      final model = _geminiModels[modelIndex];
      final isLastModel = modelIndex == _geminiModels.length - 1;

      try {
        onProgress?.call(
          40 + (modelIndex * 5),
          modelIndex == 0
              ? 'Sending to Gemini ($model)...'
              : 'Gemini fallback: trying $model...',
        );

        final result = await _generateContentWithRetry(
          () => geminiFactory(model),
          onProgress: onProgress,
        );

        developer.log('✅ Gemini ($model) succeeded');
        return result;
      } catch (geminiError) {
        developer.log('Gemini $model failed: $geminiError');
        onProviderError?.call('Gemini ($model)', geminiError);

        // If this is not the last model, try the next one immediately
        if (!isLastModel) {
          final nextModel = _geminiModels[modelIndex + 1];
          onProgress?.call(
            45 + (modelIndex * 5),
            'Gemini $model failed. Switching to $nextModel...',
          );
          continue; // Try next model
        }

        // Last Gemini model failed - return null to signal fallback chain should continue
        return null;
      }
    }
    return null; // All models exhausted
  }

  /// Run Kimi provider with proper PDF/file handling
  /// Returns null if Kimi fails or is not configured (doesn't throw)
  Future<dynamic> _runKimi(
    String prompt, {
    required String model,
    required double temperature,
    required int maxTokens,
    Schema? responseSchema,
    required bool isAnalysis,
    String? mimeType,
    List<int>? fileBytes,
    void Function(int progress, String message)? onProgress,
    void Function(String provider, Object error)? onProviderError,
  }) async {
    if (_kimiApiKey.isEmpty) {
      onProviderError?.call('Kimi', Exception('API key not configured'));
      return null;
    }

    try {
      // For PDF/image analysis, upload file to Kimi first for content extraction
      String? kimiFileId;
      if (isAnalysis && fileBytes != null && mimeType != null) {
        onProgress?.call(57, 'Uploading document to fallback engine (Kimi)...');
        final fileName = 'document_${DateTime.now().millisecondsSinceEpoch}${_getFileExtension(mimeType)}';
        kimiFileId = await _uploadFileToKimi(
          fileBytes: fileBytes,
          mimeType: mimeType,
          fileName: fileName,
        );
        if (kimiFileId != null) {
          onProgress?.call(58, 'Document uploaded to Kimi. Extracting content...');
        }
      }

      final kimiResponse = await _callKimiApi(
        prompt: prompt,
        model: model,
        temperature: temperature,
        maxTokens: maxTokens,
        responseSchema: responseSchema,
        fileId: kimiFileId,
      );

      if (kimiResponse != null) {
        String responseText = kimiResponse;
        if (isAnalysis) {
          final parsedJson = _parseJsonSafely(kimiResponse, 'Kimi Analysis');
          if (parsedJson != null) {
            responseText = json.encode(parsedJson);
          } else {
            throw Exception('Kimi returned invalid JSON');
          }
        }
        developer.log('✅ Kimi succeeded');
        return _createMockGenerateContentResponse(responseText);
      }

      throw Exception('Kimi returned null');
    } catch (e) {
      onProviderError?.call('Kimi', e);
      return null;
    }
  }

  /// Run Cerebras provider (ultra-fast, text-only)
  /// Returns null if Cerebras fails or is not configured (doesn't throw)
  Future<dynamic> _runCerebras(
    String prompt, {
    required String model,
    required double temperature,
    required int maxTokens,
    Schema? responseSchema,
    required bool isAnalysis,
    void Function(String provider, Object error)? onProviderError,
  }) async {
    if (_cerebrasApiKey.isEmpty) {
      onProviderError?.call('Cerebras', Exception('API key not configured'));
      return null;
    }

    try {
      final cerebrasResponse = await _callCerebrasApi(
        prompt: prompt,
        model: model,
        temperature: temperature,
        maxTokens: maxTokens,
        responseSchema: responseSchema,
      );

      if (cerebrasResponse != null) {
        String responseText = cerebrasResponse;
        if (isAnalysis) {
          final parsedJson = _parseJsonSafely(cerebrasResponse, 'Cerebras Analysis');
          if (parsedJson != null) {
            responseText = json.encode(parsedJson);
          } else {
            throw Exception('Cerebras returned invalid JSON');
          }
        }
        developer.log('✅ Cerebras succeeded (ultra-fast)');
        return _createMockGenerateContentResponse(responseText);
      }

      throw Exception('Cerebras returned null');
    } catch (e) {
      onProviderError?.call('Cerebras', e);
      return null;
    }
  }

  /// Creates a mock response object that mimics GenerateContentResponse for fallback providers
  _MockGenerateContentResponse _createMockGenerateContentResponse(String text) {
    return _MockGenerateContentResponse(text);
  }

  /// Get file extension from MIME type
  String _getFileExtension(String mimeType) {
    switch (mimeType) {
      case 'application/pdf':
        return '.pdf';
      case 'image/jpeg':
        return '.jpg';
      case 'image/png':
        return '.png';
      case 'image/webp':
        return '.webp';
      default:
        return '.pdf';
    }
  }

  /// Read file bytes from local file path
  Future<List<int>?> _readLocalFileBytes(String localFilePath) async {
    try {
      final file = File(localFilePath);
      if (await file.exists()) {
        return await file.readAsBytes();
      }
      return null;
    } catch (e) {
      developer.log('Error reading file: $e');
      return null;
    }
  }

  /// Determine MIME type from file path
  String _getMimeTypeFromPath(String filePath) {
    final fileName = filePath.toLowerCase();

    if (fileName.endsWith('.pdf')) {
      return 'application/pdf';
    } else if (fileName.endsWith('.jpg') || fileName.endsWith('.jpeg')) {
      return 'image/jpeg';
    } else if (fileName.endsWith('.png')) {
      return 'image/png';
    } else if (fileName.endsWith('.webp')) {
      return 'image/webp';
    }

    // Default to PDF
    return 'application/pdf';
  }
}

/// Mock response class to mimic GenerateContentResponse for fallback providers
class _MockGenerateContentResponse {
  final String _text;

  _MockGenerateContentResponse(this._text);

  String? get text => _text;

  // Null prompt feedback to avoid errors when checking for block reasons
  dynamic get promptFeedback => null;
}

/// Custom exception for server-side AI errors
class ServerException implements Exception {
  final String message;
  const ServerException(this.message);

  @override
  String toString() => 'ServerException: $message';
}
