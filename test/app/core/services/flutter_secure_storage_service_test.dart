import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/core/services/flutter_secure_storage_service.dart';
import 'package:mocktail/mocktail.dart';

class MockFlutterSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockFlutterSecureStorage mockStorage;
  late FlutterSecureStorageService service;

  setUp(() {
    mockStorage = MockFlutterSecureStorage();
    service = FlutterSecureStorageService(storage: mockStorage);
  });

  group('FlutterSecureStorageService', () {
    group('read', () {
      test('should delegate to FlutterSecureStorage.read', () async {
        when(() => mockStorage.read(key: 'test_key')).thenAnswer((_) async => 'test_value');

        final result = await service.read('test_key');

        expect(result, 'test_value');
        verify(() => mockStorage.read(key: 'test_key')).called(1);
      });

      test('should return null when key does not exist', () async {
        when(() => mockStorage.read(key: 'missing')).thenAnswer((_) async => null);

        final result = await service.read('missing');

        expect(result, isNull);
      });
    });

    group('write', () {
      test('should delegate to FlutterSecureStorage.write', () async {
        when(() => mockStorage.write(key: 'key', value: 'value')).thenAnswer((_) async {});

        await service.write(key: 'key', value: 'value');

        verify(() => mockStorage.write(key: 'key', value: 'value')).called(1);
      });
    });

    group('delete', () {
      test('should delegate to FlutterSecureStorage.delete', () async {
        when(() => mockStorage.delete(key: 'key')).thenAnswer((_) async {});

        await service.delete('key');

        verify(() => mockStorage.delete(key: 'key')).called(1);
      });
    });

    group('clear', () {
      test('should delegate to FlutterSecureStorage.deleteAll', () async {
        when(() => mockStorage.deleteAll()).thenAnswer((_) async {});

        await service.clear();

        verify(() => mockStorage.deleteAll()).called(1);
      });
    });
  });
}
