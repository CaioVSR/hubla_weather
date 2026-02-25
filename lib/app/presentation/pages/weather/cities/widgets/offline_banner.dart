import 'package:flutter/material.dart';
import 'package:hubla_weather/app/core/extensions/hubla_color_extension.dart';
import 'package:hubla_weather/app/core/extensions/hubla_shape_extension.dart';
import 'package:hubla_weather/app/core/extensions/hubla_spacing_extension.dart';
import 'package:hubla_weather/app/core/extensions/hubla_text_style_extension.dart';
import 'package:hubla_weather/app/core/l10n/generated/app_localizations.dart';

/// Offline connectivity banner shown at the top of the content area.
class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.hublaColors;
    final spacing = context.hublaSpacing;
    final shape = context.hublaShape;
    final textStyles = context.hublaTextStyles;
    final l10n = AppLocalizations.of(context);

    return Container(
      width: double.infinity,
      margin: EdgeInsets.symmetric(horizontal: spacing.md, vertical: spacing.xxs),
      padding: EdgeInsets.symmetric(
        horizontal: spacing.sm,
        vertical: spacing.xs,
      ),
      decoration: BoxDecoration(
        color: colors.warningLight,
        borderRadius: BorderRadius.circular(shape.medium),
        border: Border.all(
          color: colors.warning.withValues(alpha: 0.3),
        ),
      ),
      child: Row(
        children: [
          Icon(
            Icons.wifi_off_rounded,
            size: 16,
            color: colors.warningDark,
          ),
          SizedBox(width: spacing.xs),
          Text(
            l10n.offlineBanner,
            style: textStyles.labelMedium.copyWith(
              color: colors.warningDark,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
