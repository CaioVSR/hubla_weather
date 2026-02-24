---
applyTo: "lib/app/data/**"
---

<!-- Version: 1.0.0 -->

# Data Layer (v1.0.0)

## Repositories

```dart
class FeatureRepository {
  FeatureRepository({
    required FeatureLocalDatasource featureLocalDatasource,
    required FeatureRemoteDatasource featureRemoteDatasource,
  }) : _featureLocalDatasource = featureLocalDatasource,
       _featureRemoteDatasource = featureRemoteDatasource;

  final FeatureLocalDatasource _featureLocalDatasource;
  final FeatureRemoteDatasource _featureRemoteDatasource;

  Future<Result<FeatureError, SomeEntity>> doSomething() async {
    final result = await _featureRemoteDatasource.doSomething();
    return result.when(
      (error) => Error(UnknownFeatureError(errorMessage: error.errorMessage)),
      Success.new,
    );
  }
}
```

**Rules:**
- Repositories are **concrete classes** (NOT abstract interfaces), unless the project already uses abstractions
- Compose local + remote datasources via constructor injection
- Map data/network errors to domain-specific errors
- File: `<feature>_repository.dart` in `lib/app/data/<feature>/`

## Remote Datasources

```dart
class FeatureRemoteDatasource {
  FeatureRemoteDatasource({required HttpClient client}) : _client = client;
  final HttpClient _client;

  Future<Result<AppError, SomeEntity>> getSomething({required String id}) async {
    final responseResult = await _client.request(GetSomethingRequest(id: id));
    return responseResult.when(Error.new, (response) {
      try {
        final data = response['data'] as Map<String, dynamic>;
        return Success(SomeEntity.fromJson(data));
      } catch (error, stackTrace) {
        return Error(SerializationError('Serialization Error: $error', stackTrace: stackTrace));
      }
    });
  }
}
```

## Local Datasources

```dart
class FeatureLocalDatasource {
  FeatureLocalDatasource({required StorageService storageService})
      : _storageService = storageService;
  final StorageService _storageService;

  SomeEntity? getSomeData() => _storageService.read('some_data_key');

  Future<void> saveSomeData(SomeEntity data) =>
      _storageService.write(key: 'some_data_key', value: data.toJson());

  Future<void> deleteSomeData() => _storageService.delete('some_data_key');
}
```

## HTTP Request Objects

```dart
// POST with body
class CreateSomethingRequest extends HttpRequest {
  CreateSomethingRequest({required this.name});
  final String name;

  @override String get path => '/api/v1/something';
  @override HttpMethod get method => HttpMethod.post;
  @override Map<String, dynamic> get body => {'name': name};
}

// GET with query parameters
class GetSomethingRequest extends HttpRequest {
  GetSomethingRequest({this.filter});
  final String? filter;

  @override String get path => '/api/v1/something';
  @override HttpMethod get method => HttpMethod.get;
  @override Map<String, dynamic> get queryParameters => {
    if (filter != null) 'filter': filter,
  };
}
```
