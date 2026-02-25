import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hubla_weather/app/core/extensions/hubla_spacing_extension.dart';
import 'package:hubla_weather/app/domain/weather/entities/city_weather.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/widgets/city_weather_card.dart';
import 'package:hubla_weather/app/presentation/routing/hubla_route.dart';

/// Scrollable list of city weather cards with pull-to-refresh.
class CityList extends StatelessWidget {
  const CityList({
    required this.cities,
    required this.onRefresh,
    super.key,
  });

  final List<CityWeather> cities;
  final RefreshCallback onRefresh;

  @override
  Widget build(BuildContext context) {
    final spacing = context.hublaSpacing;

    return RefreshIndicator(
      onRefresh: onRefresh,
      child: ListView.separated(
        padding: EdgeInsets.all(spacing.md),
        itemCount: cities.length,
        separatorBuilder: (_, _) => SizedBox(height: spacing.sm),
        itemBuilder: (context, index) {
          final cityWeather = cities[index];
          return CityWeatherCard(
            cityWeather: cityWeather,
            onTap: () => context.push(
              HublaRoute.forecast.path.replaceFirst(':cityId', cityWeather.citySlug),
            ),
          );
        },
      ),
    );
  }
}
