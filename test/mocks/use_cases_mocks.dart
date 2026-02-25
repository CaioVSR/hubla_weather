import 'package:hubla_weather/app/domain/auth/use_cases/get_session_use_case.dart';
import 'package:hubla_weather/app/domain/auth/use_cases/sign_in_use_case.dart';
import 'package:mocktail/mocktail.dart';

class MockSignInUseCase extends Mock implements SignInUseCase {}

class MockGetSessionUseCase extends Mock implements GetSessionUseCase {}
