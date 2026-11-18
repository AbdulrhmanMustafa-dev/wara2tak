import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';

/// Context extensions for easy access to theme, navigation, etc.
extension AppContextExtensions on BuildContext {
  // Theme
  ThemeData get theme => Theme.of(this);
  ColorScheme get colors => theme.colorScheme;
  TextTheme get textTheme => theme.textTheme;
  bool get isDarkMode => theme.brightness == Brightness.dark;

  // Navigation
  GoRouter get router => GoRouter.of(this);

  /// Whether the current route can be popped (GoRouter extension)
  bool get canGoBack => router.canPop();

  /// Pop the current route safely (uses GoRouter)
  void goBack<T extends Object?>([T? result]) => router.pop<T>(result);

  // MediaQuery
  MediaQueryData get mediaQuery => MediaQuery.of(this);
  Size get screenSize => mediaQuery.size;
  double get screenWidth => screenSize.width;
  double get screenHeight => screenSize.height;
  double get statusBarHeight => mediaQuery.padding.top;
  double get bottomPadding => mediaQuery.padding.bottom;
  double get viewPaddingBottom => mediaQuery.viewPadding.bottom;
  double get viewInsetsBottom => mediaQuery.viewInsets.bottom;
  bool get isKeyboardOpen => viewInsetsBottom > 0;
  bool get isTablet => screenWidth >= 600;
  bool get isLandscape => screenWidth > screenHeight;

  // Directionality
  TextDirection get textDirection => Directionality.of(this);
  bool get isRTL => textDirection == TextDirection.rtl;
  bool get isLTR => textDirection == TextDirection.ltr;

  // Localization
  Locale get locale => Localizations.localeOf(this);
  String get languageCode => locale.languageCode;
  bool get isArabic => languageCode == 'ar';

  // Responsive spacing
  double get responsiveGutter => isTablet ? 24 : 16;
  double get responsiveSpacingBase => isTablet ? 20 : 16;

  // Safe area
  EdgeInsets get safeAreaPadding => mediaQuery.padding;
  EdgeInsets get safeAreaHorizontal => EdgeInsets.symmetric(
        horizontal: mediaQuery.padding.horizontal.clamp(16, 24),
      );

  // Show snack bar
  void showSnackBar(String message, {Duration? duration}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration ?? const Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // Show error snack bar
  void showErrorSnackBar(String message) {
    showSnackBar(message);
  }

  // Focus
  void unfocus() => FocusScope.of(this).unfocus();
}

/// Widget extensions for common patterns
extension WidgetExtensions on Widget {
  /// Add padding
  Widget paddingAll(double value) => Padding(
        padding: EdgeInsets.all(value),
        child: this,
      );

  Widget paddingSymmetric({double horizontal = 0, double vertical = 0}) => Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
        child: this,
      );

  Widget paddingOnly({
    double left = 0,
    double top = 0,
    double right = 0,
    double bottom = 0,
  }) =>
      Padding(
        padding: EdgeInsets.only(left: left, top: top, right: right, bottom: bottom),
        child: this,
      );

  /// Add constraints
  Widget constrained({double? minWidth, double? maxWidth, double? minHeight, double? maxHeight}) =>
      ConstrainedBox(
        constraints: BoxConstraints(
          minWidth: minWidth ?? 0,
          maxWidth: maxWidth ?? double.infinity,
          minHeight: minHeight ?? 0,
          maxHeight: maxHeight ?? double.infinity,
        ),
        child: this,
      );

  /// Center
  Widget centered() => Center(child: this);

  /// Expanded
  Widget expanded({int flex = 1}) => Expanded(flex: flex, child: this);

  /// Flexible
  Widget flexible({int flex = 1, FlexFit fit = FlexFit.loose}) =>
      Flexible(flex: flex, fit: fit, child: this);

  /// Add decoration
  Widget decorated({
    Color? color,
    DecorationImage? image,
    BoxBorder? border,
    BorderRadius? borderRadius,
    List<BoxShadow>? boxShadow,
    Gradient? gradient,
  }) =>
      Container(
        decoration: BoxDecoration(
          color: color,
          image: image,
          border: border,
          borderRadius: borderRadius,
          boxShadow: boxShadow,
          gradient: gradient,
        ),
        child: this,
      );

  /// Clip
  Widget clipped({BorderRadius? borderRadius}) => ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        child: this,
      );

  /// Add semantic label
  Widget withSemantics({String? label, String? hint, bool? button}) => Semantics(
        label: label,
        hint: hint,
        button: button ?? false,
        child: this,
      );

  /// Conditional widget
  Widget when(bool condition, Widget Function(Widget) builder) =>
      condition ? builder(this) : this;

  Widget whenNot(bool condition, Widget Function(Widget) builder) =>
      condition ? this : builder(this);
}

/// Iterable extensions for widget lists
extension WidgetListExtensions on Iterable<Widget> {
  /// Add separator between widgets
  Widget separatedBy(Widget separator) =>
      ListView.separated(
        itemCount: length,
        separatorBuilder: (_, _) => separator,
        itemBuilder: (_, index) => elementAt(index),
      );

  /// Add spacing between widgets in a Column
  Widget spacedColumn({double spacing = 8, CrossAxisAlignment alignment = CrossAxisAlignment.center}) =>
      Column(
        crossAxisAlignment: alignment,
        children: [
          for (int i = 0; i < length; i++) ...[
            elementAt(i),
            if (i < length - 1) SizedBox(height: spacing),
          ],
        ],
      );

  /// Add spacing between widgets in a Row
  Widget spacedRow({double spacing = 8, MainAxisAlignment alignment = MainAxisAlignment.center}) =>
      Row(
        mainAxisAlignment: alignment,
        children: [
          for (int i = 0; i < length; i++) ...[
            elementAt(i),
            if (i < length - 1) SizedBox(width: spacing),
          ],
        ],
      );
}

/// Extension for tapping a widget
extension WhenTapped on Widget {
  Widget whenTapped(VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: this,
      );
}