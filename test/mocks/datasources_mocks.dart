import 'package:hubla_weather/app/data/auth/datasources/local/auth_local_datasource.dart';
import 'package:hubla_weather/app/data/weather/datasources/local/weather_local_datasource.dart';
import 'package:hubla_weather/app/data/weather/datasources/remote/weather_remote_datasource.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthLocalDatasource extends Mock implements AuthLocalDatasource {}

class MockWeatherLocalDatasource extends Mock implements WeatherLocalDatasource {}

class MockWeatherRemoteDatasource extends Mock implements WeatherRemoteDatasource {}
