import 'package:bloc_presentation_test/bloc_presentation_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:hubla_weather/app/presentation/pages/auth/sign_in/cubit/sign_in_cubit.dart';
import 'package:hubla_weather/app/presentation/pages/auth/sign_in/cubit/sign_in_presentation_event.dart';
import 'package:hubla_weather/app/presentation/pages/auth/sign_in/cubit/sign_in_state.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/cubit/cities_cubit.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/cubit/cities_presentation_event.dart';
import 'package:hubla_weather/app/presentation/pages/weather/cities/cubit/cities_state.dart';

class MockSignInCubit extends MockPresentationCubit<SignInState, SignInPresentationEvent> implements SignInCubit {}

class FakeSignInCubit extends MockCubit<SignInState> implements SignInCubit {}

class MockCitiesCubit extends MockPresentationCubit<CitiesState, CitiesPresentationEvent> implements CitiesCubit {}
