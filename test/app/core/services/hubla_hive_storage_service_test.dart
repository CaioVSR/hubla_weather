import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_ce/hive.dart';
import 'package:hubla_weather/app/core/services/hubla_hive_storage_service.dart';
import 'package:hubla_weather/app/core/services/hubla_storage_service.dart';

void main() {
  late HublaHiveStorageService service;
  late Directory tempDir;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('hubla_hive_test_');
    Hive.init(tempDir.path);
    service = HublaHiveStorageService();
  });

  tearDown(() async {
    await Hive.close();
    if (tempDir.existsSync()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('HublaHiveStorageService', () {
    group('write and read', () {
      test('should write and read a string value', () async {
        await service.write(key: 'name', value: 'Hubla');

        final result = await service.read<String>('name');

        expect(result, 'Hubla');
      });

      test('should write and read an int value', () async {
        await service.write(key: 'count', value: 42);

        final result = await service.read<int>('count');

        expect(result, 42);
      });

      test('should write and read a double value', () async {
        await service.write(key: 'temp', value: 25.5);

        final result = await service.read<double>('temp');

        expect(result, 25.5);
      });

      test('should write and read a bool value', () async {
        await service.write(key: 'active', value: true);

        final result = await service.read<bool>('active');

        expect(result, isTrue);
      });

      test('should write and read a Map value', () async {
        final data = {'city': 'São Paulo', 'temp': 25.0};
        await service.write(key: 'weather', value: data);

        final result = await service.read<Map<dynamic, dynamic>>('weather');

        expect(result, data);
      });

      test('should write and read a List value', () async {
        final data = [1, 2, 3];
        await service.write(key: 'numbers', value: data);

        final result = await service.read<List<dynamic>>('numbers');

        expect(result, data);
      });

      test('should overwrite existing value for the same key', () async {
        await service.write(key: 'name', value: 'old');
        await service.write(key: 'name', value: 'new');

        final result = await service.read<String>('name');

        expect(result, 'new');
      });
    });

    group('read', () {
      test('should return null for a nonexistent key', () async {
        final result = await service.read<String>('nonexistent');

        expect(result, isNull);
      });

      test('should return null when value type does not match requested type', () async {
        await service.write(key: 'number', value: 42);

        final result = await service.read<String>('number');

        expect(result, isNull);
      });
    });

    group('delete', () {
      test('should delete an existing key', () async {
        await service.write(key: 'name', value: 'Hubla');
        await service.delete('name');

        final result = await service.read<String>('name');

        expect(result, isNull);
      });

      test('should not throw when deleting a nonexistent key', () async {
        await expectLater(service.delete('nonexistent'), completes);
      });
    });

    group('clear', () {
      test('should remove all entries from the box', () async {
        await service.write(key: 'a', value: 1);
        await service.write(key: 'b', value: 2);
        await service.write(key: 'c', value: 3);

        await service.clear();

        expect(await service.read<int>('a'), isNull);
        expect(await service.read<int>('b'), isNull);
        expect(await service.read<int>('c'), isNull);
      });
    });

    group('custom box names', () {
      test('should isolate data between different boxes', () async {
        await service.write(key: 'key', value: 'box1_value', boxName: 'box1');
        await service.write(key: 'key', value: 'box2_value', boxName: 'box2');

        final box1Value = await service.read<String>('key', boxName: 'box1');
        final box2Value = await service.read<String>('key', boxName: 'box2');

        expect(box1Value, 'box1_value');
        expect(box2Value, 'box2_value');
      });

      test('should clear only the specified box', () async {
        await service.write(key: 'key', value: 'value1', boxName: 'box1');
        await service.write(key: 'key', value: 'value2', boxName: 'box2');

        await service.clear(boxName: 'box1');

        expect(await service.read<String>('key', boxName: 'box1'), isNull);
        expect(await service.read<String>('key', boxName: 'box2'), 'value2');
      });

      test('should use default box name when not specified', () async {
        await service.write(key: 'key', value: 'default_value');

        // ignore: avoid_redundant_argument_values
        final result = await service.read<String>('key', boxName: HublaStorageService.defaultBoxName);

        expect(result, 'default_value');
      });

      test('should delete only from the specified box', () async {
        await service.write(key: 'key', value: 'value1', boxName: 'box1');
        await service.write(key: 'key', value: 'value2', boxName: 'box2');

        await service.delete('key', boxName: 'box1');

        expect(await service.read<String>('key', boxName: 'box1'), isNull);
        expect(await service.read<String>('key', boxName: 'box2'), 'value2');
      });
    });

    group('box caching', () {
      test('should reuse the same box instance on subsequent operations', () async {
        // Write and read multiple times — box should be opened only once and cached.
        await service.write(key: 'a', value: 1);
        await service.write(key: 'b', value: 2);
        final a = await service.read<int>('a');
        final b = await service.read<int>('b');

        expect(a, 1);
        expect(b, 2);
      });
    });
  });
}
