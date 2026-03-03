import 'package:hive_ce_flutter/hive_flutter.dart';
import 'package:hubla_weather/app/core/services/hubla_storage_service.dart';

/// Hive CE implementation of [HublaStorageService].
///
/// Stores JSON-serializable data (Map, List, String, num, bool) in Hive boxes.
/// No custom TypeAdapters are needed — raw JSON values are stored directly.
class HublaHiveStorageService implements HublaStorageService {
  final Map<String, Box<dynamic>> _openBoxes = {};

  @override
  Future<void> init() async {
    await Hive.initFlutter();
    await _openBox(HublaStorageService.defaultBoxName);
  }

  @override
  Future<T?> read<T>(String key, {String boxName = HublaStorageService.defaultBoxName}) async {
    final box = await _openBox(boxName);
    final value = box.get(key);
    if (value is T) {
      return value;
    }
    return null;
  }

  @override
  Future<void> write<T>({
    required String key,
    required T value,
    String boxName = HublaStorageService.defaultBoxName,
  }) async {
    final box = await _openBox(boxName);
    await box.put(key, value);
  }

  @override
  Future<void> delete(String key, {String boxName = HublaStorageService.defaultBoxName}) async {
    final box = await _openBox(boxName);
    await box.delete(key);
  }

  @override
  Future<void> clear({String boxName = HublaStorageService.defaultBoxName}) async {
    final box = await _openBox(boxName);
    await box.clear();
  }

  /// Opens a box if not already open, and caches the reference.
  Future<Box<dynamic>> _openBox(String name) async {
    if (_openBoxes.containsKey(name)) {
      return _openBoxes[name]!;
    }
    final box = await Hive.openBox<dynamic>(name);
    _openBoxes[name] = box;
    return box;
  }
}
