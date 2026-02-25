// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'forecast_entry.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ForecastEntry _$ForecastEntryFromJson(Map json) => ForecastEntry(
  dateTime: DateTime.parse(json['dateTime'] as String),
  temperature: (json['temperature'] as num).toDouble(),
  humidity: (json['humidity'] as num).toInt(),
  windSpeed: (json['windSpeed'] as num).toDouble(),
  weather: WeatherInfo.fromJson(
    Map<String, dynamic>.from(json['weather'] as Map),
  ),
);

Map<String, dynamic> _$ForecastEntryToJson(ForecastEntry instance) =>
    <String, dynamic>{
      'dateTime': instance.dateTime.toIso8601String(),
      'temperature': instance.temperature,
      'humidity': instance.humidity,
      'windSpeed': instance.windSpeed,
      'weather': instance.weather.toJson(),
    };
