---
applyTo: "lib/app/domain/**"
---

<!-- Version: 1.1.0 -->

# Domain Layer (v1.1.0)

## Entities / Models

```dart
import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'my_entity.g.dart';

@JsonSerializable()
class MyEntity extends Equatable {
  const MyEntity({
    required this.id,
    required this.name,
    this.description,
  });

  factory MyEntity.fromJson(Map<String, dynamic> json) => _$MyEntityFromJson(json);
  Map<String, dynamic> toJson() => _$MyEntityToJson(this);

  final int id;
  final String name;
  final String? description;

  @override
  List<Object?> get props => [id, name, description];
}
```

**Rules:**
- Extend `Equatable` and override `props`
- Use `@JsonSerializable()` + `part 'file.g.dart'` (if `json_serializable` is a project dependency)
- Factory `fromJson` + method `toJson`
- Use `@JsonKey(name: 'api_field')` for field name mapping when needed
- Use `@JsonKey(unknownEnumValue: MyEnum.unknown)` for safe enum deserialization
- Use `sealed class` for sum types
- Manual `copyWith` methods (no freezed, unless the project already uses it)

> **Pragmatic decision:** This project places `@JsonSerializable()` directly on domain entities to reduce boilerplate. In strict Clean Architecture, serialization belongs in the data layer (DTOs/Models). For this project's scope, the pragmatic approach is preferred. For larger projects, consider separate DTO classes in `data/` that map to domain entities.

> **Adaptability:** If the project uses `freezed`, `built_value`, or another serialization approach, follow that instead.

## Use Cases

```dart
class GetSomethingUseCase {
  GetSomethingUseCase({required SomeRepository someRepository})
      : _someRepository = someRepository;

  final SomeRepository _someRepository;

  Future<Result<AppError, SomeEntity>> call({required String id}) async {
    final result = await _someRepository.getSomething(id: id);
    return result.when(
      Error.new,
      (data) => Success(data),
    );
  }
}
```

**Rules:**
- One class per file, one public `call()` method (callable class pattern)
- File naming: `verb_noun_use_case.dart` (e.g., `get_store_by_id_use_case.dart`)
- Class naming: `VerbNounUseCase` (e.g., `GetStoreByIdUseCase`)
- Constructor injection with `required` named params, stored as `_private final` fields
- Async methods return `Future<Result<ErrorType, SuccessType>>` (if a Result type exists)
- NO abstract base class for use cases

## Result Type

If the project has a `Result` type (or similar like `Either`, `Outcome`), use it consistently:

```dart
sealed class Result<E, S> {
  W when<W>(ErrorCallback<W, E> whenError, SuccessCallback<W, S> whenSuccess);
}
final class Success<E, S> extends Result<E, S> { ... }
final class Error<E, S> extends Result<E, S> { ... }
```

**Usage:** Always use pattern matching or `.when()` for branching — never throw exceptions for expected error flows.

## Errors

```dart
sealed class FeatureError extends AppError {
  FeatureError({required super.errorMessage});
}

class SpecificError extends FeatureError {
  SpecificError({required super.errorMessage});
}
```

**Hierarchy:** Base app error → Feature error (sealed) → concrete variants

## Enums

```dart
enum OrderType {
  @JsonValue('DELIVERY')
  delivery('Delivery', 'DELIVERY'),
  @JsonValue('CARRYOUT')
  carryout('Carryout', 'CARRYOUT');

  const OrderType(this.label, this.apiValue);
  final String label;
  final String apiValue;
}
```

- Always use enhanced enums with `const` constructors and fields
- Use `@JsonValue()` for JSON deserialization mapping when using `json_serializable`
