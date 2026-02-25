import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:hubla_weather/app/presentation/pages/auth/sign_in/cubit/sign_in_cubit.dart';
import 'package:hubla_weather/app/presentation/routing/hubla_app_router.dart';

final GetIt serviceLocator = GetIt.instance;

void setupServiceLocator() {
  // Cubits
  serviceLocator.registerFactory<SignInCubit>(SignInCubit.new);

  // Router
  serviceLocator.registerLazySingleton<GoRouter>(createRouter);
}
