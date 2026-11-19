import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:material_ui/material_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthState; // Hide Supabase's AuthState to avoid conflict with our AuthCubit's AuthState

import 'core/design_system/index.dart';
import 'core/di/injection.dart';
import 'core/l10n/locale_cubit.dart';
import 'core/navigation/app_router.dart';
import 'features/index.dart';
import 'generated/l10n/app_localizations.dart';
import 'supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting();

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
        BlocProvider<LocaleCubit>.value(value: getIt<LocaleCubit>()),
        BlocProvider<AuthCubit>.value(value: getIt<AuthCubit>()),
        BlocProvider<DocumentCubit>(create: (_) => getIt<DocumentCubit>()),
        BlocProvider<HomeCubit>(create: (_) => getIt<HomeCubit>()),
        BlocProvider<AnalysisCubit>(create: (_) => getIt<AnalysisCubit>()),
        BlocProvider<ChecklistCubit>(create: (_) => getIt<ChecklistCubit>()),
        BlocProvider<ChatCubit>(create: (_) => getIt<ChatCubit>()),
        BlocProvider<TranslationCubit>(
          create: (_) => getIt<TranslationCubit>(),
        ),
        BlocProvider<ProfileCubit>(create: (_) => getIt<ProfileCubit>()),
      ],
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            // Trigger data loading when user authenticates
            context.read<DocumentCubit>().loadUserDocuments(state.user.id);
            context.read<HomeCubit>().loadDashboard(state.user.id);
            context.read<ProfileCubit>().loadProfile(state.user.id);
          } else if (state is AuthUnauthenticated) {
            // Clear data when user signs out
            // Cubits will reset to initial state on next load
          }
        },
        child: BlocBuilder<ProfileCubit, ProfileState>(
          builder: (context, profileState) {
            // Determine theme mode from profile
            ThemeMode themeMode = ThemeMode.system;

            if (profileState is ProfileLoaded) {
              final profile = profileState.profile;
              themeMode = profile.isDarkMode ? ThemeMode.dark : ThemeMode.light;
            }

            return BlocBuilder<LocaleCubit, LocaleState>(
              builder: (context, localeState) {
                return MaterialApp.router(
                  title: 'Wara2tak',
                  debugShowCheckedModeBanner: false,
                  theme: AppTheme.lightTheme,
                  darkTheme: AppTheme.darkTheme,
                  themeMode: themeMode,
                  locale: localeState is LocaleLoaded ? localeState.locale : null,
                  supportedLocales: AppLocalizations.supportedLocales,
                  // Use material_ui's delegates so MaterialLocalizations matches
                  // the Material widgets imported from that package.
                  localizationsDelegates: [
                    AppLocalizations.delegate,
                    ...GlobalMaterialLocalizations.delegates,
                  ],
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
                );
              },
            );
          },
        ),
      ),
    );
  }
}
