import 'package:flutter/material.dart';
import 'package:hubla_weather/app/core/extensions/hubla_color_extension.dart';
import 'package:hubla_weather/app/core/extensions/hubla_spacing_extension.dart';
import 'package:hubla_weather/app/core/extensions/hubla_text_style_extension.dart';
import 'package:hubla_weather/app/core/l10n/generated/app_localizations.dart';

/// Search input for filtering the city list by name.
class CitiesSearchBar extends StatelessWidget {
  const CitiesSearchBar({required this.onChanged, super.key});

  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    final colors = context.hublaColors;
    final spacing = context.hublaSpacing;
    final textStyles = context.hublaTextStyles;
    final l10n = AppLocalizations.of(context);

    return Container(
      margin: EdgeInsets.fromLTRB(spacing.md, spacing.sm, spacing.md, spacing.xs),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(spacing.xl),
        boxShadow: [
          BoxShadow(
            color: colors.onSurface.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        onChanged: onChanged,
        style: textStyles.bodyMedium.copyWith(color: colors.onSurface),
        decoration: InputDecoration(
          hintText: l10n.searchCities,
          hintStyle: textStyles.bodyMedium.copyWith(color: colors.gray50),
          prefixIcon: Icon(Icons.search_rounded, color: colors.gray50),
          filled: true,
          fillColor: colors.white.withValues(alpha: 0.75),
          contentPadding: EdgeInsets.symmetric(
            horizontal: spacing.md,
            vertical: spacing.sm,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(spacing.xl),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(spacing.xl),
            borderSide: BorderSide(
              color: colors.white.withValues(alpha: 0.5),
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(spacing.xl),
            borderSide: BorderSide(color: colors.sky),
          ),
        ),
      ),
    );
  }
}
