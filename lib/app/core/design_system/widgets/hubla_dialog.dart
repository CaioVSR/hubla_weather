import 'package:flutter/material.dart';
import 'package:hubla_weather/app/core/design_system/animation/hubla_animation_tokens.dart';
import 'package:hubla_weather/app/core/design_system/tokens/hubla_color_tokens.dart';
import 'package:hubla_weather/app/core/extensions/hubla_color_extension.dart';
import 'package:hubla_weather/app/core/extensions/hubla_shape_extension.dart';
import 'package:hubla_weather/app/core/extensions/hubla_spacing_extension.dart';
import 'package:hubla_weather/app/core/extensions/hubla_text_style_extension.dart';

/// The visual variant of a [HublaDialog], which controls the icon and
/// accent color.
enum HublaDialogVariant {
  /// Red accent — for errors and destructive confirmations.
  error(Icons.error_outline_rounded),

  /// Amber accent — for warnings / caution.
  warning(Icons.warning_amber_rounded),

  /// Blue accent — for neutral information.
  info(Icons.info_outline_rounded),

  /// Green accent — for success confirmations.
  success(Icons.check_circle_outline_rounded)
  ;

  const HublaDialogVariant(this.icon);

  final IconData icon;
}

/// A themed dialog using the Hubla design system tokens.
///
/// Supports one-button, two-button, and info-only variants.
/// Always use the static factory methods for convenience:
///
/// ```dart
/// HublaDialog.showError(context, title: '...', message: '...');
/// HublaDialog.showInfo(context, title: '...', message: '...');
/// HublaDialog.showWarning(context, title: '...', message: '...');
/// HublaDialog.showSuccess(context, title: '...', message: '...');
/// HublaDialog.showConfirm(context, title: '...', message: '...');
/// ```
class HublaDialog extends StatelessWidget {
  const HublaDialog({
    required this.title,
    required this.message,
    required this.variant,
    super.key,
    this.primaryLabel,
    this.secondaryLabel,
    this.onPrimaryPressed,
    this.onSecondaryPressed,
  });

  /// The dialog title displayed below the icon.
  final String title;

  /// The dialog body text.
  final String message;

  /// Visual variant controlling the icon and accent color.
  final HublaDialogVariant variant;

  /// Primary (right) action button label. Defaults to "OK" via l10n.
  final String? primaryLabel;

  /// Secondary (left) action button label. If `null`, only the primary button
  /// is shown.
  final String? secondaryLabel;

  /// Callback when the primary button is tapped. Pops the dialog by default.
  final VoidCallback? onPrimaryPressed;

  /// Callback when the secondary button is tapped. Pops the dialog by default.
  final VoidCallback? onSecondaryPressed;

  // ── Static convenience methods ──

  /// Shows an **error** dialog with a single dismiss button.
  static Future<void> showError(
    BuildContext context, {
    required String title,
    required String message,
    String? buttonLabel,
    VoidCallback? onPressed,
  }) => _show(
    context,
    variant: HublaDialogVariant.error,
    title: title,
    message: message,
    primaryLabel: buttonLabel,
    onPrimaryPressed: onPressed,
  );

  /// Shows an **info** dialog with a single dismiss button.
  static Future<void> showInfo(
    BuildContext context, {
    required String title,
    required String message,
    String? buttonLabel,
    VoidCallback? onPressed,
  }) => _show(
    context,
    variant: HublaDialogVariant.info,
    title: title,
    message: message,
    primaryLabel: buttonLabel,
    onPrimaryPressed: onPressed,
  );

  /// Shows a **warning** dialog with a single dismiss button.
  static Future<void> showWarning(
    BuildContext context, {
    required String title,
    required String message,
    String? buttonLabel,
    VoidCallback? onPressed,
  }) => _show(
    context,
    variant: HublaDialogVariant.warning,
    title: title,
    message: message,
    primaryLabel: buttonLabel,
    onPrimaryPressed: onPressed,
  );

  /// Shows a **success** dialog with a single dismiss button.
  static Future<void> showSuccess(
    BuildContext context, {
    required String title,
    required String message,
    String? buttonLabel,
    VoidCallback? onPressed,
  }) => _show(
    context,
    variant: HublaDialogVariant.success,
    title: title,
    message: message,
    primaryLabel: buttonLabel,
    onPrimaryPressed: onPressed,
  );

  /// Shows a **confirmation** dialog with primary and secondary buttons.
  static Future<void> showConfirm(
    BuildContext context, {
    required String title,
    required String message,
    HublaDialogVariant variant = HublaDialogVariant.warning,
    String? primaryLabel,
    String? secondaryLabel,
    VoidCallback? onPrimaryPressed,
    VoidCallback? onSecondaryPressed,
  }) => _show(
    context,
    variant: variant,
    title: title,
    message: message,
    primaryLabel: primaryLabel,
    secondaryLabel: secondaryLabel,
    onPrimaryPressed: onPrimaryPressed,
    onSecondaryPressed: onSecondaryPressed,
  );

