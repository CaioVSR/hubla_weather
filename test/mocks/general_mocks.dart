import 'package:dio/dio.dart';
import 'package:hubla_weather/app/core/http/app_dio.dart';
import 'package:hubla_weather/app/core/http/http_request.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements HttpClient {}

class FakeHttpRequest extends Fake implements HttpRequest {}

class MockRequestInterceptorHandler extends Mock implements RequestInterceptorHandler {}

class MockResponseInterceptorHandler extends Mock implements ResponseInterceptorHandler {}

class MockErrorInterceptorHandler extends Mock implements ErrorInterceptorHandler {}

class MockDio extends Mock implements Dio {}
