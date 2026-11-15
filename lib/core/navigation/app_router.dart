import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'dart:async';

import '../../core/design_system/index.dart';
import '../../core/extensions/context_extensions.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';
import '../../features/auth/presentation/screens/auth_screen.dart';
import '../../features/documents/presentation/screens/home_screen.dart';
import '../../features/documents/presentation/screens/upload_screen.dart';
import '../../features/documents/presentation/screens/my_documents_screen.dart';
import '../../features/documents/presentation/screens/document_details_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../core/di/injection.dart';
import '../../shared/widgets/index.dart';

/// A simple Listenable that notifies when auth state changes
class _AuthStateListenable extends ChangeNotifier {
  _AuthStateListenable(this._cubit) {
    _subscription = _cubit.stream.listen((_) => notifyListeners());
  }

  final AuthCubit _cubit;
  late final StreamSubscription _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}

/// Wara2tak App Router Configuration
/// Centralized routing using go_router for type-safe navigation
class AppRouter {
  AppRouter._();

  // ===========================================================================
  // Route Names
  // ===========================================================================

  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String auth = '/auth';
  static const String home = '/home';
  static const String upload = '/upload';
  static const String preview = '/preview';
  static const String analysisProgress = '/analysis-progress';
  static const String analysisError = '/analysis-error';
  static const String documentDetails = '/document/:documentId';
  static const String documentChat = '/document/:documentId/chat';
  static const String checklist = '/document/:documentId/checklist';
  static const String translation = '/document/:documentId/translate';
  static const String myDocuments = '/my-documents';
  static const String profile = '/profile';

  // ===========================================================================
  // Route Paths (for programmatic navigation)
  // ===========================================================================

  static String documentDetailsPath(String documentId) =>
      '/document/$documentId';

  static String documentChatPath(String documentId) =>
      '/document/$documentId/chat';

  static String checklistPath(String documentId) =>
      '/document/$documentId/checklist';

  static String translationPath(String documentId) =>
      '/document/$documentId/translate';

  // ===========================================================================
  // Router Configuration
  // ===========================================================================

  static final _authStateListenable = _AuthStateListenable(getIt<AuthCubit>());

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    debugLogDiagnostics: true,
    refreshListenable: _authStateListenable,
    routes: [
      // Splash Screen
      GoRoute(
        path: splash,
        name: 'splash',
        builder: (context, state) => const _SplashScreen(),
      ),

      // Onboarding
      GoRoute(
        path: onboarding,
        name: 'onboarding',
        builder: (context, state) => const _OnboardingScreen(),
      ),

      // Authentication
      GoRoute(
        path: auth,
        name: 'auth',
        builder: (context, state) => const AuthScreen(),
      ),

      // Home (Main Dashboard)
      GoRoute(
        path: home,
        name: 'home',
        builder: (context, state) => const HomeScreen(),
      ),

      // Upload Document (Step 1)
      GoRoute(
        path: upload,
        name: 'upload',
        builder: (context, state) => const UploadScreen(),
      ),

      // Preview/Confirm Document (Step 2)
      GoRoute(
        path: preview,
        name: 'preview',
        builder: (context, state) => const _PreviewScreen(),
      ),

      // Analysis Progress
      GoRoute(
        path: analysisProgress,
        name: 'analysisProgress',
        builder: (context, state) => const _AnalysisProgressScreen(),
      ),

      // Analysis Error
      GoRoute(
        path: analysisError,
        name: 'analysisError',
        builder: (context, state) => const _AnalysisErrorScreen(),
      ),

      // Document Details / Results
      GoRoute(
        path: documentDetails,
        name: 'documentDetails',
        builder: (context, state) {
          final documentId = state.pathParameters['documentId']!;
          return DocumentDetailsScreen(documentId: documentId);
        },
      ),

      // Document Chat
      GoRoute(
        path: documentChat,
        name: 'documentChat',
        builder: (context, state) {
          final documentId = state.pathParameters['documentId']!;
          return _DocumentChatScreen(documentId: documentId);
        },
      ),

      // Checklist
      GoRoute(
        path: checklist,
        name: 'checklist',
        builder: (context, state) {
          final documentId = state.pathParameters['documentId']!;
          return _ChecklistScreen(documentId: documentId);
        },
      ),

      // Translation
      GoRoute(
        path: translation,
        name: 'translation',
        builder: (context, state) {
          final documentId = state.pathParameters['documentId']!;
          return _TranslationScreen(documentId: documentId);
        },
      ),

      // My Documents
      GoRoute(
        path: myDocuments,
        name: 'myDocuments',
        builder: (context, state) => const MyDocumentsScreen(),
      ),

      // Profile/Settings
      GoRoute(
        path: profile,
        name: 'profile',
        builder: (context, state) => const ProfileScreen(),
      ),
    ],

