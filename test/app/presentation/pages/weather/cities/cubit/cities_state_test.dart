import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/cubit/cities_state.dart';

import '../../../../../../factories/entities/city_weather_factory.dart';

void main() {
  group('CitiesState', () {
    test('should have correct initial values', () {
      final state = CitiesState.initial();

      expect(state.cities, isEmpty);
      expect(state.searchQuery, isEmpty);
      expect(state.isLoading, isTrue);
      expect(state.isOffline, isFalse);
      expect(state.hasError, isFalse);
    });

    group('hasCities', () {
      test('should return false when cities list is empty', () {
        expect(CitiesState.initial().hasCities, isFalse);
      });

      test('should return true when cities list is not empty', () {
        final state = CitiesState.initial().copyWith(
          cities: [CityWeatherFactory.create()],
        );

        expect(state.hasCities, isTrue);
      });
    });

    group('showEmptySearch', () {
      test('should return false when searchQuery is empty', () {
        final state = CitiesState.initial().copyWith(
          cities: [CityWeatherFactory.create()],
          searchQuery: '',
        );

        expect(state.showEmptySearch, isFalse);
      });

      test('should return false when there are no cities loaded', () {
        final state = CitiesState.initial().copyWith(searchQuery: 'xyz');

        expect(state.showEmptySearch, isFalse);
      });

      test('should return true when search matches no cities', () {
        final state = CitiesState.initial().copyWith(
          cities: [CityWeatherFactory.create(citySlug: 'sao-paulo')],
          searchQuery: 'xyz',
        );

        expect(state.showEmptySearch, isTrue);
      });

      test('should return false when search matches some cities', () {
        final state = CitiesState.initial().copyWith(
          cities: [CityWeatherFactory.create(citySlug: 'sao-paulo')],
          searchQuery: 'Paulo',
        );

        expect(state.showEmptySearch, isFalse);
      });
    });

    group('filteredCities', () {
      test('should return all cities when searchQuery is empty', () {
        final cities = [
          CityWeatherFactory.create(citySlug: 'sao-paulo'),
          CityWeatherFactory.create(citySlug: 'rio-de-janeiro'),
        ];
        final state = CitiesState.initial().copyWith(cities: cities);

        expect(state.filteredCities, hasLength(2));
      });

      test('should filter cities by name case-insensitively', () {
        final cities = [
          CityWeatherFactory.create(citySlug: 'sao-paulo'),
          CityWeatherFactory.create(citySlug: 'rio-de-janeiro'),
        ];
        final state = CitiesState.initial().copyWith(
          cities: cities,
          searchQuery: 'rio',
        );

        expect(state.filteredCities, hasLength(1));
        expect(state.filteredCities.first.citySlug, 'rio-de-janeiro');
      });

      test('should filter cities accent-insensitively', () {
        final cities = [
          CityWeatherFactory.create(citySlug: 'sao-paulo'),
          CityWeatherFactory.create(citySlug: 'brasilia'),
        ];
        final state = CitiesState.initial().copyWith(
          cities: cities,
          searchQuery: 'sao',
        );

        expect(state.filteredCities, hasLength(1));
        expect(state.filteredCities.first.citySlug, 'sao-paulo');
      });

      test('should return empty list when no city matches', () {
        final cities = [
          CityWeatherFactory.create(citySlug: 'sao-paulo'),
        ];
        final state = CitiesState.initial().copyWith(
          cities: cities,
          searchQuery: 'zzz',
        );

        expect(state.filteredCities, isEmpty);
      });
    });

    group('copyWith', () {
      test('should update cities while preserving other fields', () {
        final cities = [CityWeatherFactory.create()];
        final state = CitiesState.initial().copyWith(cities: cities);

        expect(state.cities, cities);
        expect(state.searchQuery, isEmpty);
        expect(state.isLoading, isTrue);
      });

      test('should update isLoading while preserving other fields', () {
        final state = CitiesState.initial().copyWith(isLoading: false);

        expect(state.isLoading, isFalse);
        expect(state.cities, isEmpty);
      });

      test('should update isOffline while preserving other fields', () {
        final state = CitiesState.initial().copyWith(isOffline: true);

        expect(state.isOffline, isTrue);
        expect(state.isLoading, isTrue);
      });

      test('should update hasError while preserving other fields', () {
        final state = CitiesState.initial().copyWith(hasError: true);

        expect(state.hasError, isTrue);
        expect(state.isLoading, isTrue);
      });

      test('should update searchQuery while preserving other fields', () {
        final state = CitiesState.initial().copyWith(searchQuery: 'test');

        expect(state.searchQuery, 'test');
        expect(state.cities, isEmpty);
      });
    });

    group('equality', () {
      test('should be equal when all fields match', () {
        final a = CitiesState.initial();
        final b = CitiesState.initial();

        expect(a, equals(b));
      });

      test('should not be equal when a field differs', () {
        final a = CitiesState.initial();
        final b = CitiesState.initial().copyWith(isLoading: false);

        expect(a, isNot(equals(b)));
      });
    });
  });
}
