import 'package:hubla_weather/app/data/auth/auth_repository.dart';
import 'package:hubla_weather/app/data/weather/weather_repository.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

class MockWeatherRepository extends Mock implements WeatherRepository {}
