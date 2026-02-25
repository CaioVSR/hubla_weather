/// Base class for all application errors.
///
/// Subclasses represent specific failure modes (network, serialization, etc.).
/// Used as the error type in `Result<AppError, T>`.
sealed class AppError {
  const AppError({
    required this.errorMessage,
    this.statusCode,
    this.stackTrace,
  });

  /// A human-readable description of the error.
  final String errorMessage;

  /// HTTP status code, if applicable.
  final int? statusCode;

  /// Stack trace captured at the point of failure.
  final StackTrace? stackTrace;

  /// A label for the concrete error type (used in [toString]).
  String get label;

  @override
  String toString() => '$label(errorMessage: $errorMessage, statusCode: $statusCode)';
}

/// The device has no internet connection.
final class NoConnectionError extends AppError {
  const NoConnectionError({
    super.errorMessage = 'No internet connection',
    super.stackTrace,
  });

  @override
  String get label => 'NoConnectionError';
}

/// An HTTP error returned by the server.
final class HttpError extends AppError {
  const HttpError({
    required super.errorMessage,
    required super.statusCode,
    super.stackTrace,
  });

  @override
  String get label => 'HttpError';
}

/// A timeout occurred while connecting, sending, or receiving data.
final class TimeoutError extends AppError {
  const TimeoutError({
    super.errorMessage = 'Request timed out',
    super.stackTrace,
  });

  @override
  String get label => 'TimeoutError';
}

/// Failed to parse the server response.
final class SerializationError extends AppError {
  const SerializationError(
    String message, {
    super.stackTrace,
  }) : super(errorMessage: message);

  @override
  String get label => 'SerializationError';
}

/// A fallback error for unexpected failures.
final class UnknownError extends AppError {
  const UnknownError({
    super.errorMessage = 'An unexpected error occurred',
    super.stackTrace,
  });

  @override
  String get label => 'UnknownError';
}
