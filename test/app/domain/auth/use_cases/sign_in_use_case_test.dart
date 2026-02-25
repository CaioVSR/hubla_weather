import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/core/errors/result.dart';
import 'package:hubla_weather/app/domain/auth/errors/auth_error.dart';
import 'package:hubla_weather/app/domain/auth/use_cases/sign_in_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../factories/entities/user_factory.dart';
import '../../../../mocks/repositories_mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late SignInUseCase useCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = SignInUseCase(authRepository: mockAuthRepository);
  });

  group('SignInUseCase', () {
    test('should return Success with User when repository returns success', () async {
      final user = UserFactory.create();
      when(
        () => mockAuthRepository.signIn(email: 'weather@hub.la', password: 'weatherhubla'),
      ).thenAnswer((_) async => Success(user));

      final result = await useCase(email: 'weather@hub.la', password: 'weatherhubla');

      expect(result.isSuccess, isTrue);
      expect(result.getSuccess(), user);
      verify(() => mockAuthRepository.signIn(email: 'weather@hub.la', password: 'weatherhubla')).called(1);
    });

    test('should return Error with AuthError when repository returns error', () async {
      when(
        () => mockAuthRepository.signIn(email: 'wrong@email.com', password: 'wrong'),
      ).thenAnswer((_) async => const Error(InvalidCredentialsError()));

      final result = await useCase(email: 'wrong@email.com', password: 'wrong');

      expect(result.isError, isTrue);
      expect(result.getError(), isA<InvalidCredentialsError>());
      verify(() => mockAuthRepository.signIn(email: 'wrong@email.com', password: 'wrong')).called(1);
    });

    test('should forward email and password to repository', () async {
      final user = UserFactory.create();
      when(
        () => mockAuthRepository.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenAnswer((_) async => Success(user));

      await useCase(email: 'custom@test.com', password: 'custompass');

      verify(() => mockAuthRepository.signIn(email: 'custom@test.com', password: 'custompass')).called(1);
    });
  });
}
