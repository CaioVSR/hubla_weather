import 'package:flutter/material.dart';
import 'package:hubla_weather/app/core/extensions/hubla_color_extension.dart';
import 'package:hubla_weather/app/core/extensions/hubla_shape_extension.dart';
import 'package:hubla_weather/app/core/extensions/hubla_spacing_extension.dart';
import 'package:hubla_weather/app/core/extensions/hubla_text_style_extension.dart';
import 'package:hubla_weather/app/core/l10n/generated/app_localizations.dart';

/// Full-screen error state displayed when no cached data is available.
class CitiesErrorState extends StatelessWidget {
  const CitiesErrorState({required this.onRetry, super.key});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final colors = context.hublaColors;
    final spacing = context.hublaSpacing;
    final textStyles = context.hublaTextStyles;
    final l10n = AppLocalizations.of(context);

    final shape = context.hublaShape;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(spacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: colors.skyLight.withValues(alpha: 0.4),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.cloud_off_rounded,
                size: 44,
                color: colors.sky,
              ),
            ),
            SizedBox(height: spacing.lg),
            Text(
              l10n.noDataAvailable,
              textAlign: TextAlign.center,
              style: textStyles.bodyMedium.copyWith(
                color: colors.onSurfaceVariant,
              ),
            ),
            SizedBox(height: spacing.lg),
            ElevatedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh_rounded),
              label: Text(l10n.retry),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.sky,
                foregroundColor: colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(shape.full),
                ),
                padding: EdgeInsets.symmetric(
                  horizontal: spacing.lg,
                  vertical: spacing.sm,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
