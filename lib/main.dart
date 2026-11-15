import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'core/design_system/index.dart';
import 'core/di/injection.dart';
import 'core/navigation/app_router.dart';
import 'features/index.dart';
import 'supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase (optional for development without Supabase project)
  bool supabaseInitialized = false;
  try {
    await SupabaseConfig.loadEnv();
    await SupabaseConfig.initialize();
    await Supabase.initialize(
      url: SupabaseConfig.supabaseUrl,
      publishableKey: SupabaseConfig.supabaseAnonKey,
    );
    supabaseInitialized = true;
    debugPrint('Supabase initialized successfully');
  } catch (e) {
    debugPrint('Supabase initialization failed (expected in development): $e');
  }

  // Initialize dependencies (pass whether Supabase is available)
  await initializeDependencies(supabaseAvailable: supabaseInitialized);

  runApp(const Wara2takApp());
}

/// Main app widget
class Wara2takApp extends StatelessWidget {
  const Wara2takApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthCubit>.value(value: getIt<AuthCubit>()),
        BlocProvider<DocumentCubit>(
          create: (_) {
            final cubit = getIt<DocumentCubit>();
            final authState = getIt<AuthCubit>().state;
            if (authState is AuthAuthenticated) {
              cubit.loadUserDocuments(authState.user.id);
            }
            return cubit;
          },
        ),
        BlocProvider<HomeCubit>(
          create: (_) {
            final cubit = getIt<HomeCubit>();
            final authState = getIt<AuthCubit>().state;
            if (authState is AuthAuthenticated) {
              cubit.loadDashboard(authState.user.id);
            }
            return cubit;
          },
        ),
        BlocProvider<AnalysisCubit>(create: (_) => getIt<AnalysisCubit>()),
        BlocProvider<ChecklistCubit>(create: (_) => getIt<ChecklistCubit>()),
        BlocProvider<ChatCubit>(create: (_) => getIt<ChatCubit>()),
        BlocProvider<TranslationCubit>(
          create: (_) => getIt<TranslationCubit>(),
        ),
        BlocProvider<ProfileCubit>(create: (_) => getIt<ProfileCubit>()),
      ],
      child: MaterialApp.router(
        title: 'Wara2tak',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeMode.system,
        routerConfig: AppRouter.router,
        builder: (context, child) {
          // Apply Google Fonts globally
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(
              textScaler: TextScaler.linear(
                MediaQuery.of(context).textScaler.scale(1.0),
              ),
            ),
            child: child!,
          );
        },
      ),
    );
  }
}
