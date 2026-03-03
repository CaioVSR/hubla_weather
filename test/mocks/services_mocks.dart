import 'package:hubla_weather/app/core/services/hubla_connectivity_service.dart';
import 'package:hubla_weather/app/core/services/hubla_logger_service.dart';
import 'package:hubla_weather/app/core/services/hubla_secure_storage_service.dart';
import 'package:hubla_weather/app/core/services/hubla_storage_service.dart';
import 'package:mocktail/mocktail.dart';

class MockConnectivityService extends Mock implements HublaConnectivityService {}

class MockStorageService extends Mock implements HublaStorageService {}

class MockLoggerService extends Mock implements HublaLoggerService {}

class MockSecureStorageService extends Mock implements HublaSecureStorageService {}
