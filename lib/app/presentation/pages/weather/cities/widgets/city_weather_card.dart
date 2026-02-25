import 'package:flutter/material.dart';
import 'package:hubla_weather/app/core/design_system/animation/hubla_animation_tokens.dart';
import 'package:hubla_weather/app/core/design_system/tokens/hubla_color_tokens.dart';
import 'package:hubla_weather/app/core/extensions/hubla_color_extension.dart';
import 'package:hubla_weather/app/core/extensions/hubla_shape_extension.dart';
import 'package:hubla_weather/app/core/extensions/hubla_spacing_extension.dart';
import 'package:hubla_weather/app/core/extensions/hubla_text_style_extension.dart';
import 'package:hubla_weather/app/core/l10n/generated/app_localizations.dart';
import 'package:hubla_weather/app/domain/weather/entities/city_weather.dart';
import 'package:hubla_weather/app/domain/weather/entities/predefined_cities.dart';
import 'package:hubla_weather/app/domain/weather/enums/weather_condition.dart';

/// A medium-sized card displaying current weather data for a single city.
///
/// Features an animated scale-down press effect and Material ink ripple.
///
/// Layout:
/// - Top row: condition icon badge (left) + city name & condition + temperature (right)
/// - Middle: detail pills (temp range, humidity, wind)
/// - Bottom: live/cached data source indicator
class CityWeatherCard extends StatefulWidget {
  const CityWeatherCard({
    required this.cityWeather,
    required this.onTap,
    super.key,
  });

  final CityWeather cityWeather;
  final VoidCallback onTap;

  @override
  State<CityWeatherCard> createState() => _CityWeatherCardState();
}

