import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../../../core/design_system/index.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../shared/widgets/index.dart';
import '../cubit/document_cubit.dart';
import '../cubit/document_state.dart';
import '../../domain/models/document_model.dart';
import '../../domain/models/analysis_model.dart';

/// Document details screen
class DocumentDetailsScreen extends StatefulWidget {
  final String documentId;

  const DocumentDetailsScreen({super.key, required this.documentId});

  @override
  State<DocumentDetailsScreen> createState() => _DocumentDetailsScreenState();
}

class _DocumentDetailsScreenState extends State<DocumentDetailsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _loadData() {
    context.read<DocumentCubit>().getDocument(widget.documentId);
    context.read<DocumentCubit>().getAnalysis(widget.documentId);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DocumentCubit, DocumentState>(
      builder: (context, state) {
        if (state is DocumentLoaded) {
          final doc = state.document;
          return Scaffold(
            appBar: AppBar(
              title: Text(doc.title, style: AppTypography.headlineSmall),
              actions: [
                AppIconButton(
                  icon: Symbols.more_vert,
                  onPressed: () => _showMoreOptions(context, doc),
                ),
              ],
              bottom: TabBar(
                controller: _tabController,
                tabs: const [
                  Tab(text: 'Summary'),
                  Tab(text: 'Key Clauses'),
                  Tab(text: 'Deadlines'),
                  Tab(text: 'Financials'),
                ],
                labelStyle: AppTypography.labelMedium,
                unselectedLabelStyle: AppTypography.labelMedium,
                indicatorColor: context.colors.primary,
                labelColor: context.colors.primary,
                unselectedLabelColor: context.colors.onSurfaceVariant,
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                _buildSummaryTab(doc),
                _buildKeyClausesTab(doc),
                _buildDeadlinesTab(doc),
                _buildFinancialsTab(doc),
              ],
            ),
            bottomNavigationBar: _buildBottomActions(context, doc),
          );
        } else if (state is DocumentLoading) {
          return Scaffold(
            appBar: AppBar(title: const Text('Document Details')),
            body: const LoadingState(message: 'Loading document...'),
          );
        } else if (state is DocumentError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Document Details')),
            body: ErrorState(
              title: 'Failed to load document',
              subtitle: state.message,
              actionLabel: 'Retry',
              onAction: _loadData,
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  Widget _buildSummaryTab(DocumentModel doc) {
    return BlocBuilder<DocumentCubit, DocumentState>(
      builder: (context, state) {
        if (state is AnalysisLoaded) {
          final analysis = state.analysis;
          return SingleChildScrollView(
            padding: AppSpacing.screenPadding,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Document info
                _buildInfoCard(doc),
                const SizedBox(height: AppSpacing.spacingLg),

                // AI Summary
                if (analysis.summary != null) ...[
                  Text('AI Summary', style: AppTypography.headlineSmall),
                  const SizedBox(height: AppSpacing.spacingSm),
                  AppCard(
                    child: Text(
                      analysis.summary!,
                      style: AppTypography.bodyMedium,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.spacingLg),
                ],

                // Key metrics
                _buildMetricsRow(analysis),
                const SizedBox(height: AppSpacing.spacingLg),

                // Red flags
                if (analysis.redFlags.isNotEmpty) ...[
                  Text('Red Flags', style: AppTypography.headlineSmall),
                  const SizedBox(height: AppSpacing.spacingSm),
                  ...analysis.redFlags.map((flag) => _RedFlagCard(flag: flag)),
                  const SizedBox(height: AppSpacing.spacingLg),
                ],

                // Checklist preview
                if (analysis.checklistItems.isNotEmpty) ...[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Checklist', style: AppTypography.headlineSmall),
                      TertiaryButton(
                        label: 'View All',
                        onPressed: () => AppRouter.goToChecklist(context, doc.id),
                        trailingIcon: Symbols.chevron_right,
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.spacingSm),
                  ...analysis.checklistItems.take(3).map((item) => _ChecklistPreviewItem(item: item)),
                  if (analysis.checklistItems.length > 3) ...[
                    const SizedBox(height: AppSpacing.spacingSm),
                    Center(
                      child: TertiaryButton(
                        label: 'View ${analysis.checklistItems.length} items',
                        onPressed: () => AppRouter.goToChecklist(context, doc.id),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          );
        }
        return const LoadingState(message: 'Loading analysis...');
      },
    );
  }

  Widget _buildKeyClausesTab(DocumentModel doc) {
    return BlocBuilder<DocumentCubit, DocumentState>(
      builder: (context, state) {
        if (state is AnalysisLoaded) {
          final clauses = state.analysis.keyClauses;
          if (clauses.isEmpty) {
            return EmptyState(
              icon: Symbols.description,
              title: 'No key clauses found',
              subtitle: 'The AI analysis did not identify any key clauses',
            );
          }
          return ListView.separated(
            padding: AppSpacing.screenPadding,
            itemCount: clauses.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.spacingMd),
            itemBuilder: (context, index) {
              final clause = clauses[index];
              return _KeyClauseCard(clause: clause);
            },
          );
        }
        return const LoadingState(message: 'Loading clauses...');
      },
    );
  }

  Widget _buildDeadlinesTab(DocumentModel doc) {
    return BlocBuilder<DocumentCubit, DocumentState>(
      builder: (context, state) {
        if (state is AnalysisLoaded) {
          final deadlines = state.analysis.deadlines;
          if (deadlines.isEmpty) {
            return EmptyState(
              icon: Symbols.event,
              title: 'No deadlines found',
              subtitle: 'The AI analysis did not identify any deadlines',
            );
          }
          return ListView.separated(
            padding: AppSpacing.screenPadding,
            itemCount: deadlines.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.spacingMd),
            itemBuilder: (context, index) {
              final deadline = deadlines[index];
              return _DeadlineCard(deadline: deadline);
            },
          );
        }
        return const LoadingState(message: 'Loading deadlines...');
      },
    );
  }

  Widget _buildFinancialsTab(DocumentModel doc) {
    return BlocBuilder<DocumentCubit, DocumentState>(
      builder: (context, state) {
        if (state is AnalysisLoaded) {
          final financials = state.analysis.financialObligations;
          if (financials.isEmpty) {
            return EmptyState(
              icon: Symbols.attach_money,
              title: 'No financial obligations found',
              subtitle: 'The AI analysis did not identify any financial obligations',
            );
          }
          return ListView.separated(
            padding: AppSpacing.screenPadding,
            itemCount: financials.length,
            separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.spacingMd),
            itemBuilder: (context, index) {
              final financial = financials[index];
              return _FinancialCard(financial: financial);
            },
          );
        }
        return const LoadingState(message: 'Loading financials...');
      },
    );
  }

  Widget _buildInfoCard(DocumentModel doc) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: _getTypeColor(doc.type).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppShapes.radiusMd),
                ),
                child: Icon(_getTypeIcon(doc.type), color: _getTypeColor(doc.type), size: 24),
              ),
              const SizedBox(width: AppSpacing.spacingMd),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(doc.title, style: AppTypography.labelLarge),
                    Text(
                      doc.typeLabel,
                      style: AppTypography.bodySmall.copyWith(color: context.colors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),
              _StatusBadge(status: doc.status.name),
            ],
          ),
          const SizedBox(height: AppSpacing.spacingMd),
          const Divider(height: 1),
          const SizedBox(height: AppSpacing.spacingMd),
          Row(
            children: [
              Expanded(
                child: _InfoItem(
                  label: 'Pages',
                  value: doc.pageCount.toString(),
                  icon: Symbols.description,
                ),
              ),
              Expanded(
                child: _InfoItem(
                  label: 'Size',
                  value: doc.formattedFileSize,
                  icon: Symbols.data_object,
                ),
              ),
              Expanded(
                child: _InfoItem(
                  label: 'Uploaded',
                  value: _formatDate(doc.createdAt),
                  icon: Symbols.calendar_today,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsRow(AnalysisModel analysis) {
    return Row(
      children: [
        Expanded(
          child: _MetricCard(
            label: 'Clauses',
            value: analysis.keyClauses.length.toString(),
            icon: Symbols.description,
            color: context.colors.primary,
          ),
        ),
        const SizedBox(width: AppSpacing.spacingMd),
        Expanded(
          child: _MetricCard(
            label: 'Deadlines',
            value: analysis.deadlines.length.toString(),
            icon: Symbols.event,
            color: AppColors.warning,
          ),
        ),
        const SizedBox(width: AppSpacing.spacingMd),
        Expanded(
          child: _MetricCard(
            label: 'Financials',
            value: analysis.financialObligations.length.toString(),
            icon: Symbols.attach_money,
            color: AppColors.success,
          ),
        ),
        const SizedBox(width: AppSpacing.spacingMd),
        Expanded(
          child: _MetricCard(
            label: 'Red Flags',
            value: analysis.redFlags.length.toString(),
            icon: Symbols.flag,
            color: AppColors.error,
          ),
        ),
      ],
    );
  }

  Widget _buildBottomActions(BuildContext context, DocumentModel doc) {
    return SafeArea(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Row(
          children: [
            Expanded(
              child: SecondaryButton(
                label: 'Chat',
                onPressed: () => AppRouter.goToDocumentChat(context, doc.id),
                leadingIcon: Symbols.chat,
                isFullWidth: true,
              ),
            ),
            const SizedBox(width: AppSpacing.spacingMd),
            Expanded(
              child: PrimaryButton(
                label: 'Checklist',
                onPressed: () => AppRouter.goToChecklist(context, doc.id),
                leadingIcon: Symbols.checklist,
                isFullWidth: true,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoreOptions(BuildContext context, DocumentModel doc) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppShapes.radiusXl)),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Symbols.translate, color: context.colors.primary),
              title: Text('Translate', style: AppTypography.labelLarge),
              onTap: () {
                Navigator.pop(context);
                AppRouter.goToTranslation(context, doc.id);
              },
            ),
            ListTile(
              leading: Icon(Symbols.delete, color: AppColors.error),
              title: Text('Delete', style: AppTypography.labelLarge.copyWith(color: AppColors.error)),
              onTap: () {
                Navigator.pop(context);
                _showDeleteDialog(context, doc);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showDeleteDialog(BuildContext context, DocumentModel doc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Document', style: AppTypography.headlineSmall),
        content: Text(
          'Are you sure you want to delete "${doc.title}"? This action cannot be undone.',
          style: AppTypography.bodyMedium,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppShapes.cardLg),
        actions: [
          TertiaryButton(
            label: 'Cancel',
            onPressed: () => Navigator.pop(context),
          ),
          FilledDestructiveButton(
            label: 'Delete',
            onPressed: () {
              Navigator.pop(context);
              context.read<DocumentCubit>().deleteDocument(doc.id);
              Navigator.pop(context);
            },
            leadingIcon: Symbols.delete,
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Color _getTypeColor(DocumentType type) {
    switch (type) {
      case DocumentType.rentalContract:
        return context.colors.primary;
      case DocumentType.employmentContract:
        return AppColors.success;
      case DocumentType.termsOfService:
        return AppColors.warning;
      case DocumentType.privacyPolicy:
        return context.colors.secondary;
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

/// Status badge widget
class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    switch (status) {
      case 'analyzed':
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spacingSm,
            vertical: AppSpacing.spacing2xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.successLight,
            borderRadius: AppShapes.chip,
            border: Border.all(color: AppColors.success.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: AppColors.success,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.spacing2xs),
              Text('Analyzed', style: AppTypography.tinyBold.copyWith(color: AppColors.success)),
            ],
          ),
        );
      case 'analyzing':
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spacingSm,
            vertical: AppSpacing.spacing2xs,
          ),
          decoration: BoxDecoration(
            color: context.isDarkMode
                ? AppColors.teal.withValues(alpha: 0.1)
                : AppColors.tealLight,
            borderRadius: AppShapes.chip,
            border: Border.all(
              color: context.isDarkMode ? AppColors.teal : AppColors.tealHover,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 10,
                height: 10,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    context.isDarkMode ? AppColors.tealHover : AppColors.teal,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.spacing2xs),
              Text(
                'Analyzing',
                style: AppTypography.tinyBold.copyWith(
                  color: context.isDarkMode ? AppColors.tealHover : AppColors.teal,
                ),
              ),
            ],
          ),
        );
      case 'failed':
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spacingSm,
            vertical: AppSpacing.spacing2xs,
          ),
          decoration: BoxDecoration(
            color: AppColors.errorLight,
            borderRadius: AppShapes.chip,
            border: Border.all(color: AppColors.error.withValues(alpha: 0.3)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Symbols.error, size: 10, color: AppColors.error),
              const SizedBox(width: AppSpacing.spacing2xs),
              Text('Failed', style: AppTypography.tinyBold.copyWith(color: AppColors.error)),
            ],
          ),
        );
      default:
        return Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spacingSm,
            vertical: AppSpacing.spacing2xs,
          ),
          decoration: BoxDecoration(
            color: context.isDarkMode ? AppColors.darkSurfaceVariant : AppColors.lightSurfaceVariant,
            borderRadius: AppShapes.chip,
            border: Border.all(
              color: context.isDarkMode ? AppColors.darkOutlineVariant : AppColors.lightOutlineVariant,
            ),
          ),
          child: Text(status, style: AppTypography.tiny.copyWith(color: context.colors.onSurfaceVariant)),
        );
    }
  }
}

/// Info item widget
class _InfoItem extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;

  const _InfoItem({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, size: 20, color: context.colors.onSurfaceVariant),
        const SizedBox(height: AppSpacing.spacingXs),
        Text(value, style: AppTypography.labelMedium),
        Text(label, style: AppTypography.tiny.copyWith(color: context.colors.onSurfaceVariant)),
      ],
    );
  }
}

