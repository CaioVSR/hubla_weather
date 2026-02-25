import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hubla_weather/app/core/design_system/tokens/hubla_typography_tokens.dart';

/// Concrete typography values for the Hubla Weather design system.
///
/// Uses Rubik font via `google_fonts` for a friendly, rounded feel.
/// Non-const because `GoogleFonts.rubik()` returns runtime TextStyle.
class HublaTypographyTheme extends HublaTypographyTokens {
  HublaTypographyTheme()
    : super(
        // Display
        displayLarge: GoogleFonts.rubik(fontWeight: FontWeight.w700, fontSize: 57, height: 64 / 57),
        displayMedium: GoogleFonts.rubik(fontWeight: FontWeight.w700, fontSize: 45, height: 52 / 45),
        displaySmall: GoogleFonts.rubik(fontWeight: FontWeight.w700, fontSize: 36, height: 44 / 36),
        // Headline
        headlineLarge: GoogleFonts.rubik(fontWeight: FontWeight.w600, fontSize: 32, height: 40 / 32),
        headlineMedium: GoogleFonts.rubik(fontWeight: FontWeight.w600, fontSize: 28, height: 36 / 28),
        headlineSmall: GoogleFonts.rubik(fontWeight: FontWeight.w600, fontSize: 24, height: 32 / 24),
        // Title
        titleLarge: GoogleFonts.rubik(fontWeight: FontWeight.w600, fontSize: 22, height: 28 / 22),
        titleMedium: GoogleFonts.rubik(fontWeight: FontWeight.w500, fontSize: 16, height: 24 / 16),
        titleSmall: GoogleFonts.rubik(fontWeight: FontWeight.w500, fontSize: 14, height: 20 / 14),
        // Body
        bodyLarge: GoogleFonts.rubik(fontWeight: FontWeight.w400, fontSize: 16, height: 24 / 16),
        bodyMedium: GoogleFonts.rubik(fontWeight: FontWeight.w400, fontSize: 14, height: 20 / 14),
        bodySmall: GoogleFonts.rubik(fontWeight: FontWeight.w400, fontSize: 12, height: 16 / 12),
        // Label
        labelLarge: GoogleFonts.rubik(fontWeight: FontWeight.w500, fontSize: 14, height: 20 / 14),
        labelMedium: GoogleFonts.rubik(fontWeight: FontWeight.w500, fontSize: 12, height: 16 / 12),
        labelSmall: GoogleFonts.rubik(fontWeight: FontWeight.w500, fontSize: 11, height: 16 / 11),
      );
}
