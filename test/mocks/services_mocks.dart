import 'package:hubla_weather/app/core/services/connectivity_service.dart';
import 'package:hubla_weather/app/core/services/logger_service.dart';
import 'package:hubla_weather/app/core/services/storage_service.dart';
import 'package:mocktail/mocktail.dart';

class MockConnectivityService extends Mock implements ConnectivityService {}

class MockStorageService extends Mock implements StorageService {}

class MockLoggerService extends Mock implements LoggerService {}