    // Error handling
    errorBuilder: (context, state) => _ErrorScreen(error: state.error),

    // Redirect logic (auth guards)
    redirect: (context, state) {
      final authState = getIt<AuthCubit>().state;
      final isAuthenticated = authState is AuthAuthenticated;
      final isAuthRoute = state.matchedLocation == auth;
      final isSplashOrOnboarding = state.matchedLocation == splash || state.matchedLocation == onboarding;

      // If not authenticated and not on auth/splash/onboarding, redirect to auth
      if (!isAuthenticated && !isAuthRoute && !isSplashOrOnboarding) {
        return auth;
      }

      // If authenticated and on auth route, redirect to home
      if (isAuthenticated && isAuthRoute) {
        return home;
      }

      // If on splash and authenticated, go to home
      if (isAuthenticated && state.matchedLocation == splash) {
        return home;
      }

      // If on splash and not authenticated, go to onboarding (or auth)
      if (!isAuthenticated && state.matchedLocation == splash) {
        return onboarding; // or auth depending on flow
      }

      return null;
    },
  );

  // ===========================================================================
  // Navigation Helpers
  // ===========================================================================

  /// Navigate to a named route
  static void go(BuildContext context, String location) {
    context.go(location);
  }

  /// Push a named route onto the stack
  static void push(BuildContext context, String location) {
    context.push(location);
  }

  /// Replace current route with named route
  static void replace(BuildContext context, String location) {
    context.replace(location);
  }

  /// Pop current route
  static void pop(BuildContext context, [Object? result]) {
    context.pop(result);
  }

  /// Pop until a specific route
  static void popUntil(BuildContext context, String location) {
    while (context.canPop()) {
      if (GoRouterState.of(context).matchedLocation == location) break;
      context.pop();
    }
  }

  // ===========================================================================
  // Feature-specific Navigation Helpers
  // ===========================================================================

  static void goToHome(BuildContext context) => go(context, home);
  static void goToUpload(BuildContext context) => go(context, upload);
  static void goToMyDocuments(BuildContext context) => go(context, myDocuments);
  static void goToProfile(BuildContext context) => go(context, profile);
  static void goToAuth(BuildContext context) => go(context, auth);
  static void goToOnboarding(BuildContext context) => go(context, onboarding);

  static void goToDocumentDetails(BuildContext context, String documentId) =>
      go(context, documentDetailsPath(documentId));

  static void goToDocumentChat(BuildContext context, String documentId) =>
      go(context, documentChatPath(documentId));

  static void goToChecklist(BuildContext context, String documentId) =>
      go(context, checklistPath(documentId));

  static void goToTranslation(BuildContext context, String documentId) =>
      go(context, translationPath(documentId));

  static void goToAnalysisProgress(BuildContext context) =>
      go(context, analysisProgress);

  static void goToAnalysisError(BuildContext context) =>
      go(context, analysisError);

  static void goToPreview(BuildContext context) =>
      go(context, preview);

  // Push helpers (for modal-like flows)
  static void pushDocumentChat(BuildContext context, String documentId) =>
      push(context, documentChatPath(documentId));

  static void pushChecklist(BuildContext context, String documentId) =>
      push(context, checklistPath(documentId));

  static void pushTranslation(BuildContext context, String documentId) =>
      push(context, translationPath(documentId));
}

// ===========================================================================
// Placeholder Screen Widgets (to be replaced with actual implementations)
// ===========================================================================

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: context.colors.primaryContainer,
                borderRadius: BorderRadius.circular(AppShapes.radiusXl),
              ),
              child: Icon(
                Symbols.description,
                size: 40,
                color: context.colors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.spacingLg),
            Text(
              'Wara2tak',
              style: AppTypography.displayLargeMobile.copyWith(
                fontWeight: FontWeight.w700,
                color: context.colors.primary,
              ),
            ),
            const SizedBox(height: AppSpacing.spacingSm),
            Text(
              'AI Document Intelligence',
              style: AppTypography.bodyLarge.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: AppSpacing.spacingXl * 2),
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

