import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// 🎨 Light color scheme (fresh, airy)
ColorScheme _lightScheme = const ColorScheme(
  brightness: Brightness.light,
  primary: Color(0xFF2196F3), // sky blue
  onPrimary: Colors.white,
  secondary: Color(0xFFFF9800), // amber (accent)
  onSecondary: Colors.white,
  error: Color(0xFFD32F2F),
  onError: Colors.white,
  surface: Color(0xFFFDFDFD),
  onSurface: Color(0xFF1F2937),
  background: Color(0xFFFFFFFF),
  onBackground: Color(0xFF111827),
  primaryContainer: Color(0xFFE3F2FD), // lighter blue
  onPrimaryContainer: Color(0xFF0D47A1),
  secondaryContainer: Color(0xFFFFE0B2), // light amber
  onSecondaryContainer: Color(0xFF6D4C41),
  surfaceVariant: Color(0xFFF2F4F7),
  onSurfaceVariant: Color(0xFF374151),
  outline: Color(0xFFCBD5E1),
  outlineVariant: Color(0xFFE2E8F0),
  tertiary: Color(0xFF4CAF50), // green success
  onTertiary: Colors.white,
  scrim: Colors.black54,
);

/// 🌙 Dark color scheme (vibrant accents, readable background)
ColorScheme _darkScheme = const ColorScheme(
  brightness: Brightness.dark,
  primary: Color(0xFF64B5F6), // lighter blue
  onPrimary: Color(0xFF0D1117),
  secondary: Color(0xFFFFB74D), // amber accent
  onSecondary: Color(0xFF0D1117),
  error: Color(0xFFFFB4AB),
  onError: Color(0xFF690005),
  surface: Color(0xFF0D1117), // dark navy background
  onSurface: Color(0xFFE2E8F0),
  background: Color(0xFF0B0F14),
  onBackground: Color(0xFFE2E8F0),
  primaryContainer: Color(0xFF1565C0),
  onPrimaryContainer: Color(0xFFE3F2FD),
  secondaryContainer: Color(0xFF6D4C41),
  onSecondaryContainer: Color(0xFFFFE0B2),
  surfaceVariant: Color(0xFF1E293B),
  onSurfaceVariant: Color(0xFFCBD5E1),
  outline: Color(0xFF475569),
  outlineVariant: Color(0xFF1F2937),
  tertiary: Color(0xFF81C784), // soft green
  onTertiary: Color(0xFF0D1117),
  scrim: Colors.black54,
);

class FontSizes {
  static const display = 34.0;
  static const headline = 28.0;
  static const title = 20.0;
  static const label = 13.0;
  static const body = 15.0;
  static const small = 12.0;
}

ThemeData _baseTheme(ColorScheme scheme) {
  final textTheme = TextTheme(
    displayMedium: GoogleFonts.inter(
      fontSize: FontSizes.display,
      fontWeight: FontWeight.w800,
      letterSpacing: -0.3,
      height: 1.1,
    ),
    headlineMedium: GoogleFonts.inter(
      fontSize: FontSizes.headline,
      fontWeight: FontWeight.w700,
      letterSpacing: -0.2,
    ),
    titleMedium: GoogleFonts.inter(
      fontSize: FontSizes.title,
      fontWeight: FontWeight.w700,
    ),
    labelLarge: GoogleFonts.inter(
      fontSize: FontSizes.label,
      fontWeight: FontWeight.w600,
    ),
    bodyLarge: GoogleFonts.inter(
      fontSize: FontSizes.body,
      fontWeight: FontWeight.w500,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: FontSizes.small,
      fontWeight: FontWeight.w500,
    ),
  );

  return ThemeData(
    colorScheme: scheme,
    textTheme: textTheme,
    useMaterial3: true,
    scaffoldBackgroundColor: scheme.background,
    appBarTheme: AppBarTheme(
      elevation: 0,
      backgroundColor: scheme.primary,
      foregroundColor: scheme.onPrimary,
      titleTextStyle: textTheme.titleMedium?.copyWith(color: scheme.onPrimary),
      centerTitle: true,
    ),
    chipTheme: ChipThemeData(
      labelStyle: textTheme.labelLarge?.copyWith(color: scheme.onSurface),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(999)),
      side: BorderSide(color: scheme.outline),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
    ),
    sliderTheme: SliderThemeData(
      activeTrackColor: scheme.primary,
      inactiveTrackColor: scheme.outlineVariant,
      thumbColor: scheme.primary,
      trackHeight: 4,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 10),
    ),
    cardTheme: CardTheme(
      elevation: 0,
      color: scheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      margin: EdgeInsets.zero,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: scheme.surfaceVariant,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.outline),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.outlineVariant),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: scheme.primary, width: 1.5),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        elevation: 0,
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    ),
    dividerTheme: DividerThemeData(
      color: scheme.outline.withOpacity(.28),
      thickness: 1,
      space: 24,
    ),
  );
}

final lightTheme = _baseTheme(_lightScheme);
final darkTheme = _baseTheme(_darkScheme);
