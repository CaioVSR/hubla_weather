import 'package:flutter_test/flutter_test.dart';
import 'package:hubla_weather/app/core/http/http_request.dart';

/// Concrete implementation of HttpRequest for testing default values.
class _TestGetRequest extends HttpRequest {
  _TestGetRequest({this.testPath = '/test', this.testMethod = HttpMethod.get});

  final String testPath;
  final HttpMethod testMethod;

  @override
  String get path => testPath;

  @override
  HttpMethod get method => testMethod;
}

/// POST request with body for testing.
class _TestPostRequest extends HttpRequest {
  _TestPostRequest({required this.testBody});

  final Map<String, dynamic> testBody;

  @override
  String get path => '/test';

  @override
  HttpMethod get method => HttpMethod.post;

  @override
  Map<String, dynamic> get body => testBody;
}

/// Request with custom query params, headers, and cacheable flag.
class _TestCacheableRequest extends HttpRequest {
  @override
  String get path => '/data/2.5/weather';

  @override
  HttpMethod get method => HttpMethod.get;

  @override
  Map<String, dynamic> get queryParameters => {'lat': -23.5505, 'lon': -46.6333};

  @override
  Map<String, String> get headers => {'X-Custom': 'value'};

  @override
  bool get isCacheable => true;
}

void main() {
  group('HttpRequest', () {
    test('should have empty body by default', () {
      final request = _TestGetRequest();

      expect(request.body, isEmpty);
    });

    test('should have empty queryParameters by default', () {
      final request = _TestGetRequest();

      expect(request.queryParameters, isEmpty);
    });

    test('should have empty headers by default', () {
      final request = _TestGetRequest();

      expect(request.headers, isEmpty);
    });

    test('should not be cacheable by default', () {
      final request = _TestGetRequest();

      expect(request.isCacheable, isFalse);
    });

    test('should return correct path and method', () {
      // ignore: avoid_redundant_argument_values
      final request = _TestGetRequest(testPath: '/data/2.5/forecast', testMethod: HttpMethod.get);

      expect(request.path, '/data/2.5/forecast');
      expect(request.method, HttpMethod.get);
    });

    test('should return body for POST requests', () {
      final request = _TestPostRequest(testBody: {'name': 'test'});

      expect(request.body, {'name': 'test'});
      expect(request.method, HttpMethod.post);
    });

    test('should return custom queryParameters and headers', () {
      final request = _TestCacheableRequest();

      expect(request.queryParameters, {'lat': -23.5505, 'lon': -46.6333});
      expect(request.headers, {'X-Custom': 'value'});
      expect(request.isCacheable, isTrue);
    });
  });

  group('HttpMethod', () {
    test('should contain all expected methods', () {
      expect(HttpMethod.values, containsAll([HttpMethod.get, HttpMethod.post, HttpMethod.put, HttpMethod.patch, HttpMethod.delete]));
    });
  });
}
