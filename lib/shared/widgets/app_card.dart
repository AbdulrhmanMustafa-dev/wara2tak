import 'package:material_ui/material_ui.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:intl/intl.dart';

import '../../core/design_system/index.dart';
import '../../core/extensions/context_extensions.dart';
import 'app_button.dart';

/// Base card widget with consistent styling
class AppCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final List<BoxShadow>? shadows;
  final Border? border;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;
  final bool isInteractive;
  final bool provideMaterial;

  const AppCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.shadows,
    this.border,
    this.borderRadius,
    this.onTap,
    this.isInteractive = false,
    this.provideMaterial = false,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      margin: margin,
      padding: padding ?? AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: color ?? context.colors.surface,
        borderRadius: borderRadius ?? AppShapes.card,
        border:
            border ??
            Border.all(
              color: context.isDarkMode
                  ? AppColors.darkOutlineVariant
                  : AppColors.lightOutlineVariant,
              width: 1,
            ),
        boxShadow: shadows ?? (context.isDarkMode ? [] : AppShapes.cardShadow),
      ),
      child: child,
    );

    // Wrap with Material to provide ancestor for ListTile, InkWell, etc.
    final withMaterial = Material(color: Colors.transparent, child: card);

    if (onTap != null || isInteractive) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? AppShapes.card,
          child: card,
        ),
      );
    }

    if (provideMaterial) {
      return withMaterial;
    }

    return card;
  }
}

/// Elevated card with shadow
class ElevatedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color? color;
  final BorderRadius? borderRadius;
  final VoidCallback? onTap;

  const ElevatedCard({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.color,
    this.borderRadius,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Container(
      margin: margin,
      padding: padding ?? AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: color ?? context.colors.surface,
        borderRadius: borderRadius ?? AppShapes.cardLg,
        boxShadow: context.isDarkMode
            ? AppShapes.modalShadow
            : AppShapes.cardShadowElevated,
      ),
      child: child,
    );

    if (onTap != null) {
      return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: borderRadius ?? AppShapes.cardLg,
          child: card,
        ),
      );
    }

    return card;
  }
}

/// Action card with prominent CTA (used in home screen)
class ActionCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String buttonLabel;
  final VoidCallback onPressed;
  final IconData? leadingIcon;
  final IconData? emblemIcon;
  final Color? emblemColor;
  final Widget? trailingWidget;

  const ActionCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.buttonLabel,
    required this.onPressed,
    this.leadingIcon,
    this.emblemIcon,
    this.emblemColor,
    this.trailingWidget,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: AppSpacing.cardPadding,
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppShapes.cardLg,
        border: Border.all(
          color: context.isDarkMode
              ? AppColors.darkOutlineVariant
              : AppColors.lightOutlineVariant,
        ),
        boxShadow: context.isDarkMode ? [] : AppShapes.cardShadow,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (leadingIcon != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.spacingSm,
                          vertical: AppSpacing.spacing2xs,
                        ),
                        decoration: BoxDecoration(
                          color: context.isDarkMode
                              ? AppColors.darkSecondary
                              : AppColors.lightSecondary,
                          borderRadius: AppShapes.chip,
                          border: Border.all(
                            color: context.isDarkMode
                                ? AppColors.darkOutlineVariant
                                : AppColors.lightOutlineVariant,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              leadingIcon,
                              size: 14,
                              color: context.colors.primary,
                            ),
                            const SizedBox(width: AppSpacing.spacing2xs),
                            Text(
                              context.l10n.aiDocumentIntelligence,
                              style: AppTypography.labelSmall.copyWith(
                                color: context.colors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppSpacing.spacingSm),
                    ],
                    Text(title, style: AppTypography.headlineSmall),
                    const SizedBox(height: AppSpacing.spacingXs),
                    Text(subtitle, style: AppTypography.bodySmall),
                  ],
                ),
              ),
              ?trailingWidget,
              if (emblemIcon != null) ...[
                const SizedBox(width: AppSpacing.spacingMd),
                Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color: (emblemColor ?? context.colors.primaryContainer)
                        .withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(AppShapes.radiusXl),
                    border: Border.all(
                      color: context.isDarkMode
                          ? AppColors.darkOutlineVariant
                          : AppColors.lightOutlineVariant,
                    ),
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Icon(
                        emblemIcon,
                        size: 30,
                        color: emblemColor ?? context.colors.primary,
                      ),
                      Positioned(
                        top: -2,
                        right: -2,
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: context.colors.primaryContainer,
                            borderRadius: AppShapes.chip,
                            boxShadow: context.isDarkMode
                                ? []
                                : AppShapes.cardShadow,
                          ),
                          child: Icon(
                            Symbols.auto_awesome,
                            size: 12,
                            color: context.isDarkMode
                                ? AppColors.darkOnPrimary
                                : AppColors.lightOnPrimary,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: AppSpacing.spacingMd),
          PrimaryButton(
            label: buttonLabel,
            onPressed: onPressed,
            leadingIcon: Symbols.add_circle,
            isFullWidth: true,
          ),
        ],
      ),
    );
  }
}

