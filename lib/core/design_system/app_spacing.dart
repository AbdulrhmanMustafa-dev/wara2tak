import 'package:material_ui/material_ui.dart';

/// Wara2tak Design System Spacing & Layout
/// Based on the Stitch design system export
/// Mobile-first architecture with 390px viewport baseline
class AppSpacing {
  AppSpacing._();

  // ===========================================================================
  // Base Spacing Scale (4px/8px modular system)
  // ===========================================================================

  static const double spacing2xs = 4;   // 4px
  static const double spacingXs = 4;    // 4px (alias)
  static const double spacingSm = 8;    // 8px
  static const double spacingMd = 12;   // 12px
  static const double spacingBase = 16; // 16px (base unit)
  static const double spacingLg = 20;   // 20px
  static const double spacingXl = 24;   // 24px
  static const double spacing2xl = 32;  // 32px
  static const double spacing3xl = 40;  // 40px

  // ===========================================================================
  // Semantic Spacing
  // ===========================================================================

  /// Standard screen gutter/margin (16px)
  static const double gutterMobile = 16;

  /// Bottom navigation height (68px)
  static const double navHeight = 68;

  /// Minimum touch target size (44px)
  static const double touchTargetMin = 44;

  /// App bar height
  static const double appBarHeight = 56;

  /// Status bar height (approximate)
  static const double statusBarHeight = 24;

  // ===========================================================================
  // Layout Constraints
  // ===========================================================================

  /// Mobile viewport baseline width
  static const double mobileViewportWidth = 390;

  /// Maximum content width for centered layouts
  static const double maxContentWidth = 360;

  /// Card horizontal padding
  static const double cardPaddingHorizontal = 16;

  /// Card vertical padding
  static const double cardPaddingVertical = 12;

  /// Section vertical spacing
  static const double sectionSpacing = 24;

  /// Item spacing within lists
  static const double itemSpacing = 8;

  /// Compact item spacing
  static const double itemSpacingCompact = 4;

  // ===========================================================================
  // Edge Insets Helpers
  // ===========================================================================

  /// Standard screen padding
  static const EdgeInsets screenPadding = EdgeInsets.symmetric(
    horizontal: gutterMobile,
    vertical: spacingBase,
  );

  /// Standard horizontal padding
  static const EdgeInsets horizontalPadding = EdgeInsets.symmetric(
    horizontal: gutterMobile,
  );

  /// Standard vertical padding
  static const EdgeInsets verticalPadding = EdgeInsets.symmetric(
    vertical: spacingBase,
  );

  /// Card padding
  static const EdgeInsets cardPadding = EdgeInsets.symmetric(
    horizontal: cardPaddingHorizontal,
    vertical: cardPaddingVertical,
  );

  /// Card padding compact
  static const EdgeInsets cardPaddingCompact = EdgeInsets.symmetric(
    horizontal: 12,
    vertical: 8,
  );

  /// Section padding
  static const EdgeInsets sectionPadding = EdgeInsets.symmetric(
    horizontal: gutterMobile,
    vertical: sectionSpacing / 2,
  );

  /// Bottom nav safe area padding
  static const EdgeInsets bottomNavPadding = EdgeInsets.only(
    bottom: navHeight + 16,
  );
}

/// Extension for responsive spacing
extension ResponsiveSpacing on BuildContext {
  double get screenWidth => MediaQuery.sizeOf(this).width;

  bool get isTablet => screenWidth >= 600;

  double get responsiveGutter => isTablet ? 24 : AppSpacing.gutterMobile;

  double get responsiveSpacingBase => isTablet ? 20 : AppSpacing.spacingBase;

  EdgeInsets get responsiveScreenPadding => EdgeInsets.symmetric(
        horizontal: responsiveGutter,
        vertical: responsiveSpacingBase,
      );
}