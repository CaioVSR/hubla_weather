import 'package:hubla_weather/app/core/services/secure_storage_service.dart';
import 'package:hubla_weather/app/data/auth/datasources/local/auth_local_datasource.dart';

import '../mocks/services_mocks.dart';

abstract class DatasourcesFactories {
  static AuthLocalDatasource createAuthLocalDatasource({
    SecureStorageService? secureStorageService,
  }) => AuthLocalDatasource(
    secureStorageService: secureStorageService ?? MockSecureStorageService(),
  );
}
