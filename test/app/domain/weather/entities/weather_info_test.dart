import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/domain/weather/entities/weather_info.dart';
import 'package:hubla_weather/app/domain/weather/enums/weather_condition.dart';

import '../../../../factories/entities/weather_info_factory.dart';

void main() {
  group('WeatherInfo', () {
    group('fromJson', () {
      test('should deserialize correctly from JSON', () {
        final json = {
          'id': 501,
          'main': 'Rain',
          'description': 'moderate rain',
          'icon': '10d',
        };

        final info = WeatherInfo.fromJson(json);

        expect(info.id, 501);
        expect(info.condition, WeatherCondition.rain);
        expect(info.description, 'moderate rain');
        expect(info.icon, '10d');
      });

      test('should map unknown condition to WeatherCondition.unknown', () {
        final json = {
          'id': 999,
          'main': 'SomeFutureCondition',
          'description': 'something new',
          'icon': '50d',
        };

        final info = WeatherInfo.fromJson(json);

        expect(info.condition, WeatherCondition.unknown);
      });

      test('should map all known conditions correctly', () {
        final conditions = {
          'Clear': WeatherCondition.clear,
          'Clouds': WeatherCondition.clouds,
          'Rain': WeatherCondition.rain,
          'Drizzle': WeatherCondition.drizzle,
          'Thunderstorm': WeatherCondition.thunderstorm,
          'Snow': WeatherCondition.snow,
          'Mist': WeatherCondition.mist,
          'Smoke': WeatherCondition.smoke,
          'Haze': WeatherCondition.haze,
          'Dust': WeatherCondition.dust,
          'Fog': WeatherCondition.fog,
          'Sand': WeatherCondition.sand,
          'Ash': WeatherCondition.ash,
          'Squall': WeatherCondition.squall,
          'Tornado': WeatherCondition.tornado,
        };

        for (final entry in conditions.entries) {
          final json = {
            'id': 800,
            'main': entry.key,
            'description': 'test',
            'icon': '01d',
          };

          final info = WeatherInfo.fromJson(json);

          expect(info.condition, entry.value, reason: 'Failed for ${entry.key}');
        }
      });
    });

    group('toJson', () {
      test('should serialize correctly to JSON', () {
        final info = WeatherInfoFactory.create(
          id: 800,
          condition: WeatherCondition.clear,
          description: 'clear sky',
          icon: '01d',
        );

        final json = info.toJson();

        expect(json, {
          'id': 800,
          'main': 'Clear',
          'description': 'clear sky',
          'icon': '01d',
        });
      });
    });

    group('equality', () {
      test('should be equal when all fields match', () {
        final a = WeatherInfoFactory.create(id: 800);
        final b = WeatherInfoFactory.create(id: 800);

        expect(a, equals(b));
      });

      test('should not be equal when id differs', () {
        final a = WeatherInfoFactory.create(id: 800);
        final b = WeatherInfoFactory.create(id: 501);

        expect(a, isNot(equals(b)));
      });

      test('should not be equal when condition differs', () {
        final a = WeatherInfoFactory.create(condition: WeatherCondition.clear);
        final b = WeatherInfoFactory.create(condition: WeatherCondition.rain);

        expect(a, isNot(equals(b)));
      });
    });

    group('fromJson → toJson roundtrip', () {
      test('should produce identical JSON after roundtrip', () {
        final original = WeatherInfoFactory.create();
        final json = original.toJson();
        final restored = WeatherInfo.fromJson(json);

        expect(restored, equals(original));
      });
    });
  });
}
