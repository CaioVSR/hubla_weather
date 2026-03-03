import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/core/errors/app_error.dart';

void main() {
  group('NoConnectionError', () {
    test('should have default error message', () {
      const error = NoConnectionError();

      expect(error.errorMessage, 'No internet connection');
    });

    test('should have correct label', () {
      const error = NoConnectionError();

      expect(error.label, 'NoConnectionError');
    });

    test('should accept a custom error message', () {
      const error = NoConnectionError(errorMessage: 'Custom message');

      expect(error.errorMessage, 'Custom message');
    });

    test('should have null statusCode', () {
      const error = NoConnectionError();

      expect(error.statusCode, isNull);
    });

    test('should format toString correctly', () {
      const error = NoConnectionError();

      expect(error.toString(), 'NoConnectionError(errorMessage: No internet connection, statusCode: null)');
    });

    test('should capture stackTrace when provided', () {
      final stackTrace = StackTrace.current;
      final error = NoConnectionError(stackTrace: stackTrace);

      expect(error.stackTrace, stackTrace);
    });
  });

  group('HttpError', () {
    test('should store error message and status code', () {
      const error = HttpError(errorMessage: 'Not Found', statusCode: 404);

      expect(error.errorMessage, 'Not Found');
      expect(error.statusCode, 404);
    });

    test('should have correct label', () {
      const error = HttpError(errorMessage: 'Server Error', statusCode: 500);

      expect(error.label, 'HttpError');
    });

    test('should format toString with status code', () {
      const error = HttpError(errorMessage: 'Not Found', statusCode: 404);

      expect(error.toString(), 'HttpError(errorMessage: Not Found, statusCode: 404)');
    });

    test('should accept null statusCode', () {
      const error = HttpError(errorMessage: 'Server error', statusCode: null);

      expect(error.statusCode, isNull);
    });
  });

  group('TimeoutError', () {
    test('should have default error message', () {
      const error = TimeoutError();

      expect(error.errorMessage, 'Request timed out');
    });

    test('should have correct label', () {
      const error = TimeoutError();

      expect(error.label, 'TimeoutError');
    });

    test('should have null statusCode', () {
      const error = TimeoutError();

      expect(error.statusCode, isNull);
    });

    test('should format toString correctly', () {
      const error = TimeoutError();

      expect(error.toString(), 'TimeoutError(errorMessage: Request timed out, statusCode: null)');
    });
  });

  group('SerializationError', () {
    test('should store the provided message', () {
      const error = SerializationError('Failed to decode JSON');

      expect(error.errorMessage, 'Failed to decode JSON');
    });

    test('should have correct label', () {
      const error = SerializationError('parse error');

      expect(error.label, 'SerializationError');
    });

    test('should have null statusCode', () {
      const error = SerializationError('parse error');

      expect(error.statusCode, isNull);
    });

    test('should format toString correctly', () {
      const error = SerializationError('parse error');

      expect(error.toString(), 'SerializationError(errorMessage: parse error, statusCode: null)');
    });
  });

  group('UnknownError', () {
    test('should have default error message', () {
      const error = UnknownError();

      expect(error.errorMessage, 'An unexpected error occurred');
    });

    test('should have correct label', () {
      const error = UnknownError();

      expect(error.label, 'UnknownError');
    });

    test('should accept a custom error message', () {
      const error = UnknownError(errorMessage: 'Something broke');

      expect(error.errorMessage, 'Something broke');
    });

    test('should have null statusCode', () {
      const error = UnknownError();

      expect(error.statusCode, isNull);
    });

    test('should format toString correctly', () {
      const error = UnknownError();

      expect(error.toString(), 'UnknownError(errorMessage: An unexpected error occurred, statusCode: null)');
    });
  });

  group('AppError type hierarchy', () {
    test('all subtypes should be AppError instances', () {
      const errors = <AppError>[
        NoConnectionError(),
        HttpError(errorMessage: 'err', statusCode: 500),
        TimeoutError(),
        SerializationError('err'),
        UnknownError(),
      ];

      for (final error in errors) {
        expect(error, isA<AppError>());
      }
    });

    test('each subtype should have a distinct label', () {
      const errors = <AppError>[
        NoConnectionError(),
        HttpError(errorMessage: 'err', statusCode: 500),
        TimeoutError(),
        SerializationError('err'),
        UnknownError(),
      ];

      final labels = errors.map((e) => e.label).toSet();

      expect(labels.length, errors.length, reason: 'All labels should be unique');
    });
  });
}
