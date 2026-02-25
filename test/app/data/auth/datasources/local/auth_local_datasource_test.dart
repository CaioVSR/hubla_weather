import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/data/auth/datasources/local/auth_local_datasource.dart';
import 'package:hubla_weather/app/domain/auth/entities/user.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../../factories/datasources_factories.dart';
import '../../../../../factories/entities/user_factory.dart';
import '../../../../../mocks/services_mocks.dart';

void main() {
  late MockSecureStorageService mockSecureStorageService;
  late AuthLocalDatasource datasource;

  setUp(() {
    mockSecureStorageService = MockSecureStorageService();
    datasource = DatasourcesFactories.createAuthLocalDatasource(
      secureStorageService: mockSecureStorageService,
    );
  });

  group('AuthLocalDatasource', () {
    group('saveSession', () {
      test('should write user JSON to secure storage', () async {
        final user = UserFactory.create();
        final expectedJson = jsonEncode(user.toJson());

        when(() => mockSecureStorageService.write(key: 'auth_session', value: expectedJson)).thenAnswer((_) async {});

        await datasource.saveSession(user);

        verify(() => mockSecureStorageService.write(key: 'auth_session', value: expectedJson)).called(1);
      });
    });

    group('getSession', () {
      test('should return User when session exists in secure storage', () async {
        final user = UserFactory.create();
        final storedJson = jsonEncode(user.toJson());

        when(() => mockSecureStorageService.read('auth_session')).thenAnswer((_) async => storedJson);

        final result = await datasource.getSession();

        expect(result, isA<User>());
        expect(result?.email, user.email);
        expect(result?.name, user.name);
      });

      test('should return null when no session exists', () async {
        when(() => mockSecureStorageService.read('auth_session')).thenAnswer((_) async => null);

        final result = await datasource.getSession();

        expect(result, isNull);
      });
    });

    group('clearSession', () {
      test('should delete session key from secure storage', () async {
        when(() => mockSecureStorageService.delete('auth_session')).thenAnswer((_) async {});

        await datasource.clearSession();

        verify(() => mockSecureStorageService.delete('auth_session')).called(1);
      });
    });
  });
}
