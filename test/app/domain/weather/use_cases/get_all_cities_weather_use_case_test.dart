import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/core/errors/result.dart';
import 'package:hubla_weather/app/domain/weather/errors/weather_error.dart';
import 'package:hubla_weather/app/domain/weather/use_cases/get_all_cities_weather_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../factories/entities/city_weather_factory.dart';
import '../../../../mocks/repositories_mocks.dart';

void main() {
  late MockWeatherRepository mockWeatherRepository;
  late GetAllCitiesWeatherUseCase useCase;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    useCase = GetAllCitiesWeatherUseCase(weatherRepository: mockWeatherRepository);
  });

  group('GetAllCitiesWeatherUseCase', () {
    test('should return Success with list of CityWeather from repository', () async {
      final citiesWeather = [
        CityWeatherFactory.create(citySlug: 'sao-paulo'),
        CityWeatherFactory.create(citySlug: 'rio-de-janeiro'),
      ];
      when(() => mockWeatherRepository.getAllCitiesWeather()).thenAnswer(
        (_) async => Success(citiesWeather),
      );

      final result = await useCase();

      expect(result.isSuccess, isTrue);
      expect(result.getSuccess(), hasLength(2));
      verify(() => mockWeatherRepository.getAllCitiesWeather()).called(1);
    });

    test('should return Error when repository returns error', () async {
      when(() => mockWeatherRepository.getAllCitiesWeather()).thenAnswer(
        (_) async => const Error(NoCachedDataError()),
      );

      final result = await useCase();

      expect(result.isError, isTrue);
      expect(result.getError(), isA<NoCachedDataError>());
    });
  });
}
