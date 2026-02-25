import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/data/weather/datasources/local/weather_local_datasource.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../factories/datasources_factories.dart';
import '../../../../../factories/entities/city_weather_factory.dart';
import '../../../../../mocks/services_mocks.dart';

void main() {
  late MockStorageService mockStorageService;
  late WeatherLocalDatasource datasource;

  setUp(() {
    mockStorageService = MockStorageService();
    datasource = DatasourcesFactories.createWeatherLocalDatasource(
      storageService: mockStorageService,
    );
  });

  group('WeatherLocalDatasource', () {
    group('saveCityWeather', () {
      test('should write city weather JSON to storage with correct key', () async {
        final cityWeather = CityWeatherFactory.create(citySlug: 'sao-paulo');
        when(
          () => mockStorageService.write<Map<String, dynamic>>(
            key: any(named: 'key'),
            value: any(named: 'value'),
            boxName: any(named: 'boxName'),
          ),
        ).thenAnswer((_) async {});

        await datasource.saveCityWeather(cityWeather);

        verify(
          () => mockStorageService.write<Map<String, dynamic>>(
            key: 'weather_sao-paulo',
            value: cityWeather.toJson(),
            boxName: 'weather_cache',
          ),
        ).called(1);
      });
    });

    group('getCityWeather', () {
      test('should return CityWeather when cached data exists', () async {
        final cityWeather = CityWeatherFactory.create(citySlug: 'sao-paulo');
        when(
          () => mockStorageService.read<Map<dynamic, dynamic>>(
            'weather_sao-paulo',
            boxName: 'weather_cache',
          ),
        ).thenAnswer((_) async => cityWeather.toJson());

        final result = await datasource.getCityWeather('sao-paulo');

        expect(result, isNotNull);
        expect(result!.citySlug, 'sao-paulo');
      });

      test('should return null when no cached data exists', () async {
        when(
          () => mockStorageService.read<Map<dynamic, dynamic>>(
            'weather_sao-paulo',
            boxName: 'weather_cache',
          ),
        ).thenAnswer((_) async => null);

        final result = await datasource.getCityWeather('sao-paulo');

        expect(result, isNull);
      });
    });

    group('getAllCachedCitiesWeather', () {
      test('should return list of cached cities', () async {
        final spWeather = CityWeatherFactory.create(citySlug: 'sao-paulo');
        final rjWeather = CityWeatherFactory.create(citySlug: 'rio-de-janeiro');

        when(
          () => mockStorageService.read<Map<dynamic, dynamic>>(
            any(),
            boxName: 'weather_cache',
          ),
        ).thenAnswer((_) async => null);

        when(
          () => mockStorageService.read<Map<dynamic, dynamic>>(
            'weather_sao-paulo',
            boxName: 'weather_cache',
          ),
        ).thenAnswer((_) async => spWeather.toJson());

        when(
          () => mockStorageService.read<Map<dynamic, dynamic>>(
            'weather_rio-de-janeiro',
            boxName: 'weather_cache',
          ),
        ).thenAnswer((_) async => rjWeather.toJson());

        final result = await datasource.getAllCachedCitiesWeather();

        expect(result, hasLength(2));
        expect(result.map((c) => c.citySlug), containsAll(['sao-paulo', 'rio-de-janeiro']));
      });

      test('should return empty list when no cities are cached', () async {
        when(
          () => mockStorageService.read<Map<dynamic, dynamic>>(
            any(),
            boxName: 'weather_cache',
          ),
        ).thenAnswer((_) async => null);

        final result = await datasource.getAllCachedCitiesWeather();

        expect(result, isEmpty);
      });
    });

    group('saveGeocodingResult', () {
      test('should write geocoding data with correct key and box', () async {
        when(
          () => mockStorageService.write<Map<String, double>>(
            key: any(named: 'key'),
            value: any(named: 'value'),
            boxName: any(named: 'boxName'),
          ),
        ).thenAnswer((_) async {});

        await datasource.saveGeocodingResult(
          citySlug: 'sao-paulo',
          lat: -23.5506,
          lon: -46.6340,
        );

        verify(
          () => mockStorageService.write(
            key: 'geocoding_sao-paulo',
            value: {'lat': -23.5506, 'lon': -46.6340},
            boxName: 'geocoding_cache',
          ),
        ).called(1);
      });
    });

    group('getGeocodingResult', () {
      test('should return coordinates when cached data exists', () async {
        when(
          () => mockStorageService.read<Map<dynamic, dynamic>>(
            'geocoding_sao-paulo',
            boxName: 'geocoding_cache',
          ),
        ).thenAnswer((_) async => {'lat': -23.5506, 'lon': -46.6340});

        final result = await datasource.getGeocodingResult('sao-paulo');

        expect(result, isNotNull);
        expect(result!.lat, -23.5506);
        expect(result.lon, -46.6340);
      });

      test('should return null when no cached geocoding data exists', () async {
        when(
          () => mockStorageService.read<Map<dynamic, dynamic>>(
            'geocoding_sao-paulo',
            boxName: 'geocoding_cache',
          ),
        ).thenAnswer((_) async => null);

        final result = await datasource.getGeocodingResult('sao-paulo');

        expect(result, isNull);
      });
    });
  });
}
