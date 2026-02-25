import 'package:hubla_weather/app/core/errors/app_error.dart';

/// Errors specific to the weather feature.
sealed class WeatherError extends AppError {
  const WeatherError({required super.errorMessage, super.stackTrace});
}

/// Failed to fetch weather data from the remote API.
final class FetchWeatherError extends WeatherError {
  const FetchWeatherError({
    super.errorMessage = 'Failed to fetch weather data',
    super.stackTrace,
  });

  @override
  String get label => 'FetchWeatherError';
}

/// No cached weather data is available and the remote fetch failed.
final class NoCachedDataError extends WeatherError {
  const NoCachedDataError({
    super.errorMessage = 'No weather data available. Connect to the internet to load weather data.',
    super.stackTrace,
  });

  @override
  String get label => 'NoCachedDataError';
}
