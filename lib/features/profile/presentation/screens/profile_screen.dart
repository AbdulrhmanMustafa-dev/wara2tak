import 'package:material_ui/material_ui.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../../../../features/auth/index.dart';
import '../../../../../features/profile/index.dart';
import '../../../../core/design_system/index.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../../../../core/l10n/locale_cubit.dart';
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
            title: Text(context.l10n.profile, style: AppTypography.titleLarge),
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
                            title: context.l10n.preferences,
                            children: [
                              _SettingsTile(
                                icon: Symbols.dark_mode,
                                title: context.l10n.darkMode,
                                subtitle: context.l10n.toggleDarkLightTheme,
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
                                title: context.l10n.notifications,
                                subtitle: context.l10n.enablePushNotifications,
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
                              // App Language (en/ar) - using LocaleCubit
                              _SettingsTile(
                                icon: Symbols.language,
                                title: context.l10n.appLanguage,
                                subtitle:
                                    context.watch<LocaleCubit>().state
                                        is LocaleLoaded
                                    ? (context.watch<LocaleCubit>().state
                                                      as LocaleLoaded)
                                                  .locale
                                                  .languageCode ==
                                              'ar'
                                          ? context.l10n.arabic
                                          : context.l10n.english
                                    : context.l10n.english,
                                trailing: Icon(
                                  Symbols.chevron_right,
                                  color: context.colors.onSurfaceVariant,
                                ),
                                onTap: () => _showAppLanguageDialog(context),
                              ),
                              // Default Translation Language (10 languages) - using ProfileCubit
                              _SettingsTile(
                                icon: Symbols.translate,
                                title: context.l10n.defaultTranslationLanguage,
                                subtitle:
                                    profile.defaultTranslationLanguage != null
                                    ? TranslationLanguages.getLanguageName(
                                        context,
                                        profile.defaultTranslationLanguage!,
                                      )
                                    : context.l10n.systemDefault,
                                trailing: Icon(
                                  Symbols.chevron_right,
                                  color: context.colors.onSurfaceVariant,
                                ),
                                onTap: () => _showTranslationLanguageDialog(
                                  context,
                                  profile,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: AppSpacing.spacingLg),

                          _buildSection(
                            context,
                            title: context.l10n.account,
                            children: [
                              _SettingsTile(
                                icon: Symbols.person,
                                title: context.l10n.editProfile,
                                subtitle:
                                    context.l10n.updatePersonalInformation,
                                trailing: Icon(
                                  Symbols.chevron_right,
                                  color: context.colors.onSurfaceVariant,
                                ),
                                onTap: () =>
                                    _showEditProfileDialog(context, profile),
                              ),
                              _SettingsTile(
                                icon: Symbols.security,
                                title: context.l10n.security,
                                subtitle: context.l10n.managePasswordBiometric,
                                trailing: Icon(
                                  Symbols.chevron_right,
                                  color: context.colors.onSurfaceVariant,
                                ),
                                onTap: () {},
                              ),
                              _SettingsTile(
                                icon: Symbols.delete_forever,
                                title: context.l10n.deleteAccount,
                                subtitle:
                                    context.l10n.permanentlyDeleteAccountData,
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
                            title: context.l10n.about,
                            children: [
                              _SettingsTile(
                                icon: Symbols.info,
                                title: context.l10n.version,
                                subtitle: '1.0.0',
                                trailing: const SizedBox.shrink(),
                              ),
                              _SettingsTile(
                                icon: Symbols.description,
                                title: context.l10n.termsOfService,
                                subtitle: context.l10n.readTermsConditions,
                                trailing: const SizedBox.shrink(),
                                onTap: () {},
                              ),
                              _SettingsTile(
                                icon: Symbols.privacy_tip,
                                title: context.l10n.privacyPolicy,
                                subtitle: context.l10n.learnHowWeProtectData,
                                trailing: const SizedBox.shrink(),
                                onTap: () {},
                              ),
                              _SettingsTile(
                                icon: Symbols.help,
                                title: context.l10n.helpSupport,
                                subtitle: context.l10n.getHelpContactSupport,
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
                              label: context.l10n.signOut,
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
                  return LoadingState(message: context.l10n.loadingProfile);
                } else if (state is ProfileError) {
                  return RefreshIndicator(
                    onRefresh: () => _onRefresh(context),
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: ConstrainedBox(
                        constraints: BoxConstraints(
                          minHeight:
                              MediaQuery.of(context).size.height -
                              56.0 -
                              MediaQuery.of(context).padding.top,
                        ),
                        child: ErrorState(
                          title: context.l10n.failedToLoadProfile,
                          subtitle: context.localizedErrorMessage(
                            state.message,
                          ),
                          actionLabel: context.l10n.retry,
                          onAction: () =>
                              context.read<ProfileCubit>().loadProfile(
                                (context.read<AuthCubit>().state
                                        as AuthAuthenticated)
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

  // App Language Dialog (en/ar) - uses LocaleCubit
  void _showAppLanguageDialog(BuildContext context) {
    final localeCubit = context.read<LocaleCubit>();
    final currentLocale = localeCubit.currentLocale.languageCode;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          context.l10n.selectAppLanguage,
          style: AppTypography.titleLarge,
        ),
        content: RadioGroup<String>(
          groupValue: currentLocale,
          onChanged: (value) {
            if (value != null) {
              localeCubit.changeLocale(value);
              Navigator.pop(context);
            }
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RadioListTile<String>(
                title: Text(
                  context.l10n.english,
                  style: AppTypography.bodyMedium,
                ),
                value: 'en',
                activeColor: context.colors.primary,
              ),
              RadioListTile<String>(
                title: Text(
                  context.l10n.arabic,
                  style: AppTypography.bodyMedium,
                ),
                value: 'ar',
                activeColor: context.colors.primary,
              ),
            ],
          ),
        ),
        actions: [
          TertiaryButton(
            label: context.l10n.cancel,
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }

  // Default Translation Language Dialog (10 languages) - uses ProfileCubit
  void _showTranslationLanguageDialog(
    BuildContext context,
    ProfileModel profile,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          context.l10n.selectTranslationLanguage,
          style: AppTypography.titleLarge,
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: RadioGroup<String>(
            groupValue: profile.defaultTranslationLanguage,
            onChanged: (value) {
              if (value != null) {
                context
                    .read<ProfileCubit>()
                    .updateTranslationLanguagePreference(profile.id, value);
                Navigator.pop(context);
              }
            },
            child: ListView(
              shrinkWrap: true,
              children: TranslationLanguages.languages.entries.map((entry) {
                return RadioListTile<String>(
                  title: Text(
                    TranslationLanguages.getLanguageName(context, entry.key),
                    style: AppTypography.bodyMedium,
                  ),
                  value: entry.key,
                  activeColor: context.colors.primary,
                );
              }).toList(),
            ),
          ),
        ),
        actions: [
          TertiaryButton(
            label: context.l10n.cancel,
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
        title: Text(context.l10n.editProfile, style: AppTypography.titleLarge),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: context.l10n.displayName,
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
            label: context.l10n.cancel,
            onPressed: () => Navigator.pop(context),
          ),
          PrimaryButton(
            label: context.l10n.save,
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
          context.l10n.deleteAccount,
          style: AppTypography.titleLarge.copyWith(color: AppColors.error),
        ),
        content: Text(
          context.l10n.deleteAccountConfirmation,
          style: AppTypography.bodyMedium,
        ),
        shape: RoundedRectangleBorder(borderRadius: AppShapes.cardLg),
        actions: [
          TertiaryButton(
            label: context.l10n.cancel,
            onPressed: () => Navigator.pop(context),
          ),
          FilledDestructiveButton(
            label: context.l10n.deleteAccount,
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
                profile.displayName ?? context.l10n.user,
                style: AppTypography.headlineSmall,
              ),
              Text(
                profile.email,
                style: AppTypography.bodyMedium.copyWith(
                  color: context.colors.onSurfaceVariant,
                ),
                textDirection: TextDirection.ltr,
              ),
            ],
          ),
        ),
        TertiaryButton(
          label: context.l10n.edit,
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
    // Wrap ListTile in Material to ensure ink splash and background are visible
    // when used inside an AppCard with a background color
    return Material(
      color: Colors.transparent,
      child: ListTile(
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: (titleColor ?? context.colors.primary).withValues(
              alpha: 0.1,
            ),
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
      ),
    );
  }
}

/// Translation languages (10 languages for document translation)
class TranslationLanguages {
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

  static String getLanguageName(BuildContext context, String code) {
    return switch (code) {
      'ar' => context.l10n.languageArabic,
      'en' => context.l10n.languageEnglish,
      'fr' => context.l10n.languageFrench,
      'es' => context.l10n.languageSpanish,
      'de' => context.l10n.languageGerman,
      'zh' => context.l10n.languageChinese,
      'hi' => context.l10n.languageHindi,
      'ur' => context.l10n.languageUrdu,
      'tr' => context.l10n.languageTurkish,
      'fa' => context.l10n.languagePersian,
      _ => code.toUpperCase(),
    };
  }

  static bool isRTL(String code) {
    return ['ar', 'ur', 'fa'].contains(code);
  }
}
