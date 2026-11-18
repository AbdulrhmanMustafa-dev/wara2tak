import 'package:material_ui/material_ui.dart';

/// Wara2tak Design System Colors
/// Based on the Stitch design system export
class AppColors {
  AppColors._();

  // ===========================================================================
  // Light Theme Colors
  // ===========================================================================

  /// Deep Indigo - Primary brand color conveying academic rigor and AI intelligence
  static const Color lightPrimary = Color(0xFF4F46E5);

  /// White - Text on primary
  static const Color lightOnPrimary = Color(0xFFFFFFFF);

  /// Soft Blue - Secondary color for gentle contrast, container fills, highlights
  static const Color lightSecondary = Color(0xFFE0E7FF);

  /// Dark Indigo - Text on secondary
  static const Color lightOnSecondary = Color(0xFF1E1B4B);

  /// Pure White - Elevated cards
  static const Color lightSurface = Color(0xFFFFFFFF);

  /// Dark Navy - Primary text color for high legibility
  static const Color lightOnSurface = Color(0xFF0F172A);

  /// Light Slate - Surface variant for subtle backgrounds
  static const Color lightSurfaceVariant = Color(0xFFF1F5F9);

  /// Slate Gray - Supportive metadata and timestamps
  static const Color lightOnSurfaceVariant = Color(0xFF475569);

  /// Slate 300 - Borders and dividers
  static const Color lightOutline = Color(0xFFCBD5E1);

  /// Slate 200 - Subtle borders
  static const Color lightOutlineVariant = Color(0xFFE2E8F0);

  /// Background - High-clarity, eye-friendly light neutral canvas
  static const Color lightBackground = Color(0xFFF8FAFC);

  // ===========================================================================
  // Dark Theme Colors
  // ===========================================================================

  /// Dark Navy - Dark theme background
  static const Color darkBackground = Color(0xFF0F172A);

  /// Light Indigo - Primary for dark mode
  static const Color darkPrimary = Color(0xFF818CF8);

  /// Dark Navy - Text on primary in dark mode
  static const Color darkOnPrimary = Color(0xFF0F172A);

  /// Dark Indigo - Secondary for dark mode
  static const Color darkSecondary = Color(0xFF1E1B4B);

  /// Soft Blue - Text on secondary in dark mode
  static const Color darkOnSecondary = Color(0xFFE0E7FF);

  /// Slate 800 - Dark surface/elevated cards
  static const Color darkSurface = Color(0xFF1E293B);

  /// Slate 50 - Text on surface in dark mode
  static const Color darkOnSurface = Color(0xFFF8FAFC);

  /// Slate 700 - Surface variant in dark mode
  static const Color darkSurfaceVariant = Color(0xFF334155);

  /// Slate 300 - Text on surface variant in dark mode
  static const Color darkOnSurfaceVariant = Color(0xFFCBD5E1);

  /// Slate 600 - Borders in dark mode
  static const Color darkOutline = Color(0xFF475569);

  /// Slate 700 - Subtle borders in dark mode
  static const Color darkOutlineVariant = Color(0xFF334155);

  // ===========================================================================
  // Semantic Status Colors (Consistent across themes)
  // ===========================================================================

  /// Green - Completed requirements, success states
  static const Color success = Color(0xFF16A34A);
  static const Color successLight = Color(0xFFDCFCE7);
  static const Color successDark = Color(0xFF052E16);

  /// Amber - Upcoming deadlines, warnings
  static const Color warning = Color(0xFFF59E0B);
  static const Color warningText = Color(0xFFB45309); // Darker amber for text contrast
  static const Color warningLight = Color(0xFFFEF3C7);
  static const Color warningDark = Color(0xFF78350F);

  /// Red - Urgent expirations, missing requirements, errors
  static const Color error = Color(0xFFEF4444);
  static const Color errorLight = Color(0xFFFEF2F2);
  static const Color errorDark = Color(0xFF7F1D1D);

