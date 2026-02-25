import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'generated/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// The app title
  ///
  /// In en, this message translates to:
  /// **'Hubla Weather'**
  String get appTitle;

  /// Sign in button label
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Welcome subtitle on the sign-in page
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// Subtitle on the sign-in page
  ///
  /// In en, this message translates to:
  /// **'Sign in to check the weather'**
  String get signInSubtitle;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Error shown when login credentials are wrong
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get invalidEmailOrPassword;

  /// Error shown when email format is invalid
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get invalidEmailFormat;

  /// Error shown when password is empty
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// Placeholder for the city search bar
  ///
  /// In en, this message translates to:
  /// **'Search cities'**
  String get searchCities;

  /// Empty state when search finds no cities
  ///
  /// In en, this message translates to:
  /// **'No results'**
  String get noResults;

  /// Banner shown when there is no internet connection
  ///
  /// In en, this message translates to:
  /// **'You are offline'**
  String get offlineBanner;

  /// Empty state when there is no cached data and no network
  ///
  /// In en, this message translates to:
  /// **'No data available. Connect to the internet to load weather data.'**
  String get noDataAvailable;

  /// Retry button label
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// Forecast screen title / label
  ///
  /// In en, this message translates to:
  /// **'Forecast'**
  String get forecast;

  /// Humidity label
  ///
  /// In en, this message translates to:
  /// **'Humidity'**
  String get humidity;

  /// Wind speed label
  ///
  /// In en, this message translates to:
  /// **'Wind speed'**
  String get windSpeed;

  /// Max temperature label
  ///
  /// In en, this message translates to:
  /// **'Max'**
  String get maxTemp;

  /// Min temperature label
  ///
  /// In en, this message translates to:
  /// **'Min'**
  String get minTemp;

  /// Temperature formatted in Celsius
  ///
  /// In en, this message translates to:
  /// **'{value}°C'**
  String temperatureCelsius(String value);

  /// Humidity formatted as percentage
  ///
  /// In en, this message translates to:
  /// **'{value}%'**
  String humidityPercent(String value);

  /// Wind speed formatted in meters per second
  ///
  /// In en, this message translates to:
  /// **'{value} m/s'**
  String windSpeedMs(String value);

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get somethingWentWrong;

  /// OK button label
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// Cancel button label
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Confirm button label
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// Error dialog title
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Warning dialog title
  ///
  /// In en, this message translates to:
  /// **'Warning'**
  String get warning;

  /// Success dialog title
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Info dialog title
  ///
  /// In en, this message translates to:
  /// **'Info'**
  String get info;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
