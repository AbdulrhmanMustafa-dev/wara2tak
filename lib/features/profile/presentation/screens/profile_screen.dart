import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../../../../features/auth/index.dart';
import '../../../../../features/profile/index.dart';
import '../../../../core/design_system/index.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/navigation/app_router.dart';
import '../../../../shared/widgets/index.dart';

/// Profile screen
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  Future<void> _onRefresh(BuildContext context) async {
    final authState = context.read<AuthCubit>().state;
    if (authState is AuthAuthenticated) {
      await context.read<ProfileCubit>().loadProfile(authState.user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) return;
        AppRouter.goToHome(context);
      },
      child: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is AuthUnauthenticated) {
            AppRouter.goToAuth(context);
          }
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text('Profile', style: AppTypography.titleLarge),
            leading: AppIconButton(
              icon: Symbols.arrow_back,
              onPressed: () => AppRouter.goToHome(context),
            ),
          ),
          body: SafeArea(
            child: BlocBuilder<ProfileCubit, ProfileState>(
              builder: (context, state) {
                if (state is ProfileLoaded) {
                  final profile = state.profile;
                  return RefreshIndicator(
                    onRefresh: () => _onRefresh(context),
                    child: SingleChildScrollView(
                      padding: AppSpacing.screenPadding,
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Profile Header
                        _ProfileHeader(profile: profile),
                        const SizedBox(height: AppSpacing.spacingXl),

                        // Settings Sections
                        _buildSection(
                          context,
                          title: 'Preferences',
                          children: [
                            _SettingsTile(
                              icon: Symbols.dark_mode,
                              title: 'Dark Mode',
                              subtitle: 'Toggle dark/light theme',
                              trailing: Switch(
                                value: profile.isDarkMode,
                                onChanged: (value) => context
                                    .read<ProfileCubit>()
                                    .updateThemePreference(profile.id, value),
                                activeThumbColor: context.colors.primary,
                              ),
                            ),
                            _SettingsTile(
                              icon: Symbols.notifications,
                              title: 'Notifications',
                              subtitle: 'Enable push notifications',
                              trailing: Switch(
                                value: profile.notificationsEnabled,
                                onChanged: (value) => context
                                    .read<ProfileCubit>()
                                    .updateNotificationPreference(
                                      profile.id,
                                      value,
                                    ),
                                activeThumbColor: context.colors.primary,
                              ),
                            ),
                            _SettingsTile(
                              icon: Symbols.language,
                              title: 'Language',
                              subtitle: profile.preferredLanguage != null
                                  ? SupportedLanguages.getLanguageName(
                                      profile.preferredLanguage!,
                                    )
                                  : 'System default',
                              trailing: Icon(
                                Symbols.chevron_right,
                                color: context.colors.onSurfaceVariant,
                              ),
                              onTap: () =>
                                  _showLanguageDialog(context, profile),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSpacing.spacingLg),

                        _buildSection(
                          context,
                          title: 'Account',
                          children: [
                            _SettingsTile(
                              icon: Symbols.person,
                              title: 'Edit Profile',
                              subtitle: 'Update your personal information',
                              trailing: Icon(
                                Symbols.chevron_right,
                                color: context.colors.onSurfaceVariant,
                              ),
                              onTap: () =>
                                  _showEditProfileDialog(context, profile),
                            ),
                            _SettingsTile(
                              icon: Symbols.security,
                              title: 'Security',
                              subtitle: 'Manage password and biometric auth',
                              trailing: Icon(
                                Symbols.chevron_right,
                                color: context.colors.onSurfaceVariant,
                              ),
                              onTap: () {},
                            ),
                            _SettingsTile(
                              icon: Symbols.delete_forever,
                              title: 'Delete Account',
                              subtitle:
                                  'Permanently delete your account and data',
                              titleColor: AppColors.error,
                              trailing: Icon(
                                Symbols.chevron_right,
                                color: AppColors.error,
                              ),
                              onTap: () =>
                                  _showDeleteAccountDialog(context, profile),
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSpacing.spacingLg),

                        _buildSection(
                          context,
                          title: 'About',
                          children: [
                            _SettingsTile(
                              icon: Symbols.info,
                              title: 'Version',
                              subtitle: '1.0.0',
                              trailing: const SizedBox.shrink(),
                            ),
                            _SettingsTile(
                              icon: Symbols.description,
                              title: 'Terms of Service',
                              subtitle: 'Read our terms and conditions',
                              trailing: const SizedBox.shrink(),
                              onTap: () {},
                            ),
                            _SettingsTile(
                              icon: Symbols.privacy_tip,
                              title: 'Privacy Policy',
                              subtitle: 'Learn how we protect your data',
                              trailing: const SizedBox.shrink(),
                              onTap: () {},
                            ),
                            _SettingsTile(
                              icon: Symbols.help,
                              title: 'Help & Support',
                              subtitle: 'Get help or contact support',
                              trailing: const SizedBox.shrink(),
                              onTap: () {},
                            ),
                          ],
                        ),

                        const SizedBox(height: AppSpacing.spacingXl),

                        // Sign Out Button
                        SizedBox(
                          width: double.infinity,
                          child: DestructiveButton(
                            label: 'Sign Out',
                            onPressed: () =>
                                context.read<AuthCubit>().signOut(),
                            leadingIcon: Symbols.logout,
                            isFullWidth: true,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
                } else if (state is ProfileLoading) {
                  return const LoadingState(message: 'Loading profile...');
                } else if (state is ProfileError) {
                  return RefreshIndicator(
                    onRefresh: () => _onRefresh(context),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height -
                              56.0 -
                              MediaQuery.of(context).padding.top,
                        ),
                        child: ErrorState(
                          title: 'Failed to load profile',
                          subtitle: state.message,
                          actionLabel: 'Retry',
                          onAction: () => context.read<ProfileCubit>().loadProfile(
                            (context.read<AuthCubit>().state as AuthAuthenticated)
                                .user
                                .id,
                          ),
                        ),
                      ),
                    ),
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context, {
    required String title,
    required List<Widget> children,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: AppTypography.titleLarge),
        const SizedBox(height: AppSpacing.spacingSm),
        AppCard(
          padding: EdgeInsets.zero,
          provideMaterial: true, // Required for ListTile ink splash
          child: Column(
            children: children
                .expand(
                  (widget) => [
                    widget,
                    if (widget != children.last)
                      Divider(
                        height: 1,
                        indent:
                            AppSpacing.spacingMd + 48 + AppSpacing.spacingMd,
                        color: context.isDarkMode
                            ? AppColors.darkOutlineVariant
                            : AppColors.lightOutlineVariant,
                      ),
                  ],
                )
                .toList(),
          ),
        ),
      ],
    );
  }

  void _showLanguageDialog(BuildContext context, ProfileModel profile) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select Language', style: AppTypography.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: SupportedLanguages.languages.entries.map((entry) {
            final isSelected = profile.preferredLanguage == entry.key;
            return RadioListTile<String>(
              title: Text(entry.value, style: AppTypography.bodyMedium),
              value: entry.key,
              groupValue: profile.preferredLanguage,
              activeColor: context.colors.primary,
              onChanged: (value) {
                if (value != null) {
                  context.read<ProfileCubit>().updateLanguagePreference(
                    profile.id,
                    value,
                  );
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
        actions: [
          TertiaryButton(
            label: 'Cancel',
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, ProfileModel profile) {
    final nameController = TextEditingController(
      text: profile.displayName ?? '',
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Profile', style: AppTypography.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: 'Display Name',
                labelStyle: AppTypography.bodyMedium,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(AppShapes.radiusMd),
                ),
              ),
              style: AppTypography.bodyMedium,
            ),
          ],
        ),
        actions: [
          TertiaryButton(
            label: 'Cancel',
            onPressed: () => Navigator.pop(context),
          ),
          PrimaryButton(
            label: 'Save',
            onPressed: () {
              context.read<ProfileCubit>().updateProfile(
                profile.copyWith(
                  displayName: nameController.text.isEmpty
                      ? null
                      : nameController.text,
                  updatedAt: DateTime.now(),
                ),
              );
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  void _showDeleteAccountDialog(BuildContext context, ProfileModel profile) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          'Delete Account',
          style: AppTypography.titleLarge.copyWith(color: AppColors.error),
        ),
        content: Text(
          'This action cannot be undone. All your documents, analyses, and data will be permanently deleted.',
          style: AppTypography.bodyMedium,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppShapes.cardLg),
        actions: [
          TertiaryButton(
            label: 'Cancel',
            onPressed: () => Navigator.pop(context),
          ),
          FilledDestructiveButton(
            label: 'Delete Account',
            onPressed: () {
              Navigator.pop(context);
              context.read<ProfileCubit>().deleteAccount(profile.id);
            },
            leadingIcon: Symbols.delete_forever,
          ),
        ],
      ),
    );
  }
}

/// Profile header widget
class _ProfileHeader extends StatelessWidget {
  final ProfileModel profile;

  const _ProfileHeader({required this.profile});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 40,
          backgroundColor: context.colors.primaryContainer,
          backgroundImage: profile.photoUrl != null
              ? NetworkImage(profile.photoUrl!)
              : null,
          child: profile.photoUrl == null
              ? Text(
                  profile.displayName?.isNotEmpty == true
                      ? profile.displayName![0].toUpperCase()
                      : profile.email[0].toUpperCase(),
                  style: AppTypography.headlineMedium.copyWith(
                    color: context.colors.primary,
                  ),
                )
              : null,
        ),
        const SizedBox(width: AppSpacing.spacingMd),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                profile.displayName ?? 'User',
                style: AppTypography.headlineSmall,
              ),
              Text(
                profile.email,
                style: AppTypography.bodyMedium.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ),
        TertiaryButton(
          label: 'Edit',
          onPressed: () {},
          leadingIcon: Symbols.edit,
        ),
      ],
    );
  }
}

/// Settings tile widget
class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final Widget trailing;
  final VoidCallback? onTap;
  final Color? titleColor;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.trailing,
    this.onTap,
    this.titleColor,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: (titleColor ?? context.colors.primary).withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppShapes.radiusMd),
        ),
        child: Icon(
          icon,
          color: titleColor ?? context.colors.primary,
          size: 20,
        ),
      ),
      title: Text(
        title,
        style: AppTypography.labelLarge.copyWith(color: titleColor),
      ),
      subtitle: Text(
        subtitle,
        style: AppTypography.bodySmall.copyWith(
          color: context.colors.onSurfaceVariant,
        ),
      ),
      trailing: trailing,
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.spacingMd,
      ),
    );
  }
}

/// Supported languages (re-exported from translation feature)
class SupportedLanguages {
  static const Map<String, String> languages = {
    'ar': 'Arabic',
    'en': 'English',
    'fr': 'French',
    'es': 'Spanish',
    'de': 'German',
    'zh': 'Chinese',
    'hi': 'Hindi',
    'ur': 'Urdu',
    'tr': 'Turkish',
    'fa': 'Persian',
  };

  static String getLanguageName(String code) {
    return languages[code] ?? code.toUpperCase();
  }

  static bool isRTL(String code) {
    return ['ar', 'ur', 'fa'].contains(code);
  }
}
