import 'package:equatable/equatable.dart';
import 'package:hubla_weather/app/domain/weather/enums/weather_condition.dart';
import 'package:json_annotation/json_annotation.dart';

part 'weather_info.g.dart';

/// Weather condition details from the OpenWeatherMap API.
///
/// Maps to the `weather[0]` object in the API response.
@JsonSerializable()
class WeatherInfo extends Equatable {
  const WeatherInfo({
    required this.id,
    required this.condition,
    required this.description,
    required this.icon,
  });

  factory WeatherInfo.fromJson(Map<String, dynamic> json) => _$WeatherInfoFromJson(json);
  Map<String, dynamic> toJson() => _$WeatherInfoToJson(this);

  /// OpenWeatherMap weather condition ID.
  final int id;

  /// Weather condition group (e.g., Clear, Clouds, Rain).
  @JsonKey(name: 'main', unknownEnumValue: WeatherCondition.unknown)
  final WeatherCondition condition;

  /// Weather condition description (e.g., "moderate rain").
  final String description;

  /// Icon code for the weather condition (e.g., "10d").
  final String icon;

  @override
  List<Object?> get props => [id, condition, description, icon];
}
