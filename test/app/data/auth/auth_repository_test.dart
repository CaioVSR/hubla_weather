import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/data/auth/auth_repository.dart';
import 'package:hubla_weather/app/domain/auth/entities/user.dart';
import 'package:hubla_weather/app/domain/auth/errors/auth_error.dart';
import 'package:mocktail/mocktail.dart';

import '../../../factories/entities/user_factory.dart';
import '../../../factories/repositories_factories.dart';
import '../../../mocks/datasources_mocks.dart';

void main() {
  late MockAuthLocalDatasource mockLocalDatasource;
  late AuthRepository repository;

  setUpAll(() {
    registerFallbackValue(UserFactory.create());
  });

  setUp(() {
    mockLocalDatasource = MockAuthLocalDatasource();
    repository = RepositoriesFactories.createAuthRepository(
      authLocalDatasource: mockLocalDatasource,
    );
  });

  group('AuthRepository', () {
    group('signIn', () {
      test('should return Success with User when credentials are valid', () async {
        when(() => mockLocalDatasource.saveSession(any())).thenAnswer((_) async {});

        final result = await repository.signIn(email: 'weather@hub.la', password: 'weatherhubla');

        expect(result.isSuccess, isTrue);
        final user = result.getSuccess();
        expect(user, isA<User>());
        expect(user?.email, 'weather@hub.la');
        expect(user?.name, 'Weather User');
        verify(() => mockLocalDatasource.saveSession(any())).called(1);
      });

      test('should return Error with InvalidCredentialsError when email is wrong', () async {
        final result = await repository.signIn(email: 'wrong@email.com', password: 'weatherhubla');

        expect(result.isError, isTrue);
        expect(result.getError(), isA<InvalidCredentialsError>());
        verifyNever(() => mockLocalDatasource.saveSession(any()));
      });

      test('should return Error with InvalidCredentialsError when password is wrong', () async {
        final result = await repository.signIn(email: 'weather@hub.la', password: 'wrongpassword');

        expect(result.isError, isTrue);
        expect(result.getError(), isA<InvalidCredentialsError>());
        verifyNever(() => mockLocalDatasource.saveSession(any()));
      });

      test('should return Error with InvalidCredentialsError when both are wrong', () async {
        final result = await repository.signIn(email: 'wrong@email.com', password: 'wrongpassword');

        expect(result.isError, isTrue);
        expect(result.getError(), isA<InvalidCredentialsError>());
      });

      test('should return Error with correct error message', () async {
        final result = await repository.signIn(email: 'wrong@email.com', password: 'wrong');

        final error = result.getError();
        expect(error?.errorMessage, 'Invalid email or password');
      });
    });

    group('getSession', () {
      test('should delegate to AuthLocalDatasource.getSession', () async {
        final user = UserFactory.create();
        when(() => mockLocalDatasource.getSession()).thenAnswer((_) async => user);

        final result = await repository.getSession();

        expect(result, user);
        verify(() => mockLocalDatasource.getSession()).called(1);
      });

      test('should return null when no session exists', () async {
        when(() => mockLocalDatasource.getSession()).thenAnswer((_) async => null);

        final result = await repository.getSession();

        expect(result, isNull);
      });
    });

    group('signOut', () {
      test('should delegate to AuthLocalDatasource.clearSession', () async {
        when(() => mockLocalDatasource.clearSession()).thenAnswer((_) async {});

        await repository.signOut();

        verify(() => mockLocalDatasource.clearSession()).called(1);
      });
    });
  });
}
