import 'package:hubla_weather/app/domain/weather/entities/city.dart';

abstract class CityFactory {
  static City create({
    String? name,
    String? slug,
    double? latitude,
    double? longitude,
  }) => City(
    name: name ?? 'São Paulo',
    slug: slug ?? 'sao-paulo',
    latitude: latitude ?? -23.5505,
    longitude: longitude ?? -46.6333,
  );
}
