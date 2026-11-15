import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Wara2tak Design System Typography
/// Based on the Stitch design system export
/// Uses Cairo for Arabic/Headlines and Inter for English/Body text
class AppTypography {
  AppTypography._();

  // ===========================================================================
  // Font Families
  // ===========================================================================

  static const String _cairoFontFamily = 'Cairo';
  static const String _interFontFamily = 'Inter';

  // Cairo font family using Google Fonts
  static TextStyle get _cairoRegular => GoogleFonts.cairo(
        fontWeight: FontWeight.w400,
      );
  static TextStyle get _cairoMedium => GoogleFonts.cairo(
        fontWeight: FontWeight.w500,
      );
  static TextStyle get _cairoSemiBold => GoogleFonts.cairo(
        fontWeight: FontWeight.w600,
      );
  static TextStyle get _cairoBold => GoogleFonts.cairo(
        fontWeight: FontWeight.w700,
      );

  // Inter font family using Google Fonts
  static TextStyle get _interRegular => GoogleFonts.inter(
        fontWeight: FontWeight.w400,
      );
  static TextStyle get _interMedium => GoogleFonts.inter(
        fontWeight: FontWeight.w500,
      );
  static TextStyle get _interSemiBold => GoogleFonts.inter(
        fontWeight: FontWeight.w600,
      );
  static TextStyle get _interBold => GoogleFonts.inter(
        fontWeight: FontWeight.w700,
      );

  // ===========================================================================
  // Display Styles (Large headlines, marketing)
  // ===========================================================================

  /// Display Large - 36px/44px, Cairo Bold, -0.5px letter spacing
  static TextStyle get displayLarge => _cairoBold.copyWith(
        fontSize: 36,
        height: 44 / 36,
        letterSpacing: -0.5,
      );

  /// Display Large Mobile - 28px/36px, Cairo Bold, -0.25px letter spacing
  static TextStyle get displayLargeMobile => _cairoBold.copyWith(
        fontSize: 28,
        height: 36 / 28,
        letterSpacing: -0.25,
      );

  // ===========================================================================
  // Headline Styles (Section headers, card titles)
  // ===========================================================================

  /// Headline Large - 32px/40px, Cairo Bold, -0.25px letter spacing
  static TextStyle get headlineLarge => _cairoBold.copyWith(
        fontSize: 32,
        height: 40 / 32,
        letterSpacing: -0.25,
      );

  /// Title Large - 20px/28px, Cairo SemiBold (alias for headlineLargeMobile)
  static TextStyle get titleLarge => _cairoSemiBold.copyWith(
        fontSize: 20,
        height: 28 / 20,
        letterSpacing: 0,
      );

  /// Headline Large Mobile - 24px/32px, Cairo Bold
  static TextStyle get headlineLargeMobile => _cairoBold.copyWith(
        fontSize: 24,
        height: 32 / 24,
        letterSpacing: 0,
      );

  /// Headline Medium - 22px/30px, Cairo SemiBold
  static TextStyle get headlineMedium => _cairoSemiBold.copyWith(
        fontSize: 22,
        height: 30 / 22,
        letterSpacing: 0,
      );

  /// Headline Small - 18px/26px, Cairo SemiBold
  static TextStyle get headlineSmall => _cairoSemiBold.copyWith(
        fontSize: 18,
        height: 26 / 18,
        letterSpacing: 0,
      );

  // ===========================================================================
  // Body Styles (Main reading text)
  // ===========================================================================

  /// Body Large - 16px/24px, Inter Regular
  static TextStyle get bodyLarge => _interRegular.copyWith(
        fontSize: 16,
        height: 24 / 16,
        letterSpacing: 0,
      );

  /// Body Medium - 14px/20px, Inter Regular
  static TextStyle get bodyMedium => _interRegular.copyWith(
        fontSize: 14,
        height: 20 / 14,
        letterSpacing: 0,
      );

  /// Body Small - 12px/18px, Inter Regular
  static TextStyle get bodySmall => _interRegular.copyWith(
        fontSize: 12,
        height: 18 / 12,
        letterSpacing: 0,
      );

  // ===========================================================================
  // Label Styles (Buttons, form labels, chips)
  // ===========================================================================

  /// Label Large - 14px/20px, Inter SemiBold, 0.1px letter spacing
  static TextStyle get labelLarge => _interSemiBold.copyWith(
        fontSize: 14,
        height: 20 / 14,
        letterSpacing: 0.1,
      );

  /// Label Medium - 12px/16px, Inter Medium, 0.2px letter spacing
  static TextStyle get labelMedium => _interMedium.copyWith(
        fontSize: 12,
        height: 16 / 12,
        letterSpacing: 0.2,
      );

  /// Label Small - 11px/14px, Inter Medium, 0.3px letter spacing
  static TextStyle get labelSmall => _interMedium.copyWith(
        fontSize: 11,
        height: 14 / 11,
        letterSpacing: 0.3,
      );

  // ===========================================================================
  // Additional Styles for Specific Use Cases
  // ===========================================================================

  /// Tiny text - 10px, for metadata, page references
  static TextStyle get tiny => _interRegular.copyWith(
        fontSize: 10,
        height: 14 / 10,
        letterSpacing: 0,
      );

  /// Tiny Bold - 10px, for badges, status labels
  static TextStyle get tinyBold => _interSemiBold.copyWith(
        fontSize: 10,
        height: 14 / 10,
        letterSpacing: 0,
      );

  /// Caption - 11px, for supporting text
  static TextStyle get caption => _interRegular.copyWith(
        fontSize: 11,
        height: 16 / 11,
        letterSpacing: 0,
      );

  /// Caption Bold - 11px, for emphasized supporting text
  static TextStyle get captionBold => _interSemiBold.copyWith(
        fontSize: 11,
        height: 16 / 11,
        letterSpacing: 0,
      );

  // ===========================================================================
  // RTL-Aware Style Helpers
  // ===========================================================================

  /// Get headline style that adapts to RTL (uses Cairo for Arabic)
  static TextStyle headlineForLocale(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    return isRTL ? headlineMedium : headlineMedium;
  }

  /// Get body style that adapts to RTL (uses Inter for English, Cairo for Arabic body)
  static TextStyle bodyForLocale(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    if (isRTL) {
      return _cairoRegular.copyWith(
        fontSize: 14,
        height: 20 / 14,
        letterSpacing: 0,
      );
    }
    return bodyMedium;
  }

  /// Get label style that adapts to RTL
  static TextStyle labelForLocale(BuildContext context) {
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    if (isRTL) {
      return _cairoSemiBold.copyWith(
        fontSize: 14,
        height: 20 / 14,
        letterSpacing: 0.1,
      );
    }
    return labelLarge;
  }
}

/// Extension for easy access to typography styles
extension AppTextStyle on TextStyle {
  TextStyle get cairo => copyWith(fontFamily: 'Cairo');
  TextStyle get inter => copyWith(fontFamily: 'Inter');
  TextStyle get arabic => copyWith(fontFamily: 'Cairo');
  TextStyle get english => copyWith(fontFamily: 'Inter');
}