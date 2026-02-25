import 'package:flutter/material.dart';
import 'package:hubla_weather/app/core/design_system/themes/hubla_themes.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const HublaWeatherApp());
}

class HublaWeatherApp extends StatelessWidget {
  const HublaWeatherApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Hubla Weather',
    debugShowCheckedModeBanner: false,
    theme: HublaThemes.lightTheme,
    darkTheme: HublaThemes.darkTheme,
    home: const Scaffold(
      body: Center(
        child: Text('Hubla Weather'),
      ),
    ),
  );
}
