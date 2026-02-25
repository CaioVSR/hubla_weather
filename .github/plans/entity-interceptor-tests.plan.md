# Plan: Entity, Interceptor & Service Tests

## Goal
Create comprehensive tests for all domain entities, HTTP interceptors, and the HttpClient — plus supporting mocks and factories.

## Analysis
- **5 entities** need fromJson/toJson/equality tests: User, City, WeatherInfo, CityWeather, ForecastEntry
- **WeatherCondition enum** needs unknown fallback test via WeatherInfo deserialization
- **5 interceptors** (auth, connectivity, cache, logging, retry) need unit tests with mocked dependencies
- **HttpClient** needs DioException → AppError mapping tests
- **HttpRequest / HttpResponse** need basic property/equality tests
- Interceptor tests use Dio's handler pattern — mock handlers to verify next/resolve/reject calls
- CacheInterceptor tests need mocked StorageService and LoggerService
- RetryInterceptor tests need mocked Dio for retry behavior (complex async)
- All entity factories go in `test/factories/entities/`
- New mock files: `services_mocks.dart`, `general_mocks.dart`

## Steps

- [ ] Step 1: Create `test/mocks/services_mocks.dart` — MockConnectivityService, MockStorageService, MockLoggerService
- [ ] Step 2: Create `test/mocks/general_mocks.dart` — MockHttpClient, FakeHttpRequest
- [ ] Step 3: Create entity factories (User, City, WeatherInfo, CityWeather, ForecastEntry)
- [ ] Step 4: Create User entity test
- [ ] Step 5: Create City entity test
- [ ] Step 6: Create WeatherInfo entity test (+ unknown enum fallback)
- [ ] Step 7: Create CityWeather entity test
- [ ] Step 8: Create ForecastEntry entity test
- [ ] Step 9: Create AuthInterceptor test
- [ ] Step 10: Create ConnectivityInterceptor test
- [ ] Step 11: Create CacheInterceptor test
- [ ] Step 12: Create LoggingInterceptor test
- [ ] Step 13: Create RetryInterceptor test
- [ ] Step 14: Create HttpClient test
- [ ] Step 15: Create HttpRequest & HttpResponse tests
- [ ] Step 16: Run `flutter test` + `flutter analyze`

## Notes
- Interceptors use Dio's `RequestInterceptorHandler`, `ResponseInterceptorHandler`, `ErrorInterceptorHandler` — these need to be mocked with mocktail
- RetryInterceptor calls `_dio.fetch()` internally — needs careful mocking
- CacheInterceptor has multiple code paths: offline+cache hit, offline+cache miss, online+cacheable response, error+cache fallback
