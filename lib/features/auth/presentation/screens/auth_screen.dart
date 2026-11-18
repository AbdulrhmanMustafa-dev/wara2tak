import 'dart:math' as math;

import 'package:material_ui/material_ui.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../../../core/design_system/index.dart';
import '../../../../core/extensions/context_extensions.dart';
import '../cubit/auth_cubit.dart';
import '../cubit/auth_state.dart';

/// Auth screen with Google Sign-In
class AuthScreen extends StatelessWidget {
  const AuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          context.showErrorSnackBar(state.message);
        } else if (state is AuthAuthenticated) {
          context.go('/home');
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              return SingleChildScrollView(
                padding: AppSpacing.screenPadding,
                child: ConstrainedBox(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: IntrinsicHeight(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Spacer(flex: 2),

                        // Logo/Brand
                        _buildBrandSection(context),

                        const Spacer(flex: 1),

                        // Description
                        Text(
                          'Sign in to analyze your documents with AI',
                          style: AppTypography.bodyMedium.copyWith(
                            color: context.colors.onSurfaceVariant,
                          ),
                          textAlign: TextAlign.center,
                        ),

                        const SizedBox(height: AppSpacing.spacingXl),

                        // Google Sign-In Button
                        BlocBuilder<AuthCubit, AuthState>(
                          builder: (context, state) {
                            return _AuthSignInButton(
                              onPressed: () =>
                                  context.read<AuthCubit>().signInWithGoogle(),
                              isLoading: state is AuthLoading,
                              errorMessage: state is AuthError
                                  ? state.message
                                  : null,
                            );
                          },
                        ),

                        const SizedBox(height: AppSpacing.spacingLg),

                        // Terms
                        _buildTermsSection(context),

                        const Spacer(flex: 2),

                        // Version info
                        _buildVersionInfo(context),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildBrandSection(BuildContext context) {
    return Column(
      children: [
        // Animated logo container
        TweenAnimationBuilder<double>(
          tween: Tween(begin: 0.0, end: 1.0),
          duration: const Duration(milliseconds: 800),
          curve: Curves.elasticOut,
          builder: (context, value, child) {
            return Transform.scale(scale: value, child: child);
          },
          child: Container(
            width: 96,
            height: 96,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  context.colors.primary,
                  context.colors.primary.withValues(alpha: 0.7),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(AppShapes.radiusXl * 1.5),
              boxShadow: [
                BoxShadow(
                  color: context.colors.primary.withValues(alpha: 0.3),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Icon(
              Symbols.auto_awesome,
              size: 48,
              color: context.colors.onPrimary,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.spacingLg),
        // App name with gradient text effect
        ShaderMask(
          shaderCallback: (bounds) => LinearGradient(
            colors: [context.colors.primary, context.colors.secondary],
          ).createShader(bounds),
          child: Text(
            'Wara2tak',
            style: AppTypography.displayLargeMobile.copyWith(
              fontWeight: FontWeight.w800,
              color: Colors.white,
              letterSpacing: -0.5,
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.spacingSm),
        Text(
          'AI Document Intelligence',
          style: AppTypography.bodyLarge.copyWith(
            color: context.colors.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: AppSpacing.spacingMd),
        // Tagline
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.spacingLg,
            vertical: AppSpacing.spacingSm,
          ),
          decoration: BoxDecoration(
            color: context.colors.primaryContainer.withValues(alpha: 0.5),
            borderRadius: AppShapes.chip,
            border: Border.all(
              color: context.colors.primary.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Symbols.psychology, size: 16, color: context.colors.primary),
              const SizedBox(width: AppSpacing.spacingXs),
              Text(
                'Extract clauses • Find deadlines • Plan applications',
                style: AppTypography.labelMedium.copyWith(
                  color: context.colors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTermsSection(BuildContext context) {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        style: AppTypography.bodySmall.copyWith(
          color: context.colors.onSurfaceVariant,
        ),
        children: [
          const TextSpan(text: 'By continuing, you agree to our '),
          TextSpan(
            text: 'Terms of Service',
            style: TextStyle(
              color: context.colors.primary,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
              decorationColor: context.colors.primary,
            ),
          ),
          const TextSpan(text: ' and '),
          TextSpan(
            text: 'Privacy Policy',
            style: TextStyle(
              color: context.colors.primary,
              fontWeight: FontWeight.w600,
              decoration: TextDecoration.underline,
              decorationColor: context.colors.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionInfo(BuildContext context) {
    return Text(
      'Version 1.0.0+1',
      style: AppTypography.bodySmall.copyWith(
        color: context.colors.onSurfaceVariant.withValues(alpha: 0.5),
      ),
      textAlign: TextAlign.center,
    );
  }
}

/// Enhanced Google Sign-In button with error display
class _AuthSignInButton extends StatefulWidget {
  final VoidCallback? onPressed;
  final bool isLoading;
  final String? errorMessage;

  const _AuthSignInButton({
    required this.onPressed,
    required this.isLoading,
    this.errorMessage,
  });

  @override
  State<_AuthSignInButton> createState() => _AuthSignInButtonState();
}

class _AuthSignInButtonState extends State<_AuthSignInButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  @override
  void initState() {
    super.initState();
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  @override
  void didUpdateWidget(covariant _AuthSignInButton oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.errorMessage != null && oldWidget.errorMessage == null) {
      _shakeController.forward().then((_) => _shakeController.reverse());
    }
  }

  @override
  void dispose() {
    _shakeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _shakeAnimation,
      builder: (context, child) {
        final shakeOffset = widget.errorMessage != null
            ? 10 * (1 - (2 * _shakeAnimation.value - 1).abs())
            : 0.0;

        return Transform.translate(
          offset: Offset(shakeOffset, 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Sign-in button
              SizedBox(
                width: double.infinity,
                height: 56,
                child: OutlinedButton(
                  onPressed: widget.isLoading ? null : widget.onPressed,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.spacingLg,
                      vertical: AppSpacing.spacingMd,
                    ),
                    side: BorderSide(
                      color: widget.isLoading
                          ? context.colors.outline.withValues(alpha: 0.5)
                          : context.colors.outline,
                      width: 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: AppShapes.button,
                    ),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    backgroundColor: widget.isLoading
                        ? context.colors.surfaceContainerHighest.withValues(
                            alpha: 0.5,
                          )
                        : Colors.transparent,
                  ),
                  child: widget.isLoading
                      ? _buildLoadingIndicator(context)
                      : _buildButtonContent(context),
                ),
              ),

              // Error message
              if (widget.errorMessage != null) ...[
                const SizedBox(height: AppSpacing.spacingMd),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeOut,
                  padding: const EdgeInsets.all(AppSpacing.spacingMd),
                  decoration: BoxDecoration(
                    color: AppColors.blue.withValues(alpha: 0.05),
                    borderRadius: AppShapes.card,
                    border: Border.all(
                      color: AppColors.error.withValues(alpha: 0.3),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Symbols.error_outline,
                        size: 20,
                        color: AppColors.error,
                      ),
                      const SizedBox(width: AppSpacing.spacingSm),
                      Expanded(
                        child: Text(
                          widget.errorMessage!,
                          style: AppTypography.bodySmall.copyWith(
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            valueColor: AlwaysStoppedAnimation<Color>(context.colors.primary),
          ),
        ),
        const SizedBox(width: AppSpacing.spacingMd),
        Text(
          'Signing in...',
          style: AppTypography.labelLarge.copyWith(
            color: context.colors.onSurfaceVariant,
          ),
        ),
      ],
    );
  }

  Widget _buildButtonContent(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Google logo using official colors
        _GoogleLogo(size: 22),
        const SizedBox(width: AppSpacing.spacingMd),
        Text(
          'Continue with Google',
          style: AppTypography.labelLarge.copyWith(fontWeight: FontWeight.w600),
        ),
      ],
    );
  }
}

/// Official Google logo with correct colors
class _GoogleLogo extends StatelessWidget {
  final double size;

  const _GoogleLogo({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final scale = size.width / 48.0;
    canvas.scale(scale, scale);

    // Google Blue
    final bluePaint = Paint()..color = const Color(0xFF4285F4);
    // Google Red
    final redPaint = Paint()..color = const Color(0xFFEA4335);
    // Google Yellow
    final yellowPaint = Paint()..color = const Color(0xFFFBBC05);
    // Google Green
    final greenPaint = Paint()..color = const Color(0xFF34A853);

    final center = Offset(24, 24);
    final radius = 20.0;

    // Draw full circle in blue
    canvas.drawCircle(center, radius, bluePaint);

    // Draw red segment (top-right)
    final redPath = Path()
      ..moveTo(center.dx, center.dy)
      ..arcTo(
        Rect.fromCircle(center: center, radius: radius),
        -math.pi / 2,
        math.pi / 2,
        false,
      )
      ..close();
    canvas.drawPath(redPath, redPaint);

    // Draw yellow segment (bottom-right)
    final yellowPath = Path()
      ..moveTo(center.dx, center.dy)
      ..arcTo(
        Rect.fromCircle(center: center, radius: radius),
        math.pi / 2,
        math.pi / 2,
        false,
      )
      ..close();
    canvas.drawPath(yellowPath, yellowPaint);

    // Draw green segment (bottom-left)
    final greenPath = Path()
      ..moveTo(center.dx, center.dy)
      ..arcTo(
        Rect.fromCircle(center: center, radius: radius),
        math.pi,
        math.pi / 2,
        false,
      )
      ..close();
    canvas.drawPath(greenPath, greenPaint);

    // Draw inner white circle
    final whitePaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, radius * 0.55, whitePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
