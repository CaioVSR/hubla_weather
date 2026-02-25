import 'package:go_router/go_router.dart';
import 'package:hubla_weather/app/presentation/routing/hubla_route.dart';
import 'package:hubla_weather/app/presentation/routing/routes/sign_in_route.dart';

GoRouter createRouter() => GoRouter(
  initialLocation: HublaRoute.login.path,
  routes: [
    SignInRoute().toRoute,
  ],
);
