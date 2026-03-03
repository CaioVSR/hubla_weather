import 'package:dio/dio.dart';
import 'package:hubla_weather/app/core/http/hubla_http_client.dart';
import 'package:hubla_weather/app/core/http/hubla_http_request.dart';
import 'package:mocktail/mocktail.dart';

class MockHttpClient extends Mock implements HublaHttpClient {}

class FakeHttpRequest extends Fake implements HublaHttpRequest {}

class MockRequestInterceptorHandler extends Mock implements RequestInterceptorHandler {}

class MockResponseInterceptorHandler extends Mock implements ResponseInterceptorHandler {}

class MockErrorInterceptorHandler extends Mock implements ErrorInterceptorHandler {}

class MockDio extends Mock implements Dio {}
