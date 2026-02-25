import 'package:flutter/material.dart';

/// Sort criteria available for the city list.
///
/// Each criterion defines its icon, default sort direction, and the
/// comparison logic used to order city weather items.
enum CitiesSortCriteria {
  name(icon: Icons.sort_by_alpha_rounded, defaultAscending: true),
  temperature(icon: Icons.thermostat_rounded, defaultAscending: false),
  wind(icon: Icons.air_rounded, defaultAscending: false),
  humidity(icon: Icons.water_drop_rounded, defaultAscending: false)
  ;

  const CitiesSortCriteria({required this.icon, required this.defaultAscending});

  /// Icon displayed in the sort UI for this criterion.
  final IconData icon;

  /// Whether ascending is the most useful default direction for this criterion.
  final bool defaultAscending;
}
