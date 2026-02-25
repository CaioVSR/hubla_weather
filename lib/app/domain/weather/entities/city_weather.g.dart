// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city_weather.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CityWeather _$CityWeatherFromJson(Map json) => CityWeather(
  citySlug: json['citySlug'] as String,
  temperature: (json['temperature'] as num).toDouble(),
  temperatureMin: (json['temperatureMin'] as num).toDouble(),
  temperatureMax: (json['temperatureMax'] as num).toDouble(),
  humidity: (json['humidity'] as num).toInt(),
  windSpeed: (json['windSpeed'] as num).toDouble(),
  weather: WeatherInfo.fromJson(
    Map<String, dynamic>.from(json['weather'] as Map),
  ),
  dateTime: DateTime.parse(json['dateTime'] as String),
);

Map<String, dynamic> _$CityWeatherToJson(CityWeather instance) =>
    <String, dynamic>{
      'citySlug': instance.citySlug,
      'temperature': instance.temperature,
      'temperatureMin': instance.temperatureMin,
      'temperatureMax': instance.temperatureMax,
      'humidity': instance.humidity,
      'windSpeed': instance.windSpeed,
      'weather': instance.weather.toJson(),
      'dateTime': instance.dateTime.toIso8601String(),
    };
