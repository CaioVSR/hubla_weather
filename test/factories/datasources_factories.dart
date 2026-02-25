import 'package:hubla_weather/app/core/http/app_dio.dart';
import 'package:hubla_weather/app/core/services/secure_storage_service.dart';
import 'package:hubla_weather/app/core/services/storage_service.dart';
import 'package:hubla_weather/app/data/auth/datasources/local/auth_local_datasource.dart';
import 'package:hubla_weather/app/data/weather/datasources/local/weather_local_datasource.dart';
import 'package:hubla_weather/app/data/weather/datasources/remote/weather_remote_datasource.dart';

import '../mocks/general_mocks.dart';
import '../mocks/services_mocks.dart';

abstract class DatasourcesFactories {
  static AuthLocalDatasource createAuthLocalDatasource({
    SecureStorageService? secureStorageService,
  }) => AuthLocalDatasource(
    secureStorageService: secureStorageService ?? MockSecureStorageService(),
  );

  static WeatherLocalDatasource createWeatherLocalDatasource({
    StorageService? storageService,
  }) => WeatherLocalDatasource(
    storageService: storageService ?? MockStorageService(),
  );

  static WeatherRemoteDatasource createWeatherRemoteDatasource({
    HttpClient? client,
  }) => WeatherRemoteDatasource(
    client: client ?? MockHttpClient(),
  );
}
