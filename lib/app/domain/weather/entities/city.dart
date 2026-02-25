import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'city.g.dart';

/// A pre-configured Brazilian city with geographic coordinates.
///
/// Used as the basis for fetching weather data from the OpenWeatherMap API.
/// The [slug] serves as a stable, human-readable identifier for routing
/// and cache keys.
@JsonSerializable()
class City extends Equatable {
  const City({
    required this.name,
    required this.slug,
    required this.latitude,
    required this.longitude,
  });

  factory City.fromJson(Map<String, dynamic> json) => _$CityFromJson(json);
  Map<String, dynamic> toJson() => _$CityToJson(this);

  /// Display name of the city (e.g., "São Paulo").
  final String name;

  /// URL-friendly identifier derived from the city name
  /// (e.g., "sao-paulo"). Used as route param and cache key.
  final String slug;

  /// Geographic latitude.
  final double latitude;

  /// Geographic longitude.
  final double longitude;

  @override
  List<Object?> get props => [name, slug, latitude, longitude];
}
