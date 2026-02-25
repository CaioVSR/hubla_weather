import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hubla_weather/app/core/di/service_locator.dart';
import 'package:hubla_weather/main.dart';

import 'helpers/google_fonts_mocks.dart';

void main() {
  setUp(() {
    setUpGoogleFontsMocks();
    setupServiceLocator();
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
