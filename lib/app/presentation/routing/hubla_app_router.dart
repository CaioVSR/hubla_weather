import 'package:go_router/go_router.dart';
import 'package:hubla_weather/app/domain/auth/use_cases/get_session_use_case.dart';
import 'package:hubla_weather/app/presentation/routing/hubla_route.dart';
import 'package:hubla_weather/app/presentation/routing/routes/cities_route.dart';
import 'package:hubla_weather/app/presentation/routing/routes/sign_in_route.dart';

GoRouter createRouter({required GetSessionUseCase getSessionUseCase}) => GoRouter(
  initialLocation: HublaRoute.login.path,
  redirect: (context, state) async {
    final session = await getSessionUseCase();
    final isAuthenticated = session != null;
    final isOnLogin = state.matchedLocation == HublaRoute.login.path;

    if (!isAuthenticated && !isOnLogin) {
      return HublaRoute.login.path;
    }

    if (isAuthenticated && isOnLogin) {
      return HublaRoute.cities.path;
    }

    return null;
  },
  routes: [
    SignInRoute().toRoute,
    CitiesRoute().toRoute,
  ],
);
