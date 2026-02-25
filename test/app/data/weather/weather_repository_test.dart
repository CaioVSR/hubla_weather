import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/core/errors/app_error.dart';
import 'package:hubla_weather/app/core/errors/result.dart';
import 'package:hubla_weather/app/data/weather/weather_repository.dart';
import 'package:hubla_weather/app/domain/weather/entities/predefined_cities.dart';
import 'package:hubla_weather/app/domain/weather/errors/weather_error.dart';
import 'package:mocktail/mocktail.dart';

import '../../../factories/entities/city_factory.dart';
import '../../../factories/entities/city_weather_factory.dart';
import '../../../factories/repositories_factories.dart';
import '../../../mocks/datasources_mocks.dart';

void main() {
  late MockWeatherRemoteDatasource mockRemote;
  late MockWeatherLocalDatasource mockLocal;
  late WeatherRepository repository;

  setUp(() {
    mockRemote = MockWeatherRemoteDatasource();
    mockLocal = MockWeatherLocalDatasource();
    repository = RepositoriesFactories.createWeatherRepository(
      weatherRemoteDatasource: mockRemote,
      weatherLocalDatasource: mockLocal,
    );

    // Default: no cached geocoding results, geocoding API fails → uses hardcoded coords
    when(() => mockLocal.getGeocodingResult(any())).thenAnswer((_) async => null);
    when(
      () => mockRemote.geocodeCity(cityName: any(named: 'cityName')),
    ).thenAnswer((_) async => const Error(NoConnectionError()));
  });

  setUpAll(() {
    registerFallbackValue(CityFactory.create());
    registerFallbackValue(CityWeatherFactory.create());
  });

  group('WeatherRepository', () {
    group('getAllCitiesWeather', () {
      test('should return all cities weather on full success', () async {
        for (final city in predefinedCities) {
          when(() => mockRemote.getCurrentWeather(city: city)).thenAnswer(
            (_) async => Success(CityWeatherFactory.create(citySlug: city.slug)),
          );
        }
        when(() => mockLocal.saveCityWeather(any())).thenAnswer((_) async {});

        final result = await repository.getAllCitiesWeather();

        expect(result.isSuccess, isTrue);
        expect(result.getSuccess(), hasLength(10));
      });

      test('should save each successful result to local cache', () async {
        for (final city in predefinedCities) {
          when(() => mockRemote.getCurrentWeather(city: city)).thenAnswer(
            (_) async => Success(CityWeatherFactory.create(citySlug: city.slug)),
          );
        }
        when(() => mockLocal.saveCityWeather(any())).thenAnswer((_) async {});

        await repository.getAllCitiesWeather();

        verify(() => mockLocal.saveCityWeather(any())).called(10);
      });

      test('should return partial results with stale flag on partial failure', () async {
        // First city: success
        when(() => mockRemote.getCurrentWeather(city: predefinedCities[0])).thenAnswer(
          (_) async => Success(CityWeatherFactory.create(citySlug: predefinedCities[0].slug)),
        );
        when(() => mockLocal.saveCityWeather(any())).thenAnswer((_) async {});

        // Second city: fails but has cache
        when(() => mockRemote.getCurrentWeather(city: predefinedCities[1])).thenAnswer(
          (_) async => const Error(NoConnectionError()),
        );
        when(() => mockLocal.getCityWeather(predefinedCities[1].slug)).thenAnswer(
          (_) async => CityWeatherFactory.create(citySlug: predefinedCities[1].slug),
        );

        // Remaining cities: fail with no cache
        for (var i = 2; i < predefinedCities.length; i++) {
          when(() => mockRemote.getCurrentWeather(city: predefinedCities[i])).thenAnswer(
            (_) async => const Error(NoConnectionError()),
          );
          when(() => mockLocal.getCityWeather(predefinedCities[i].slug)).thenAnswer(
            (_) async => null,
          );
        }

        final result = await repository.getAllCitiesWeather();

        expect(result.isSuccess, isTrue);
        final cities = result.getSuccess()!;
        expect(cities, hasLength(2));

        // The cached one should be marked stale
        final staleCities = cities.where((c) => c.isStale).toList();
        expect(staleCities, hasLength(1));
        expect(staleCities.first.citySlug, predefinedCities[1].slug);
      });

      test('should return NoCachedDataError when all fail and no cache exists', () async {
        for (final city in predefinedCities) {
          when(() => mockRemote.getCurrentWeather(city: city)).thenAnswer(
            (_) async => const Error(NoConnectionError()),
          );
          when(() => mockLocal.getCityWeather(city.slug)).thenAnswer(
            (_) async => null,
          );
        }

        final result = await repository.getAllCitiesWeather();

        expect(result.isError, isTrue);
        expect(result.getError(), isA<NoCachedDataError>());
      });

      test('should return all cached data as stale when all remote calls fail', () async {
        for (final city in predefinedCities) {
          when(() => mockRemote.getCurrentWeather(city: city)).thenAnswer(
            (_) async => const Error(NoConnectionError()),
          );
          when(() => mockLocal.getCityWeather(city.slug)).thenAnswer(
            (_) async => CityWeatherFactory.create(citySlug: city.slug),
          );
        }

        final result = await repository.getAllCitiesWeather();

        expect(result.isSuccess, isTrue);
        final cities = result.getSuccess()!;
        expect(cities, hasLength(10));
        expect(cities.every((c) => c.isStale), isTrue);
      });
    });

    group('getCityWeather', () {
      final city = CityFactory.create();

      test('should return fresh CityWeather on success', () async {
        final cityWeather = CityWeatherFactory.create(citySlug: city.slug);
        when(() => mockRemote.getCurrentWeather(city: city)).thenAnswer(
          (_) async => Success(cityWeather),
        );
        when(() => mockLocal.saveCityWeather(any())).thenAnswer((_) async {});

        final result = await repository.getCityWeather(city: city);

        expect(result.isSuccess, isTrue);
        expect(result.getSuccess()!.isStale, isFalse);
      });

      test('should save to local cache on success', () async {
        final cityWeather = CityWeatherFactory.create(citySlug: city.slug);
        when(() => mockRemote.getCurrentWeather(city: city)).thenAnswer(
          (_) async => Success(cityWeather),
        );
        when(() => mockLocal.saveCityWeather(any())).thenAnswer((_) async {});

        await repository.getCityWeather(city: city);

        verify(() => mockLocal.saveCityWeather(cityWeather)).called(1);
      });

      test('should return stale cached data on remote failure', () async {
        final cachedWeather = CityWeatherFactory.create(citySlug: city.slug);
        when(() => mockRemote.getCurrentWeather(city: city)).thenAnswer(
          (_) async => const Error(NoConnectionError()),
        );
        when(() => mockLocal.getCityWeather(city.slug)).thenAnswer(
          (_) async => cachedWeather,
        );

        final result = await repository.getCityWeather(city: city);

        expect(result.isSuccess, isTrue);
        expect(result.getSuccess()!.isStale, isTrue);
      });

      test('should return FetchWeatherError when remote fails and no cache', () async {
        when(() => mockRemote.getCurrentWeather(city: city)).thenAnswer(
          (_) async => const Error(NoConnectionError()),
        );
        when(() => mockLocal.getCityWeather(city.slug)).thenAnswer(
          (_) async => null,
        );

        final result = await repository.getCityWeather(city: city);

        expect(result.isError, isTrue);
        expect(result.getError(), isA<FetchWeatherError>());
      });
    });

    group('geocoding resolution', () {
      test('should use cached geocoding coordinates when available', () async {
        final city = CityFactory.create();
        const cachedCoords = (lat: -23.55, lon: -46.63);

        when(() => mockLocal.getGeocodingResult(city.slug)).thenAnswer(
          (_) async => cachedCoords,
        );
        when(() => mockRemote.getCurrentWeather(city: any(named: 'city'))).thenAnswer(
          (_) async => Success(CityWeatherFactory.create(citySlug: city.slug)),
        );
        when(() => mockLocal.saveCityWeather(any())).thenAnswer((_) async {});

        await repository.getCityWeather(city: city);

        verifyNever(
          () => mockRemote.geocodeCity(cityName: any(named: 'cityName')),
        );
      });

      test('should call geocoding API when no cached geocoding exists', () async {
        final city = CityFactory.create();
        const geocodedCoords = (lat: -23.5501, lon: -46.6340);

        when(() => mockLocal.getGeocodingResult(city.slug)).thenAnswer(
          (_) async => null,
        );
        when(
          () => mockRemote.geocodeCity(cityName: city.name),
        ).thenAnswer((_) async => const Success(geocodedCoords));
        when(
          () => mockLocal.saveGeocodingResult(
            citySlug: any(named: 'citySlug'),
            lat: any(named: 'lat'),
            lon: any(named: 'lon'),
          ),
        ).thenAnswer((_) async {});
        when(() => mockRemote.getCurrentWeather(city: any(named: 'city'))).thenAnswer(
          (_) async => Success(CityWeatherFactory.create(citySlug: city.slug)),
        );
        when(() => mockLocal.saveCityWeather(any())).thenAnswer((_) async {});

        await repository.getCityWeather(city: city);

        verify(
          () => mockLocal.saveGeocodingResult(
            citySlug: city.slug,
            lat: geocodedCoords.lat,
            lon: geocodedCoords.lon,
          ),
        ).called(1);
      });

      test('should fallback to hardcoded coords when geocoding fails', () async {
        final city = CityFactory.create();

        when(() => mockLocal.getGeocodingResult(city.slug)).thenAnswer(
          (_) async => null,
        );
        when(
          () => mockRemote.geocodeCity(cityName: city.name),
        ).thenAnswer((_) async => const Error(NoConnectionError()));
        when(() => mockRemote.getCurrentWeather(city: city)).thenAnswer(
          (_) async => Success(CityWeatherFactory.create(citySlug: city.slug)),
        );
        when(() => mockLocal.saveCityWeather(any())).thenAnswer((_) async {});

        final result = await repository.getCityWeather(city: city);

        expect(result.isSuccess, isTrue);
        verify(() => mockRemote.getCurrentWeather(city: city)).called(1);
      });
    });
  });
}