  // ===========================================================================
  // Additional UI Colors
  // ===========================================================================

  /// Teal - Used in some Stitch screens for upload/analysis
  static const Color teal = Color(0xFF0F766E);
  static const Color tealHover = Color(0xFF0D9488);
  static const Color tealLight = Color(0xFFCCFBF1);

  /// Additional semantic colors for document types
  static const Color blue = Color(0xFF3B82F6);
  static const Color green = Color(0xFF16A34A);
  static const Color orange = Color(0xFFF97316);
  static const Color purple = Color(0xFF9333EA);

  /// Google Colors for Sign-In button
  static const Color googleBlue = Color(0xFF4285F4);
  static const Color googleGreen = Color(0xFF34A853);
  static const Color googleYellow = Color(0xFFFBBC05);
  static const Color googleRed = Color(0xFFEA4335);

  // ===========================================================================
  // ColorScheme Builders
  // ===========================================================================

  static ColorScheme get lightColorScheme => ColorScheme(
        brightness: Brightness.light,
        primary: lightPrimary,
        onPrimary: lightOnPrimary,
        secondary: lightSecondary,
        onSecondary: lightOnSecondary,
        surface: lightSurface,
        onSurface: lightOnSurface,
        surfaceContainerHighest: lightSurfaceVariant,
        onSurfaceVariant: lightOnSurfaceVariant,
        outline: lightOutline,
        outlineVariant: lightOutlineVariant,
        error: error,
        onError: lightOnPrimary,
        errorContainer: errorLight,
        onErrorContainer: errorDark,
        tertiary: teal,
        onTertiary: lightOnPrimary,
        tertiaryContainer: tealLight,
        onTertiaryContainer: teal,
        primaryContainer: lightSecondary,
        onPrimaryContainer: lightOnSecondary,
        secondaryContainer: lightSurfaceVariant,
        onSecondaryContainer: lightOnSurfaceVariant,
        surfaceContainer: lightSurfaceVariant,
        surfaceContainerHigh: lightSurfaceVariant,
        surfaceContainerLow: lightSurface,
        surfaceContainerLowest: lightBackground,
        inverseSurface: darkSurface,
        onInverseSurface: darkOnSurface,
        inversePrimary: darkPrimary,
        shadow: Colors.black.withValues(alpha: 0.1),
        scrim: Colors.black.withValues(alpha: 0.5),
        surfaceTint: lightPrimary,
      );

  static ColorScheme get darkColorScheme => ColorScheme(
        brightness: Brightness.dark,
        primary: darkPrimary,
        onPrimary: darkOnPrimary,
        secondary: darkSecondary,
        onSecondary: darkOnSecondary,
        surface: darkSurface,
        onSurface: darkOnSurface,
        surfaceContainerHighest: darkSurfaceVariant,
        onSurfaceVariant: darkOnSurfaceVariant,
        outline: darkOutline,
        outlineVariant: darkOutlineVariant,
        error: error,
        onError: darkOnPrimary,
        errorContainer: errorDark,
        onErrorContainer: errorLight,
        tertiary: tealHover,
        onTertiary: darkOnPrimary,
        tertiaryContainer: teal,
        onTertiaryContainer: darkOnPrimary,
        primaryContainer: darkSecondary,
        onPrimaryContainer: darkOnSecondary,
        secondaryContainer: darkSurfaceVariant,
        onSecondaryContainer: darkOnSurfaceVariant,
        surfaceContainer: darkSurfaceVariant,
        surfaceContainerHigh: darkSurfaceVariant,
        surfaceContainerLow: darkSurface,
        surfaceContainerLowest: darkBackground,
        inverseSurface: lightSurface,
        onInverseSurface: lightOnSurface,
        inversePrimary: lightPrimary,
        shadow: Colors.black.withValues(alpha: 0.3),
        scrim: Colors.black.withValues(alpha: 0.7),
        surfaceTint: darkPrimary,
      );
}