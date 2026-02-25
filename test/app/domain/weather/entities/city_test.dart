import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/domain/weather/entities/city.dart';

import '../../../../factories/entities/city_factory.dart';

void main() {
  group('City', () {
    group('fromJson', () {
      test('should deserialize correctly from JSON', () {
        final json = {
          'name': 'Rio de Janeiro',
          'slug': 'rio-de-janeiro',
          'latitude': -22.9068,
          'longitude': -43.1729,
        };

        final city = City.fromJson(json);

        expect(city.name, 'Rio de Janeiro');
        expect(city.slug, 'rio-de-janeiro');
        expect(city.latitude, -22.9068);
        expect(city.longitude, -43.1729);
      });
    });

    group('toJson', () {
      test('should serialize correctly to JSON', () {
        final city = CityFactory.create(
          name: 'Brasília',
          slug: 'brasilia',
          latitude: -15.7975,
          longitude: -47.8919,
        );

        final json = city.toJson();

        expect(json, {
          'name': 'Brasília',
          'slug': 'brasilia',
          'latitude': -15.7975,
          'longitude': -47.8919,
        });
      });
    });

    group('equality', () {
      test('should be equal when all fields match', () {
        final a = CityFactory.create(slug: 'sao-paulo');
        final b = CityFactory.create(slug: 'sao-paulo');

        expect(a, equals(b));
      });

      test('should not be equal when slug differs', () {
        final a = CityFactory.create(slug: 'sao-paulo');
        final b = CityFactory.create(slug: 'rio-de-janeiro');

        expect(a, isNot(equals(b)));
      });

      test('should not be equal when latitude differs', () {
        final a = CityFactory.create(latitude: -23.5505);
        final b = CityFactory.create(latitude: -22.9068);

        expect(a, isNot(equals(b)));
      });
    });

    group('fromJson → toJson roundtrip', () {
      test('should produce identical JSON after roundtrip', () {
        final original = CityFactory.create();
        final json = original.toJson();
        final restored = City.fromJson(json);

        expect(restored, equals(original));
      });
    });
  });
}
