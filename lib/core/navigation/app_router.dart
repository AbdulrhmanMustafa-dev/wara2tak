import 'dart:async';

import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:uuid/uuid.dart';

import '../../core/design_system/index.dart';
import '../../core/di/injection.dart';
import '../../core/extensions/context_extensions.dart';
import '../../features/analysis/presentation/cubit/analysis_cubit.dart';
import '../../features/analysis/presentation/cubit/analysis_state.dart';
import '../../features/auth/presentation/cubit/auth_cubit.dart';
import '../../features/auth/presentation/cubit/auth_state.dart';
import '../../features/auth/presentation/screens/auth_screen.dart';
import '../../features/checklist/domain/models/checklist_model.dart' as checklist_models;
import '../../features/checklist/presentation/cubit/checklist_cubit.dart';
import '../../features/checklist/presentation/cubit/checklist_state.dart' as checklist_state;
import '../../features/chat/domain/models/chat_model.dart';
import '../../features/chat/presentation/cubit/chat_cubit.dart';
import '../../features/chat/presentation/cubit/chat_state.dart';
import '../../features/documents/domain/models/analysis_model.dart' as doc_models;
import '../../features/documents/presentation/cubit/document_cubit.dart';
import '../../features/documents/presentation/cubit/document_state.dart';
import '../../features/documents/presentation/screens/document_details_screen.dart';
import '../../features/documents/presentation/screens/home_screen.dart';
import '../../features/documents/presentation/screens/my_documents_screen.dart';
import '../../features/documents/presentation/screens/upload_screen.dart';
import '../../features/profile/presentation/screens/profile_screen.dart';
import '../../features/translation/domain/models/translation_model.dart' as translation_models;
import '../../features/translation/presentation/cubit/translation_cubit.dart';
import '../../features/translation/presentation/cubit/translation_state.dart' as translation_state;
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
      if (state.matchedLocation == splash &&
          (authState is AuthInitial || authState is AuthLoading)) {
        return null;
      }

      final isAuthenticated = authState is AuthAuthenticated;
      final isAuthRoute = state.matchedLocation == auth;
      final isSplashOrOnboarding =
          state.matchedLocation == splash ||
          state.matchedLocation == onboarding;

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

  // Main tabs and root screens - use go() to replace the stack
  static void goToHome(BuildContext context) => go(context, home);
  static void goToMyDocuments(BuildContext context) => go(context, myDocuments);
  static void goToProfile(BuildContext context) => go(context, profile);
  static void goToAuth(BuildContext context) => go(context, auth);
  static void goToOnboarding(BuildContext context) => go(context, onboarding);
  static void goToUpload(BuildContext context) =>
      go(context, upload); // Upload is a main tab

  // Sub-screens and flows - use push() to preserve the navigation stack
  static void goToDocumentDetails(BuildContext context, String documentId) =>
      push(context, documentDetailsPath(documentId));

  static void goToDocumentChat(BuildContext context, String documentId) =>
      push(context, documentChatPath(documentId));

  static void goToChecklist(BuildContext context, String documentId) =>
      push(context, checklistPath(documentId));

  static void goToTranslation(BuildContext context, String documentId) =>
      push(context, translationPath(documentId));

  static void goToAnalysisProgress(BuildContext context) =>
      push(context, analysisProgress);

  static void goToAnalysisError(BuildContext context) =>
      push(context, analysisError);

  static void goToPreview(BuildContext context) => push(context, preview);
}

// ===========================================================================
// Placeholder Screen Widgets (to be replaced with actual implementations)
// ===========================================================================

class _SplashScreen extends StatefulWidget {
  const _SplashScreen();

