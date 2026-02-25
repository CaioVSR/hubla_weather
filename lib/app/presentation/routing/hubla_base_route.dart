import 'package:go_router/go_router.dart';
import 'package:hubla_weather/app/presentation/routing/hubla_route_transition.dart';

abstract class HublaBaseRoute extends HublaGoRoute {
  @override
  GoRoute get toRoute => GoRoute(
    path: path,
    name: name,
    redirect: redirect,
    pageBuilder: (context, state) => switch (transition) {
      RouteTransition.rightToLeft => HublaRouteTransition.buildPageRightToLeftTransition(
        state: state,
        child: builder(context, state),
      ),
      RouteTransition.bottomToTop => HublaRouteTransition.buildPageBottomToTopTransition(
        context: context,
        state: state,
        child: builder(context, state),
      ),
    },
    routes: routes,
  );
}

abstract class HublaGoRoute {
  String get name;
  String get path;
  GoRouterWidgetBuilder get builder;
  GoRouterRedirect? get redirect => null;
  GoRoute get toRoute;
  List<GoRoute> get routes => [];
  RouteTransition get transition => RouteTransition.rightToLeft;
}
