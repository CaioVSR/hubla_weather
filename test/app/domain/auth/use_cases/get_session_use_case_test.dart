import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/domain/auth/use_cases/get_session_use_case.dart';
import 'package:mocktail/mocktail.dart';

import '../../../../factories/entities/user_factory.dart';
import '../../../../mocks/repositories_mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late GetSessionUseCase useCase;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    useCase = GetSessionUseCase(authRepository: mockAuthRepository);
  });

  group('GetSessionUseCase', () {
    test('should return User when a session exists', () async {
      final user = UserFactory.create();
      when(() => mockAuthRepository.getSession()).thenAnswer((_) async => user);

      final result = await useCase();

      expect(result, user);
      verify(() => mockAuthRepository.getSession()).called(1);
    });

    test('should return null when no session exists', () async {
      when(() => mockAuthRepository.getSession()).thenAnswer((_) async => null);

      final result = await useCase();

      expect(result, isNull);
      verify(() => mockAuthRepository.getSession()).called(1);
    });
  });
}