  @override
  State<_SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<_SplashScreen>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    )..repeat();
    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isDark = colors.brightness == Brightness.dark;
    final background = isDark
        ? const Color(0xFF0F172A)
        : const Color(0xFFF8FAFC);

    return Scaffold(
      backgroundColor: background,
      body: Stack(
        alignment: Alignment.center,
        children: [
          Positioned(
            top: MediaQuery.sizeOf(context).height * 0.24,
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: colors.primary.withValues(alpha: isDark ? 0.1 : 0.08),
                boxShadow: [
                  BoxShadow(
                    color: colors.primary.withValues(
                      alpha: isDark ? 0.12 : 0.1,
                    ),
                    blurRadius: 90,
                    spreadRadius: 25,
                  ),
                ],
              ),
            ),
          ),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  const Spacer(),
                  SizedBox(
                    width: 148,
                    height: 148,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        AnimatedBuilder(
                          animation: _pulseController,
                          builder: (context, child) {
                            final progress = _pulseController.value;
                            return Opacity(
                              opacity: 0.38 * (1 - progress),
                              child: Transform.scale(
                                scale: 0.78 + progress * 0.42,
                                child: child,
                              ),
                            );
                          },
                          child: Container(
                            width: 116,
                            height: 116,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(32),
                              border: Border.all(
                                color: colors.primary,
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                        AnimatedBuilder(
                          animation: _floatController,
                          builder: (context, child) => Transform.translate(
                            offset: Offset(
                              0,
                              -4 *
                                  Curves.easeInOut.transform(
                                    _floatController.value,
                                  ),
                            ),
                            child: child,
                          ),
                          child: Container(
                            width: 100,
                            height: 100,
                            padding: const EdgeInsets.all(17),
                            decoration: BoxDecoration(
                              color: isDark ? colors.surface : Colors.white,
                              borderRadius: BorderRadius.circular(27),
                              border: Border.all(color: colors.outlineVariant),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(
                                    alpha: isDark ? 0.2 : 0.06,
                                  ),
                                  blurRadius: 24,
                                  offset: const Offset(0, 12),
                                ),
                              ],
                            ),
                            child: SvgPicture.asset(
                              'assets/images/wara2tak_brand_mark.svg',
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 28),
                  Text(
                    'ورقتك',
                    textDirection: TextDirection.rtl,
                    style: AppTypography.displayLarge.copyWith(
                      color: colors.onSurface,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Wara2tak',
                    style: AppTypography.headlineSmall.copyWith(
                      color: colors.primary,
                      letterSpacing: 0.7,
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    'Understand every document. Plan your next step.',
                    textAlign: TextAlign.center,
                    style: AppTypography.bodyMedium.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                  ),
                  const Spacer(),
                  SizedBox(
                    width: 112,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(99),
                      child: LinearProgressIndicator(
                        minHeight: 4,
                        backgroundColor: colors.primary.withValues(alpha: 0.14),
                        color: colors.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'PREPARING YOUR WORKSPACE',
                    style: AppTypography.labelSmall.copyWith(
                      color: colors.onSurfaceVariant,
                      letterSpacing: 1.1,
                    ),
                  ),
                  const SizedBox(height: 34),
                ],
              ),
            ),
          ),
        ],
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
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(AppShapes.radiusXl),
                ),
                child: Icon(
                  Symbols.auto_awesome,
                  size: 50,
                  color: Theme.of(context).colorScheme.primary,
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
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
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
            Icon(
              Symbols.picture_as_pdf,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: AppSpacing.spacingLg),
            Text('Preview Screen', style: AppTypography.headlineMedium),
            const SizedBox(height: AppSpacing.spacingSm),
            Text(
              'Document preview and confirmation',
              style: AppTypography.bodyMedium.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
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
    return BlocConsumer<AnalysisCubit, AnalysisState>(
      listener: (context, state) {
        if (state is AnalysisCompleted) {
          // Use context.go() to replace the progress screen with document details
          // This properly clears the progress screen from the stack
          context.go(AppRouter.documentDetailsPath(state.analysis.documentId));
        } else if (state is AnalysisError) {
          // For errors, replace current route with error screen
          context.go(AppRouter.analysisError);
        }
      },
      builder: (context, state) {
        int progress = 0;
        String message = 'Starting analysis...';

        if (state is AnalysisProgress) {
          progress = state.progress;
          message = state.message ?? message;
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Analyzing...', style: AppTypography.titleLarge),
            automaticallyImplyLeading:
                false, // Prevent backing out during analysis
          ),
          body: Center(
            child: Padding(
              padding: AppSpacing.screenPadding,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: AppSpacing.spacingXl),
                  Text(
                    '$progress%',
                    style: AppTypography.displayLargeMobile.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spacingSm),
                  Text(
                    'Analyzing Document',
                    style: AppTypography.headlineMedium,
                  ),
                  const SizedBox(height: AppSpacing.spacingSm),
                  Text(
                    message,
                    style: AppTypography.bodyMedium.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _AnalysisErrorScreen extends StatelessWidget {
  const _AnalysisErrorScreen();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AnalysisCubit, AnalysisState>(
      builder: (context, state) {
        final errorMessage = state is AnalysisError
            ? state.message
            : 'Something went wrong during analysis. Please try again.';
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
                    style: AppTypography.headlineMedium.copyWith(
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spacingSm),
                  Text(
                    errorMessage,
                    style: AppTypography.bodyMedium.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppSpacing.spacingXl),
                  PrimaryButton(
                    label: 'Retry',
                    onPressed: () {
                      final analysisCubit = context.read<AnalysisCubit>();
                      if (!analysisCubit.canRetryLastAnalysis) {
                        AppRouter.goToUpload(context);
                        return;
                      }

                      unawaited(analysisCubit.retryLastAnalysis());
                      AppRouter.goToAnalysisProgress(context);
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// ===========================================================================
// Full Screen Implementations
// ===========================================================================

/// Checklist Screen - Full interactive implementation
class _ChecklistScreen extends StatefulWidget {
  final String documentId;
  const _ChecklistScreen({required this.documentId});

  @override
  State<_ChecklistScreen> createState() => _ChecklistScreenState();
}

class _ChecklistScreenState extends State<_ChecklistScreen> {
  final _uuid = const Uuid();

  @override
  void initState() {
    super.initState();
    _loadChecklist();
  }

  Future<void> _loadChecklist() async {
    final checklistCubit = context.read<ChecklistCubit>();
    await checklistCubit.loadChecklist(widget.documentId);

    // Check if checklist is empty and needs to be generated from analysis
    if (!mounted) return;
    final state = checklistCubit.state;
    if (state is checklist_state.ChecklistLoaded && state.items.isEmpty) {
      await _generateChecklistFromAnalysis();
    }
  }

  Future<void> _generateChecklistFromAnalysis() async {
    final documentCubit = context.read<DocumentCubit>();
    final documentState = documentCubit.state;

    if (documentState is DocumentLoaded && documentState.analysis != null) {
      final analysis = documentState.analysis!;
      final checklistItems = <checklist_models.ChecklistItemModel>[];

      // Generate from summary
      if (analysis.summary != null && analysis.summary!.isNotEmpty) {
        checklistItems.add(checklist_models.ChecklistItemModel(
          id: _uuid.v4(),
          title: 'Review Document Summary',
          description: analysis.summary!,
          isCompleted: false,
          category: checklist_models.ChecklistCategory.beforeSigning,
          priority: 1,
          pageNumber: null,
        ));
      }

      // Generate from deadlines
      for (final deadline in analysis.deadlines) {
        checklistItems.add(checklist_models.ChecklistItemModel(
          id: _uuid.v4(),
          title: deadline.title,
          description: deadline.description,
          isCompleted: false,
          category: checklist_models.ChecklistCategory.ongoing,
          priority: 1,
          dueDate: deadline.dueDate,
          pageNumber: deadline.pageNumber,
        ));
      }

      // Generate from financial obligations
      for (final financial in analysis.financialObligations) {
        checklistItems.add(checklist_models.ChecklistItemModel(
          id: _uuid.v4(),
          title: 'Financial: ${financial.title}',
          description: financial.description,
          isCompleted: false,
          category: checklist_models.ChecklistCategory.financial,
          priority: 1,
          dueDate: financial.dueDate,
          pageNumber: financial.pageNumber,
        ));
      }

      // Generate from key clauses (critical and high importance)
      for (final clause in analysis.keyClauses.where(
          (c) => c.importance == doc_models.ClauseImportance.critical ||
              c.importance == doc_models.ClauseImportance.high)) {
        checklistItems.add(checklist_models.ChecklistItemModel(
          id: _uuid.v4(),
          title: 'Review: ${clause.title}',
          description: clause.description,
          isCompleted: false,
          category: checklist_models.ChecklistCategory.legal,
          priority: clause.importance == doc_models.ClauseImportance.critical ? 1 : 2,
          pageNumber: clause.pageNumber,
          relatedClauseId: clause.id,
        ));
      }

      // Generate from red flags
      for (final flag in analysis.redFlags) {
        checklistItems.add(checklist_models.ChecklistItemModel(
          id: _uuid.v4(),
          title: 'Red Flag: ${flag.title}',
          description: flag.description,
          isCompleted: false,
          category: checklist_models.ChecklistCategory.legal,
          priority: flag.severity == doc_models.RedFlagSeverity.critical ? 1 : 2,
          pageNumber: flag.pageNumber,
        ));
      }

      // Save generated checklist
      if (checklistItems.isNotEmpty) {
        final checklistCubit = context.read<ChecklistCubit>();
        await checklistCubit.saveChecklist(widget.documentId, checklistItems);
      }
    }
  }

  Future<void> _showAddTaskDialog() async {
    final titleController = TextEditingController();
    final descriptionController = TextEditingController();
    checklist_models.ChecklistCategory selectedCategory = checklist_models.ChecklistCategory.other;
    int? selectedPriority;
    DateTime? selectedDueDate;

    await showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text('Add Task', style: AppTypography.headlineSmall),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleController,
                  decoration: const InputDecoration(labelText: 'Task Title'),
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: AppSpacing.spacingMd),
                TextField(
                  controller: descriptionController,
                  decoration: const InputDecoration(labelText: 'Description (optional)'),
                  maxLines: 3,
                  textCapitalization: TextCapitalization.sentences,
                ),
                const SizedBox(height: AppSpacing.spacingMd),
                DropdownButtonFormField<checklist_models.ChecklistCategory>(
                  initialValue: selectedCategory,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: checklist_models.ChecklistCategory.values
                      .map((c) => DropdownMenuItem(
                            value: c,
                            child: Text(c.name.toUpperCase()),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => selectedCategory = v!),
                ),
                const SizedBox(height: AppSpacing.spacingMd),
                DropdownButtonFormField<int?>(
                  initialValue: selectedPriority,
                  decoration: const InputDecoration(labelText: 'Priority (1-5, optional)'),
                  items: [null, 1, 2, 3, 4, 5]
                      .map((p) => DropdownMenuItem(
                            value: p,
                            child: Text(p == null ? 'None' : 'Priority $p'),
                          ))
                      .toList(),
                  onChanged: (v) => setState(() => selectedPriority = v),
                ),
                const SizedBox(height: AppSpacing.spacingMd),
                ListTile(
                  title: Text(selectedDueDate == null
                      ? 'Set Due Date (optional)'
                      : 'Due: ${selectedDueDate!.day}/${selectedDueDate!.month}/${selectedDueDate!.year}'),
                  trailing: Icon(Symbols.calendar_today, color: Theme.of(context).colorScheme.primary),
                  onTap: () async {
                    final date = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (date != null) setState(() => selectedDueDate = date);
                  },
                ),
              ],
            ),
          ),
          actions: [
            TertiaryButton(
              label: 'Cancel',
              onPressed: () => Navigator.pop(context),
            ),
            PrimaryButton(
              label: 'Add',
              onPressed: () {
                if (titleController.text.trim().isEmpty) return;
                Navigator.pop(context);
                _addCustomTask(
                  title: titleController.text.trim(),
                  description: descriptionController.text.trim(),
                  category: selectedCategory,
                  priority: selectedPriority,
                  dueDate: selectedDueDate,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addCustomTask({
    required String title,
    required String description,
    required checklist_models.ChecklistCategory category,
    int? priority,
    DateTime? dueDate,
  }) async {
    final newItem = checklist_models.ChecklistItemModel(
      id: _uuid.v4(),
      title: title,
      description: description,
      isCompleted: false,
      category: category,
      priority: priority,
      dueDate: dueDate,
    );

    final checklistCubit = context.read<ChecklistCubit>();
    final currentState = checklistCubit.state;
    if (currentState is checklist_state.ChecklistLoaded) {
      final updatedItems = [...currentState.items, newItem];
      await checklistCubit.saveChecklist(widget.documentId, updatedItems);
    }
  }

  Future<void> _confirmDeleteItem(checklist_models.ChecklistItemModel item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Task', style: AppTypography.headlineSmall),
        content: Text('Are you sure you want to delete "${item.title}"?', style: AppTypography.bodyMedium),
        actions: [
          TertiaryButton(label: 'Cancel', onPressed: () => Navigator.pop(context, false)),
          FilledDestructiveButton(
            label: 'Delete',
            onPressed: () => Navigator.pop(context, true),
            leadingIcon: Symbols.delete,
          ),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final checklistCubit = context.read<ChecklistCubit>();
      final currentState = checklistCubit.state;
      if (currentState is checklist_state.ChecklistLoaded) {
        final updatedItems = currentState.items.where((i) => i.id != item.id).toList();
        await checklistCubit.saveChecklist(widget.documentId, updatedItems);
      }
    }
  }

  String _getCategoryLabel(checklist_models.ChecklistCategory category) {
    switch (category) {
      case checklist_models.ChecklistCategory.beforeSigning:
        return 'Before Signing';
      case checklist_models.ChecklistCategory.afterSigning:
        return 'After Signing';
      case checklist_models.ChecklistCategory.ongoing:
        return 'Ongoing';
      case checklist_models.ChecklistCategory.legal:
        return 'Legal';
      case checklist_models.ChecklistCategory.financial:
        return 'Financial';
      case checklist_models.ChecklistCategory.other:
        return 'Other';
    }
  }

  Color _getCategoryColor(checklist_models.ChecklistCategory category, BuildContext context) {
    switch (category) {
      case checklist_models.ChecklistCategory.beforeSigning:
        return context.colors.primary;
      case checklist_models.ChecklistCategory.afterSigning:
        return AppColors.success;
      case checklist_models.ChecklistCategory.ongoing:
        return AppColors.warning;
      case checklist_models.ChecklistCategory.legal:
        return AppColors.error;
      case checklist_models.ChecklistCategory.financial:
        return context.colors.secondary;
      case checklist_models.ChecklistCategory.other:
        return context.colors.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChecklistCubit, checklist_state.ChecklistState>(
      builder: (context, state) {
        if (state is checklist_state.ChecklistLoading) {
          return Scaffold(
            appBar: AppBar(title: Text('Checklist', style: AppTypography.titleLarge)),
            body: const LoadingState(message: 'Loading checklist...'),
          );
        }

        if (state is checklist_state.ChecklistError) {
          return Scaffold(
            appBar: AppBar(title: Text('Checklist', style: AppTypography.titleLarge)),
            body: ErrorState(
              title: 'Failed to load checklist',
              subtitle: state.message,
              actionLabel: 'Retry',
              onAction: _loadChecklist,
            ),
          );
        }

        if (state is checklist_state.ChecklistLoaded) {
          final items = state.items;
          final officialItems = items.where((i) => i.category != checklist_models.ChecklistCategory.other).toList();
          final personalItems = items.where((i) => i.category == checklist_models.ChecklistCategory.other).toList();

          final total = items.length;
          final completed = items.where((i) => i.isCompleted).length;
          final progress = total > 0 ? completed / total : 0.0;

          return Scaffold(
            appBar: AppBar(
              title: Text('Checklist', style: AppTypography.titleLarge),
              actions: [
                IconButton(
                  icon: const Icon(Symbols.add),
                  onPressed: _showAddTaskDialog,
                  tooltip: 'Add Task',
                ),
              ],
            ),
            body: Column(
              children: [
                // Progress bar
                Container(
                  padding: AppSpacing.screenPadding,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Progress', style: AppTypography.labelMedium),
                          Text('$completed / $total', style: AppTypography.labelMedium.copyWith(color: context.colors.primary)),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.spacingXs),
                      LinearProgressIndicator(
                        value: progress,
                        backgroundColor: context.colors.surfaceContainerHighest,
                        color: context.colors.primary,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Checklist items
                Expanded(
                  child: items.isEmpty
                      ? EmptyState(
                          icon: Symbols.checklist,
                          title: 'No checklist items',
                          subtitle: 'Tasks will be generated from document analysis',
                          actionLabel: 'Add Task',
                          onAction: _showAddTaskDialog,
                        )
                      : ListView(
                          padding: AppSpacing.screenPadding,
                          children: [
                            if (officialItems.isNotEmpty) ...[
                              _buildSectionHeader('From Document', officialItems.length, context.colors.primary),
                              ...officialItems.map((item) => _ChecklistItemWidget(
                                item: item,
                                onToggle: () => context.read<ChecklistCubit>().toggleItem(item),
                                onDelete: () => _confirmDeleteItem(item),
                                categoryColor: _getCategoryColor(item.category, context),
                                categoryLabel: _getCategoryLabel(item.category),
                              )),
                              const SizedBox(height: AppSpacing.spacingLg),
                            ],
                            if (personalItems.isNotEmpty) ...[
                              _buildSectionHeader('Personal Tasks', personalItems.length, context.colors.secondary),
                              ...personalItems.map((item) => _ChecklistItemWidget(
                                item: item,
                                onToggle: () => context.read<ChecklistCubit>().toggleItem(item),
                                onDelete: () => _confirmDeleteItem(item),
                                categoryColor: _getCategoryColor(item.category, context),
                                categoryLabel: _getCategoryLabel(item.category),
                              )),
                            ],
                          ],
                        ),
                ),
              ],
            ),
          );
        }

        return Scaffold(
          appBar: AppBar(title: Text('Checklist', style: AppTypography.titleLarge)),
          body: const LoadingState(message: 'Loading checklist...'),
        );
      },
    );
  }

  Widget _buildSectionHeader(String title, int count, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.spacingSm),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: AppSpacing.spacingSm),
          Text(title, style: AppTypography.labelLarge.copyWith(color: color, fontWeight: FontWeight.w600)),
          const SizedBox(width: AppSpacing.spacingXs),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text('$count', style: AppTypography.tinyBold.copyWith(color: color)),
          ),
        ],
      ),
    );
  }
}

/// Checklist Item Widget
class _ChecklistItemWidget extends StatelessWidget {
  final checklist_models.ChecklistItemModel item;
  final VoidCallback onToggle;
  final VoidCallback onDelete;
  final Color categoryColor;
  final String categoryLabel;

  const _ChecklistItemWidget({
    required this.item,
    required this.onToggle,
    required this.onDelete,
    required this.categoryColor,
    required this.categoryLabel,
  });

  @override
  Widget build(BuildContext context) {
    final isOverdue = item.dueDate != null &&
        item.dueDate!.isBefore(DateTime.now()) &&
        !item.isCompleted;

    return AppCard(
      margin: const EdgeInsets.only(bottom: AppSpacing.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Checkbox(
                value: item.isCompleted,
                onChanged: (_) => onToggle(),
                activeColor: context.colors.primary,
              ),
              const SizedBox(width: AppSpacing.spacingSm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.title,
                      style: AppTypography.labelMedium.copyWith(
                        decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                        color: item.isCompleted ? context.colors.onSurfaceVariant : context.colors.onSurface,
                      ),
                    ),
                    if (item.description.isNotEmpty)
                      Text(
                        item.description,
                        style: AppTypography.bodySmall.copyWith(
                          color: item.isCompleted
                              ? context.colors.onSurfaceVariant.withValues(alpha: 0.7)
                              : context.colors.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              if (item.dueDate != null) ...[
                const SizedBox(width: AppSpacing.spacingSm),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacingSm, vertical: 4),
                  decoration: BoxDecoration(
                    color: isOverdue ? AppColors.errorLight : context.colors.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(AppShapes.radiusSm),
                    border: isOverdue ? Border.all(color: AppColors.error) : null,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        isOverdue ? Symbols.warning : Symbols.calendar_today,
                        size: 12,
                        color: isOverdue ? AppColors.error : context.colors.onSurfaceVariant,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${item.dueDate!.day}/${item.dueDate!.month}/${item.dueDate!.year}',
                        style: AppTypography.tiny.copyWith(
                          color: isOverdue ? AppColors.error : context.colors.onSurfaceVariant,
                          fontWeight: isOverdue ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              const SizedBox(width: AppSpacing.spacingXs),
              PopupMenuButton<String>(
                icon: Icon(Symbols.more_vert, size: 20, color: context.colors.onSurfaceVariant),
                onSelected: (value) {
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (context) => [
                  const PopupMenuItem(value: 'delete', child: Row(children: [Icon(Symbols.delete, size: 18), SizedBox(width: 8), Text('Delete')])),
                ],
              ),
            ],
          ),
          if (item.category != checklist_models.ChecklistCategory.other) ...[
            const SizedBox(height: AppSpacing.spacingXs),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacingSm, vertical: 2),
                  decoration: BoxDecoration(
                    color: categoryColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppShapes.radiusSm),
                  ),
                  child: Text(categoryLabel, style: AppTypography.tinyBold.copyWith(color: categoryColor)),
                ),
                if (item.pageNumber != null) ...[
                  const SizedBox(width: AppSpacing.spacingSm),
                  Text('Page ${item.pageNumber}', style: AppTypography.tiny.copyWith(color: context.colors.onSurfaceVariant)),
                ],
              ],
            ),
          ],
        ],
      ),
    );
  }
}

/// Document Chat Screen - Full implementation
class _DocumentChatScreen extends StatefulWidget {
  final String documentId;
  const _DocumentChatScreen({required this.documentId});

  @override
  State<_DocumentChatScreen> createState() => _DocumentChatScreenState();
}

class _DocumentChatScreenState extends State<_DocumentChatScreen> {
  final _messageController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isLoading = false;

  static const List<String> _suggestedQuestions = [
    'What are the key deadlines?',
    'What documents do I need to prepare?',
    'What are the termination conditions?',
    'Are there any penalties or fees?',
    'Summarize the financial obligations.',
  ];

  @override
  void initState() {
    super.initState();
    _loadChat();
  }

  Future<void> _loadChat() async {
    final chatCubit = context.read<ChatCubit>();
    await chatCubit.loadChatHistory(widget.documentId);
  }

  Future<void> _sendMessage() async {
    final text = _messageController.text.trim();
    if (text.isEmpty || _isLoading) return;

    _messageController.clear();
    _scrollToBottom();

    setState(() => _isLoading = true);

    final authCubit = context.read<AuthCubit>();
    final authState = authCubit.state;
    String userId = '';
    if (authState is AuthAuthenticated) {
      userId = authState.user.id;
    }

    final chatCubit = context.read<ChatCubit>();
    final chatState = chatCubit.state;
    List<ChatMessageModel> history = [];
    if (chatState is ChatLoaded) {
      history = chatState.messages;
    }

    await chatCubit.sendMessage(
      documentId: widget.documentId,
      userId: userId,
      message: text,
      history: history,
    );

    if (mounted) {
      setState(() => _isLoading = false);
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _clearChat() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Clear Conversation', style: AppTypography.headlineSmall),
        content: Text('Are you sure you want to delete all messages? This cannot be undone.', style: AppTypography.bodyMedium),
        actions: [
          TertiaryButton(label: 'Cancel', onPressed: () => Navigator.pop(context, false)),
          FilledDestructiveButton(label: 'Clear', onPressed: () => Navigator.pop(context, true)),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      await context.read<ChatCubit>().clearChat(widget.documentId);
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ChatCubit, ChatState>(
      builder: (context, state) {
        List<ChatMessageModel> messages = [];
        if (state is ChatLoaded) {
          messages = state.messages;
        } else if (state is ChatMessageSent) {
          // This state is transient, the list will be updated via BlocBuilder
          // We'll handle it by getting the current state from the cubit
          // For now, just show empty - the next build will have ChatLoaded
        }

        return Scaffold(
          appBar: AppBar(
            title: Text('Document Chat', style: AppTypography.titleLarge),
            actions: [
              if (messages.isNotEmpty)
                IconButton(
                  icon: Icon(Symbols.delete_sweep, color: AppColors.error),
                  onPressed: _clearChat,
                  tooltip: 'Clear Conversation',
                ),
            ],
          ),
          body: Column(
            children: [
              // Suggested questions (only when empty)
              if (messages.isEmpty)
                _buildSuggestions(),
              // Messages list
              Expanded(
                child: messages.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        controller: _scrollController,
                        padding: AppSpacing.screenPadding,
                        itemCount: messages.length + (_isLoading ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == messages.length && _isLoading) {
                            return _buildLoadingBubble();
                          }
                          return _ChatBubble(message: messages[index]);
                        },
                      ),
              ),
              // Input bar
              _buildInputBar(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSuggestions() {
    return Container(
      padding: AppSpacing.screenPadding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Suggested Questions', style: AppTypography.labelMedium),
          const SizedBox(height: AppSpacing.spacingSm),
          Wrap(
            spacing: AppSpacing.spacingSm,
            runSpacing: AppSpacing.spacingSm,
            children: _suggestedQuestions.map((q) => ActionChip(
              label: Text(q, style: AppTypography.bodySmall),
              onPressed: () {
                _messageController.text = q;
                _sendMessage();
              },
              backgroundColor: context.colors.surfaceContainerHighest,
              side: BorderSide(color: context.colors.outlineVariant),
            )).toList(),
          ),
          const Divider(height: AppSpacing.spacingLg),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Symbols.chat, size: 64, color: context.colors.onSurfaceVariant),
            const SizedBox(height: AppSpacing.spacingLg),
            Text('Start a Conversation', style: AppTypography.headlineMedium),
            const SizedBox(height: AppSpacing.spacingSm),
            Text(
              'Ask questions about your document. The AI will answer based on the analyzed content.',
              style: AppTypography.bodyMedium.copyWith(color: context.colors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingBubble() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.spacingMd),
        padding: const EdgeInsets.all(AppSpacing.spacingMd),
        decoration: BoxDecoration(
          color: context.colors.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(AppShapes.radiusMd),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: context.colors.primary),
            ),
            const SizedBox(width: AppSpacing.spacingMd),
            Text('Thinking...', style: AppTypography.bodyMedium.copyWith(color: context.colors.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return SafeArea(
      child: Container(
        padding: AppSpacing.screenPadding,
        decoration: BoxDecoration(
          color: context.colors.surface,
          border: Border(top: BorderSide(color: context.colors.outlineVariant)),
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _messageController,
                decoration: InputDecoration(
                  hintText: 'Ask about the document...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(AppShapes.radiusMd),
                    borderSide: BorderSide(color: context.colors.outlineVariant),
                  ),
                  filled: true,
                  fillColor: context.colors.surfaceContainerHighest,
                  contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacingMd, vertical: AppSpacing.spacingSm),
                ),
                style: AppTypography.bodyMedium,
                onSubmitted: (_) => _sendMessage(),
                maxLines: null,
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            const SizedBox(width: AppSpacing.spacingSm),
            IconButton.filled(
              icon: Icon(Symbols.send, color: context.colors.onPrimary),
              onPressed: _isLoading ? null : _sendMessage,
              style: IconButton.styleFrom(
                backgroundColor: context.colors.primary,
                disabledBackgroundColor: context.colors.onSurfaceVariant.withValues(alpha: 0.12),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Chat Bubble Widget
class _ChatBubble extends StatelessWidget {
  final ChatMessageModel message;

  const _ChatBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.role == 'user';
    final bubbleColor = isUser ? context.colors.primary : context.colors.surfaceContainerHighest;
    final textColor = isUser ? context.colors.onPrimary : context.colors.onSurface;
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final borderRadius = isUser
        ? BorderRadius.only(
            topLeft: Radius.circular(AppShapes.radiusLg),
            topRight: Radius.circular(AppShapes.radiusLg),
            bottomLeft: Radius.circular(AppShapes.radiusLg),
            bottomRight: Radius.circular(AppShapes.radiusSm),
          )
        : BorderRadius.only(
            topLeft: Radius.circular(AppShapes.radiusLg),
            topRight: Radius.circular(AppShapes.radiusLg),
            bottomLeft: Radius.circular(AppShapes.radiusSm),
            bottomRight: Radius.circular(AppShapes.radiusLg),
          );

    return Align(
      alignment: alignment,
      child: Container(
        margin: const EdgeInsets.only(bottom: AppSpacing.spacingMd),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.8),
        padding: const EdgeInsets.all(AppSpacing.spacingMd),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: borderRadius,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(message.content, style: AppTypography.bodyMedium.copyWith(color: textColor)),
            if (message.sources != null && message.sources!.isNotEmpty) ...[
              const SizedBox(height: AppSpacing.spacingXs),
              Wrap(
                spacing: AppSpacing.spacingXs,
                children: message.sources!.map((source) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: AppSpacing.spacingSm, vertical: 2),
                  decoration: BoxDecoration(
                    color: isUser ? context.colors.onPrimary.withValues(alpha: 0.2) : context.colors.primary.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(AppShapes.radiusSm),
                  ),
                  child: Text(
                    'Source: $source',
                    style: AppTypography.tiny.copyWith(
                      color: isUser ? context.colors.onPrimary : context.colors.primary,
                    ),
                  ),
                )).toList(),
              ),
            ],
            const SizedBox(height: AppSpacing.spacingXs),
            Text(
              _formatTime(message.timestamp),
              style: AppTypography.tiny.copyWith(
                color: isUser ? context.colors.onPrimary.withValues(alpha: 0.7) : context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}

/// Translation Screen - Full implementation
class _TranslationScreen extends StatefulWidget {
  final String documentId;
  const _TranslationScreen({required this.documentId});

  @override
  State<_TranslationScreen> createState() => _TranslationScreenState();
}

class _TranslationScreenState extends State<_TranslationScreen> {
  final _customTextController = TextEditingController();
  String _selectedTargetLanguage = 'ar';
  String _selectedSourceLanguage = 'en';
  bool _isTranslating = false;

  static const List<String> _translationTabs = [
    'Summary',
    'Deadlines',
    'Financial Obligations',
    'Key Clauses',
    'Red Flags',
    'Custom Text',
  ];

  @override
  void dispose() {
    _customTextController.dispose();
    super.dispose();
  }

  Future<void> _translateContent(String content) async {
    if (content.trim().isEmpty || _isTranslating) return;

    setState(() => _isTranslating = true);

    final authCubit = context.read<AuthCubit>();
    final authState = authCubit.state;
    String userId = '';
    if (authState is AuthAuthenticated) {
      userId = authState.user.id;
    }

    final translationCubit = context.read<TranslationCubit>();
    await translationCubit.translate(
      documentId: widget.documentId,
      userId: userId,
      sourceLanguage: _selectedSourceLanguage,
      targetLanguage: _selectedTargetLanguage,
      content: content,
    );

    if (mounted) {
      setState(() => _isTranslating = false);
    }
  }

  String _getContentForTab(int tabIndex, doc_models.AnalysisModel? analysis) {
    if (analysis == null) return '';

    switch (tabIndex) {
      case 0:
        return analysis.summary ?? '';
      case 1:
        return analysis.deadlines
            .map((d) => '${d.title}: ${d.description} (Due: ${d.dueDate.day}/${d.dueDate.month}/${d.dueDate.year})')
            .join('\n\n');
      case 2:
        return analysis.financialObligations
            .map((f) => f.dueDate != null
                ? '${f.title}: ${f.description} (Due: ${f.dueDate!.day}/${f.dueDate!.month}/${f.dueDate!.year})'
                : '${f.title}: ${f.description} (No due date)')
            .join('\n\n');
      case 3:
        return analysis.keyClauses
            .map((c) => '${c.title}: ${c.description} (Importance: ${c.importance.name})')
            .join('\n\n');
      case 4:
        return analysis.redFlags
            .map((r) => '${r.title}: ${r.description} (Severity: ${r.severity.name})')
            .join('\n\n');
      case 5:
        return _customTextController.text;
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentCubit, DocumentState>(
      builder: (context, docState) {
        doc_models.AnalysisModel? analysis;
        if (docState is DocumentLoaded) {
          analysis = docState.analysis;
        }

        // Wrap with DefaultTabController to provide TabController for TabBar/TabBarView
        return DefaultTabController(
          length: _translationTabs.length,
          child: Scaffold(
            appBar: AppBar(
              title: Text('Translate', style: AppTypography.titleLarge),
              bottom: TabBar(
                isScrollable: true,
                tabs: _translationTabs.map((t) => Tab(text: t)).toList(),
                labelStyle: AppTypography.labelMedium,
                unselectedLabelStyle: AppTypography.labelMedium,
              ),
            ),
            body: TabBarView(
              children: _translationTabs.asMap().entries.map((entry) {
                final index = entry.key;
                return _buildTranslationTab(index, analysis);
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTranslationTab(int tabIndex, doc_models.AnalysisModel? analysis) {
    return BlocBuilder<TranslationCubit, translation_state.TranslationState>(
      builder: (context, state) {
        String? translatedText;
        bool isLoading = _isTranslating;

        if (state is translation_state.TranslationCompleted) {
          translatedText = state.translation.translatedContent;
        } else if (state is translation_state.TranslationLoading) {
          isLoading = true;
        } else if (state is translation_state.TranslationError) {
          // Show error
        }

        final content = _getContentForTab(tabIndex, analysis);
        final hasContent = content.trim().isNotEmpty;

        if (tabIndex == 4) {
          // Custom text tab
          return SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Language selectors
                Row(
                  children: [
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedSourceLanguage,
                        decoration: const InputDecoration(labelText: 'From'),
                        items: translation_models.SupportedLanguages.languages.entries
                            .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                            .toList(),
                        onChanged: (v) => setState(() => _selectedSourceLanguage = v!),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.spacingMd),
                    Icon(Symbols.swap_horiz, color: context.colors.primary),
                    const SizedBox(width: AppSpacing.spacingMd),
                    Expanded(
                      child: DropdownButtonFormField<String>(
                        initialValue: _selectedTargetLanguage,
                        decoration: const InputDecoration(labelText: 'To'),
                        items: translation_models.SupportedLanguages.languages.entries
                            .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                            .toList(),
                        onChanged: (v) => setState(() => _selectedTargetLanguage = v!),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.spacingLg),
                TextField(
                  controller: _customTextController,
                  maxLines: 6,
                  decoration: InputDecoration(
                    labelText: 'Text to Translate',
                    hintText: 'Enter text to translate...',
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(AppShapes.radiusMd)),
                    filled: true,
                    fillColor: context.colors.surfaceContainerHighest,
                  ),
                  style: AppTypography.bodyMedium,
                ),
                const SizedBox(height: AppSpacing.spacingMd),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    label: 'Translate',
                    onPressed: hasContent && !isLoading
                        ? () => _translateContent(_customTextController.text)
                        : null,
                    isLoading: isLoading,
                    leadingIcon: Symbols.translate,
                  ),
                ),
                if (translatedText != null) ...[
                  const SizedBox(height: AppSpacing.spacingLg),
                  const Divider(),
                  const SizedBox(height: AppSpacing.spacingMd),
                  Text('Translation', style: AppTypography.labelLarge),
                  const SizedBox(height: AppSpacing.spacingSm),
                  AppCard(
                    child: SelectableText(
                      translatedText,
                      style: AppTypography.bodyMedium,
                    ),
                  ),
                ],
              ],
            ),
          );
        }

        // Predefined tabs
        return SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Language selectors
              Row(
                children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedSourceLanguage,
                      decoration: const InputDecoration(labelText: 'From'),
                      items: translation_models.SupportedLanguages.languages.entries
                          .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedSourceLanguage = v!),
                    ),
                  ),
                  const SizedBox(width: AppSpacing.spacingMd),
                  Icon(Symbols.swap_horiz, color: context.colors.primary),
                  const SizedBox(width: AppSpacing.spacingMd),
                  Expanded(
                    child: DropdownButtonFormField<String>(
                      initialValue: _selectedTargetLanguage,
                      decoration: const InputDecoration(labelText: 'To'),
                      items: translation_models.SupportedLanguages.languages.entries
                          .map((e) => DropdownMenuItem(value: e.key, child: Text(e.value)))
                          .toList(),
                      onChanged: (v) => setState(() => _selectedTargetLanguage = v!),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.spacingLg),
              // Original content
              if (hasContent) ...[
                Text('Original (${translation_models.SupportedLanguages.getLanguageName(_selectedSourceLanguage)})', style: AppTypography.labelMedium),
                const SizedBox(height: AppSpacing.spacingSm),
                AppCard(
                  child: Text(content, style: AppTypography.bodyMedium),
                ),
                const SizedBox(height: AppSpacing.spacingMd),
                SizedBox(
                  width: double.infinity,
                  child: PrimaryButton(
                    label: 'Translate',
                    onPressed: !isLoading ? () => _translateContent(content) : null,
                    isLoading: isLoading,
                    leadingIcon: Symbols.translate,
                  ),
                ),
                if (translatedText != null) ...[
                  const SizedBox(height: AppSpacing.spacingLg),
                  const Divider(),
                  const SizedBox(height: AppSpacing.spacingMd),
                  Text('Translation (${translation_models.SupportedLanguages.getLanguageName(_selectedTargetLanguage)})', style: AppTypography.labelMedium),
                  const SizedBox(height: AppSpacing.spacingSm),
                  AppCard(
                    child: SelectableText(
                      translatedText,
                      style: AppTypography.bodyMedium,
                    ),
                  ),
                ],
              ] else ...[
                EmptyState(
                  icon: Symbols.translate,
                  title: 'No content to translate',
                  subtitle: 'The analysis does not have content for this section',
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}

class _ErrorScreen extends StatelessWidget {
  final Exception? error;
  const _ErrorScreen({this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Error', style: AppTypography.titleLarge)),
      body: Center(
        child: Padding(
          padding: AppSpacing.screenPadding,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Symbols.error, size: 64, color: AppColors.error),
              const SizedBox(height: AppSpacing.spacingLg),
              Text('Something went wrong', style: AppTypography.headlineMedium),
              const SizedBox(height: AppSpacing.spacingSm),
              Text(
                error?.toString() ?? 'Unknown error',
                style: AppTypography.bodyMedium.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
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
