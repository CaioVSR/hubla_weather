/// HTTP methods supported by the [HttpRequest] abstraction.
enum HttpMethod { get, post, put, patch, delete }

/// Base class for HTTP request definitions.
///
/// Subclasses define the [path], [method], and optionally [body],
/// [queryParameters], and [headers] for a specific API call.
///
/// Example:
/// ```dart
/// class GetWeatherRequest extends HttpRequest {
///   GetWeatherRequest({required this.lat, required this.lon});
///   final double lat;
///   final double lon;
///
///   @override String get path => '/data/2.5/weather';
///   @override HttpMethod get method => HttpMethod.get;
///   @override Map<String, dynamic> get queryParameters => {'lat': lat, 'lon': lon};
/// }
/// ```
abstract class HttpRequest {
  const HttpRequest();

  /// The URL path (relative to the base URL).
  String get path;

  /// The HTTP method for this request.
  HttpMethod get method;

  /// Request body (used for POST, PUT, PATCH).
  Map<String, dynamic> get body => const {};

  /// Query parameters appended to the URL.
  Map<String, dynamic> get queryParameters => const {};

  /// Additional headers for this specific request.
  Map<String, String> get headers => const {};

  /// Whether responses to this request should be cached locally.
  ///
  /// Defaults to `false`. Override to `true` in subclasses whose responses
  /// should be stored for offline-first access.
  bool get isCacheable => false;
}
