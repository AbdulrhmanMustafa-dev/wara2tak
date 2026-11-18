import 'package:material_ui/material_ui.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

import 'app_colors.dart';
import 'app_spacing.dart';
import 'app_shapes.dart';
import 'app_typography.dart';

/// Wara2tak Complete Design System Theme
/// Combines colors, typography, spacing, shapes, and motion
class AppTheme {
  AppTheme._();

  // ===========================================================================
  // Light Theme
  // ===========================================================================

  static ThemeData get lightTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorScheme: AppColors.lightColorScheme,
        fontFamily: GoogleFonts.inter().fontFamily,

        // Scaffold
        scaffoldBackgroundColor: AppColors.lightBackground,

        // App Bar
        appBarTheme: AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: AppColors.lightSurface,
          surfaceTintColor: Colors.transparent,
          foregroundColor: AppColors.lightOnSurface,
          titleTextStyle: AppTypography.headlineSmall.copyWith(
            color: AppColors.lightOnSurface,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.dark,
          centerTitle: false,
        ),

        // Card
        cardTheme: CardThemeData(
          elevation: 0,
          margin: EdgeInsets.zero,
          color: AppColors.lightSurface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: AppShapes.card,
            side: BorderSide(
              color: AppColors.lightOutlineVariant,
              width: 1,
            ),
          ),
          shadowColor: Colors.transparent,
        ),

        // Elevated Button
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColors.lightPrimary,
            foregroundColor: AppColors.lightOnPrimary,
            disabledBackgroundColor: AppColors.lightOutline,
            disabledForegroundColor: AppColors.lightOnSurfaceVariant,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.spacingLg,
              vertical: AppSpacing.spacingMd,
            ),
            minimumSize: const Size(
              AppSpacing.touchTargetMin,
              AppSpacing.touchTargetMin,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: AppShapes.button,
            ),
            textStyle: AppTypography.labelLarge,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ).copyWith(
            overlayColor: WidgetStateProperty.resolveWith<Color?>(
              (states) {
                if (states.contains(WidgetState.pressed)) {
                  return AppColors.lightPrimary.withValues(alpha: 0.1);
                }
                if (states.contains(WidgetState.hovered)) {
                  return AppColors.lightPrimary.withValues(alpha: 0.05);
                }
                return null;
              },
            ),
          ),
        ),

        // Filled Button (Secondary)
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.lightSecondary,
            foregroundColor: AppColors.lightOnSecondary,
            disabledBackgroundColor: AppColors.lightOutlineVariant,
            disabledForegroundColor: AppColors.lightOnSurfaceVariant,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.spacingLg,
              vertical: AppSpacing.spacingMd,
            ),
            minimumSize: const Size(
              AppSpacing.touchTargetMin,
              AppSpacing.touchTargetMin,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: AppShapes.button,
            ),
            textStyle: AppTypography.labelLarge,
          ),
        ),

        // Outlined Button
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.lightPrimary,
            disabledForegroundColor: AppColors.lightOnSurfaceVariant,
            side: BorderSide(
              color: AppColors.lightOutline,
              width: 1.5,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.spacingLg,
              vertical: AppSpacing.spacingMd,
            ),
            minimumSize: const Size(
              AppSpacing.touchTargetMin,
              AppSpacing.touchTargetMin,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: AppShapes.button,
            ),
            textStyle: AppTypography.labelLarge.copyWith(
              color: AppColors.lightPrimary,
            ),
          ),
        ),

        // Text Button
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.lightPrimary,
            disabledForegroundColor: AppColors.lightOnSurfaceVariant,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.spacingMd,
              vertical: AppSpacing.spacingSm,
            ),
            minimumSize: const Size(
              AppSpacing.touchTargetMin,
              AppSpacing.touchTargetMin,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: AppShapes.button,
            ),
            textStyle: AppTypography.labelLarge.copyWith(
              color: AppColors.lightPrimary,
            ),
          ),
        ),

        // Icon Button
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            foregroundColor: AppColors.lightOnSurface,
            disabledForegroundColor: AppColors.lightOnSurfaceVariant,
            backgroundColor: Colors.transparent,
            minimumSize: const Size(
              AppSpacing.touchTargetMin,
              AppSpacing.touchTargetMin,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: AppShapes.chip,
            ),
          ),
        ),

        // Input Decoration
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.lightBackground,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spacingMd,
            vertical: AppSpacing.spacingMd,
          ),
          border: OutlineInputBorder(
            borderRadius: AppShapes.inputField,
            borderSide: BorderSide(
              color: AppColors.lightOutline,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppShapes.inputField,
            borderSide: BorderSide(
              color: AppColors.lightOutline,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppShapes.inputField,
            borderSide: BorderSide(
              color: AppColors.lightPrimary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: AppShapes.inputField,
            borderSide: BorderSide(
              color: AppColors.error,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: AppShapes.inputField,
            borderSide: BorderSide(
              color: AppColors.error,
              width: 2,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: AppShapes.inputField,
            borderSide: BorderSide(
              color: AppColors.lightOutlineVariant,
              width: 1,
            ),
          ),
          labelStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.lightOnSurfaceVariant,
          ),
          hintStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.lightOnSurfaceVariant.withValues(alpha: 0.6),
          ),
          errorStyle: AppTypography.bodySmall.copyWith(
            color: AppColors.error,
          ),
          floatingLabelStyle: AppTypography.labelMedium.copyWith(
            color: AppColors.lightPrimary,
          ),
          prefixIconColor: WidgetStateColor.resolveWith((states) {
            if (states.contains(WidgetState.focused)) {
              return AppColors.lightPrimary;
            }
            return AppColors.lightOnSurfaceVariant;
          }),
          suffixIconColor: WidgetStateColor.resolveWith((states) {
            if (states.contains(WidgetState.focused)) {
              return AppColors.lightPrimary;
            }
            return AppColors.lightOnSurfaceVariant;
          }),
        ),

        // Text Theme
        textTheme: TextTheme(
          displayLarge: AppTypography.displayLarge.copyWith(
            color: AppColors.lightOnSurface,
            fontFamily: GoogleFonts.cairo().fontFamily,
          ),
          displayMedium: AppTypography.displayLargeMobile.copyWith(
            color: AppColors.lightOnSurface,
            fontFamily: GoogleFonts.cairo().fontFamily,
          ),
          displaySmall: AppTypography.headlineLarge.copyWith(
            color: AppColors.lightOnSurface,
            fontFamily: GoogleFonts.cairo().fontFamily,
          ),
          headlineLarge: AppTypography.headlineLarge.copyWith(
            color: AppColors.lightOnSurface,
            fontFamily: GoogleFonts.cairo().fontFamily,
          ),
          headlineMedium: AppTypography.headlineMedium.copyWith(
            color: AppColors.lightOnSurface,
            fontFamily: GoogleFonts.cairo().fontFamily,
          ),
          headlineSmall: AppTypography.headlineSmall.copyWith(
            color: AppColors.lightOnSurface,
            fontFamily: GoogleFonts.cairo().fontFamily,
          ),
          titleLarge: AppTypography.headlineSmall.copyWith(
            color: AppColors.lightOnSurface,
            fontFamily: GoogleFonts.cairo().fontFamily,
          ),
          titleMedium: AppTypography.labelLarge.copyWith(
            color: AppColors.lightOnSurface,
          ),
          titleSmall: AppTypography.labelMedium.copyWith(
            color: AppColors.lightOnSurface,
          ),
          bodyLarge: AppTypography.bodyLarge.copyWith(
            color: AppColors.lightOnSurface,
          ),
          bodyMedium: AppTypography.bodyMedium.copyWith(
            color: AppColors.lightOnSurface,
          ),
          bodySmall: AppTypography.bodySmall.copyWith(
            color: AppColors.lightOnSurfaceVariant,
          ),
          labelLarge: AppTypography.labelLarge.copyWith(
            color: AppColors.lightOnSurface,
          ),
          labelMedium: AppTypography.labelMedium.copyWith(
            color: AppColors.lightOnSurfaceVariant,
          ),
          labelSmall: AppTypography.labelSmall.copyWith(
            color: AppColors.lightOnSurfaceVariant,
          ),
        ).apply(
          fontFamily: GoogleFonts.inter().fontFamily,
        ),

        // Chip Theme
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.lightSurfaceVariant,
          disabledColor: AppColors.lightOutlineVariant,
          selectedColor: AppColors.lightSecondary,
          secondarySelectedColor: AppColors.lightSecondary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spacingSm,
            vertical: AppSpacing.spacing2xs,
          ),
          labelStyle: AppTypography.labelMedium.copyWith(
            color: AppColors.lightOnSurface,
          ),
          secondaryLabelStyle: AppTypography.labelMedium.copyWith(
            color: AppColors.lightOnSecondary,
          ),
          brightness: Brightness.light,
          elevation: 0,
          pressElevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppShapes.chip,
            side: BorderSide.none,
          ),
          showCheckmark: false,
        ),

        // Bottom Navigation Bar
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.lightSurface,
          elevation: 0,
          selectedItemColor: AppColors.lightPrimary,
          unselectedItemColor: AppColors.lightOnSurfaceVariant,
          selectedLabelStyle: AppTypography.labelSmall.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: AppTypography.labelSmall.copyWith(
            fontWeight: FontWeight.w500,
          ),
          type: BottomNavigationBarType.fixed,
          landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        ),

        // Navigation Bar (Material 3)
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.lightSurface,
          elevation: 0,
          indicatorColor: AppColors.lightSecondary,
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
            (states) {
              if (states.contains(WidgetState.selected)) {
                return AppTypography.labelSmall.copyWith(
                  color: AppColors.lightPrimary,
                  fontWeight: FontWeight.w600,
                );
              }
              return AppTypography.labelSmall.copyWith(
                color: AppColors.lightOnSurfaceVariant,
                fontWeight: FontWeight.w500,
              );
            },
          ),
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
            (states) {
              if (states.contains(WidgetState.selected)) {
                return IconThemeData(
                  color: AppColors.lightPrimary,
                  size: 24,
                );
              }
              return IconThemeData(
                color: AppColors.lightOnSurfaceVariant,
                size: 24,
              );
            },
          ),
          height: AppSpacing.navHeight,
        ),

        // Divider
        dividerTheme: DividerThemeData(
          color: AppColors.lightOutlineVariant,
          thickness: 1,
          space: 1,
          indent: 0,
          endIndent: 0,
        ),

        // List Tile
        listTileTheme: ListTileThemeData(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spacingMd,
            vertical: AppSpacing.spacingXs,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppShapes.card,
          ),
          tileColor: Colors.transparent,
          selectedTileColor: AppColors.lightSecondary.withValues(alpha: 0.5),
          iconColor: AppColors.lightOnSurfaceVariant,
          textColor: AppColors.lightOnSurface,
          titleTextStyle: AppTypography.labelLarge.copyWith(
            color: AppColors.lightOnSurface,
          ),
          subtitleTextStyle: AppTypography.bodySmall.copyWith(
            color: AppColors.lightOnSurfaceVariant,
          ),
          leadingAndTrailingTextStyle: AppTypography.bodySmall.copyWith(
            color: AppColors.lightOnSurfaceVariant,
          ),
        ),

        // Dialog
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.lightSurface,
          surfaceTintColor: Colors.transparent,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: AppShapes.modal,
          ),
          titleTextStyle: AppTypography.headlineMedium.copyWith(
            color: AppColors.lightOnSurface,
          ),
          contentTextStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.lightOnSurface,
          ),
        ),

        // Bottom Sheet
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: AppColors.lightSurface,
          surfaceTintColor: Colors.transparent,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: AppShapes.modalTop,
          ),
          modalBackgroundColor: AppColors.lightSurface,
          constraints: BoxConstraints(
            maxWidth: AppSpacing.mobileViewportWidth,
          ),
        ),

        // Snack Bar
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.lightOnSurface,
          contentTextStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.lightBackground,
          ),
          actionTextColor: AppColors.lightSecondary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: AppShapes.card,
          ),
          elevation: 4,
        ),

        // Floating Action Button
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.lightPrimary,
          foregroundColor: AppColors.lightOnPrimary,
          elevation: 2,
          focusElevation: 4,
          hoverElevation: 4,
          highlightElevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: AppShapes.chip,
          ),
        ),

        // Progress Indicators
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: AppColors.lightPrimary,
          linearTrackColor: AppColors.lightOutlineVariant,
          circularTrackColor: AppColors.lightOutlineVariant,
        ),

        // Slider
        sliderTheme: SliderThemeData(
          activeTrackColor: AppColors.lightPrimary,
          inactiveTrackColor: AppColors.lightOutlineVariant,
          thumbColor: AppColors.lightPrimary,
          overlayColor: AppColors.lightPrimary.withValues(alpha: 0.1),
          valueIndicatorColor: AppColors.lightPrimary,
          valueIndicatorTextStyle: AppTypography.labelSmall.copyWith(
            color: AppColors.lightOnPrimary,
          ),
        ),

        // Switch
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.lightPrimary;
              }
              return AppColors.lightOutline;
            },
          ),
          trackColor: WidgetStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.lightPrimary.withValues(alpha: 0.5);
              }
              return AppColors.lightOutlineVariant;
            },
          ),
          trackOutlineColor: WidgetStateProperty.resolveWith<Color?>(
            (states) => null,
          ),
        ),

        // Checkbox
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.lightPrimary;
              }
              return Colors.transparent;
            },
          ),
          checkColor: WidgetStateProperty.all(AppColors.lightOnPrimary),
          side: BorderSide(
            color: AppColors.lightOutline,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppShapes.radiusSm),
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),

        // Radio
        radioTheme: RadioThemeData(
          fillColor: WidgetStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.lightPrimary;
              }
              return AppColors.lightOutline;
            },
          ),
        ),

        // Tooltip
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: AppColors.lightOnSurface.withValues(alpha: 0.9),
            borderRadius: AppShapes.radiusMdAll,
          ),
          textStyle: AppTypography.labelSmall.copyWith(
            color: AppColors.lightBackground,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spacingMd,
            vertical: AppSpacing.spacingSm,
          ),
          preferBelow: false,
        ),

        // Material Tap Target Size
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,

        // Visual Density
        visualDensity: VisualDensity.adaptivePlatformDensity,

        // Platform overrides
        platform: TargetPlatform.android,
      );

  // ===========================================================================
  // Dark Theme
  // ===========================================================================

  static ThemeData get darkTheme => ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorScheme: AppColors.darkColorScheme,
        fontFamily: GoogleFonts.inter().fontFamily,

        // Scaffold
        scaffoldBackgroundColor: AppColors.darkBackground,

        // App Bar
        appBarTheme: AppBarTheme(
          elevation: 0,
          scrolledUnderElevation: 0,
          backgroundColor: AppColors.darkSurface,
          surfaceTintColor: Colors.transparent,
          foregroundColor: AppColors.darkOnSurface,
          titleTextStyle: AppTypography.headlineSmall.copyWith(
            color: AppColors.darkOnSurface,
          ),
          systemOverlayStyle: SystemUiOverlayStyle.light,
          centerTitle: false,
        ),

        // Card
        cardTheme: CardThemeData(
          elevation: 0,
          margin: EdgeInsets.zero,
          color: AppColors.darkSurface,
          surfaceTintColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: AppShapes.card,
            side: BorderSide(
              color: AppColors.darkOutlineVariant,
              width: 1,
            ),
          ),
          shadowColor: Colors.transparent,
        ),

        // Elevated Button
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 0,
            backgroundColor: AppColors.darkPrimary,
            foregroundColor: AppColors.darkOnPrimary,
            disabledBackgroundColor: AppColors.darkOutline,
            disabledForegroundColor: AppColors.darkOnSurfaceVariant,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.spacingLg,
              vertical: AppSpacing.spacingMd,
            ),
            minimumSize: const Size(
              AppSpacing.touchTargetMin,
              AppSpacing.touchTargetMin,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: AppShapes.button,
            ),
            textStyle: AppTypography.labelLarge,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ).copyWith(
            overlayColor: WidgetStateProperty.resolveWith<Color?>(
              (states) {
                if (states.contains(WidgetState.pressed)) {
                  return AppColors.darkPrimary.withValues(alpha: 0.1);
                }
                if (states.contains(WidgetState.hovered)) {
                  return AppColors.darkPrimary.withValues(alpha: 0.05);
                }
                return null;
              },
            ),
          ),
        ),

        // Filled Button
        filledButtonTheme: FilledButtonThemeData(
          style: FilledButton.styleFrom(
            backgroundColor: AppColors.darkSecondary,
            foregroundColor: AppColors.darkOnSecondary,
            disabledBackgroundColor: AppColors.darkOutlineVariant,
            disabledForegroundColor: AppColors.darkOnSurfaceVariant,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.spacingLg,
              vertical: AppSpacing.spacingMd,
            ),
            minimumSize: const Size(
              AppSpacing.touchTargetMin,
              AppSpacing.touchTargetMin,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: AppShapes.button,
            ),
            textStyle: AppTypography.labelLarge,
          ),
        ),

        // Outlined Button
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: AppColors.darkPrimary,
            disabledForegroundColor: AppColors.darkOnSurfaceVariant,
            side: BorderSide(
              color: AppColors.darkOutline,
              width: 1.5,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.spacingLg,
              vertical: AppSpacing.spacingMd,
            ),
            minimumSize: const Size(
              AppSpacing.touchTargetMin,
              AppSpacing.touchTargetMin,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: AppShapes.button,
            ),
            textStyle: AppTypography.labelLarge.copyWith(
              color: AppColors.darkPrimary,
            ),
          ),
        ),

        // Text Button
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: AppColors.darkPrimary,
            disabledForegroundColor: AppColors.darkOnSurfaceVariant,
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.spacingMd,
              vertical: AppSpacing.spacingSm,
            ),
            minimumSize: const Size(
              AppSpacing.touchTargetMin,
              AppSpacing.touchTargetMin,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: AppShapes.button,
            ),
            textStyle: AppTypography.labelLarge.copyWith(
              color: AppColors.darkPrimary,
            ),
          ),
        ),

        // Icon Button
        iconButtonTheme: IconButtonThemeData(
          style: IconButton.styleFrom(
            foregroundColor: AppColors.darkOnSurface,
            disabledForegroundColor: AppColors.darkOnSurfaceVariant,
            backgroundColor: Colors.transparent,
            minimumSize: const Size(
              AppSpacing.touchTargetMin,
              AppSpacing.touchTargetMin,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: AppShapes.chip,
            ),
          ),
        ),

        // Input Decoration
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: AppColors.darkSurfaceVariant,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spacingMd,
            vertical: AppSpacing.spacingMd,
          ),
          border: OutlineInputBorder(
            borderRadius: AppShapes.inputField,
            borderSide: BorderSide(
              color: AppColors.darkOutline,
              width: 1,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: AppShapes.inputField,
            borderSide: BorderSide(
              color: AppColors.darkOutline,
              width: 1,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: AppShapes.inputField,
            borderSide: BorderSide(
              color: AppColors.darkPrimary,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: AppShapes.inputField,
            borderSide: BorderSide(
              color: AppColors.error,
              width: 1,
            ),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: AppShapes.inputField,
            borderSide: BorderSide(
              color: AppColors.error,
              width: 2,
            ),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: AppShapes.inputField,
            borderSide: BorderSide(
              color: AppColors.darkOutlineVariant,
              width: 1,
            ),
          ),
          labelStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.darkOnSurfaceVariant,
          ),
          hintStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.darkOnSurfaceVariant.withValues(alpha: 0.6),
          ),
          errorStyle: AppTypography.bodySmall.copyWith(
            color: AppColors.error,
          ),
          floatingLabelStyle: AppTypography.labelMedium.copyWith(
            color: AppColors.darkPrimary,
          ),
          prefixIconColor: WidgetStateColor.resolveWith((states) {
            if (states.contains(WidgetState.focused)) {
              return AppColors.darkPrimary;
            }
            return AppColors.darkOnSurfaceVariant;
          }),
          suffixIconColor: WidgetStateColor.resolveWith((states) {
            if (states.contains(WidgetState.focused)) {
              return AppColors.darkPrimary;
            }
            return AppColors.darkOnSurfaceVariant;
          }),
        ),

        // Text Theme
        textTheme: TextTheme(
          displayLarge: AppTypography.displayLarge.copyWith(
            color: AppColors.darkOnSurface,
            fontFamily: GoogleFonts.cairo().fontFamily,
          ),
          displayMedium: AppTypography.displayLargeMobile.copyWith(
            color: AppColors.darkOnSurface,
            fontFamily: GoogleFonts.cairo().fontFamily,
          ),
          displaySmall: AppTypography.headlineLarge.copyWith(
            color: AppColors.darkOnSurface,
            fontFamily: GoogleFonts.cairo().fontFamily,
          ),
          headlineLarge: AppTypography.headlineLarge.copyWith(
            color: AppColors.darkOnSurface,
            fontFamily: GoogleFonts.cairo().fontFamily,
          ),
          headlineMedium: AppTypography.headlineMedium.copyWith(
            color: AppColors.darkOnSurface,
            fontFamily: GoogleFonts.cairo().fontFamily,
          ),
          headlineSmall: AppTypography.headlineSmall.copyWith(
            color: AppColors.darkOnSurface,
            fontFamily: GoogleFonts.cairo().fontFamily,
          ),
          titleLarge: AppTypography.headlineSmall.copyWith(
            color: AppColors.darkOnSurface,
            fontFamily: GoogleFonts.cairo().fontFamily,
          ),
          titleMedium: AppTypography.labelLarge.copyWith(
            color: AppColors.darkOnSurface,
          ),
          titleSmall: AppTypography.labelMedium.copyWith(
            color: AppColors.darkOnSurface,
          ),
          bodyLarge: AppTypography.bodyLarge.copyWith(
            color: AppColors.darkOnSurface,
          ),
          bodyMedium: AppTypography.bodyMedium.copyWith(
            color: AppColors.darkOnSurface,
          ),
          bodySmall: AppTypography.bodySmall.copyWith(
            color: AppColors.darkOnSurfaceVariant,
          ),
          labelLarge: AppTypography.labelLarge.copyWith(
            color: AppColors.darkOnSurface,
          ),
          labelMedium: AppTypography.labelMedium.copyWith(
            color: AppColors.darkOnSurfaceVariant,
          ),
          labelSmall: AppTypography.labelSmall.copyWith(
            color: AppColors.darkOnSurfaceVariant,
          ),
        ).apply(
          fontFamily: GoogleFonts.inter().fontFamily,
        ),

        // Chip Theme
        chipTheme: ChipThemeData(
          backgroundColor: AppColors.darkSurfaceVariant,
          disabledColor: AppColors.darkOutlineVariant,
          selectedColor: AppColors.darkSecondary,
          secondarySelectedColor: AppColors.darkSecondary,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spacingSm,
            vertical: AppSpacing.spacing2xs,
          ),
          labelStyle: AppTypography.labelMedium.copyWith(
            color: AppColors.darkOnSurface,
          ),
          secondaryLabelStyle: AppTypography.labelMedium.copyWith(
            color: AppColors.darkOnSecondary,
          ),
          brightness: Brightness.dark,
          elevation: 0,
          pressElevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: AppShapes.chip,
            side: BorderSide.none,
          ),
          showCheckmark: false,
        ),

        // Bottom Navigation Bar
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: AppColors.darkSurface,
          elevation: 0,
          selectedItemColor: AppColors.darkPrimary,
          unselectedItemColor: AppColors.darkOnSurfaceVariant,
          selectedLabelStyle: AppTypography.labelSmall.copyWith(
            fontWeight: FontWeight.w600,
          ),
          unselectedLabelStyle: AppTypography.labelSmall.copyWith(
            fontWeight: FontWeight.w500,
          ),
          type: BottomNavigationBarType.fixed,
          landscapeLayout: BottomNavigationBarLandscapeLayout.centered,
        ),

        // Navigation Bar
        navigationBarTheme: NavigationBarThemeData(
          backgroundColor: AppColors.darkSurface,
          elevation: 0,
          indicatorColor: AppColors.darkSecondary,
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
            (states) {
              if (states.contains(WidgetState.selected)) {
                return AppTypography.labelSmall.copyWith(
                  color: AppColors.darkPrimary,
                  fontWeight: FontWeight.w600,
                );
              }
              return AppTypography.labelSmall.copyWith(
                color: AppColors.darkOnSurfaceVariant,
                fontWeight: FontWeight.w500,
              );
            },
          ),
          iconTheme: WidgetStateProperty.resolveWith<IconThemeData>(
            (states) {
              if (states.contains(WidgetState.selected)) {
                return IconThemeData(
                  color: AppColors.darkPrimary,
                  size: 24,
                );
              }
              return IconThemeData(
                color: AppColors.darkOnSurfaceVariant,
                size: 24,
              );
            },
          ),
          height: AppSpacing.navHeight,
        ),

        // Divider
        dividerTheme: DividerThemeData(
          color: AppColors.darkOutlineVariant,
          thickness: 1,
          space: 1,
          indent: 0,
          endIndent: 0,
        ),

        // List Tile
        listTileTheme: ListTileThemeData(
          contentPadding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spacingMd,
            vertical: AppSpacing.spacingXs,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: AppShapes.card,
          ),
          tileColor: Colors.transparent,
          selectedTileColor: AppColors.darkSecondary.withValues(alpha: 0.5),
          iconColor: AppColors.darkOnSurfaceVariant,
          textColor: AppColors.darkOnSurface,
          titleTextStyle: AppTypography.labelLarge.copyWith(
            color: AppColors.darkOnSurface,
          ),
          subtitleTextStyle: AppTypography.bodySmall.copyWith(
            color: AppColors.darkOnSurfaceVariant,
          ),
          leadingAndTrailingTextStyle: AppTypography.bodySmall.copyWith(
            color: AppColors.darkOnSurfaceVariant,
          ),
        ),

        // Dialog
        dialogTheme: DialogThemeData(
          backgroundColor: AppColors.darkSurface,
          surfaceTintColor: Colors.transparent,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: AppShapes.modal,
          ),
          titleTextStyle: AppTypography.headlineMedium.copyWith(
            color: AppColors.darkOnSurface,
          ),
          contentTextStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.darkOnSurface,
          ),
        ),

        // Bottom Sheet
        bottomSheetTheme: BottomSheetThemeData(
          backgroundColor: AppColors.darkSurface,
          surfaceTintColor: Colors.transparent,
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: AppShapes.modalTop,
          ),
          modalBackgroundColor: AppColors.darkSurface,
          constraints: BoxConstraints(
            maxWidth: AppSpacing.mobileViewportWidth,
          ),
        ),

        // Snack Bar
        snackBarTheme: SnackBarThemeData(
          backgroundColor: AppColors.darkOnSurface,
          contentTextStyle: AppTypography.bodyMedium.copyWith(
            color: AppColors.darkBackground,
          ),
          actionTextColor: AppColors.darkSecondary,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: AppShapes.card,
          ),
          elevation: 4,
        ),

        // Floating Action Button
        floatingActionButtonTheme: FloatingActionButtonThemeData(
          backgroundColor: AppColors.darkPrimary,
          foregroundColor: AppColors.darkOnPrimary,
          elevation: 2,
          focusElevation: 4,
          hoverElevation: 4,
          highlightElevation: 6,
          shape: RoundedRectangleBorder(
            borderRadius: AppShapes.chip,
          ),
        ),

        // Progress Indicators
        progressIndicatorTheme: ProgressIndicatorThemeData(
          color: AppColors.darkPrimary,
          linearTrackColor: AppColors.darkOutlineVariant,
          circularTrackColor: AppColors.darkOutlineVariant,
        ),

        // Slider
        sliderTheme: SliderThemeData(
          activeTrackColor: AppColors.darkPrimary,
          inactiveTrackColor: AppColors.darkOutlineVariant,
          thumbColor: AppColors.darkPrimary,
          overlayColor: AppColors.darkPrimary.withValues(alpha: 0.1),
          valueIndicatorColor: AppColors.darkPrimary,
          valueIndicatorTextStyle: AppTypography.labelSmall.copyWith(
            color: AppColors.darkOnPrimary,
          ),
        ),

        // Switch
        switchTheme: SwitchThemeData(
          thumbColor: WidgetStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.darkPrimary;
              }
              return AppColors.darkOutline;
            },
          ),
          trackColor: WidgetStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.darkPrimary.withValues(alpha: 0.5);
              }
              return AppColors.darkOutlineVariant;
            },
          ),
        ),

        // Checkbox
        checkboxTheme: CheckboxThemeData(
          fillColor: WidgetStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.darkPrimary;
              }
              return Colors.transparent;
            },
          ),
          checkColor: WidgetStateProperty.all(AppColors.darkOnPrimary),
          side: BorderSide(
            color: AppColors.darkOutline,
            width: 2,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppShapes.radiusSm),
          ),
          materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),

        // Radio
        radioTheme: RadioThemeData(
          fillColor: WidgetStateProperty.resolveWith<Color>(
            (states) {
              if (states.contains(WidgetState.selected)) {
                return AppColors.darkPrimary;
              }
              return AppColors.darkOutline;
            },
          ),
        ),

        // Tooltip
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: AppColors.darkOnSurface.withValues(alpha: 0.9),
            borderRadius: AppShapes.radiusMdAll,
          ),
          textStyle: AppTypography.labelSmall.copyWith(
            color: AppColors.darkBackground,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spacingMd,
            vertical: AppSpacing.spacingSm,
          ),
          preferBelow: false,
        ),

        // Material Tap Target Size
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,

        // Visual Density
        visualDensity: VisualDensity.adaptivePlatformDensity,

        // Platform overrides
        platform: TargetPlatform.android,
      );
}