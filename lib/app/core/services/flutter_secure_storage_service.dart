import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:hubla_weather/app/core/services/secure_storage_service.dart';

/// [FlutterSecureStorage]-backed implementation of [SecureStorageService].
///
/// Uses Keychain on iOS and EncryptedSharedPreferences on Android
/// to store sensitive data such as authentication sessions.
class FlutterSecureStorageService implements SecureStorageService {
  FlutterSecureStorageService({FlutterSecureStorage? storage}) : _storage = storage ?? const FlutterSecureStorage();

  final FlutterSecureStorage _storage;

  @override
  Future<String?> read(String key) => _storage.read(key: key);

  @override
  Future<void> write({required String key, required String value}) => _storage.write(key: key, value: value);

  @override
  Future<void> delete(String key) => _storage.delete(key: key);

  @override
  Future<void> clear() => _storage.deleteAll();
}