/// Document card for lists (used in My Documents, Home)
class DocumentCard extends StatelessWidget {
  final String title;
  final String type;
  final String status; // 'analyzed', 'analyzing', 'failed'
  final DateTime? date;
  final int? pageCount;
  final bool wasAnalyzed;
  final String? deadlineText;
  final String? taskProgressText;
  final Color? typeColor;
  final IconData? typeIcon;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final Widget? trailingActions;

  const DocumentCard({
    super.key,
    required this.title,
    required this.type,
    required this.status,
    this.date,
    this.pageCount,
    this.wasAnalyzed = false,
    this.deadlineText,
    this.taskProgressText,
    this.typeColor,
    this.typeIcon,
    this.onTap,
    this.onDelete,
    this.trailingActions,
  });

  @override
  Widget build(BuildContext context) {
    final metadataText = date == null || pageCount == null
        ? null
        : wasAnalyzed
        ? context.l10n.analyzedOn(
            DateFormat.yMMMd(context.locale.toString()).format(date!),
            pageCount!,
          )
        : context.l10n.uploadedOn(
            DateFormat.yMMMd(context.locale.toString()).format(date!),
            pageCount!,
          );

    return AppCard(
      onTap: onTap,
      isInteractive: onTap != null,
      padding: const EdgeInsets.all(AppSpacing.spacingMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 40,
                height: 48,
                decoration: BoxDecoration(
                  color: (typeColor ?? context.colors.primaryContainer)
                      .withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(AppShapes.radiusMd),
                  border: Border.all(
                    color: context.isDarkMode
                        ? AppColors.darkOutlineVariant
                        : AppColors.lightOutlineVariant,
                  ),
                ),
                child: Center(
                  child: Icon(
                    typeIcon ?? Symbols.description,
                    size: 20,
                    color: typeColor ?? context.colors.primary,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.spacingMd),
              Expanded(
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
                            color: context.isDarkMode
                                ? AppColors.darkSecondary
                                : AppColors.lightSecondary,
                            borderRadius: AppShapes.chip,
                          ),
                          child: Text(
                            type,
                            style: AppTypography.tinyBold.copyWith(
                              color: context.colors.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: AppSpacing.spacingXs),
                        _StatusBadge(status: status),
                      ],
                    ),
                    const SizedBox(height: AppSpacing.spacingXs),
                    Text(
                      title,
                      style: AppTypography.labelLarge,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: AppSpacing.spacing2xs),
                    if (metadataText != null)
                      Text(
                        metadataText,
                        style: AppTypography.tiny.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                  ],
                ),
              ),
              if (onDelete != null)
                AppIconButton(
                  icon: Symbols.delete,
                  onPressed: onDelete,
                  color: context.colors.onSurfaceVariant,
                ),
            ],
          ),
          if (deadlineText != null || taskProgressText != null) ...[
            const SizedBox(height: AppSpacing.spacingMd),
            const Divider(height: 1),
            const SizedBox(height: AppSpacing.spacingMd),
            Row(
              children: [
                if (taskProgressText != null) ...[
                  Text(
                    taskProgressText!,
                    style: AppTypography.tiny.copyWith(
                      color: context.colors.onSurfaceVariant,
                    ),
                  ),
                ],
                const Spacer(),
                if (deadlineText != null) _DeadlineBadge(text: deadlineText!),
              ],
            ),
          ],
          if (trailingActions != null) ...[
            const SizedBox(height: AppSpacing.spacingMd),
            trailingActions!,
          ],
        ],
      ),
    );
  }
}

