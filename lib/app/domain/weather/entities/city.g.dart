// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'city.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

City _$CityFromJson(Map json) => City(
  name: json['name'] as String,
  slug: json['slug'] as String,
  latitude: (json['latitude'] as num).toDouble(),
  longitude: (json['longitude'] as num).toDouble(),
);

Map<String, dynamic> _$CityToJson(City instance) => <String, dynamic>{
  'name': instance.name,
  'slug': instance.slug,
  'latitude': instance.latitude,
  'longitude': instance.longitude,
};