  static Future<void> _show(
    BuildContext context, {
    required HublaDialogVariant variant,
    required String title,
    required String message,
    String? primaryLabel,
    String? secondaryLabel,
    VoidCallback? onPrimaryPressed,
    VoidCallback? onSecondaryPressed,
  }) => showDialog<void>(
    context: context,
    builder: (_) => HublaDialog(
      variant: variant,
      title: title,
      message: message,
      primaryLabel: primaryLabel,
      secondaryLabel: secondaryLabel,
      onPrimaryPressed: onPrimaryPressed,
      onSecondaryPressed: onSecondaryPressed,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final colors = context.hublaColors;
    final textStyles = context.hublaTextStyles;
    final shape = context.hublaShape;
    final spacing = context.hublaSpacing;

    final accentColor = _accentColorFor(variant, colors);
    final accentLightColor = _accentLightColorFor(variant, colors);

    return Dialog(
      backgroundColor: colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(shape.extraLarge),
      ),
      elevation: 0,
      child: Padding(
        padding: EdgeInsets.all(spacing.lg),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // ── Icon badge ──
            _DialogIconBadge(
              icon: variant.icon,
              accentColor: accentColor,
              accentLightColor: accentLightColor,
            ),
            SizedBox(height: spacing.md),

            // ── Title ──
            Text(
              title,
              style: textStyles.titleLarge.copyWith(color: colors.onSurface),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.xs),

            // ── Message ──
            Text(
              message,
              style: textStyles.bodyMedium.copyWith(color: colors.onSurfaceVariant),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: spacing.lg),

            // ── Buttons ──
            _DialogActions(
              primaryLabel: primaryLabel ?? 'OK',
              secondaryLabel: secondaryLabel,
              accentColor: accentColor,
              onPrimaryPressed: onPrimaryPressed ?? () => Navigator.of(context).pop(),
              onSecondaryPressed: onSecondaryPressed ?? () => Navigator.of(context).pop(),
            ),
          ],
        ),
      ),
    );
  }

  Color _accentColorFor(HublaDialogVariant variant, HublaColorTokens colors) => switch (variant) {
    HublaDialogVariant.error => colors.danger,
    HublaDialogVariant.warning => colors.warning,
    HublaDialogVariant.info => colors.info,
    HublaDialogVariant.success => colors.success,
  };

  Color _accentLightColorFor(HublaDialogVariant variant, HublaColorTokens colors) => switch (variant) {
    HublaDialogVariant.error => colors.dangerLight,
    HublaDialogVariant.warning => colors.warningLight,
    HublaDialogVariant.info => colors.infoLight,
    HublaDialogVariant.success => colors.successLight,
  };
}

// ── Icon badge ──

class _DialogIconBadge extends StatelessWidget {
  const _DialogIconBadge({
    required this.icon,
    required this.accentColor,
    required this.accentLightColor,
  });

  final IconData icon;
  final Color accentColor;
  final Color accentLightColor;

  @override
  Widget build(BuildContext context) {
    final spacing = context.hublaSpacing;

    return Container(
      width: 64,
      height: 64,
      decoration: BoxDecoration(
        color: accentLightColor,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: AnimatedSwitcher(
          duration: HublaAnimationTokens.short3,
          child: Icon(
            icon,
            key: ValueKey(icon),
            size: spacing.xl,
            color: accentColor,
          ),
        ),
      ),
    );
  }
}

// ── Action buttons ──

class _DialogActions extends StatelessWidget {
  const _DialogActions({
    required this.primaryLabel,
    required this.accentColor,
    required this.onPrimaryPressed,
    required this.onSecondaryPressed,
    this.secondaryLabel,
  });

  final String primaryLabel;
  final String? secondaryLabel;
  final Color accentColor;
  final VoidCallback onPrimaryPressed;
  final VoidCallback onSecondaryPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.hublaColors;
    final shape = context.hublaShape;
    final spacing = context.hublaSpacing;

    final hasSecondary = secondaryLabel != null;

    return Row(
      children: [
        if (hasSecondary) ...[
          Expanded(
            child: _DialogButton(
              label: secondaryLabel!,
              backgroundColor: colors.gray10,
              foregroundColor: colors.onSurface,
              borderRadius: shape.medium,
              onPressed: onSecondaryPressed,
            ),
          ),
          SizedBox(width: spacing.sm),
        ],
        Expanded(
          child: _DialogButton(
            label: primaryLabel,
            backgroundColor: accentColor,
            foregroundColor: colors.white,
            borderRadius: shape.medium,
            onPressed: onPrimaryPressed,
          ),
        ),
      ],
    );
  }
}

// ── Single button ──

class _DialogButton extends StatelessWidget {
  const _DialogButton({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
    required this.borderRadius,
    required this.onPressed,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;
  final double borderRadius;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final textStyles = context.hublaTextStyles;
    final spacing = context.hublaSpacing;

    return SizedBox(
      height: 48,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: foregroundColor,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          ),
          padding: EdgeInsets.symmetric(horizontal: spacing.md),
        ),
        child: Text(
          label,
          style: textStyles.labelLarge.copyWith(color: foregroundColor),
        ),
      ),
    );
  }
}
