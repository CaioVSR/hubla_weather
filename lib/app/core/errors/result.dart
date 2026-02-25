import 'package:meta/meta.dart';

/// A sealed Result type representing either a [Success] or an [Error].
///
/// - `E` is the error type (typically an `AppError` subclass).
/// - `S` is the success value type.
sealed class Result<E, S> {
  const Result();

  /// Pattern-matches over this result.
  T when<T>(
    T Function(E error) onError,
    T Function(S success) onSuccess,
  );

  /// Returns the success value, or `null` if this is an [Error].
  S? getSuccess() => null;

  /// Returns the error value, or `null` if this is a [Success].
  E? getError() => null;

  /// Whether this result is a [Success].
  bool get isSuccess => this is Success<E, S>;

  /// Whether this result is an [Error].
  bool get isError => this is Error<E, S>;
}

/// A successful result containing a [value].
@immutable
final class Success<E, S> extends Result<E, S> {
  const Success(this.value);

  /// The success value.
  final S value;

  @override
  T when<T>(
    T Function(E error) onError,
    T Function(S success) onSuccess,
  ) => onSuccess(value);

  @override
  S? getSuccess() => value;

  @override
  bool operator ==(Object other) => other is Success<E, S> && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'Success($value)';
}

/// An error result containing an [error].
@immutable
final class Error<E, S> extends Result<E, S> {
  const Error(this.error);

  /// The error value.
  final E error;

  @override
  T when<T>(
    T Function(E error) onError,
    T Function(S success) onSuccess,
  ) => onError(error);

  @override
  E? getError() => error;

  @override
  bool operator ==(Object other) => other is Error<E, S> && other.error == error;

  @override
  int get hashCode => error.hashCode;

  @override
  String toString() => 'Error($error)';
}