class _CityWeatherCardState extends State<CityWeatherCard> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  static const _pressedScale = 0.97;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: HublaAnimationTokens.short2,
      reverseDuration: HublaAnimationTokens.short4,
    );
    _scaleAnimation = Tween<double>(begin: 1, end: _pressedScale).animate(
      CurvedAnimation(parent: _controller, curve: HublaAnimationTokens.standard),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onTapDown(TapDownDetails _) => _controller.forward();

  void _onTapUp(TapUpDetails _) {
    _controller.reverse();
    widget.onTap();
  }

  void _onTapCancel() => _controller.reverse();

  @override
  Widget build(BuildContext context) {
    final colors = context.hublaColors;
    final spacing = context.hublaSpacing;
    final textStyles = context.hublaTextStyles;
    final shape = context.hublaShape;
    final l10n = AppLocalizations.of(context);
    final cityName = _resolveCityName(widget.cityWeather.citySlug);
    final accentColor = _conditionAccentColor(
      colors,
      widget.cityWeather.weather.condition,
    );
    final borderRadius = BorderRadius.circular(shape.largeIncreased);

    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) => Transform.scale(
        scale: _scaleAnimation.value,
        child: child,
      ),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: colors.surface.withValues(alpha: 0.88),
          borderRadius: borderRadius,
          border: Border.all(
            color: colors.white.withValues(alpha: 0.6),
          ),
          boxShadow: [
            BoxShadow(
              color: colors.onSurface.withValues(alpha: 0.05),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: borderRadius,
          child: InkWell(
            borderRadius: borderRadius,
            splashColor: accentColor.withValues(alpha: 0.08),
            highlightColor: accentColor.withValues(alpha: 0.04),
            onTapDown: _onTapDown,
            onTapUp: _onTapUp,
            onTapCancel: _onTapCancel,
            child: Padding(
              padding: EdgeInsets.all(spacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Top row: icon badge + city name/condition + temperature
                  Row(
                    children: [
                      // Weather condition icon in colored circle
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: accentColor.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          widget.cityWeather.weather.condition.icon,
                          size: 24,
                          color: accentColor,
                        ),
                      ),
                      SizedBox(width: spacing.sm),
                      // City name + condition label
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              cityName,
                              style: textStyles.titleMedium.copyWith(
                                color: colors.onSurface,
                                fontWeight: FontWeight.w600,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: spacing.xxxs),
                            Text(
                              widget.cityWeather.weather.condition.label,
                              style: textStyles.bodySmall.copyWith(
                                color: colors.onSurfaceVariant,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(width: spacing.xs),
                      // Temperature — large and prominent
                      Text(
                        l10n.temperatureCelsius(
                          widget.cityWeather.temperature.round().toString(),
                        ),
                        style: textStyles.headlineMedium.copyWith(
                          color: colors.onSurface,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: spacing.sm),
                  // Detail pills
                  Wrap(
                    spacing: spacing.xs,
                    runSpacing: spacing.xs,
                    children: [
                      _DetailPill(
                        icon: Icons.thermostat_rounded,
                        label:
                            '${widget.cityWeather.temperatureMax.round()}° / '
                            '${widget.cityWeather.temperatureMin.round()}°',
                      ),
                      _DetailPill(
                        icon: Icons.water_drop_outlined,
                        label: l10n.humidityPercent(
                          widget.cityWeather.humidity.toString(),
                        ),
                      ),
                      _DetailPill(
                        icon: Icons.air_rounded,
                        label: l10n.windSpeedMs(
                          widget.cityWeather.windSpeed.toStringAsFixed(1),
                        ),
                      ),
                    ],
                  ),
                  // Data source indicator
                  SizedBox(height: spacing.xs),
                  Row(
                    children: [
                      Icon(
                        widget.cityWeather.isStale ? Icons.cloud_off_rounded : Icons.cloud_done_rounded,
                        size: 14,
                        color: widget.cityWeather.isStale ? colors.warning : colors.success,
                      ),
                      SizedBox(width: spacing.xxxs),
                      Text(
                        widget.cityWeather.isStale ? l10n.cachedData : l10n.liveData,
                        style: textStyles.labelSmall.copyWith(
                          color: widget.cityWeather.isStale ? colors.warning : colors.success,
                        ),
                      ),
                      if (widget.cityWeather.isStale) ...[
                        SizedBox(width: spacing.xxxs),
                        Text(
                          '— ${l10n.staleData}',
                          style: textStyles.labelSmall.copyWith(
                            color: colors.warning,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _resolveCityName(String slug) {
    for (final city in predefinedCities) {
      if (city.slug == slug) {
        return city.name;
      }
    }
    return slug;
  }
}

/// Maps a [WeatherCondition] to its accent color from the design tokens.
Color _conditionAccentColor(
  HublaColorTokens colors,
  WeatherCondition condition,
) => switch (condition) {
  WeatherCondition.clear => colors.sun,
  WeatherCondition.clouds => colors.sky,
  WeatherCondition.rain || WeatherCondition.drizzle => colors.skyDark,
  WeatherCondition.thunderstorm => colors.core,
  WeatherCondition.snow => colors.lavender,
  WeatherCondition.mist || WeatherCondition.haze || WeatherCondition.fog || WeatherCondition.smoke => colors.gray50,
  WeatherCondition.dust || WeatherCondition.sand || WeatherCondition.ash => colors.coral,
  WeatherCondition.squall || WeatherCondition.tornado => colors.danger,
  WeatherCondition.unknown => colors.gray50,
};

/// A pill-shaped chip displaying an icon and label for weather detail metrics.
class _DetailPill extends StatelessWidget {
  const _DetailPill({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.hublaColors;
    final spacing = context.hublaSpacing;
    final shape = context.hublaShape;
    final textStyles = context.hublaTextStyles;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: spacing.xs,
        vertical: spacing.xxxs,
      ),
      decoration: BoxDecoration(
        color: colors.surfaceVariant.withValues(alpha: 0.6),
        borderRadius: BorderRadius.circular(shape.full),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: colors.onSurfaceVariant),
          SizedBox(width: spacing.xxxs),
          Text(
            label,
            style: textStyles.labelSmall.copyWith(
              color: colors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
