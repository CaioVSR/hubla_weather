import 'package:hubla_weather/app/data/auth/auth_repository.dart';
import 'package:hubla_weather/app/domain/auth/entities/user.dart';

class GetSessionUseCase {
  GetSessionUseCase({required AuthRepository authRepository}) : _authRepository = authRepository;

  final AuthRepository _authRepository;

  Future<User?> call() => _authRepository.getSession();
}
