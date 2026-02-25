import 'dart:async';

import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_fonts/src/google_fonts_base.dart' as google_fonts_base;
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';

class _MockHttpClient extends Mock implements http.Client {}

class _MockAssetManifest extends Mock implements AssetManifest {
  @override
  List<String> listAssets() => <String>[];
}

bool _fallbackRegistered = false;

/// Sets up a mock HTTP client for google_fonts to prevent network requests
/// in tests. Call this in `setUp` and `tearDownGoogleFontsMocks` in `tearDown`.
///
/// The mock HTTP client returns a future that never completes, so
/// google_fonts never throws and no dangling async errors leak into tests.
/// `GoogleFonts.rubik()` still returns a valid `TextStyle` synchronously
/// with the correct family name, fontSize, height, and fontWeight.
void setUpGoogleFontsMocks() {
  final mockHttpClient = _MockHttpClient();
  google_fonts_base.httpClient = mockHttpClient;
  google_fonts_base.assetManifest = _MockAssetManifest();
  GoogleFonts.config.allowRuntimeFetching = true;

  if (!_fallbackRegistered) {
    registerFallbackValue(Uri());
    _fallbackRegistered = true;
  }

  when(() => mockHttpClient.get(any(), headers: any(named: 'headers'))).thenAnswer(
    (_) => Completer<http.Response>().future,
  );
}

/// Clears google_fonts font cache and restores defaults. Call in `tearDown`.
void tearDownGoogleFontsMocks() {
  google_fonts_base.clearCache();
}