/// Metric card widget
class _MetricCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  const _MetricCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacingMd),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: AppShapes.card,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, size: 24, color: color),
          const SizedBox(height: AppSpacing.spacingXs),
          Text(value, style: AppTypography.headlineSmall.copyWith(color: color, fontWeight: FontWeight.w700)),
          Text(label, style: AppTypography.tiny.copyWith(color: color)),
        ],
      ),
    );
  }
}

/// Key clause card
class _KeyClauseCard extends StatelessWidget {
  final KeyClauseModel clause;

  const _KeyClauseCard({required this.clause});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.spacingSm,
                  vertical: AppSpacing.spacing2xs,
                ),
                decoration: BoxDecoration(
                  color: _getImportanceColor(clause.importance).withValues(alpha: 0.2),
                  borderRadius: AppShapes.chip,
                ),
                child: Text(
                  clause.importance.name.toUpperCase(),
                  style: AppTypography.tinyBold.copyWith(color: _getImportanceColor(clause.importance)),
                ),
              ),
              const Spacer(),
              Text(
                'Page ${clause.pageNumber}',
                style: AppTypography.tiny.copyWith(color: context.colors.onSurfaceVariant),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.spacingSm),
          Text(clause.title, style: AppTypography.labelLarge),
          const SizedBox(height: AppSpacing.spacingXs),
          Text(clause.description, style: AppTypography.bodySmall.copyWith(color: context.colors.onSurfaceVariant)),
          const SizedBox(height: AppSpacing.spacingSm),
          Text(
            clause.clauseText,
            style: AppTypography.bodySmall.copyWith(
              fontFamily: 'monospace',
              color: context.colors.onSurfaceVariant,
            ),
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Color _getImportanceColor(ClauseImportance importance) {
    switch (importance) {
      case ClauseImportance.critical:
        return AppColors.error;
      case ClauseImportance.high:
        return AppColors.warning;
      case ClauseImportance.medium:
        return AppColors.warning;
      case ClauseImportance.low:
        return AppColors.success;
    }
  }
}

