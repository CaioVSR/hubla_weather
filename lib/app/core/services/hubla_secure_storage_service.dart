/// Agnostic secure storage contract for sensitive data (e.g., auth tokens).
///
/// Provides key-value storage operations backed by platform-secure
/// storage (Keychain on iOS, EncryptedSharedPreferences on Android).
/// See `HublaFlutterSecureStorageService` for the concrete implementation.
abstract class HublaSecureStorageService {
  /// Reads the value for the given [key].
  ///
  /// Returns `null` if the key does not exist.
  Future<String?> read(String key);

  /// Writes a [value] for the given [key].
  ///
  /// Overwrites any existing value for that key.
  Future<void> write({required String key, required String value});

  /// Deletes the entry for [key].
  Future<void> delete(String key);

  /// Removes all entries from secure storage.
  Future<void> clear();
}
