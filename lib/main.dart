import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hubla_weather/app/core/design_system/themes/hubla_themes.dart';
import 'package:hubla_weather/app/core/di/service_locator.dart';
import 'package:hubla_weather/app/core/l10n/generated/app_localizations.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  setupServiceLocator();
  runApp(const HublaWeatherApp());
}

class HublaWeatherApp extends StatelessWidget {
  const HublaWeatherApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp.router(
    title: 'Hubla Weather',
    debugShowCheckedModeBanner: false,
    theme: HublaThemes.lightTheme,
    darkTheme: HublaThemes.darkTheme,
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    routerConfig: serviceLocator<GoRouter>(),
  );
}
