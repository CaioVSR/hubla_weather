// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Hubla Weather';

  @override
  String get signIn => 'Sign In';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get signInSubtitle => 'Sign in to check the weather';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get invalidEmailOrPassword => 'Invalid email or password';

  @override
  String get invalidEmailFormat => 'Please enter a valid email';

  @override
  String get passwordRequired => 'Password is required';

  @override
  String get searchCities => 'Search cities';

  @override
  String get noResults => 'No results';

  @override
  String get offlineBanner => 'You are offline';

  @override
  String get noDataAvailable => 'No data available. Connect to the internet to load weather data.';

  @override
  String get retry => 'Retry';

  @override
  String get forecast => 'Forecast';

  @override
  String get humidity => 'Humidity';

  @override
  String get windSpeed => 'Wind speed';

  @override
  String get maxTemp => 'Max';

  @override
  String get minTemp => 'Min';

  @override
  String temperatureCelsius(String value) {
    return '$value°C';
  }

  @override
  String humidityPercent(String value) {
    return '$value%';
  }

  @override
  String windSpeedMs(String value) {
    return '$value m/s';
  }

  @override
  String get somethingWentWrong => 'Something went wrong. Please try again.';

  @override
  String get ok => 'OK';

  @override
  String get cancel => 'Cancel';

  @override
  String get confirm => 'Confirm';

  @override
  String get error => 'Error';

  @override
  String get warning => 'Warning';

  @override
  String get success => 'Success';

  @override
  String get info => 'Info';
}
