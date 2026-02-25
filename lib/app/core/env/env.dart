/// Environment configuration loaded via `--dart-define-from-file`.
///
/// Values are injected at compile time using `String.fromEnvironment`.
/// Example usage:
/// ```sh
/// flutter run --dart-define-from-file=config/dev.json
/// ```
abstract final class Env {
  // ignore: do_not_use_environment
  static const String openWeatherBaseUrl = String.fromEnvironment('OPEN_WEATHER_BASE_URL');
  // ignore: do_not_use_environment
  static const String openWeatherApiKey = String.fromEnvironment('OPEN_WEATHER_API_KEY');
}
