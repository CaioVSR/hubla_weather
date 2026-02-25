import 'package:hubla_weather/app/domain/weather/entities/city.dart';

/// The 10 pre-configured Brazilian cities used by the app.
///
/// This is the single source of truth for which cities appear on the
/// City List screen. Each [City] includes coordinates for the
/// OpenWeatherMap API and a [City.slug] for routing / caching.
const List<City> predefinedCities = [
  City(name: 'São Paulo', slug: 'sao-paulo', latitude: -23.5505, longitude: -46.6333),
  City(name: 'Rio de Janeiro', slug: 'rio-de-janeiro', latitude: -22.9068, longitude: -43.1729),
  City(name: 'Brasília', slug: 'brasilia', latitude: -15.7975, longitude: -47.8919),
  City(name: 'Salvador', slug: 'salvador', latitude: -12.9714, longitude: -38.5124),
  City(name: 'Fortaleza', slug: 'fortaleza', latitude: -3.7172, longitude: -38.5433),
  City(name: 'Belo Horizonte', slug: 'belo-horizonte', latitude: -19.9191, longitude: -43.9386),
  City(name: 'Manaus', slug: 'manaus', latitude: -3.1190, longitude: -60.0217),
  City(name: 'Curitiba', slug: 'curitiba', latitude: -25.4284, longitude: -49.2733),
  City(name: 'Recife', slug: 'recife', latitude: -8.0476, longitude: -34.8770),
  City(name: 'Porto Alegre', slug: 'porto-alegre', latitude: -30.0346, longitude: -51.2177),
];
