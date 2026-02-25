import 'package:flutter_test/flutter_test.dart';

import 'package:hubla_weather/main.dart';

import 'helpers/google_fonts_mocks.dart';

void main() {
  setUp(setUpGoogleFontsMocks);
  tearDown(tearDownGoogleFontsMocks);

  testWidgets('should render HublaWeatherApp', (tester) async {
    await tester.pumpWidget(const HublaWeatherApp());

    expect(find.text('Hubla Weather'), findsOneWidget);
  });
}
