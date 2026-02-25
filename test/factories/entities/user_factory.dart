import 'package:hubla_weather/app/domain/auth/entities/user.dart';

abstract class UserFactory {
  static User create({
    String? email,
    String? name,
  }) => User(
    email: email ?? 'weather@hub.la',
    name: name ?? 'Weather User',
  );
}
