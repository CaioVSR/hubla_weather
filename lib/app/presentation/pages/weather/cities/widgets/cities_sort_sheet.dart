import 'package:flutter/material.dart';
import 'package:hubla_weather/app/core/extensions/hubla_color_extension.dart';
import 'package:hubla_weather/app/core/extensions/hubla_spacing_extension.dart';
import 'package:hubla_weather/app/core/l10n/generated/app_localizations.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/cubit/cities_sort_criteria.dart';

/// Modal bottom sheet displaying sort options for the city list.
///
/// Shows a row of interactive pills — one per [CitiesSortCriteria].
/// The active pill is highlighted with the sky accent color and shows
/// a direction arrow beside its icon (↑ or ↓). Tapping the active pill
/// toggles direction; tapping a different pill switches the criterion.
///
/// A "Clear" button in the header resets the sort to the default (name ascending).
/// The sheet does **not** auto-dismiss — the user dismisses by tapping outside
/// or dragging down.
class CitiesSortSheet extends StatefulWidget {
  const CitiesSortSheet({
    required this.activeCriteria,
    required this.isAscending,
    required this.onSort,
    required this.onClearSort,
    super.key,
  });

  final CitiesSortCriteria activeCriteria;
  final bool isAscending;
  final ValueChanged<CitiesSortCriteria> onSort;
  final VoidCallback onClearSort;

  /// Shows the sort bottom sheet.
  static Future<void> show({
    required BuildContext context,
    required CitiesSortCriteria activeCriteria,
    required bool isAscending,
    required ValueChanged<CitiesSortCriteria> onSort,
    required VoidCallback onClearSort,
  }) => showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => CitiesSortSheet(
      activeCriteria: activeCriteria,
      isAscending: isAscending,
      onSort: onSort,
      onClearSort: onClearSort,
    ),
  );

  @override
  State<CitiesSortSheet> createState() => _CitiesSortSheetState();
}

class _CitiesSortSheetState extends State<CitiesSortSheet> {
  late CitiesSortCriteria _activeCriteria;
  late bool _isAscending;

  @override
  void initState() {
    super.initState();
    _activeCriteria = widget.activeCriteria;
    _isAscending = widget.isAscending;
  }

  /// Whether the current local state differs from the default (name ascending).
  bool get _hasActiveSort => _activeCriteria != CitiesSortCriteria.name || !_isAscending;

  void _onCriteriaTap(CitiesSortCriteria criteria) {
    setState(() {
      if (criteria == _activeCriteria) {
        _isAscending = !_isAscending;
      } else {
        _activeCriteria = criteria;
        _isAscending = criteria.defaultAscending;
      }
    });
    widget.onSort(criteria);
  }

  void _onClear() {
    setState(() {
      _activeCriteria = CitiesSortCriteria.name;
      _isAscending = true;
    });
    widget.onClearSort();
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.hublaColors;
    final spacing = context.hublaSpacing;
    final l10n = AppLocalizations.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(spacing.lg)),
        boxShadow: [
          BoxShadow(
            color: colors.onSurface.withValues(alpha: 0.1),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Drag handle
            Container(
              margin: EdgeInsets.only(top: spacing.sm),
              width: 36,
              height: 4,
              decoration: BoxDecoration(
                color: colors.gray30,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(spacing.lg, spacing.md, spacing.md, spacing.xs),
              child: Row(
                children: [
                  Icon(Icons.swap_vert_rounded, size: 20, color: colors.sky),
                  SizedBox(width: spacing.xs),
                  Expanded(
                    child: Text(
                      l10n.sortBy,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: colors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (_hasActiveSort)
                    TextButton(
                      onPressed: _onClear,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.symmetric(horizontal: spacing.sm),
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        l10n.clearSort,
                        style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: colors.danger,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(spacing.md, spacing.xs, spacing.md, spacing.lg),
              child: Row(
                children: CitiesSortCriteria.values.map((criteria) {
                  final isActive = criteria == _activeCriteria;
                  return Expanded(
                    child: _SortOptionPill(
                      criteria: criteria,
                      label: _labelFor(criteria, l10n),
                      isActive: isActive,
                      isAscending: isActive ? _isAscending : criteria.defaultAscending,
                      onTap: () => _onCriteriaTap(criteria),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _labelFor(CitiesSortCriteria criteria, AppLocalizations l10n) => switch (criteria) {
    CitiesSortCriteria.name => l10n.sortName,
    CitiesSortCriteria.temperature => l10n.sortTemperature,
    CitiesSortCriteria.wind => l10n.sortWind,
    CitiesSortCriteria.humidity => l10n.sortHumidity,
  };
}

/// A single sort option displayed as an interactive pill.
class _SortOptionPill extends StatelessWidget {
  const _SortOptionPill({
    required this.criteria,
    required this.label,
    required this.isActive,
    required this.isAscending,
    required this.onTap,
  });

  final CitiesSortCriteria criteria;
  final String label;
  final bool isActive;
  final bool isAscending;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.hublaColors;
    final spacing = context.hublaSpacing;

    final backgroundColor = isActive ? colors.sky.withValues(alpha: 0.12) : colors.surfaceVariant.withValues(alpha: 0.5);
    final borderColor = isActive ? colors.sky.withValues(alpha: 0.3) : Colors.transparent;
    final iconColor = isActive ? colors.sky : colors.gray50;
    final textColor = isActive ? colors.skyDark : colors.onSurfaceVariant;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: spacing.xxs),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(spacing.sm),
          onTap: onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            curve: Curves.easeInOut,
            padding: EdgeInsets.symmetric(vertical: spacing.xs, horizontal: spacing.xxs),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(spacing.sm),
              border: Border.all(color: borderColor),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(criteria.icon, size: 22, color: iconColor),
                    if (isActive) ...[
                      SizedBox(width: spacing.xxxs),
                      Icon(
                        isAscending ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded,
                        size: 14,
                        color: colors.sky,
                      ),
                    ],
                  ],
                ),
                SizedBox(height: spacing.xxs),
                Text(
                  label,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: textColor,
                    fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
