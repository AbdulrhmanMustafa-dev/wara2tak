import 'dart:developer';

import 'package:get_it/get_it.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/services/supabase_database_service.dart';
import '../../core/services/supabase_storage_service.dart';
import '../../features/analysis/domain/repositories/ai_repository.dart';
import '../../features/analysis/presentation/cubit/analysis_cubit.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/data/repositories/mock_auth_repository.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/chat/domain/repositories/chat_repository.dart';
import '../../features/chat/presentation/cubit/chat_cubit.dart';
import '../../features/checklist/domain/repositories/checklist_repository.dart';
import '../../features/checklist/presentation/cubit/checklist_cubit.dart';
import '../../features/documents/domain/repositories/document_repository.dart';
import '../../features/documents/presentation/cubit/document_cubit.dart';
import '../../features/documents/presentation/cubit/home_cubit.dart';
import '../../features/profile/domain/repositories/profile_repository.dart';
import '../../features/profile/presentation/cubit/profile_cubit.dart';
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

/// Register repositories
void _registerRepositories() {
  try {
    if (getIt.isRegistered<SupabaseClient>()) {
      getIt.registerLazySingleton<AuthRepository>(
        () =>
            AuthRepositoryImpl(supabaseClient: getIt(), googleSignIn: getIt()),
      );
      log('Supabase AuthRepository registered');
    } else {
      throw StateError('Supabase not initialized');
    }
  } catch (e) {
    log('Using MockAuthRepository for development: $e');
    getIt.registerLazySingleton<AuthRepository>(() => MockAuthRepository());
  }

  // تسجيل باقي الـ Repositories عشان الـ Cubits تشتغل
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

/// Register Cubits/Blocs
void _registerCubits() {
  // Auth cubit
  // استخدمنا LazySingleton عشان تكون نسخة واحدة بس مشتركة بين الـ UI والـ Router
  getIt.registerLazySingleton<AuthCubit>(() => AuthCubit(getIt()));

  // Document cubit
  getIt.registerFactory<DocumentCubit>(() => DocumentCubit(getIt()));

  // Home cubit
  getIt.registerFactory<HomeCubit>(() => HomeCubit(getIt()));

  // Analysis cubit
  getIt.registerFactory<AnalysisCubit>(() => AnalysisCubit(getIt()));

  // Checklist cubit
  getIt.registerFactory<ChecklistCubit>(() => ChecklistCubit(getIt()));

  // Chat cubit
  getIt.registerFactory<ChatCubit>(() => ChatCubit(getIt()));

  // Translation cubit
  getIt.registerFactory<TranslationCubit>(() => TranslationCubit(getIt()));

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
