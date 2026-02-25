import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/domain/weather/entities/predefined_cities.dart';

void main() {
  group('predefinedCities', () {
    test('should contain exactly 10 cities', () {
      expect(predefinedCities, hasLength(10));
    });

    test('should have unique slugs', () {
      final slugs = predefinedCities.map((c) => c.slug).toSet();

      expect(slugs, hasLength(10));
    });

    test('should contain São Paulo', () {
      final sp = predefinedCities.firstWhere((c) => c.slug == 'sao-paulo');

      expect(sp.name, 'São Paulo');
      expect(sp.latitude, -23.5505);
      expect(sp.longitude, -46.6333);
    });

    test('should contain all expected city slugs', () {
      final slugs = predefinedCities.map((c) => c.slug).toList();

      expect(
        slugs,
        containsAll([
          'sao-paulo',
          'rio-de-janeiro',
          'brasilia',
          'salvador',
          'fortaleza',
          'belo-horizonte',
          'manaus',
          'curitiba',
          'recife',
          'porto-alegre',
        ]),
      );
    });
  });
}
