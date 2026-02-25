import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/core/errors/app_error.dart';
import 'package:hubla_weather/app/core/errors/result.dart';
import 'package:hubla_weather/app/core/http/http_response.dart';
import 'package:hubla_weather/app/data/weather/datasources/remote/weather_remote_datasource.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../factories/datasources_factories.dart';
import '../../../../../factories/entities/city_factory.dart';
import '../../../../../mocks/general_mocks.dart';

void main() {
  late MockHttpClient mockClient;
  late WeatherRemoteDatasource datasource;

  setUp(() {
    mockClient = MockHttpClient();
    datasource = DatasourcesFactories.createWeatherRemoteDatasource(client: mockClient);
  });

  setUpAll(() {
    registerFallbackValue(FakeHttpRequest());
  });

  group('WeatherRemoteDatasource', () {
    group('getCurrentWeather', () {
      final city = CityFactory.create();

      test('should return Success with CityWeather on valid response', () async {
        when(() => mockClient.request(any())).thenAnswer(
          (_) async => const Success(
            HttpResponse(
              data: {
                'main': {
                  'temp': 25.5,
                  'temp_min': 20.0,
                  'temp_max': 30.0,
                  'humidity': 65,
                },
                'wind': {'speed': 3.5},
                'weather': [
                  {
                    'id': 800,
                    'main': 'Clear',
                    'description': 'clear sky',
                    'icon': '01d',
                  },
                ],
                'dt': 1740484800,
              },
              isFromCache: false,
            ),
          ),
        );

        final result = await datasource.getCurrentWeather(city: city);

        expect(result.isSuccess, isTrue);
        final cityWeather = result.getSuccess()!;
        expect(cityWeather.citySlug, city.slug);
        expect(cityWeather.temperature, 25.5);
        expect(cityWeather.temperatureMin, 20.0);
        expect(cityWeather.temperatureMax, 30.0);
        expect(cityWeather.humidity, 65);
        expect(cityWeather.windSpeed, 3.5);
        expect(cityWeather.weather.description, 'clear sky');
        expect(cityWeather.isStale, isFalse);
      });

      test('should mark CityWeather as stale when response is from cache', () async {
        when(() => mockClient.request(any())).thenAnswer(
          (_) async => const Success(
            HttpResponse(
              data: {
                'main': {
                  'temp': 25.5,
                  'temp_min': 20.0,
                  'temp_max': 30.0,
                  'humidity': 65,
                },
                'wind': {'speed': 3.5},
                'weather': [
                  {
                    'id': 800,
                    'main': 'Clear',
                    'description': 'clear sky',
                    'icon': '01d',
                  },
                ],
                'dt': 1740484800,
              },
              isFromCache: true,
            ),
          ),
        );

        final result = await datasource.getCurrentWeather(city: city);

        expect(result.isSuccess, isTrue);
        expect(result.getSuccess()!.isStale, isTrue);
      });

      test('should return Error when HttpClient returns Error', () async {
        when(() => mockClient.request(any())).thenAnswer(
          (_) async => const Error(NoConnectionError()),
        );

        final result = await datasource.getCurrentWeather(city: city);

        expect(result.isError, isTrue);
        expect(result.getError(), isA<NoConnectionError>());
      });

      test('should return SerializationError on malformed response', () async {
        when(() => mockClient.request(any())).thenAnswer(
          (_) async => const Success(HttpResponse(data: {'invalid': true}, isFromCache: false)),
        );

        final result = await datasource.getCurrentWeather(city: city);

        expect(result.isError, isTrue);
        expect(result.getError(), isA<SerializationError>());
      });
    });

    group('geocodeCity', () {
      test('should return Success with lat/lon on valid response', () async {
        when(() => mockClient.request(any())).thenAnswer(
          (_) async => const Success(
            HttpResponse(
              data: [
                {
                  'name': 'São Paulo',
                  'lat': -23.5506,
                  'lon': -46.6340,
                  'country': 'BR',
                  'state': 'São Paulo',
                },
              ],
              isFromCache: false,
            ),
          ),
        );

        final result = await datasource.geocodeCity(cityName: 'São Paulo');

        expect(result.isSuccess, isTrue);
        final coords = result.getSuccess()!;
        expect(coords.lat, -23.5506);
        expect(coords.lon, -46.6340);
      });

      test('should return Error when API returns empty array', () async {
        when(() => mockClient.request(any())).thenAnswer(
          (_) async => const Success(
            HttpResponse(data: <dynamic>[], isFromCache: false),
          ),
        );

        final result = await datasource.geocodeCity(cityName: 'Unknown City');

        expect(result.isError, isTrue);
      });

      test('should return Error when HttpClient returns Error', () async {
        when(() => mockClient.request(any())).thenAnswer(
          (_) async => const Error(NoConnectionError()),
        );

        final result = await datasource.geocodeCity(cityName: 'São Paulo');

        expect(result.isError, isTrue);
        expect(result.getError(), isA<NoConnectionError>());
      });

      test('should return SerializationError on malformed response', () async {
        when(() => mockClient.request(any())).thenAnswer(
          (_) async => const Success(
            HttpResponse(data: 'not a list', isFromCache: false),
          ),
        );

        final result = await datasource.geocodeCity(cityName: 'São Paulo');

        expect(result.isError, isTrue);
        expect(result.getError(), isA<SerializationError>());
      });
    });
  });
}
