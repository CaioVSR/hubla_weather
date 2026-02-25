import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hubla_weather/app/presentation/routing/hubla_base_route.dart';
import 'package:hubla_weather/app/presentation/routing/hubla_route.dart';

/// Placeholder route for the City List screen.
///
/// TODO: Replace with the real cities page when the weather feature is implemented.
class CitiesRoute extends HublaBaseRoute {
  @override
  String get name => HublaRoute.cities.name;

  @override
  String get path => HublaRoute.cities.path;

  @override
  GoRouterWidgetBuilder get builder =>
      (context, state) => const Scaffold(body: Center(child: Text('Cities')));
}
