/// Agnostic local storage contract.
///
/// Provides key-value storage operations without coupling to any
/// specific database implementation. See `HublaHiveStorageService` for
/// the concrete Hive CE implementation.
abstract class HublaStorageService {
  /// The default box name used when no `boxName` is specified.
  static const String defaultBoxName = 'cache';

  /// Initializes the storage engine. Must be called once before any
  /// read/write operations (typically in `main()`).
  Future<void> init();

  /// Reads a value by [key] from the given [boxName].
  ///
  /// Returns `null` if the key does not exist.
  Future<T?> read<T>(String key, {String boxName = defaultBoxName});

  /// Writes a [value] for the given [key] in [boxName].
  ///
  /// Overwrites any existing value for that key.
  Future<void> write<T>({
    required String key,
    required T value,
    String boxName = defaultBoxName,
  });

  /// Deletes the entry for [key] in [boxName].
  Future<void> delete(String key, {String boxName = defaultBoxName});

  /// Removes all entries from [boxName].
  Future<void> clear({String boxName = defaultBoxName});
}
