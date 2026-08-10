import 'package:flutter/material.dart';

/// Yanso design tokens and [ThemeData] factory.
///
/// The colour palette draws loosely from earth tones and the natural
/// environment of the Nso highlands — greens, warm browns, and sky tones.
/// These are working choices for Phase 1 and should be reviewed with
/// the community before a public release.
abstract final class AppTheme {
  AppTheme._();

  // ---------------------------------------------------------------------------
  // Colour tokens
  // ---------------------------------------------------------------------------

  /// Primary green — references the Nso highlands landscape.
  static const Color _primaryGreen = Color(0xFF2D6A4F);
  static const Color _primaryGreenLight = Color(0xFF52B788);

  /// Warm earth tone — reserved for accents and cultural context elements (Phase 2).
  // ignore: unused_field
  static const Color _earthBrown = Color(0xFF8B5E3C);

  static const Color _surfaceLight = Color(0xFFF8F4EF);
  static const Color _surfaceDark = Color(0xFF1A1A1A);

  // ---------------------------------------------------------------------------
  // Light theme
  // ---------------------------------------------------------------------------

  static ThemeData light() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryGreen,
      brightness: Brightness.light,
      surface: _surfaceLight,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _surfaceLight,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      textTheme: _buildTextTheme(Brightness.light),
      extensions: const [YansoColors.light],
    );
  }

  // ---------------------------------------------------------------------------
  // Dark theme
  // ---------------------------------------------------------------------------

  static ThemeData dark() {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: _primaryGreenLight,
      brightness: Brightness.dark,
      surface: _surfaceDark,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _surfaceDark,
      appBarTheme: AppBarTheme(
        backgroundColor: colorScheme.surface,
        foregroundColor: colorScheme.onSurface,
        elevation: 0,
        centerTitle: false,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(color: colorScheme.outlineVariant),
        ),
      ),
      textTheme: _buildTextTheme(Brightness.dark),
      extensions: const [YansoColors.dark],
    );
  }

  // ---------------------------------------------------------------------------
  // Typography
  // ---------------------------------------------------------------------------

  static TextTheme _buildTextTheme(Brightness brightness) {
    // System font is used for Phase 1.
    // A Lamnso-friendly font (supporting special characters like ŋ, ə, ò, etc.)
    // should be evaluated and added before Phase 2.
    return const TextTheme();
  }
}

/// Custom colour extensions that the calendar and culture UIs need beyond
/// Material's standard [ColorScheme].
class YansoColors extends ThemeExtension<YansoColors> {
  const YansoColors({
    required this.nsoWeekdayHighlight,
    required this.restDayIndicator,
    required this.unverifiedDataBadge,
  });

  /// Background colour used to highlight the current Nso weekday in the grid.
  final Color nsoWeekdayHighlight;

  /// Colour used to mark traditional rest days.
  final Color restDayIndicator;

  /// Colour used for the "unverified data" badge on cultural content.
  final Color unverifiedDataBadge;

  static const YansoColors light = YansoColors(
    nsoWeekdayHighlight: Color(0xFFD8F3DC),
    restDayIndicator: Color(0xFFFFF3CD),
    unverifiedDataBadge: Color(0xFFE8D5C4),
  );

  static const YansoColors dark = YansoColors(
    nsoWeekdayHighlight: Color(0xFF1B4332),
    restDayIndicator: Color(0xFF332D00),
    unverifiedDataBadge: Color(0xFF3D2B1F),
  );

  @override
  YansoColors copyWith({
    Color? nsoWeekdayHighlight,
    Color? restDayIndicator,
    Color? unverifiedDataBadge,
  }) {
    return YansoColors(
      nsoWeekdayHighlight: nsoWeekdayHighlight ?? this.nsoWeekdayHighlight,
      restDayIndicator: restDayIndicator ?? this.restDayIndicator,
      unverifiedDataBadge: unverifiedDataBadge ?? this.unverifiedDataBadge,
    );
  }

  @override
  YansoColors lerp(YansoColors? other, double t) {
    if (other == null) return this;
    return YansoColors(
      nsoWeekdayHighlight: Color.lerp(
        nsoWeekdayHighlight,
        other.nsoWeekdayHighlight,
        t,
      )!,
      restDayIndicator: Color.lerp(
        restDayIndicator,
        other.restDayIndicator,
        t,
      )!,
      unverifiedDataBadge: Color.lerp(
        unverifiedDataBadge,
        other.unverifiedDataBadge,
        t,
      )!,
    );
  }
}
