import 'package:flutter/material.dart';
import 'package:hubla_weather/app/core/extensions/hubla_color_extension.dart';
import 'package:hubla_weather/app/core/extensions/hubla_spacing_extension.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/cubit/cities_sort_criteria.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/widgets/cities_sort_sheet.dart';

/// Frosted glass sort button displayed beside the search bar.
///
/// Shows the active sort criterion's icon. When the sort is not at its
/// default state (name ascending), a small sky-colored dot badge appears
/// to indicate an active sort override. Tapping opens the [CitiesSortSheet].
class CitiesSortButton extends StatelessWidget {
  const CitiesSortButton({
    required this.sortCriteria,
    required this.isAscending,
    required this.onSort,
    required this.onClearSort,
    super.key,
  });

  final CitiesSortCriteria sortCriteria;
  final bool isAscending;
  final ValueChanged<CitiesSortCriteria> onSort;
  final VoidCallback onClearSort;

  /// Whether the sort state differs from the default (name, ascending).
  bool get _hasActiveSort => sortCriteria != CitiesSortCriteria.name || !isAscending;

  @override
  Widget build(BuildContext context) {
    final colors = context.hublaColors;
    final spacing = context.hublaSpacing;

    return Container(
      margin: EdgeInsets.only(top: spacing.sm, right: spacing.md),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(spacing.xl),
              onTap: () => CitiesSortSheet.show(
                context: context,
                activeCriteria: sortCriteria,
                isAscending: isAscending,
                onSort: onSort,
                onClearSort: onClearSort,
              ),
              child: Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colors.white.withValues(alpha: 0.75),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: colors.white.withValues(alpha: 0.5),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: colors.onSurface.withValues(alpha: 0.06),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(
                  _hasActiveSort ? (isAscending ? Icons.arrow_upward_rounded : Icons.arrow_downward_rounded) : Icons.swap_vert_rounded,
                  color: _hasActiveSort ? colors.sky : colors.gray50,
                  size: 22,
                ),
              ),
            ),
          ),
          // Active sort indicator dot
          if (_hasActiveSort)
            Positioned(
              top: 2,
              right: 2,
              child: Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: colors.sky,
                  shape: BoxShape.circle,
                  border: Border.all(color: colors.white, width: 1.5),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
