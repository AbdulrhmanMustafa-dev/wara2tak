import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../../../core/design_system/index.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../shared/widgets/index.dart';
import '../../index.dart';
import '../cubit/document_cubit.dart';
import '../cubit/document_state.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';

/// My Documents screen
class MyDocumentsScreen extends StatelessWidget {
  const MyDocumentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          AppRouter.goToAuth(context);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text('My Documents', style: AppTypography.titleLarge),
          actions: [
            AppIconButton(
              icon: Symbols.search,
              onPressed: () {},
            ),
            AppIconButton(
              icon: Symbols.filter_list,
              onPressed: () {},
            ),
          ],
        ),
        body: SafeArea(
          child: BlocBuilder<DocumentCubit, DocumentState>(
            builder: (context, state) {
              if (state is DocumentsLoaded) {
                if (state.documents.isEmpty) {
                  return EmptyState(
                    icon: Symbols.folder_open,
                    title: 'No documents yet',
                    subtitle: 'Upload your first document to get started',
                    actionLabel: 'Upload Document',
                    onAction: () => AppRouter.goToUpload(context),
                  );
                }

                return ListView.separated(
                  padding: AppSpacing.screenPadding,
                  itemCount: state.documents.length,
                  separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.spacingMd),
                  itemBuilder: (context, index) {
                    final doc = state.documents[index];
                    return DocumentCard(
                      title: doc.title,
                      type: doc.typeLabel,
                      status: doc.status.name,
                      deadlineText: _getDeadlineText(doc),
                      taskProgressText: doc.status == DocumentStatus.analyzed
                          ? 'Ready for review'
                          : null,
                      typeColor: _getTypeColor(context, doc.type),
                      typeIcon: _getTypeIcon(doc.type),
                      onTap: () => AppRouter.goToDocumentDetails(context, doc.id),
                      onDelete: () => _showDeleteDialog(context, doc),
                      trailingActions: _buildTrailingActions(context, doc),
                    );
                  },
                );
              } else if (state is DocumentLoading) {
                return const LoadingState(message: 'Loading documents...');
              } else if (state is DocumentError) {
                return ErrorState(
                  title: 'Failed to load documents',
                  subtitle: state.message,
                  actionLabel: 'Retry',
                  onAction: () => context.read<DocumentCubit>().loadUserDocuments(
                        (context.read<AuthCubit>().state as AuthAuthenticated).user.id,
                      ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => AppRouter.goToUpload(context),
          icon: Icon(Symbols.add),
          label: Text('Upload', style: AppTypography.labelLarge),
          backgroundColor: context.colors.primary,
          foregroundColor: context.colors.onPrimary,
        ),
      ),
    );
  }

  String? _getDeadlineText(DocumentModel doc) {
    // This would come from analysis data
    return null;
  }

  Widget? _buildTrailingActions(BuildContext context, DocumentModel doc) {
    if (doc.status == DocumentStatus.analyzed) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TertiaryButton(
            label: 'Chat',
            onPressed: () => AppRouter.goToDocumentChat(context, doc.id),
            leadingIcon: Symbols.chat,
            isFullWidth: false,
          ),
          const SizedBox(width: AppSpacing.spacingXs),
          TertiaryButton(
            label: 'Checklist',
            onPressed: () => AppRouter.goToChecklist(context, doc.id),
            leadingIcon: Symbols.checklist,
            isFullWidth: false,
          ),
        ],
      );
    }
    return null;
  }

  void _showDeleteDialog(BuildContext context, DocumentModel doc) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Delete Document', style: AppTypography.titleLarge),
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
            },
            leadingIcon: Symbols.delete,
          ),
        ],
      ),
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