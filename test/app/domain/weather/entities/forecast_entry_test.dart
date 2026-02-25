import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/domain/weather/entities/forecast_entry.dart';
import 'package:hubla_weather/app/domain/weather/enums/weather_condition.dart';

import '../../../../factories/entities/forecast_entry_factory.dart';
import '../../../../factories/entities/weather_info_factory.dart';

void main() {
  group('ForecastEntry', () {
    group('fromJson', () {
      test('should deserialize correctly from JSON', () {
        final json = {
          'dateTime': '2026-02-25T15:00:00.000Z',
          'temperature': 26.0,
          'humidity': 70,
          'windSpeed': 4.0,
          'weather': {
            'id': 802,
            'main': 'Clouds',
            'description': 'scattered clouds',
            'icon': '03d',
          },
        };

        final entry = ForecastEntry.fromJson(json);

        expect(entry.dateTime, DateTime.utc(2026, 2, 25, 15));
        expect(entry.temperature, 26.0);
        expect(entry.humidity, 70);
        expect(entry.windSpeed, 4.0);
        expect(entry.weather.condition, WeatherCondition.clouds);
        expect(entry.weather.description, 'scattered clouds');
      });
    });

    group('toJson', () {
      test('should serialize correctly to JSON', () {
        final entry = ForecastEntryFactory.create();

        final json = entry.toJson();

        expect(json['temperature'], 26.0);
        expect(json['humidity'], 70);
        expect(json['windSpeed'], 4.0);
        expect(json['weather'], isA<Map<String, dynamic>>());
        expect(json['dateTime'], isA<String>());
      });
    });

    group('equality', () {
      test('should be equal when all fields match', () {
        final dateTime = DateTime.utc(2026, 2, 25, 15);
        final a = ForecastEntryFactory.create(dateTime: dateTime);
        final b = ForecastEntryFactory.create(dateTime: dateTime);

        expect(a, equals(b));
      });

      test('should not be equal when dateTime differs', () {
        final a = ForecastEntryFactory.create(dateTime: DateTime.utc(2026, 2, 25, 15));
        final b = ForecastEntryFactory.create(dateTime: DateTime.utc(2026, 2, 25, 18));

        expect(a, isNot(equals(b)));
      });

      test('should not be equal when temperature differs', () {
        final dateTime = DateTime.utc(2026, 2, 25, 15);
        final a = ForecastEntryFactory.create(temperature: 26, dateTime: dateTime);
        final b = ForecastEntryFactory.create(temperature: 30, dateTime: dateTime);

        expect(a, isNot(equals(b)));
      });

      test('should not be equal when weather differs', () {
        final dateTime = DateTime.utc(2026, 2, 25, 15);
        final a = ForecastEntryFactory.create(
          weather: WeatherInfoFactory.create(condition: WeatherCondition.clear),
          dateTime: dateTime,
        );
        final b = ForecastEntryFactory.create(
          weather: WeatherInfoFactory.create(condition: WeatherCondition.rain),
          dateTime: dateTime,
        );

        expect(a, isNot(equals(b)));
      });
    });

    group('fromJson → toJson roundtrip', () {
      test('should produce identical JSON after roundtrip', () {
        final original = ForecastEntryFactory.create();
        final json = original.toJson();
        final restored = ForecastEntry.fromJson(json);

        expect(restored, equals(original));
      });
    });
  });
}
