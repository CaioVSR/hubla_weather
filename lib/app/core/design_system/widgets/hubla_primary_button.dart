import 'package:flutter/material.dart';
import 'package:hubla_weather/app/core/design_system/animation/hubla_animation_tokens.dart';
import 'package:hubla_weather/app/core/extensions/hubla_color_extension.dart';
import 'package:hubla_weather/app/core/extensions/hubla_shape_extension.dart';
import 'package:hubla_weather/app/core/extensions/hubla_spacing_extension.dart';
import 'package:hubla_weather/app/core/extensions/hubla_text_style_extension.dart';

/// A full-width primary button using the Hubla design system tokens.
///
/// Features a sky-blue background, rounded corners, loading state
/// with a spinner, and disabled state styling.
class HublaPrimaryButton extends StatelessWidget {
  const HublaPrimaryButton({
    required this.label,
    required this.onPressed,
    super.key,
    this.isLoading = false,
    this.isEnabled = true,
    this.prefixIcon,
  });

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool isEnabled;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    final colors = context.hublaColors;
    final textStyles = context.hublaTextStyles;
    final shape = context.hublaShape;
    final spacing = context.hublaSpacing;

    final effectivelyEnabled = isEnabled && !isLoading && onPressed != null;

    return AnimatedContainer(
      duration: HublaAnimationTokens.short4,
      curve: HublaAnimationTokens.standard,
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: effectivelyEnabled ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: effectivelyEnabled ? colors.sky : colors.gray20,
          foregroundColor: effectivelyEnabled ? colors.white : colors.gray50,
          disabledBackgroundColor: colors.gray20,
          disabledForegroundColor: colors.gray50,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(shape.medium),
          ),
          padding: EdgeInsets.symmetric(horizontal: spacing.lg, vertical: spacing.sm),
        ),
        child: AnimatedSwitcher(
          duration: HublaAnimationTokens.short3,
          child: isLoading
              ? SizedBox(
                  key: const ValueKey('loading'),
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: colors.white,
                  ),
                )
              : Row(
                  key: const ValueKey('content'),
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (prefixIcon != null) ...[
                      prefixIcon!,
                      SizedBox(width: spacing.xs),
                    ],
                    Text(
                      label,
                      style: textStyles.labelLarge.copyWith(
                        color: effectivelyEnabled ? colors.white : colors.gray50,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
