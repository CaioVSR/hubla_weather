// ignore_for_file: do_not_use_environment

/// Environment configuration loaded via `--dart-define-from-file`.
///
/// Values are injected at compile time using `String.fromEnvironment`.
/// Example usage:
/// ```sh
/// flutter run --dart-define-from-file=.env.dev
/// ```
abstract final class Env {

  static const String environment = String.fromEnvironment('ENVIRONMENT', defaultValue: 'dev');

  static const String openWeatherBaseUrl = String.fromEnvironment('OPEN_WEATHER_BASE_URL');

  static const String openWeatherApiKey = String.fromEnvironment('OPEN_WEATHER_API_KEY');

  /// Whether the current environment is production.
  static bool get isProduction => environment == 'prod';

  /// Whether the current environment is development.
  static bool get isDevelopment => environment == 'dev';
}
