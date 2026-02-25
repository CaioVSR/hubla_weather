import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:hubla_weather/app/core/di/service_locator.dart';
import 'package:hubla_weather/app/domain/auth/use_cases/sign_in_use_case.dart';
import 'package:hubla_weather/app/presentation/pages/auth/sign_in/cubit/sign_in_cubit.dart';
import 'package:hubla_weather/app/presentation/pages/auth/sign_in/sign_in_page.dart';
import 'package:hubla_weather/app/presentation/routing/hubla_base_route.dart';
import 'package:hubla_weather/app/presentation/routing/hubla_route.dart';

class SignInRoute extends HublaBaseRoute {
  @override
  String get name => HublaRoute.login.name;

  @override
  String get path => HublaRoute.login.path;

  @override
  GoRouterWidgetBuilder get builder =>
      (context, state) => BlocProvider(
        create: (_) => SignInCubit(signInUseCase: serviceLocator<SignInUseCase>()),
        child: const SignInPage(),
      );
}
