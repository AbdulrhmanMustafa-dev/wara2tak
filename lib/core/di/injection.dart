import 'dart:developer';

import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/services/supabase_database_service.dart';
import '../../core/services/supabase_storage_service.dart';
import '../../core/l10n/locale_cubit.dart';
import '../../features/analysis/data/repositories/ai_repository_impl.dart';
import '../../features/analysis/domain/repositories/ai_repository.dart';
import '../../features/analysis/presentation/cubit/analysis_cubit.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/data/repositories/mock_auth_repository.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/chat/data/repositories/chat_repository_impl.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/chat/presentation/cubit/chat_cubit.dart';
import '../../features/checklist/data/repositories/checklist_repository_impl.dart';
import '../../features/checklist/domain/repositories/checklist_repository.dart';
import '../../features/checklist/presentation/cubit/checklist_cubit.dart';
import '../../features/documents/data/repositories/document_repository_impl.dart';
import '../../features/documents/domain/repositories/document_repository.dart';
import '../../features/documents/presentation/cubit/document_cubit.dart';
import '../../features/documents/presentation/cubit/home_cubit.dart';
import '../../features/profile/data/repositories/profile_repository_impl.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
import '../../features/translation/data/repositories/translation_repository_impl.dart';
import '../../features/translation/domain/repositories/translation_repository.dart';
import '../../features/translation/presentation/cubit/translation_cubit.dart';
import '../../supabase_config.dart';
import 'mock_repositories.dart';

/// Global GetIt instance for dependency injection
final getIt = GetIt.instance;

/// Initialize all dependencies
Future<void> initializeDependencies({required bool supabaseAvailable}) async {
  // Core services
  await _registerCoreServices(supabaseAvailable: supabaseAvailable);

  // Repositories
  _registerRepositories();

  // Cubits/Blocs
  _registerCubits();

  // Use cases
  _registerUseCases();
}

/// Register core services (Supabase, API clients, etc.)
Future<void> _registerCoreServices({required bool supabaseAvailable}) async {
  // Register SharedPreferences (needed for LocaleCubit)
  final prefs = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => prefs);

  if (supabaseAvailable) {
    try {
      getIt.registerLazySingleton<SupabaseClient>(
        () => Supabase.instance.client,
      );
      getIt.registerLazySingleton<GoTrueClient>(
        () => Supabase.instance.client.auth,
      );
      getIt.registerLazySingleton<SupabaseStorageClient>(
        () => Supabase.instance.client.storage,
      );
      getIt.registerLazySingleton<GoogleSignIn>(
        () => GoogleSignIn(
          serverClientId: SupabaseConfig.supabaseUrl.contains('supabase.co')
              ? '471240171200-74earbu056i61eav87pdtn0el3sjvcbf.apps.googleusercontent.com'
              : null,
        ),
      );

      // Custom services
      getIt.registerLazySingleton<SupabaseDatabaseService>(
        () => SupabaseDatabaseService(getIt<SupabaseClient>()),
      );
      getIt.registerLazySingleton<SupabaseStorageService>(
        () => SupabaseStorageService(getIt<SupabaseStorageClient>()),
      );

      log('Supabase services registered');
    } catch (e) {
      log('Supabase services registration failed: $e');
      // Repositories will use mock implementations
    }
  } else {
    log('Supabase not available, skipping Supabase services registration');
  }
}

/// Validate API keys at startup
void _validateApiKeys() {
  // Validate Gemini API key
  final geminiKey = SupabaseConfig.geminiApiKey;
  if (!SupabaseConfig.isGeminiConfigured || geminiKey.isEmpty) {
    final error = 'GEMINI_API_KEY is not configured. Set it in supabase_config.dart or via --dart-define.';
    if (kDebugMode) {
      log('❌ $error');
    }
    throw StateError(error);
  }
  if (kDebugMode) {
    final maskedKey = geminiKey.length > 4 ? '${geminiKey.substring(0, 4)}...${geminiKey.substring(geminiKey.length - 4)}' : '****';
    log('✅ GEMINI_API_KEY configured: $maskedKey');
  }

  // Validate Kimi API key
  final kimiKey = SupabaseConfig.kimiApiKey;
  if (!SupabaseConfig.isKimiConfigured || kimiKey.isEmpty) {
    final warning = 'KIMI_API_KEY is not configured. Fallback AI provider will be unavailable.';
    if (kDebugMode) {
      log('⚠️ $warning');
    }
  } else if (kDebugMode) {
    final maskedKey = kimiKey.length > 4 ? '${kimiKey.substring(0, 4)}...${kimiKey.substring(kimiKey.length - 4)}' : '****';
    log('✅ KIMI_API_KEY configured: $maskedKey');
  }

  // Validate Cerebras API key
  final cerebrasKey = SupabaseConfig.cerebrasApiKey;
  if (!SupabaseConfig.isCerebrasConfigured || cerebrasKey.isEmpty) {
    final warning = 'CEREBRAS_API_KEY is not configured. Ultra-fast inference will be unavailable.';
    if (kDebugMode) {
      log('⚠️ $warning');
    }
  } else if (kDebugMode) {
    final maskedKey = cerebrasKey.length > 4 ? '${cerebrasKey.substring(0, 4)}...${cerebrasKey.substring(cerebrasKey.length - 4)}' : '****';
    log('✅ CEREBRAS_API_KEY configured: $maskedKey');
  }
}

