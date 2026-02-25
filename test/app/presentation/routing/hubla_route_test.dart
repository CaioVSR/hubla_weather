import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/presentation/routing/hubla_route.dart';

void main() {
  group('HublaRoute', () {
    group('enum values', () {
      test('should have exactly 3 routes', () {
        expect(HublaRoute.values.length, 3);
      });

      test('login should have correct path and screenName', () {
        expect(HublaRoute.login.path, '/login');
        expect(HublaRoute.login.screenName, 'Login');
      });

      test('cities should have correct path and screenName', () {
        expect(HublaRoute.cities.path, '/cities');
        expect(HublaRoute.cities.screenName, 'Cities');
      });

      test('forecast should have correct path and screenName', () {
        expect(HublaRoute.forecast.path, '/cities/:cityId/forecast');
        expect(HublaRoute.forecast.screenName, 'Forecast');
      });
    });

    group('fromRouteName', () {
      test('should return login when name is "login"', () {
        expect(HublaRoute.fromRouteName('login'), HublaRoute.login);
      });

      test('should return cities when name is "cities"', () {
        expect(HublaRoute.fromRouteName('cities'), HublaRoute.cities);
      });

      test('should return forecast when name is "forecast"', () {
        expect(HublaRoute.fromRouteName('forecast'), HublaRoute.forecast);
      });

      test('should be case-insensitive', () {
        expect(HublaRoute.fromRouteName('LOGIN'), HublaRoute.login);
        expect(HublaRoute.fromRouteName('Cities'), HublaRoute.cities);
        expect(HublaRoute.fromRouteName('FORECAST'), HublaRoute.forecast);
      });

      test('should throw StateError when name is not found', () {
        expect(
          () => HublaRoute.fromRouteName('unknown'),
          throwsA(isA<StateError>()),
        );
      });
    });
  });
}