/// Deadline card
class _DeadlineCard extends StatelessWidget {
  final DeadlineModel deadline;

  const _DeadlineCard({required this.deadline});

  @override
  Widget build(BuildContext context) {
    final isOverdue = deadline.dueDate.isBefore(DateTime.now()) && !deadline.isCompleted;

    return AppCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getTypeColor(deadline.type, context).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppShapes.radiusMd),
            ),
            child: Icon(_getTypeIcon(deadline.type), color: _getTypeColor(deadline.type, context), size: 24),
          ),
          const SizedBox(width: AppSpacing.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(deadline.title, style: AppTypography.labelMedium),
                    const SizedBox(width: AppSpacing.spacingXs),
                    if (isOverdue)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.spacing2xs,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.errorLight,
                          borderRadius: AppShapes.chip,
                        ),
                        child: Text(
                          'OVERDUE',
                          style: AppTypography.tinyBold.copyWith(color: AppColors.error),
                        ),
                      ),
                    if (deadline.isCompleted) ...[
                      const SizedBox(width: AppSpacing.spacingXs),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.spacing2xs,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.successLight,
                          borderRadius: AppShapes.chip,
                        ),
                        child: Text(
                          'DONE',
                          style: AppTypography.tinyBold.copyWith(color: AppColors.success),
                        ),
                      ),
                    ],
                  ],
                ),
                Text(deadline.description, style: AppTypography.bodySmall.copyWith(color: context.colors.onSurfaceVariant)),
                Text(
                  'Due: ${_formatDate(deadline.dueDate)}',
                  style: AppTypography.tiny.copyWith(
                    color: isOverdue ? AppColors.error : context.colors.onSurfaceVariant,
                    fontWeight: isOverdue ? FontWeight.w600 : FontWeight.normal,
                  ),
                ),
              ],
            ),
          ),
          Checkbox(
            value: deadline.isCompleted,
            onChanged: (value) {},
            activeColor: context.colors.primary,
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(DeadlineType type, BuildContext context) {
    switch (type) {
      case DeadlineType.rentDue:
        return context.colors.primary;
      case DeadlineType.noticePeriod:
        return AppColors.warning;
      case DeadlineType.renewal:
        return AppColors.success;
      case DeadlineType.termination:
        return AppColors.error;
      case DeadlineType.payment:
        return context.colors.secondary;
      case DeadlineType.inspection:
        return AppColors.teal;
      case DeadlineType.other:
        return context.colors.primary;
    }
  }

  IconData _getTypeIcon(DeadlineType type) {
    switch (type) {
      case DeadlineType.rentDue:
        return Symbols.attach_money;
      case DeadlineType.noticePeriod:
        return Symbols.schedule;
      case DeadlineType.renewal:
        return Symbols.refresh;
      case DeadlineType.termination:
        return Symbols.cancel;
      case DeadlineType.payment:
        return Symbols.payments;
      case DeadlineType.inspection:
        return Symbols.search;
      case DeadlineType.other:
        return Symbols.event;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// Financial card
class _FinancialCard extends StatelessWidget {
  final FinancialObligationModel financial;

  const _FinancialCard({required this.financial});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: _getTypeColor(financial.type, context).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppShapes.radiusMd),
            ),
            child: Icon(_getTypeIcon(financial.type), color: _getTypeColor(financial.type, context), size: 24),
          ),
          const SizedBox(width: AppSpacing.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(financial.title, style: AppTypography.labelMedium),
                Text(financial.description, style: AppTypography.bodySmall.copyWith(color: context.colors.onSurfaceVariant)),
                if (financial.dueDate != null)
                  Text(
                    'Due: ${_formatDate(financial.dueDate!)}',
                    style: AppTypography.tiny.copyWith(color: context.colors.onSurfaceVariant),
                  ),
                if (financial.isRecurring)
                  Text(
                    'Recurring: ${financial.frequency}',
                    style: AppTypography.tiny.copyWith(color: context.colors.primary),
                  ),
              ],
            ),
          ),
          Text(
            '${financial.currency} ${financial.amount.toStringAsFixed(2)}',
            style: AppTypography.headlineSmall.copyWith(
              color: context.colors.primary,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(FinancialObligationType type, BuildContext context) {
    switch (type) {
      case FinancialObligationType.rent:
        return context.colors.primary;
      case FinancialObligationType.deposit:
        return context.colors.secondary;
      case FinancialObligationType.utility:
        return AppColors.warning;
      case FinancialObligationType.maintenance:
        return AppColors.teal;
      case FinancialObligationType.penalty:
        return AppColors.error;
      case FinancialObligationType.fee:
        return AppColors.warning;
      case FinancialObligationType.other:
        return context.colors.primary;
    }
  }

  IconData _getTypeIcon(FinancialObligationType type) {
    switch (type) {
      case FinancialObligationType.rent:
        return Symbols.home;
      case FinancialObligationType.deposit:
        return Symbols.account_balance_wallet;
      case FinancialObligationType.utility:
        return Symbols.bolt;
      case FinancialObligationType.maintenance:
        return Symbols.build;
      case FinancialObligationType.penalty:
        return Symbols.gavel;
      case FinancialObligationType.fee:
        return Symbols.receipt;
      case FinancialObligationType.other:
        return Symbols.attach_money;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}

/// Red flag card
class _RedFlagCard extends StatelessWidget {
  final RedFlagModel flag;

  const _RedFlagCard({required this.flag});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: _getSeverityColor(flag.severity).withValues(alpha: 0.05),
      border: Border.all(color: _getSeverityColor(flag.severity).withValues(alpha: 0.3)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.spacingSm,
                  vertical: AppSpacing.spacing2xs,
                ),
                decoration: BoxDecoration(
                  color: _getSeverityColor(flag.severity).withValues(alpha: 0.2),
                  borderRadius: AppShapes.chip,
                ),
                child: Text(
                  flag.severity.name.toUpperCase(),
                  style: AppTypography.tinyBold.copyWith(color: _getSeverityColor(flag.severity)),
                ),
              ),
              if (flag.pageNumber != null) ...[
                const Spacer(),
                Text(
                  'Page ${flag.pageNumber}',
                  style: AppTypography.tiny.copyWith(color: context.colors.onSurfaceVariant),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.spacingSm),
          Text(flag.title, style: AppTypography.labelMedium),
          const SizedBox(height: AppSpacing.spacingXs),
          Text(flag.description, style: AppTypography.bodySmall.copyWith(color: context.colors.onSurfaceVariant)),
          const SizedBox(height: AppSpacing.spacingSm),
          Container(
            padding: const EdgeInsets.all(AppSpacing.spacingSm),
            decoration: BoxDecoration(
              color: context.colors.surfaceContainerHighest,
              borderRadius: AppShapes.chip,
            ),
            child: Row(
              children: [
                Icon(Symbols.lightbulb, size: 16, color: context.colors.primary),
                const SizedBox(width: AppSpacing.spacingXs),
                Expanded(
                  child: Text(
                    'Recommendation: ${flag.recommendation}',
                    style: AppTypography.bodySmall.copyWith(color: context.colors.primary),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Color _getSeverityColor(RedFlagSeverity severity) {
    switch (severity) {
      case RedFlagSeverity.critical:
        return AppColors.error;
      case RedFlagSeverity.high:
        return AppColors.warning;
      case RedFlagSeverity.medium:
        return AppColors.warning;
      case RedFlagSeverity.low:
        return AppColors.success;
    }
  }
}

/// Checklist preview item
class _ChecklistPreviewItem extends StatelessWidget {
  final ChecklistItemModel item;

  const _ChecklistPreviewItem({required this.item});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.spacingXs),
      child: Row(
        children: [
          Checkbox(
            value: item.isCompleted,
            onChanged: null,
            activeColor: context.colors.primary,
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          const SizedBox(width: AppSpacing.spacingSm),
          Expanded(
            child: Text(
              item.title,
              style: AppTypography.bodyMedium.copyWith(
                decoration: item.isCompleted ? TextDecoration.lineThrough : null,
                color: item.isCompleted ? context.colors.onSurfaceVariant : context.colors.onSurface,
              ),
            ),
          ),
          if (item.dueDate != null)
            Text(
              '${item.dueDate!.day}/${item.dueDate!.month}',
              style: AppTypography.tiny.copyWith(color: context.colors.onSurfaceVariant),
            ),
        ],
      ),
    );
  }
}