class _OnboardingScreen extends StatelessWidget {
  const _OnboardingScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Spacer(),
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: context.colors.primaryContainer,
                  borderRadius: BorderRadius.circular(AppShapes.radiusXl),
                ),
                child: Icon(
                  Symbols.auto_awesome,
                  size: 50,
                  color: context.colors.primary,
                ),
              ),
              const SizedBox(height: AppSpacing.spacingXl),
              Text(
                'Welcome to Wara2tak',
                style: AppTypography.displayLargeMobile.copyWith(
                  fontWeight: FontWeight.w700,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.spacingLg),
              Text(
                'Upload your documents and let AI extract key clauses, deadlines, and financial obligations.',
                style: AppTypography.bodyLarge.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const Spacer(),
              PrimaryButton(
                label: 'Get Started',
                onPressed: () => AppRouter.goToAuth(context),
                isFullWidth: true,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PreviewScreen extends StatelessWidget {
  const _PreviewScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Document', style: AppTypography.titleLarge),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Symbols.picture_as_pdf, size: 64, color: context.colors.onSurfaceVariant),
            const SizedBox(height: AppSpacing.spacingLg),
            Text(
              'Preview Screen',
              style: AppTypography.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.spacingSm),
            Text(
              'Document preview and confirmation',
              style: AppTypography.bodyMedium.copyWith(color: context.colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalysisProgressScreen extends StatelessWidget {
  const _AnalysisProgressScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analyzing...', style: AppTypography.titleLarge),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: context.colors.primary),
            const SizedBox(height: AppSpacing.spacingXl),
            Text(
              'Analyzing Document',
              style: AppTypography.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.spacingSm),
            Text(
              'AI is extracting key clauses and obligations...',
              style: AppTypography.bodyMedium.copyWith(color: context.colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalysisErrorScreen extends StatelessWidget {
  const _AnalysisErrorScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Analysis Error', style: AppTypography.titleLarge),
      ),
      body: Center(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Symbols.error, size: 64, color: AppColors.error),
              const SizedBox(height: AppSpacing.spacingLg),
              Text(
                'Analysis Failed',
                style: AppTypography.headlineMedium.copyWith(color: AppColors.error),
              ),
              const SizedBox(height: AppSpacing.spacingSm),
              Text(
                'Something went wrong during analysis. Please try again.',
                style: AppTypography.bodyMedium.copyWith(color: context.colors.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.spacingXl),
              PrimaryButton(
                label: 'Retry',
                onPressed: () => AppRouter.goToUpload(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DocumentChatScreen extends StatelessWidget {
  final String documentId;
  const _DocumentChatScreen({required this.documentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Document Chat', style: AppTypography.titleLarge),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Symbols.chat, size: 64, color: context.colors.onSurfaceVariant),
            const SizedBox(height: AppSpacing.spacingLg),
            Text(
              'Chat with Document',
              style: AppTypography.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.spacingSm),
            Text(
              'Ask questions about document ID: $documentId',
              style: AppTypography.bodyMedium.copyWith(color: context.colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChecklistScreen extends StatelessWidget {
  final String documentId;
  const _ChecklistScreen({required this.documentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Checklist', style: AppTypography.titleLarge),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Symbols.checklist, size: 64, color: context.colors.onSurfaceVariant),
            const SizedBox(height: AppSpacing.spacingLg),
            Text(
              'Checklist',
              style: AppTypography.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.spacingSm),
            Text(
              'Generated checklist for document ID: $documentId',
              style: AppTypography.bodyMedium.copyWith(color: context.colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _TranslationScreen extends StatelessWidget {
  final String documentId;
  const _TranslationScreen({required this.documentId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Translate', style: AppTypography.titleLarge),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Symbols.translate, size: 64, color: context.colors.onSurfaceVariant),
            const SizedBox(height: AppSpacing.spacingLg),
            Text(
              'Translation',
              style: AppTypography.headlineMedium,
            ),
            const SizedBox(height: AppSpacing.spacingSm),
            Text(
              'Translate document ID: $documentId',
              style: AppTypography.bodyMedium.copyWith(color: context.colors.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  final Exception? error;
  const _ErrorScreen({this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Error', style: AppTypography.titleLarge),
      ),
      body: Center(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Symbols.error, size: 64, color: AppColors.error),
              const SizedBox(height: AppSpacing.spacingLg),
              Text(
                'Something went wrong',
                style: AppTypography.headlineMedium,
              ),
              const SizedBox(height: AppSpacing.spacingSm),
              Text(
                error?.toString() ?? 'Unknown error',
                style: AppTypography.bodyMedium.copyWith(color: context.colors.onSurfaceVariant),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppSpacing.spacingXl),
              PrimaryButton(
                label: 'Go Home',
                onPressed: () => AppRouter.goToHome(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}