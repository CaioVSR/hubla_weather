// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'weather_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

WeatherInfo _$WeatherInfoFromJson(Map json) => WeatherInfo(
  id: (json['id'] as num).toInt(),
  condition: $enumDecode(
    _$WeatherConditionEnumMap,
    json['main'],
    unknownValue: WeatherCondition.unknown,
  ),
  description: json['description'] as String,
  icon: json['icon'] as String,
);

Map<String, dynamic> _$WeatherInfoToJson(WeatherInfo instance) =>
    <String, dynamic>{
      'id': instance.id,
      'main': _$WeatherConditionEnumMap[instance.condition]!,
      'description': instance.description,
      'icon': instance.icon,
    };

const _$WeatherConditionEnumMap = {
  WeatherCondition.clear: 'Clear',
  WeatherCondition.clouds: 'Clouds',
  WeatherCondition.rain: 'Rain',
  WeatherCondition.drizzle: 'Drizzle',
  WeatherCondition.thunderstorm: 'Thunderstorm',
  WeatherCondition.snow: 'Snow',
  WeatherCondition.mist: 'Mist',
  WeatherCondition.smoke: 'Smoke',
  WeatherCondition.haze: 'Haze',
  WeatherCondition.dust: 'Dust',
  WeatherCondition.fog: 'Fog',
  WeatherCondition.sand: 'Sand',
  WeatherCondition.ash: 'Ash',
  WeatherCondition.squall: 'Squall',
  WeatherCondition.tornado: 'Tornado',
  WeatherCondition.unknown: 'unknown',
};
