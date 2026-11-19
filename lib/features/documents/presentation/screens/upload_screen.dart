import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../../../core/design_system/index.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../shared/widgets/index.dart';
import '../../../analysis/presentation/cubit/analysis_cubit.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../index.dart';

/// Upload document screen
class UploadScreen extends StatefulWidget {
  const UploadScreen({super.key});

  @override
  State<UploadScreen> createState() => _UploadScreenState();
}

class _UploadScreenState extends State<UploadScreen> {
  DocumentType _selectedType = DocumentType.other;
  final _titleController = TextEditingController();
  File? _selectedFile;
  String? _fileName;
  bool _isPicking = false;

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  Future<void> _pickFile() async {
    setState(() => _isPicking = true);

    try {
      final result = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'png', 'jpg', 'jpeg'],
      );

      if (result.isNotEmpty && result.single.path != null) {
        setState(() {
          _selectedFile = File(result.single.path!);
          _fileName = result.single.name;
          if (_titleController.text.isEmpty) {
            _titleController.text = _fileName!.replaceAll(
              RegExp(r'\.[^.]+$'),
              '',
            );
          }
        });
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar(context.l10n.failedToPickFile);
      }
    } finally {
      setState(() => _isPicking = false);
    }
  }

  Future<void> _pickImage(ImageSource source) async {
    setState(() => _isPicking = true);

    try {
      final picker = ImagePicker();
      final image = await picker.pickImage(source: source, imageQuality: 85);

      if (image != null) {
        setState(() {
          _selectedFile = File(image.path);
          _fileName = image.name;
          if (_titleController.text.isEmpty) {
            _titleController.text = _fileName!.replaceAll(
              RegExp(r'\.[^.]+$'),
              '',
            );
          }
        });
      }
    } catch (e) {
      if (mounted) {
        context.showErrorSnackBar(context.l10n.failedToPickImage);
      }
    } finally {
      setState(() => _isPicking = false);
    }
  }

  void _showImageSourceDialog() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppShapes.radiusXl),
        ),
      ),
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: Icon(Symbols.camera_alt, color: context.colors.primary),
              title: Text(context.l10n.camera, style: AppTypography.labelLarge),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: Icon(
                Symbols.photo_library,
                color: context.colors.primary,
              ),
              title: Text(
                context.l10n.gallery,
                style: AppTypography.labelLarge,
              ),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _uploadDocument() async {
    if (_selectedFile == null) {
      context.showErrorSnackBar(context.l10n.selectFileFirst);
      return;
    }

    final authState = context.read<AuthCubit>().state;
    if (authState is! AuthAuthenticated) {
      context.showErrorSnackBar(context.l10n.signInFirst);
      return;
    }

    await context.read<DocumentCubit>().uploadDocument(
      userId: authState.user.id,
      filePath: _selectedFile!.path,
      fileName: _fileName!,
      type: _selectedType,
      title: _titleController.text.isEmpty ? _fileName : _titleController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    DocumentModel? uploadedDocument;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) return;
        AppRouter.goToHome(context);
      },
      child: BlocListener<DocumentCubit, DocumentState>(
        listener: (context, state) {
          if (state is DocumentsLoaded) {
            // Check if a new document was added (first in list)
            if (state.documents.isNotEmpty &&
                uploadedDocument == null &&
                state.documents.first.status == DocumentStatus.uploaded) {
              uploadedDocument = state.documents.first;
              context.showSnackBar(context.l10n.documentUploaded);
              // Trigger AI Analysis with local file path
              final authState = context.read<AuthCubit>().state;
              if (authState is AuthAuthenticated && _selectedFile != null) {
                context.read<AnalysisCubit>().analyzeDocument(
                  document: uploadedDocument!,
                  localFilePath: _selectedFile!.path,
                  userId: authState.user.id,
                );
                // Go to Progress Screen
                AppRouter.goToAnalysisProgress(context);
              }
            }
          } else if (state is DocumentError) {
            context.showErrorSnackBar(
              context.localizedErrorMessage(state.message),
            );
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              context.l10n.uploadTitle,
              style: AppTypography.titleLarge,
            ),
            leading: AppIconButton(
              icon: Symbols.arrow_back,
              onPressed: () => AppRouter.goToHome(context),
            ),
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: AppSpacing.screenPadding,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // File Selection
                  Text(
                    context.l10n.selectFile,
                    style: AppTypography.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.spacingSm),

                  _FileDropZone(
                    file: _selectedFile,
                    fileName: _fileName,
                    onPickFile: _pickFile,
                    onPickImage: _showImageSourceDialog,
                    isPicking: _isPicking,
                  ),

                  const SizedBox(height: AppSpacing.spacingXl),

                  // Document Title
                  Text(
                    context.l10n.documentTitle,
                    style: AppTypography.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.spacingSm),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      hintText: context.l10n.enterDocumentTitle,
                      hintStyle: AppTypography.bodyMedium.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                      border: OutlineInputBorder(
                        borderRadius: AppShapes.inputField,
                      ),
                      filled: true,
                      fillColor: context.colors.surfaceContainerHighest,
                    ),
                    style: AppTypography.bodyMedium,
                  ),

                  const SizedBox(height: AppSpacing.spacingXl),

                  // Document Type
                  Text(
                    context.l10n.documentType,
                    style: AppTypography.titleLarge,
                  ),
                  const SizedBox(height: AppSpacing.spacingSm),
                  Wrap(
                    spacing: AppSpacing.spacingSm,
                    runSpacing: AppSpacing.spacingSm,
                    children: DocumentType.values.map((type) {
                      final isSelected = _selectedType == type;
                      return FilterChip(
                        label: Text(_getTypeLabel(context, type)),
                        selected: isSelected,
                        onSelected: (selected) {
                          if (selected) {
                            setState(() => _selectedType = type);
                          }
                        },
                        selectedColor: context.colors.primaryContainer,
                        checkmarkColor: context.colors.primary,
                        labelStyle: AppTypography.labelMedium.copyWith(
                          color: isSelected
                              ? context.colors.primary
                              : context.colors.onSurface,
                        ),
                        side: BorderSide(
                          color: isSelected
                              ? context.colors.primary
                              : (context.isDarkMode
                                    ? AppColors.darkOutlineVariant
                                    : AppColors.lightOutlineVariant),
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: AppShapes.chip,
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: AppSpacing.spacingXl * 2),

                  // Upload Button
                  BlocBuilder<DocumentCubit, DocumentState>(
                    builder: (context, state) {
                      final isLoading =
                          state is DocumentLoading ||
                          state is DocumentUploadProgress;

                      return PrimaryButton(
                        label: context.l10n.uploadButton,
                        onPressed: isLoading ? null : _uploadDocument,
                        isLoading: isLoading,
                        leadingIcon: Symbols.cloud_upload,
                        isFullWidth: true,
                      );
                    },
                  ),

                  if (_selectedFile != null) ...[
                    const SizedBox(height: AppSpacing.spacingMd),
                    Text(
                      context.l10n.supportedFormats,
                      style: AppTypography.bodySmall.copyWith(
                        color: context.colors.onSurfaceVariant,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _getTypeLabel(BuildContext context, DocumentType type) {
    switch (type) {
      case DocumentType.rentalContract:
        return context.l10n.documentTypeRental;
      case DocumentType.employmentContract:
        return context.l10n.documentTypeEmployment;
      case DocumentType.termsOfService:
        return context.l10n.documentTypeTerms;
      case DocumentType.privacyPolicy:
        return context.l10n.documentTypePrivacy;
      case DocumentType.other:
        return context.l10n.documentTypeOther;
    }
  }
}

/// File drop zone widget
class _FileDropZone extends StatelessWidget {
  final File? file;
  final String? fileName;
  final VoidCallback onPickFile;
  final VoidCallback onPickImage;
  final bool isPicking;

  const _FileDropZone({
    required this.file,
    this.fileName,
    required this.onPickFile,
    required this.onPickImage,
    required this.isPicking,
  });

  @override
  Widget build(BuildContext context) {
    if (file != null) {
      return _SelectedFileCard(
        fileName: fileName!,
        onRemove: onPickFile, // Parent will handle state change
        onChange: onPickFile,
      );
    }

    return Column(
      children: [
        // Main drop zone
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(AppSpacing.spacingXl),
          decoration: BoxDecoration(
            color: context.colors.surfaceContainerHighest,
            borderRadius: AppShapes.card,
            border: Border.all(
              color: context.isDarkMode
                  ? AppColors.darkOutlineVariant
                  : AppColors.lightOutlineVariant,
              width: 2,
              style: BorderStyle.solid,
            ),
          ),
          child: Column(
            children: [
              Icon(
                Symbols.cloud_upload,
                size: 48,
                color: context.colors.primary,
              ),
              const SizedBox(height: AppSpacing.spacingMd),
              Text(
                context.l10n.dragDropFileHere,
                style: AppTypography.labelLarge.copyWith(
                  color: context.colors.onSurface,
                ),
              ),
              const SizedBox(height: AppSpacing.spacingXs),
              Text(
                context.l10n.orTapToBrowse,
                style: AppTypography.bodySmall.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ).whenTapped(onPickFile),

        const SizedBox(height: AppSpacing.spacingMd),

        // Alternative options
        Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isPicking ? null : onPickFile,
                icon: Icon(Symbols.insert_drive_file, size: 20),
                label: Text(
                  context.l10n.chooseFile,
                  style: AppTypography.labelMedium,
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.spacingMd,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: AppShapes.button),
                ),
              ),
            ),
            const SizedBox(width: AppSpacing.spacingMd),
            Expanded(
              child: OutlinedButton.icon(
                onPressed: isPicking ? null : onPickImage,
                icon: Icon(Symbols.add_photo_alternate, size: 20),
                label: Text(
                  context.l10n.cameraGallery,
                  style: AppTypography.labelMedium,
                ),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                    vertical: AppSpacing.spacingMd,
                  ),
                  shape: RoundedRectangleBorder(borderRadius: AppShapes.button),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Selected file card widget
class _SelectedFileCard extends StatelessWidget {
  final String fileName;
  final VoidCallback onRemove;
  final VoidCallback onChange;

  const _SelectedFileCard({
    required this.fileName,
    required this.onRemove,
    required this.onChange,
  });

  @override
  Widget build(BuildContext context) {
    final isPdf = fileName.toLowerCase().endsWith('.pdf');

    return Container(
      padding: const EdgeInsets.all(AppSpacing.spacingMd),
      decoration: BoxDecoration(
        color: context.colors.surface,
        borderRadius: AppShapes.card,
        border: Border.all(
          color: context.isDarkMode
              ? AppColors.darkOutlineVariant
              : AppColors.lightOutlineVariant,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: context.colors.primaryContainer.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(AppShapes.radiusMd),
            ),
            child: Icon(
              isPdf ? Symbols.picture_as_pdf : Symbols.image,
              color: context.colors.primary,
              size: 24,
            ),
          ),
          const SizedBox(width: AppSpacing.spacingMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  style: AppTypography.labelMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  isPdf ? context.l10n.pdfDocument : context.l10n.imageFile,
                  style: AppTypography.bodySmall.copyWith(
                    color: context.colors.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          TertiaryButton(
            label: context.l10n.change,
            onPressed: onChange,
            leadingIcon: Symbols.edit,
          ),
          const SizedBox(width: AppSpacing.spacingXs),
          AppIconButton(
            icon: Symbols.close,
            onPressed: onRemove,
            color: context.colors.onSurfaceVariant,
          ),
        ],
      ),
    ).whenTapped(onChange);
  }
}
