import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/domain/weather/entities/city_weather.dart';
import 'package:hubla_weather/app/domain/weather/enums/weather_condition.dart';

import '../../../../factories/entities/city_weather_factory.dart';
import '../../../../factories/entities/weather_info_factory.dart';

void main() {
  group('CityWeather', () {
    group('fromJson', () {
      test('should deserialize correctly from JSON', () {
        final json = {
          'citySlug': 'sao-paulo',
          'temperature': 25.0,
          'temperatureMin': 20.0,
          'temperatureMax': 30.0,
          'humidity': 65,
          'windSpeed': 3.5,
          'weather': {
            'id': 800,
            'main': 'Clear',
            'description': 'clear sky',
            'icon': '01d',
          },
          'dateTime': '2026-02-25T12:00:00.000Z',
        };

        final cityWeather = CityWeather.fromJson(json);

        expect(cityWeather.citySlug, 'sao-paulo');
        expect(cityWeather.temperature, 25.0);
        expect(cityWeather.temperatureMin, 20.0);
        expect(cityWeather.temperatureMax, 30.0);
        expect(cityWeather.humidity, 65);
        expect(cityWeather.windSpeed, 3.5);
        expect(cityWeather.weather.condition, WeatherCondition.clear);
        expect(cityWeather.dateTime, DateTime.utc(2026, 2, 25, 12));
      });
    });

    group('toJson', () {
      test('should serialize correctly to JSON', () {
        final cityWeather = CityWeatherFactory.create();

        final json = cityWeather.toJson();

        expect(json['citySlug'], 'sao-paulo');
        expect(json['temperature'], 25.0);
        expect(json['temperatureMin'], 20.0);
        expect(json['temperatureMax'], 30.0);
        expect(json['humidity'], 65);
        expect(json['windSpeed'], 3.5);
        expect(json['weather'], isA<Map<String, dynamic>>());
        expect(json['dateTime'], isA<String>());
      });
    });

    group('equality', () {
      test('should be equal when all fields match', () {
        final dateTime = DateTime.utc(2026, 2, 25, 12);
        final a = CityWeatherFactory.create(dateTime: dateTime);
        final b = CityWeatherFactory.create(dateTime: dateTime);

        expect(a, equals(b));
      });

      test('should not be equal when citySlug differs', () {
        final dateTime = DateTime.utc(2026, 2, 25, 12);
        final a = CityWeatherFactory.create(citySlug: 'sao-paulo', dateTime: dateTime);
        final b = CityWeatherFactory.create(citySlug: 'rio-de-janeiro', dateTime: dateTime);

        expect(a, isNot(equals(b)));
      });

      test('should not be equal when temperature differs', () {
        final dateTime = DateTime.utc(2026, 2, 25, 12);
        final a = CityWeatherFactory.create(temperature: 25, dateTime: dateTime);
        final b = CityWeatherFactory.create(temperature: 30, dateTime: dateTime);

        expect(a, isNot(equals(b)));
      });

      test('should not be equal when weather differs', () {
        final dateTime = DateTime.utc(2026, 2, 25, 12);
        final a = CityWeatherFactory.create(
          weather: WeatherInfoFactory.create(condition: WeatherCondition.clear),
          dateTime: dateTime,
        );
        final b = CityWeatherFactory.create(
          weather: WeatherInfoFactory.create(condition: WeatherCondition.rain),
          dateTime: dateTime,
        );

        expect(a, isNot(equals(b)));
      });
    });

    group('fromJson → toJson roundtrip', () {
      test('should produce identical JSON after roundtrip', () {
        final original = CityWeatherFactory.create();
        final json = original.toJson();
        final restored = CityWeather.fromJson(json);

        expect(restored, equals(original));
      });
    });

    group('isStale', () {
      test('should default to false', () {
        final cityWeather = CityWeatherFactory.create();

        expect(cityWeather.isStale, isFalse);
      });

      test('should support true value', () {
        final cityWeather = CityWeatherFactory.create(isStale: true);

        expect(cityWeather.isStale, isTrue);
      });

      test('should not be serialized to JSON', () {
        final cityWeather = CityWeatherFactory.create(isStale: true);

        final json = cityWeather.toJson();

        expect(json.containsKey('isStale'), isFalse);
      });

      test('should default to false when deserialized from JSON', () {
        final original = CityWeatherFactory.create(isStale: true);
        final json = original.toJson();

        final deserialized = CityWeather.fromJson(json);

        expect(deserialized.isStale, isFalse);
      });
    });

    group('copyWith', () {
      test('should update isStale', () {
        final cityWeather = CityWeatherFactory.create();

        final stale = cityWeather.copyWith(isStale: true);

        expect(stale.isStale, isTrue);
        expect(stale.citySlug, cityWeather.citySlug);
        expect(stale.temperature, cityWeather.temperature);
      });

      test('should preserve isStale when not specified', () {
        final cityWeather = CityWeatherFactory.create(isStale: true);

        final copy = cityWeather.copyWith();

        expect(copy.isStale, isTrue);
      });
    });
  });
}
