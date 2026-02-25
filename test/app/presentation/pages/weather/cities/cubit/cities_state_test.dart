import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/cubit/cities_sort_criteria.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/cubit/cities_state.dart';

import '../../../../../../factories/entities/city_weather_factory.dart';

void main() {
  group('CitiesState', () {
    test('should have correct initial values', () {
      final state = CitiesState.initial();

      expect(state.cities, isEmpty);
      expect(state.searchQuery, isEmpty);
      expect(state.sortCriteria, CitiesSortCriteria.name);
      expect(state.isAscending, isTrue);
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

      test('should include sort fields in equality', () {
        final a = CitiesState.initial().copyWith(sortCriteria: CitiesSortCriteria.name);
        final b = CitiesState.initial().copyWith(sortCriteria: CitiesSortCriteria.temperature);

        expect(a, isNot(equals(b)));
      });

      test('should be equal with same sort fields', () {
        final a = CitiesState.initial().copyWith(sortCriteria: CitiesSortCriteria.wind, isAscending: false);
        final b = CitiesState.initial().copyWith(sortCriteria: CitiesSortCriteria.wind, isAscending: false);

        expect(a, equals(b));
      });
    });

    group('sorting', () {
      final saoPaulo = CityWeatherFactory.create(citySlug: 'sao-paulo', temperature: 30, windSpeed: 5, humidity: 80);
      final rio = CityWeatherFactory.create(citySlug: 'rio-de-janeiro', temperature: 35, windSpeed: 3, humidity: 70);
      final brasilia = CityWeatherFactory.create(citySlug: 'brasilia', temperature: 25, windSpeed: 7, humidity: 50);
      final cities = [saoPaulo, rio, brasilia];

      test('should sort by name ascending by default', () {
        final state = CitiesState.initial().copyWith(cities: cities, isLoading: false);

        final result = state.filteredCities;

        expect(result[0].citySlug, 'brasilia');
        expect(result[1].citySlug, 'rio-de-janeiro');
        expect(result[2].citySlug, 'sao-paulo');
      });

      test('should sort by name descending', () {
        final state = CitiesState.initial().copyWith(
          cities: cities,
          isLoading: false,
          sortCriteria: CitiesSortCriteria.name,
          isAscending: false,
        );

        final result = state.filteredCities;

        expect(result[0].citySlug, 'sao-paulo');
        expect(result[1].citySlug, 'rio-de-janeiro');
        expect(result[2].citySlug, 'brasilia');
      });

      test('should sort by temperature descending', () {
        final state = CitiesState.initial().copyWith(
          cities: cities,
          isLoading: false,
          sortCriteria: CitiesSortCriteria.temperature,
          isAscending: false,
        );

        final result = state.filteredCities;

        expect(result[0].citySlug, 'rio-de-janeiro');
        expect(result[1].citySlug, 'sao-paulo');
        expect(result[2].citySlug, 'brasilia');
      });

      test('should sort by temperature ascending', () {
        final state = CitiesState.initial().copyWith(
          cities: cities,
          isLoading: false,
          sortCriteria: CitiesSortCriteria.temperature,
          isAscending: true,
        );

        final result = state.filteredCities;

        expect(result[0].citySlug, 'brasilia');
        expect(result[1].citySlug, 'sao-paulo');
        expect(result[2].citySlug, 'rio-de-janeiro');
      });

      test('should sort by wind speed descending', () {
        final state = CitiesState.initial().copyWith(
          cities: cities,
          isLoading: false,
          sortCriteria: CitiesSortCriteria.wind,
          isAscending: false,
        );

        final result = state.filteredCities;

        expect(result[0].citySlug, 'brasilia');
        expect(result[1].citySlug, 'sao-paulo');
        expect(result[2].citySlug, 'rio-de-janeiro');
      });

      test('should sort by humidity descending', () {
        final state = CitiesState.initial().copyWith(
          cities: cities,
          isLoading: false,
          sortCriteria: CitiesSortCriteria.humidity,
          isAscending: false,
        );

        final result = state.filteredCities;

        expect(result[0].citySlug, 'sao-paulo');
        expect(result[1].citySlug, 'rio-de-janeiro');
        expect(result[2].citySlug, 'brasilia');
      });

      test('should apply search filter before sorting', () {
        final state = CitiesState.initial().copyWith(
          cities: cities,
          searchQuery: 'paulo',
          isLoading: false,
          sortCriteria: CitiesSortCriteria.temperature,
          isAscending: false,
        );

        final result = state.filteredCities;

        expect(result.length, 1);
        expect(result[0].citySlug, 'sao-paulo');
      });

      test('should preserve sort fields in copyWith', () {
        final state = CitiesState.initial().copyWith(
          sortCriteria: CitiesSortCriteria.temperature,
          isAscending: false,
        );

        final updated = state.copyWith(searchQuery: 'test');

        expect(updated.sortCriteria, CitiesSortCriteria.temperature);
        expect(updated.isAscending, false);
        expect(updated.searchQuery, 'test');
      });
    });
  });
}
