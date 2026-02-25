import 'package:flutter/material.dart';
import 'package:hubla_weather/app/core/extensions/hubla_spacing_extension.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/widgets/city_weather_card_skeleton.dart';

/// Shimmer skeleton list shown during initial data load.
class CitiesShimmerList extends StatelessWidget {
  const CitiesShimmerList({super.key});

  @override
  Widget build(BuildContext context) {
    final spacing = context.hublaSpacing;

    return ListView.separated(
      padding: EdgeInsets.all(spacing.md),
      physics: const NeverScrollableScrollPhysics(),
      itemCount: 5,
      separatorBuilder: (_, _) => SizedBox(height: spacing.sm),
      itemBuilder: (_, _) => const CityWeatherCardSkeleton(),
    );
  }
}
