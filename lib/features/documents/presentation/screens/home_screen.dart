import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../../../core/design_system/index.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../shared/widgets/index.dart';
import '../cubit/home_cubit.dart';
import '../cubit/document_cubit.dart';
import '../cubit/document_state.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../domain/models/document_model.dart';

/// Home screen with dashboard
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          AppRouter.goToAuth(context);
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              // App Bar
              SliverAppBar(
                pinned: true,
                floating: true,
                snap: true,
                title: Text(
                  'Welcome back',
                  style: AppTypography.headlineSmall,
                ),
                actions: [
                  AppIconButton(
                    icon: Symbols.notifications,
                    onPressed: () {},
                  ),
                  AppIconButton(
                    icon: Symbols.settings,
                    onPressed: () => AppRouter.goToProfile(context),
                  ),
                  const SizedBox(width: AppSpacing.spacingSm),
                ],
              ),

              // Content
              SliverPadding(
                padding: AppSpacing.screenPadding,
                sliver: SliverList(
                  delegate: SliverChildListDelegate(
                    [
                      // Action Card
                      BlocBuilder<HomeCubit, HomeState>(
                        builder: (context, state) {
                          if (state is HomeLoaded) {
                            return ActionCard(
                              title: 'Analyze a new document',
                              subtitle:
                                  'Upload a PDF or image to extract key clauses, deadlines, and financial obligations',
                              buttonLabel: 'Upload Document',
                              onPressed: () => AppRouter.goToUpload(context),
                              emblemIcon: Symbols.auto_awesome,
                              trailingWidget: state.analyzingDocuments.isNotEmpty
                                  ? _AnalyzingBadge(count: state.analyzingDocuments.length)
                                  : null,
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),

                      const SizedBox(height: AppSpacing.spacingXl),

                      // Recent Documents Section
                      _buildSectionHeader(
                        context,
                        title: 'Recent Documents',
                        actionLabel: 'View All',
                        onAction: () => AppRouter.goToMyDocuments(context),
                      ),

                      const SizedBox(height: AppSpacing.spacingMd),

                      // Documents List
                      BlocBuilder<DocumentCubit, DocumentState>(
                        builder: (context, state) {
                          if (state is DocumentsLoaded) {
                            final recentDocs = state.documents
                                .where((d) => d.status == DocumentStatus.analyzed)
                                .take(3)
                                .toList();

                            if (recentDocs.isEmpty) {
                              return EmptyState(
                                icon: Symbols.description,
                                title: 'No documents yet',
                                subtitle: 'Upload your first document to get started',
                                actionLabel: 'Upload Document',
                                onAction: () => AppRouter.goToUpload(context),
                              );
                            }

                            return Column(
                              children: recentDocs
                                  .map((doc) => Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: AppSpacing.spacingMd),
                                        child: DocumentCard(
                                          title: doc.title,
                                          type: doc.typeLabel,
                                          status: doc.status.name,
                                          typeColor: _getTypeColor(context, doc.type),
                                          typeIcon: _getTypeIcon(doc.type),
                                          onTap: () =>
                                              AppRouter.goToDocumentDetails(context, doc.id),
                                        ),
                                      ))
                                  .toList(),
                            );
                          } else if (state is DocumentLoading) {
                            return const LoadingState(message: 'Loading documents...');
                          } else if (state is DocumentError) {
                            return ErrorState(
                              title: 'Failed to load documents',
                              subtitle: state.message,
                              actionLabel: 'Retry',
                              onAction: () => context.read<HomeCubit>().loadDashboard(
                                    context.read<AuthCubit>().state is AuthAuthenticated
                                        ? (context.read<AuthCubit>().state as AuthAuthenticated)
                                            .user
                                            .id
                                        : '',
                                  ),
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),

                      const SizedBox(height: AppSpacing.spacingXl),

                      // Stats Section
                      BlocBuilder<HomeCubit, HomeState>(
                        builder: (context, state) {
                          if (state is HomeLoaded) {
                            return Row(
                              children: [
                                Expanded(
                                  child: _StatCard(
                                    label: 'Total Documents',
                                    value: state.totalDocuments.toString(),
                                    icon: Symbols.folder,
                                    color: context.colors.primary,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.spacingMd),
                                Expanded(
                                  child: _StatCard(
                                    label: 'Analyzed',
                                    value: state.analyzedCount.toString(),
                                    icon: Symbols.check_circle,
                                    color: AppColors.success,
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.spacingMd),
                                Expanded(
                                  child: _StatCard(
                                    label: 'Processing',
                                    value: state.analyzingDocuments.length.toString(),
                                    icon: Symbols.hourglass_top,
                                    color: AppColors.warning,
                                  ),
                                ),
                              ],
                            );
                          }
                          return const SizedBox.shrink();
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        bottomNavigationBar: _buildBottomNav(context),
      ),
    );
  }

  Widget _buildSectionHeader(
    BuildContext context, {
    required String title,
    String? actionLabel,
    VoidCallback? onAction,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTypography.titleLarge),
        if (actionLabel != null && onAction != null)
          TertiaryButton(
            label: actionLabel,
            onPressed: onAction,
            trailingIcon: Symbols.chevron_right,
          ),
      ],
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return NavigationBar(
      selectedIndex: 0,
      onDestinationSelected: (index) {
        switch (index) {
          case 0:
            AppRouter.goToHome(context);
            break;
          case 1:
            AppRouter.goToMyDocuments(context);
            break;
          case 2:
            AppRouter.goToUpload(context);
            break;
          case 3:
            AppRouter.goToProfile(context);
            break;
        }
      },
      destinations: const [
        NavigationDestination(
          icon: Icon(Symbols.home),
          selectedIcon: Icon(Symbols.home),
          label: 'Home',
        ),
        NavigationDestination(
          icon: Icon(Symbols.folder),
          selectedIcon: Icon(Symbols.folder),
          label: 'Documents',
        ),
        NavigationDestination(
          icon: Icon(Symbols.add_circle),
          selectedIcon: Icon(Symbols.add_circle),
          label: 'Upload',
        ),
        NavigationDestination(
          icon: Icon(Symbols.person),
          selectedIcon: Icon(Symbols.person),
          label: 'Profile',
        ),
      ],
    );
  }

  Color _getTypeColor(BuildContext context, DocumentType type) {
    switch (type) {
      case DocumentType.rentalContract:
        return AppColors.blue;
      case DocumentType.employmentContract:
        return AppColors.green;
      case DocumentType.termsOfService:
        return AppColors.orange;
      case DocumentType.privacyPolicy:
        return AppColors.purple;
      case DocumentType.other:
        return context.colors.primary;
    }
  }

  IconData _getTypeIcon(DocumentType type) {
    switch (type) {
      case DocumentType.rentalContract:
        return Symbols.home;
      case DocumentType.employmentContract:
        return Symbols.work;
      case DocumentType.termsOfService:
        return Symbols.description;
      case DocumentType.privacyPolicy:
        return Symbols.shield;
      case DocumentType.other:
        return Symbols.description;
    }
  }
}

/// Analyzing badge widget
class _AnalyzingBadge extends StatelessWidget {
  final int count;

  const _AnalyzingBadge({required this.count});

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spacingSm,
        vertical: AppSpacing.spacing2xs,
      ),
      decoration: BoxDecoration(
        color: isDark
            ? AppColors.warningDark.withValues(alpha: 0.2)
            : AppColors.warningLight,
        borderRadius: AppShapes.chip,
        border: Border.all(color: AppColors.warning),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            width: 12,
            height: 12,
            child: CircularProgressIndicator(
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(
                isDark ? AppColors.warning : AppColors.warningText,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.spacing2xs),
          Text(
            '$count analyzing',
            style: AppTypography.tinyBold.copyWith(
              color: isDark ? AppColors.warning : AppColors.warningText,
            ),
          ),
        ],
      ),
    );
  }
}

/// Stat card widget
class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = context.isDarkMode;
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacingMd),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppShapes.card,
        border: Border.all(
          color: isDark ? AppColors.darkOutlineVariant : AppColors.lightOutlineVariant,
        ),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: AppSpacing.spacingSm),
          Text(
            value,
            style: AppTypography.headlineMedium.copyWith(
              color: color,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.spacing2xs),
          Text(
            label,
            style: AppTypography.labelSmall.copyWith(color: context.colors.onSurfaceVariant),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}