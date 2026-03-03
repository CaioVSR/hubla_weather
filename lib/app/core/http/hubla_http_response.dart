import 'package:equatable/equatable.dart';

/// Wrapper around HTTP response data with cache metadata.
///
/// Used as the success type in `Result<AppError, HublaHttpResponse>` returned
/// by `HublaHttpClient.request`. Consumers can check [isFromCache] to determine
/// whether the data came from the network or local cache.
class HublaHttpResponse extends Equatable {
  const HublaHttpResponse({
    required this.data,
    required this.isFromCache,
  });

  /// The decoded response body (typically a `Map<String, dynamic>` or `List`).
  final dynamic data;

  /// Whether this response was served from local cache rather than the network.
  final bool isFromCache;

  @override
  List<Object?> get props => [data, isFromCache];

  @override
  String toString() => 'HublaHttpResponse(isFromCache: $isFromCache, data: $data)';
}
