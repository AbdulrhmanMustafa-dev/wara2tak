import 'package:material_ui/material_ui.dart';

/// Wara2tak Design System Shapes & Border Radius
/// Based on the Stitch design system export
class AppShapes {
  AppShapes._();

  // ===========================================================================
  // Border Radius Scale
  // ===========================================================================

  /// 6px - Small elements, chips, badges
  static const double radiusSm = 6;

  /// 10px - Medium elements, input fields
  static const double radiusMd = 10;

  /// 12px - Default card/container radius
  static const double radiusDefault = 12;

  /// 16px - Large cards, modals, sheets
  static const double radiusLg = 16;

  /// 20px - Extra large containers, hero sections
  static const double radiusXl = 20;

  /// 9999px - Pill/fully rounded (buttons, chips, avatars)
  static const double radiusPill = 9999;

  // ===========================================================================
  // BorderRadius Objects
  // ===========================================================================

  static const BorderRadius radiusSmAll = BorderRadius.all(Radius.circular(radiusSm));
  static const BorderRadius radiusMdAll = BorderRadius.all(Radius.circular(radiusMd));
  static const BorderRadius radiusDefaultAll = BorderRadius.all(Radius.circular(radiusDefault));
  static const BorderRadius radiusLgAll = BorderRadius.all(Radius.circular(radiusLg));
  static const BorderRadius radiusXlAll = BorderRadius.all(Radius.circular(radiusXl));
  static const BorderRadius radiusPillAll = BorderRadius.all(Radius.circular(radiusPill));

  // ===========================================================================
  // Common Border Radius Combinations
  // ===========================================================================

  /// Card radius - used for most elevated cards
  static const BorderRadius card = radiusDefaultAll;

  /// Card large radius - for hero cards, modals
  static const BorderRadius cardLg = radiusLgAll;

  /// Input field radius
  static const BorderRadius inputField = radiusMdAll;

  /// Button radius
  static const BorderRadius button = radiusDefaultAll;

  /// Chip/badge radius
  static const BorderRadius chip = radiusPillAll;

  /// Avatar radius
  static const BorderRadius avatar = radiusPillAll;

  /// Modal/Bottom sheet radius (top only)
  static const BorderRadius modalTop = BorderRadius.vertical(
    top: Radius.circular(radiusXl),
  );

  /// Modal/Bottom sheet radius (full)
  static const BorderRadius modal = radiusXlAll;

  /// Divider/line radius
  static const BorderRadius divider = BorderRadius.all(Radius.circular(1));

  // ===========================================================================
  // Elevation & Shadows
  // ===========================================================================

  /// Subtle card shadow - 0 2px 8px -2px rgba(15, 23, 42, 0.05)
  static const List<BoxShadow> cardShadow = [
    BoxShadow(
      color: Color(0x0D0F172A), // rgba(15, 23, 42, 0.05)
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: -2,
    ),
  ];

  /// Slightly elevated card shadow
  static const List<BoxShadow> cardShadowElevated = [
    BoxShadow(
      color: Color(0x140F172A), // rgba(15, 23, 42, 0.08)
      offset: Offset(0, 4),
      blurRadius: 12,
      spreadRadius: -4,
    ),
  ];

  /// Modal/Sheet lift shadow - 0 10px 25px -5px rgba(15, 23, 42, 0.08)
  static const List<BoxShadow> modalShadow = [
    BoxShadow(
      color: Color(0x140F172A), // rgba(15, 23, 42, 0.08)
      offset: Offset(0, 10),
      blurRadius: 25,
      spreadRadius: -5,
    ),
  ];

  /// Bottom navigation shadow
  static const List<BoxShadow> bottomNavShadow = [
    BoxShadow(
      color: Color(0x0A0F172A), // rgba(15, 23, 42, 0.04)
      offset: Offset(0, -4),
      blurRadius: 16,
      spreadRadius: 0,
    ),
  ];

  /// Sticky header shadow
  static const List<BoxShadow> stickyHeaderShadow = [
    BoxShadow(
      color: Color(0x080F172A), // rgba(15, 23, 42, 0.03)
      offset: Offset(0, 2),
      blurRadius: 8,
      spreadRadius: -2,
    ),
  ];

  /// Focus ring shadow
  static const List<BoxShadow> focusRing = [
    BoxShadow(
      color: Color(0x334F46E5), // rgba(79, 70, 229, 0.2)
      offset: Offset(0, 0),
      blurRadius: 0,
      spreadRadius: 2,
    ),
  ];
}

/// Extension for easy shape access
extension AppBorderRadius on BorderRadius {
  static BorderRadius get sm => AppShapes.radiusSmAll;
  static BorderRadius get md => AppShapes.radiusMdAll;
  static BorderRadius get defaultRadius => AppShapes.radiusDefaultAll;
  static BorderRadius get lg => AppShapes.radiusLgAll;
  static BorderRadius get xl => AppShapes.radiusXlAll;
  static BorderRadius get pill => AppShapes.radiusPillAll;
  static BorderRadius get card => AppShapes.card;
  static BorderRadius get cardLg => AppShapes.cardLg;
  static BorderRadius get inputField => AppShapes.inputField;
  static BorderRadius get button => AppShapes.button;
  static BorderRadius get chip => AppShapes.chip;
  static BorderRadius get modal => AppShapes.modal;
  static BorderRadius get modalTop => AppShapes.modalTop;
}