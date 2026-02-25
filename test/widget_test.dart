import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hubla_weather/app/core/di/service_locator.dart';
import 'package:hubla_weather/app/core/services/secure_storage_service.dart';
import 'package:hubla_weather/main.dart';
import 'package:mocktail/mocktail.dart';

import 'helpers/google_fonts_mocks.dart';
import 'mocks/services_mocks.dart';

void main() {
  setUp(() {
    setUpGoogleFontsMocks();
    setupServiceLocator();

    // Override SecureStorageService with a mock so the auth redirect
    // works without platform channels.
    serviceLocator.allowReassignment = true;
    final mockSecureStorage = MockSecureStorageService();
    when(() => mockSecureStorage.read(any())).thenAnswer((_) async => null);
    serviceLocator.registerLazySingleton<SecureStorageService>(() => mockSecureStorage);
    serviceLocator.allowReassignment = false;
  });

  tearDown(() {
    tearDownGoogleFontsMocks();
    GetIt.I.reset();
  });

  testWidgets('should render HublaWeatherApp', (tester) async {
    await tester.pumpWidget(const HublaWeatherApp());
    await tester.pumpAndSettle();

    expect(find.text('Welcome back'), findsOneWidget);
  });
}
