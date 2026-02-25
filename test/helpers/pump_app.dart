import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:hubla_weather/app/core/design_system/themes/hubla_themes.dart';
import 'package:hubla_weather/app/core/l10n/generated/app_localizations.dart';

/// Pumps [widget] wrapped with the minimal app shell needed for design system
/// widgets, localization, and BlocProviders.
///
/// If a [cubit] is provided alongside its runtime [Type], it will be registered
/// via `BlocProvider.value`.
///
/// Example:
/// ```dart
/// await pumpApp(tester, const SignInPage(), cubit: mockCubit);
/// ```
Future<void> pumpApp<C extends StateStreamableSource<Object?>>(
  WidgetTester tester,
  Widget widget, {
  C? cubit,
}) async {
  var child = widget;

  if (cubit != null) {
    child = BlocProvider<C>.value(value: cubit, child: child);
  }

  await tester.pumpWidget(
    MaterialApp(
      theme: HublaThemes.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    ),
  );

  // Wait for l10n delegates to resolve.
  await tester.pumpAndSettle();
}

/// Pumps [widget] inside a [GoRouter] configuration so that `context.go()`
/// and other go_router extensions work during widget tests.
///
/// [initialRoute] is the path the router starts on (default `/test`).
/// [routes] defines additional routes the router should know about.
Future<void> pumpAppWithRouter<C extends StateStreamableSource<Object?>>(
  WidgetTester tester,
  Widget widget, {
  C? cubit,
  String initialRoute = '/test',
  List<RouteBase> routes = const [],
}) async {
  var child = widget;

  if (cubit != null) {
    child = BlocProvider<C>.value(value: cubit, child: child);
  }

  final router = GoRouter(
    initialLocation: initialRoute,
    routes: [
      GoRoute(path: initialRoute, builder: (_, _) => child),
      ...routes,
    ],
  );

  await tester.pumpWidget(
    MaterialApp.router(
      theme: HublaThemes.lightTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    ),
  );

  // Wait for l10n delegates to resolve.
  await tester.pumpAndSettle();
}
