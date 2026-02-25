import 'package:flutter/material.dart';
import 'package:hubla_weather/app/core/design_system/tokens/hubla_color_tokens.dart';

/// Dark color theme for the Hubla Weather design system.
///
/// Dark mode variant with muted, deeper tones of the joyful palette.
class HublaDarkColorTheme extends HublaColorTokens {
  const HublaDarkColorTheme()
    : super(
        // Primary — Sunshine (muted for dark)
        sunDark: const Color(0xFFFFE082),
        sun: const Color(0xFFFFCA28),
        sunLight: const Color(0xFF5C4A00),
        // Secondary — Sky (muted for dark)
        skyDark: const Color(0xFF90CAF9),
        sky: const Color(0xFF64B5F6),
        skyLight: const Color(0xFF0D47A1),
        // Tertiary — Core (muted for dark)
        coreDark: const Color(0xFFD1C4E9),
        core: const Color(0xFFB388FF),
        coreLight: const Color(0xFF311B92),
        // Accent — Coral (muted for dark)
        coralDark: const Color(0xFFFFAB91),
        coral: const Color(0xFFFF8A65),
        coralLight: const Color(0xFFBF360C),
        // Accent — Mint (muted for dark)
        mintDark: const Color(0xFF80CBC4),
        mint: const Color(0xFF4DB6AC),
        mintLight: const Color(0xFF004D40),
        // Accent — Lavender (muted for dark)
        lavenderDark: const Color(0xFFE1BEE7),
        lavender: const Color(0xFFCE93D8),
        lavenderLight: const Color(0xFF4A148C),
        // Neutrals (inverted for dark)
        gray90: const Color(0xFFE4E5E8),
        gray80: const Color(0xFFC8C9CC),
        gray70: const Color(0xFFACADB0),
        gray60: const Color(0xFF919294),
        gray50: const Color(0xFF77787B),
        gray40: const Color(0xFF5E5F62),
        gray30: const Color(0xFF46474A),
        gray20: const Color(0xFF303033),
        gray10: const Color(0xFF1A1C1E),
        white: const Color(0xFF121214),
        // Semantic — Success
        successDark: const Color(0xFFA5D6A7),
        success: const Color(0xFF81C784),
        successLight: const Color(0xFF1B5E20),
        // Semantic — Warning
        warningDark: const Color(0xFFFFCC80),
        warning: const Color(0xFFFFB74D),
        warningLight: const Color(0xFFE65100),
        // Semantic — Danger
        dangerDark: const Color(0xFFEF9A9A),
        danger: const Color(0xFFE57373),
        dangerLight: const Color(0xFFB71C1C),
        // Semantic — Info
        infoDark: const Color(0xFF90CAF9),
        info: const Color(0xFF64B5F6),
        infoLight: const Color(0xFF0D47A1),
        // Surface
        surface: const Color(0xFF1A1C1E),
        surfaceVariant: const Color(0xFF252729),
        onSurface: const Color(0xFFE4E5E8),
        onSurfaceVariant: const Color(0xFFACADB0),
        // Gradient
        backgroundGradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.5, 1.0],
          colors: [
            Color(0xFF2A2410), // dark sunshine
            Color(0xFF0D1B2A), // night sky
            Color(0xFF2A1520), // dark coral
          ],
        ),
      );
}
