import 'dart:ui';

import 'package:material_ui/material_ui.dart';

/// Wara2tak Design System Motion & Micro-interactions
/// Based on the Stitch design system export
class AppMotion {
  AppMotion._();

  // ===========================================================================
  // Duration Constants
  // ===========================================================================

  /// Tap/press feedback - 120ms
  static const Duration tapDuration = Duration(milliseconds: 120);

  /// Sheet slide animation - 260ms
  static const Duration sheetSlideDuration = Duration(milliseconds: 260);

  /// Status change (checkmarks, toggles) - 180ms
  static const Duration statusChangeDuration = Duration(milliseconds: 180);

  /// Standard page transition - 300ms
  static const Duration pageTransitionDuration = Duration(milliseconds: 300);

  /// Fast micro-interaction - 80ms
  static const Duration fastDuration = Duration(milliseconds: 80);

  /// Medium animation - 200ms
  static const Duration mediumDuration = Duration(milliseconds: 200);

  /// Slow animation - 400ms
  static const Duration slowDuration = Duration(milliseconds: 400);

  // ===========================================================================
  // Curve Constants
  // ===========================================================================

  /// Standard tap curve - cubic-bezier(0.4, 0, 0.2, 1)
  static const Cubic tapCurve = Cubic(0.4, 0, 0.2, 1);

  /// Sheet slide curve - cubic-bezier(0.16, 1, 0.3, 1)
  static const Cubic sheetSlideCurve = Cubic(0.16, 1, 0.3, 1);

  /// Status change curve - ease-out
  static const Curve statusChangeCurve = Curves.easeOut;

  /// Standard page transition curve
  static const Curve pageTransitionCurve = Curves.easeInOutCubic;

  /// Spring-like curve for delightful interactions
  static const Curve springCurve = Curves.elasticOut;

  // ===========================================================================
  // Animation Builders
  // ===========================================================================

  /// Quick scale animation for tap feedback
  static Animation<double> scaleAnimation({
    required AnimationController controller,
    double begin = 1.0,
    double end = 0.95,
  }) =>
      Tween<double>(begin: begin, end: end).animate(
        CurvedAnimation(
          parent: controller,
          curve: tapCurve,
          reverseCurve: tapCurve.flipped,
        ),
      );

  /// Fade animation
  static Animation<double> fadeAnimation({
    required AnimationController controller,
    double begin = 0.0,
    double end = 1.0,
  }) =>
      Tween<double>(begin: begin, end: end).animate(
        CurvedAnimation(
          parent: controller,
          curve: tapCurve,
          reverseCurve: tapCurve.flipped,
        ),
      );

  /// Slide up animation for bottom sheets
  static Animation<Offset> slideUpAnimation({
    required AnimationController controller,
    Offset begin = const Offset(0, 1),
    Offset end = Offset.zero,
  }) =>
      Tween<Offset>(begin: begin, end: end).animate(
        CurvedAnimation(
          parent: controller,
          curve: sheetSlideCurve,
          reverseCurve: sheetSlideCurve.flipped,
        ),
      );

  /// Slide down animation for top sheets
  static Animation<Offset> slideDownAnimation({
    required AnimationController controller,
    Offset begin = const Offset(0, -1),
    Offset end = Offset.zero,
  }) =>
      Tween<Offset>(begin: begin, end: end).animate(
        CurvedAnimation(
          parent: controller,
          curve: sheetSlideCurve,
          reverseCurve: sheetSlideCurve.flipped,
        ),
      );

  /// Status change scale (for checkmarks, toggles)
  static Animation<double> statusScaleAnimation({
    required AnimationController controller,
    double begin = 0.0,
    double end = 1.0,
  }) =>
      Tween<double>(begin: begin, end: end).animate(
        CurvedAnimation(
          parent: controller,
          curve: statusChangeCurve,
          reverseCurve: statusChangeCurve.flipped,
        ),
      );

  /// Progress bar animation
  static Animation<double> progressAnimation({
    required AnimationController controller,
    double begin = 0.0,
    double end = 1.0,
  }) =>
      Tween<double>(begin: begin, end: end).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.easeOutCubic,
        ),
      );

  /// Shimmer animation for loading states
  static Animation<double> shimmerAnimation({
    required AnimationController controller,
  }) =>
      Tween<double>(begin: -1.0, end: 2.0).animate(
        CurvedAnimation(
          parent: controller,
          curve: Curves.linear,
        ),
      );
}

/// Convenience curves
class AppCurves {
  AppCurves._();

  static const Curve tap = AppMotion.tapCurve;
  static const Curve sheetSlide = AppMotion.sheetSlideCurve;
  static const Curve statusChange = AppMotion.statusChangeCurve;
  static const Curve pageTransition = AppMotion.pageTransitionCurve;
  static const Curve spring = AppMotion.springCurve;
}