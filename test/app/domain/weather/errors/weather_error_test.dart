import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/domain/weather/errors/weather_error.dart';

void main() {
  group('WeatherError', () {
    group('FetchWeatherError', () {
      test('should have default error message', () {
        const error = FetchWeatherError();

        expect(error.errorMessage, 'Failed to fetch weather data');
      });

      test('should support custom error message', () {
        const error = FetchWeatherError(errorMessage: 'Custom error');

        expect(error.errorMessage, 'Custom error');
      });

      test('should have correct label', () {
        const error = FetchWeatherError();

        expect(error.label, 'FetchWeatherError');
      });
    });

    group('NoCachedDataError', () {
      test('should have default error message', () {
        const error = NoCachedDataError();

        expect(error.errorMessage, 'No weather data available. Connect to the internet to load weather data.');
      });

      test('should have correct label', () {
        const error = NoCachedDataError();

        expect(error.label, 'NoCachedDataError');
      });
    });
  });
}