/// Register repositories
void _registerRepositories() {
  try {
    if (getIt.isRegistered<SupabaseClient>()) {
      // Validate API keys before registering AI repository
      _validateApiKeys();

      getIt.registerLazySingleton<AuthRepository>(
        () =>
            AuthRepositoryImpl(supabaseClient: getIt(), googleSignIn: getIt()),
      );
      getIt.registerLazySingleton<DocumentRepository>(
        () => DocumentRepositoryImpl(getIt<SupabaseClient>()),
      );
      getIt.registerLazySingleton<ProfileRepository>(
        () => ProfileRepositoryImpl(getIt<SupabaseClient>()),
      );
      getIt.registerLazySingleton<ChecklistRepository>(
        () => ChecklistRepositoryImpl(getIt<SupabaseClient>()),
      );
      getIt.registerLazySingleton<ChatRepository>(
        () => ChatRepositoryImpl(getIt<SupabaseClient>()),
      );
      getIt.registerLazySingleton<TranslationRepository>(
        () => TranslationRepositoryImpl(getIt<SupabaseClient>()),
      );
      // AI Repository - uses Gemini 3.0 Flash via google_generative_ai with Kimi & Cerebras fallback
      getIt.registerLazySingleton<AIRepository>(
        () => AIRepositoryImpl(
          geminiApiKey: SupabaseConfig.geminiApiKey,
          kimiApiKey: SupabaseConfig.kimiApiKey,
          cerebrasApiKey: SupabaseConfig.cerebrasApiKey,
        ),
      );
      log('Supabase repositories registered');
    } else {
      throw StateError('Supabase not initialized');
    }
  } catch (e) {
    log('Using Mock repositories for development: $e');
    getIt.registerLazySingleton<AuthRepository>(() => MockAuthRepository());
    getIt.registerLazySingleton<DocumentRepository>(
      () => MockDocumentRepository(),
    );
    getIt.registerLazySingleton<AIRepository>(() => MockAIRepository());
    getIt.registerLazySingleton<ChecklistRepository>(
      () => MockChecklistRepository(),
    );
    getIt.registerLazySingleton<ChatRepository>(() => MockChatRepository());
    getIt.registerLazySingleton<TranslationRepository>(
      () => MockTranslationRepository(),
    );
    getIt.registerLazySingleton<ProfileRepository>(() => MockProfileRepository());
  }
}

/// Register Cubits/Blocs
void _registerCubits() {
  // Locale cubit (must be registered first for app initialization)
  getIt.registerLazySingleton<LocaleCubit>(() => LocaleCubit(getIt<SharedPreferences>()));

  // Auth cubit
  // استخدمنا LazySingleton عشان تكون نسخة واحدة بس مشتركة بين الـ UI والـ Router
  getIt.registerLazySingleton<AuthCubit>(() => AuthCubit(getIt()));

  // Document cubit
  getIt.registerFactory<DocumentCubit>(() => DocumentCubit(getIt()));

  // Home cubit
  getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt()));

  // Analysis cubit
  getIt.registerFactory<AnalysisCubit>(
    () => AnalysisCubit(getIt<AIRepository>(), getIt<DocumentRepository>()),
  );

  // Checklist cubit
  getIt.registerFactory<ChecklistCubit>(() => ChecklistCubit(getIt(), getIt()));

  // Chat cubit
  getIt.registerFactory<ChatCubit>(() => ChatCubit(getIt()));

  // Translation cubit
  getIt.registerFactory<TranslationCubit>(
    () => TranslationCubit(getIt<TranslationRepository>(), getIt<AIRepository>()),
  );

  // Profile cubit
  getIt.registerFactory<ProfileCubit>(() => ProfileCubit(getIt()));
}

/// Register Use Cases
void _registerUseCases() {
  // TODO: Register use cases
  // getIt.registerLazySingleton<SignInWithGoogleUseCase>(() => SignInWithGoogleUseCase(getIt()));
  // getIt.registerLazySingleton<UploadDocumentUseCase>(() => UploadDocumentUseCase(getIt()));
  // getIt.registerLazySingleton<AnalyzeDocumentUseCase>(() => AnalyzeDocumentUseCase(getIt()));
}

/// Reset all dependencies (useful for testing)
void resetDependencies() {
  getIt.reset();
}
