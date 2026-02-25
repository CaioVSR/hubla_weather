import 'dart:convert';

import 'package:hubla_weather/app/core/services/secure_storage_service.dart';
import 'package:hubla_weather/app/domain/auth/entities/user.dart';

/// Local datasource that persists and retrieves the authenticated
/// user session from secure storage.
class AuthLocalDatasource {
  AuthLocalDatasource({required SecureStorageService secureStorageService}) : _secureStorageService = secureStorageService;

  final SecureStorageService _secureStorageService;

  static const String _sessionKey = 'auth_session';

  /// Persists the authenticated [user] to secure storage.
  Future<void> saveSession(User user) async {
    final jsonString = jsonEncode(user.toJson());
    await _secureStorageService.write(key: _sessionKey, value: jsonString);
  }

  /// Reads the persisted user session, or `null` if none is stored.
  Future<User?> getSession() async {
    final jsonString = await _secureStorageService.read(_sessionKey);
    if (jsonString == null) {
      return null;
    }
    final json = jsonDecode(jsonString) as Map<String, dynamic>;
    return User.fromJson(json);
  }

  /// Clears the persisted session.
  Future<void> clearSession() => _secureStorageService.delete(_sessionKey);
}
