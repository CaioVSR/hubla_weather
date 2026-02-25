import 'package:flutter/material.dart';
import 'package:hubla_weather/app/core/design_system/tokens/hubla_color_tokens.dart';

/// Light color theme for the Hubla Weather design system.
///
/// Joyful palette inspired by sunshine, clear skies, coral sunsets,
/// fresh mint, and soft lavender.
class HublaLightColorTheme extends HublaColorTokens {
  const HublaLightColorTheme()
    : super(
        // Primary — Sunshine
        sunDark: const Color(0xFFC78A00),
        sun: const Color(0xFFFFB800),
        sunLight: const Color(0xFFFFE082),
        // Secondary — Sky
        skyDark: const Color(0xFF1565C0),
        sky: const Color(0xFF42A5F5),
        skyLight: const Color(0xFFBBDEFB),
        // Tertiary — Core
        coreDark: const Color(0xFF4527A0),
        core: const Color(0xFF7C4DFF),
        coreLight: const Color(0xFFD1C4E9),
        // Accent — Coral
        coralDark: const Color(0xFFD84315),
        coral: const Color(0xFFFF7043),
        coralLight: const Color(0xFFFFCCBC),
        // Accent — Mint
        mintDark: const Color(0xFF00897B),
        mint: const Color(0xFF4DB6AC),
        mintLight: const Color(0xFFB2DFDB),
        // Accent — Lavender
        lavenderDark: const Color(0xFF7B1FA2),
        lavender: const Color(0xFFCE93D8),
        lavenderLight: const Color(0xFFF3E5F5),
        // Neutrals
        gray90: const Color(0xFF1A1C1E),
        gray80: const Color(0xFF303033),
        gray70: const Color(0xFF46474A),
        gray60: const Color(0xFF5E5F62),
        gray50: const Color(0xFF77787B),
        gray40: const Color(0xFF919294),
        gray30: const Color(0xFFACADB0),
        gray20: const Color(0xFFC8C9CC),
        gray10: const Color(0xFFE4E5E8),
        white: const Color(0xFFFFFFFF),
        // Semantic — Success
        successDark: const Color(0xFF2E7D32),
        success: const Color(0xFF66BB6A),
        successLight: const Color(0xFFC8E6C9),
        // Semantic — Warning
        warningDark: const Color(0xFFE65100),
        warning: const Color(0xFFFFA726),
        warningLight: const Color(0xFFFFE0B2),
        // Semantic — Danger
        dangerDark: const Color(0xFFC62828),
        danger: const Color(0xFFEF5350),
        dangerLight: const Color(0xFFFFCDD2),
        // Semantic — Info
        infoDark: const Color(0xFF1565C0),
        info: const Color(0xFF42A5F5),
        infoLight: const Color(0xFFBBDEFB),
        // Surface
        surface: const Color(0xFFFCFCFF),
        surfaceVariant: const Color(0xFFF0F1F5),
        onSurface: const Color(0xFF1A1C1E),
        onSurfaceVariant: const Color(0xFF46474A),
        // Gradient
        backgroundGradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.0, 0.5, 1.0],
          colors: [
            Color(0xFFFFF8E1), // warm sunshine
            Color(0xFFE3F2FD), // clear sky
            Color(0xFFFCE4EC), // coral blush
          ],
        ),
      );
}
