import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

enum RouteTransition { rightToLeft, bottomToTop }

abstract class HublaRouteTransition {
  static MaterialPage<T> buildPageRightToLeftTransition<T>({
    required GoRouterState state,
    required Widget child,
  }) => MaterialPage<T>(
    child: child,
    name: state.name,
    arguments: state.extra ?? state.pathParameters,
  );

  static CustomTransitionPage<T> buildPageBottomToTopTransition<T>({
    required BuildContext context,
    required GoRouterState state,
    required Widget child,
  }) => CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    name: state.name,
    arguments: state.extra ?? state.pathParameters,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final offsetAnimation = animation.drive(
        Tween(begin: const Offset(0, 1), end: Offset.zero),
      );
      return SlideTransition(position: offsetAnimation, child: child);
    },
  );
}