/// Status badge for document cards
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
              Text(
                context.l10n.statusAnalyzed,
                style: AppTypography.tinyBold.copyWith(
                  color: AppColors.success,
                ),
              ),
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
                context.l10n.statusAnalyzing,
                style: AppTypography.tinyBold.copyWith(
                  color: context.isDarkMode
                      ? AppColors.tealHover
                      : AppColors.teal,
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
              Text(
                context.l10n.statusFailed,
                style: AppTypography.tinyBold.copyWith(color: AppColors.error),
              ),
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
            color: context.isDarkMode
                ? AppColors.darkSurfaceVariant
                : AppColors.lightSurfaceVariant,
            borderRadius: AppShapes.chip,
            border: Border.all(
              color: context.isDarkMode
                  ? AppColors.darkOutlineVariant
                  : AppColors.lightOutlineVariant,
            ),
          ),
          child: Text(
            context.l10n.statusUploaded,
            style: AppTypography.tiny.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
        );
    }
  }
}

/// Deadline badge with color coding
class _DeadlineBadge extends StatelessWidget {
  final String text;

  const _DeadlineBadge({required this.text});

  @override
  Widget build(BuildContext context) {
    final isUrgent =
        text.toLowerCase().contains('passed') ||
        text.toLowerCase().contains('overdue') ||
        text.toLowerCase().contains('day');

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spacingSm,
        vertical: AppSpacing.spacing2xs,
      ),
      decoration: BoxDecoration(
        color: isUrgent
            ? (context.isDarkMode
                  ? AppColors.warningDark.withValues(alpha: 0.2)
                  : AppColors.warningLight)
            : (context.isDarkMode
                  ? AppColors.darkSurfaceVariant
                  : AppColors.lightSurfaceVariant),
        borderRadius: AppShapes.chip,
        border: Border.all(
          color: isUrgent
              ? AppColors.warning
              : (context.isDarkMode
                    ? AppColors.darkOutlineVariant
                    : AppColors.lightOutlineVariant),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isUrgent) ...[
            Icon(
              Symbols.alarm,
              size: 13,
              color: context.isDarkMode
                  ? AppColors.warning
                  : AppColors.warningText,
            ),
            const SizedBox(width: AppSpacing.spacing2xs),
          ],
          Text(
            text,
            style: AppTypography.tinyBold.copyWith(
              color: isUrgent
                  ? (context.isDarkMode
                        ? AppColors.warning
                        : AppColors.warningText)
                  : context.colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

/// Empty state widget
class EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  const EmptyState({
    super.key,
    required this.icon,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: context.isDarkMode
                    ? AppColors.darkSecondary
                    : AppColors.lightSecondary,
                borderRadius: BorderRadius.circular(AppShapes.radiusXl),
                border: Border.all(
                  color: context.isDarkMode
                      ? AppColors.darkOutlineVariant
                      : AppColors.lightOutlineVariant,
                ),
              ),
              child: Icon(icon, size: 32, color: context.colors.primary),
            ),
            const SizedBox(height: AppSpacing.spacingLg),
            Text(
              title,
              style: AppTypography.headlineSmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.spacingSm),
            Text(
              subtitle,
              style: AppTypography.bodySmall.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.spacingXl),
              PrimaryButton(
                label: actionLabel!,
                onPressed: onAction,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Error state widget
class ErrorState extends StatelessWidget {
  final String title;
  final String subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;
  final IconData icon;

  const ErrorState({
    super.key,
    required this.title,
    required this.subtitle,
    this.actionLabel,
    this.onAction,
    this.icon = Symbols.error_outline,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: AppSpacing.screenPadding,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.errorLight,
                borderRadius: BorderRadius.circular(AppShapes.radiusXl),
              ),
              child: Icon(icon, size: 28, color: AppColors.error),
            ),
            const SizedBox(height: AppSpacing.spacingLg),
            Text(
              title,
              style: AppTypography.labelLarge.copyWith(color: AppColors.error),
            ),
            const SizedBox(height: AppSpacing.spacingSm),
            Text(
              subtitle,
              style: AppTypography.bodySmall.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.spacingXl),
              FilledDestructiveButton(
                label: actionLabel!,
                onPressed: onAction,
                isFullWidth: false,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// Loading state widget
class LoadingState extends StatelessWidget {
  final String? message;
  final double size;

  const LoadingState({super.key, this.message, this.size = 32});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: size,
            height: size,
            child: CircularProgressIndicator(
              strokeWidth: 3,
              valueColor: AlwaysStoppedAnimation<Color>(context.colors.primary),
            ),
          ),
          if (message != null) ...[
            const SizedBox(height: AppSpacing.spacingMd),
            Text(
              message!,
              style: AppTypography.bodySmall.copyWith(
                color: context.colors.onSurfaceVariant,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
