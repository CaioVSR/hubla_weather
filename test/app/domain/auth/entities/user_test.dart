import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/domain/auth/entities/user.dart';

import '../../../../factories/entities/user_factory.dart';

void main() {
  group('User', () {
    group('fromJson', () {
      test('should deserialize correctly from JSON', () {
        final json = {'email': 'test@hub.la', 'name': 'Test User'};

        final user = User.fromJson(json);

        expect(user.email, 'test@hub.la');
        expect(user.name, 'Test User');
      });
    });

    group('toJson', () {
      test('should serialize correctly to JSON', () {
        final user = UserFactory.create(email: 'test@hub.la', name: 'Test User');

        final json = user.toJson();

        expect(json, {'email': 'test@hub.la', 'name': 'Test User'});
      });
    });

    group('equality', () {
      test('should be equal when all fields match', () {
        final a = UserFactory.create(email: 'a@b.com', name: 'Name');
        final b = UserFactory.create(email: 'a@b.com', name: 'Name');

        expect(a, equals(b));
      });

      test('should not be equal when email differs', () {
        final a = UserFactory.create(email: 'a@b.com');
        final b = UserFactory.create(email: 'x@y.com');

        expect(a, isNot(equals(b)));
      });

      test('should not be equal when name differs', () {
        final a = UserFactory.create(name: 'Alice');
        final b = UserFactory.create(name: 'Bob');

        expect(a, isNot(equals(b)));
      });
    });

    group('fromJson → toJson roundtrip', () {
      test('should produce identical JSON after roundtrip', () {
        final original = UserFactory.create();
        final json = original.toJson();
        final restored = User.fromJson(json);

        expect(restored, equals(original));
      });
    });
  });
}
