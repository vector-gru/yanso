import 'package:flutter/material.dart';

/// Yanso design system — African Traditional Material theme.
///
/// Palette inspiration:
///   - Deep kola-nut brown  : the earth, wood, and bark of the Nso highlands
///   - Terracotta orange    : fired clay pots, traditional architecture
///   - Kente gold           : woven ceremonial cloth, celebration
///   - Indigo clay          : raffia indigo-dyed fabric, rest and reflection
///   - Cream/off-white      : dried grass, woven mats, natural fibres
///
/// These are working choices for Phase 1 and should be reviewed with
/// Nso community members and designers before a public release.
abstract final class AppTheme {
  AppTheme._();

  // ---------------------------------------------------------------------------
  // Raw colour tokens — do not use directly in widgets; use [YansoColors].
  // ---------------------------------------------------------------------------

  /// Deep kola-nut brown — primary background.
  static const Color _kolaBrown = Color(0xFF2C1A0E);
  static const Color _kolaBrownLight = Color(0xFF3D2512);

  /// Terracotta — primary interactive colour.
  static const Color _terracotta = Color(0xFFC4622D);
  static const Color _terracottaLight = Color(0xFFE07848);

  /// Kente gold — accent, today indicator, highlights.
  static const Color _kenteGold = Color(0xFFE8A020);
  static const Color _kenteGoldMuted = Color(0xFFA87010);

  /// Indigo clay — rest day tint.
  static const Color _indigoClay = Color(0xFF3A3060);
  static const Color _indigoClayLight = Color(0xFF524880);

  /// Cream — primary text on dark backgrounds.
  static const Color _cream = Color(0xFFF5ECD7);
  static const Color _creamMuted = Color(0xFFBFAE96);

  /// Surface cards — slightly lighter than the background.
  static const Color _surfaceDark = Color(0xFF3D2512);
  static const Color _surfaceLight = Color(0xFFF5ECD7);

  // ---------------------------------------------------------------------------
  // Theme factories
  // ---------------------------------------------------------------------------

  static ThemeData dark() {
    const colorScheme = ColorScheme(
      brightness: Brightness.dark,
      primary: _terracotta,
      onPrimary: _cream,
      primaryContainer: _kolaBrownLight,
      onPrimaryContainer: _cream,
      secondary: _kenteGold,
      onSecondary: _kolaBrown,
      secondaryContainer: _kenteGoldMuted,
      onSecondaryContainer: _cream,
      tertiary: _indigoClay,
      onTertiary: _cream,
      tertiaryContainer: _indigoClayLight,
      onTertiaryContainer: _cream,
      error: Color(0xFFCF6679),
      onError: _kolaBrown,
      errorContainer: Color(0xFF8B1A2E),
      onErrorContainer: _cream,
      surface: _kolaBrown,
      onSurface: _cream,
      surfaceContainerHighest: _surfaceDark,
      onSurfaceVariant: _creamMuted,
      outline: _creamMuted,
      outlineVariant: Color(0xFF5A3A20),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: _cream,
      onInverseSurface: _kolaBrown,
      inversePrimary: _terracotta,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _kolaBrown,
      appBarTheme: const AppBarTheme(
        backgroundColor: _kolaBrown,
        foregroundColor: _cream,
        elevation: 0,
        centerTitle: false,
        // ignore: prefer_const_constructors
        titleTextStyle: TextStyle(
          color: _cream,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: _surfaceDark,
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      dividerColor: const Color(0xFF5A3A20),
      extensions: const [YansoColors.dark],
    );
  }

  static ThemeData light() {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: _terracotta,
      onPrimary: Colors.white,
      primaryContainer: Color(0xFFFFDBCC),
      onPrimaryContainer: _kolaBrown,
      secondary: _kenteGoldMuted,
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFFFFE8B0),
      onSecondaryContainer: _kolaBrown,
      tertiary: _indigoClayLight,
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFFDDD8FF),
      onTertiaryContainer: _kolaBrown,
      error: Color(0xFFB00020),
      onError: Colors.white,
      errorContainer: Color(0xFFFFDAD6),
      onErrorContainer: _kolaBrown,
      surface: _surfaceLight,
      onSurface: _kolaBrown,
      surfaceContainerHighest: Color(0xFFEDE0CC),
      onSurfaceVariant: Color(0xFF5A3A20),
      outline: Color(0xFF8B6A4A),
      outlineVariant: Color(0xFFD4B896),
      shadow: Colors.black,
      scrim: Colors.black,
      inverseSurface: _kolaBrown,
      onInverseSurface: _cream,
      inversePrimary: _terracottaLight,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: _surfaceLight,
      appBarTheme: const AppBarTheme(
        backgroundColor: _surfaceLight,
        foregroundColor: _kolaBrown,
        elevation: 0,
        centerTitle: false,
        // ignore: prefer_const_constructors
        titleTextStyle: TextStyle(
          color: _kolaBrown,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
      cardTheme: CardThemeData(
        color: Colors.white,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: const BorderSide(color: Color(0xFFD4B896)),
        ),
      ),
      extensions: const [YansoColors.light],
    );
  }
}

// ---------------------------------------------------------------------------
// YansoColors — semantic colour extension consumed by widgets.
// ---------------------------------------------------------------------------

/// Semantic colour tokens specific to Yanso's calendar and cultural UI.
///
/// Access via: `Theme.of(context).extension<YansoColors>()!`
class YansoColors extends ThemeExtension<YansoColors> {
  const YansoColors({
    required this.calendarBackground,
    required this.cellDefault,
    required this.cellDefaultText,
    required this.cellToday,
    required this.cellTodayBorder,
    required this.cellTodayText,
    required this.cellRestDay,
    required this.cellRestDayText,
    required this.cellRestDayBadge,
    required this.cellMarketDay,
    required this.cellMarketDayText,
    required this.cellMarketDayBadge,
    required this.weekdayHeaderText,
    required this.restDayHeaderText,
    required this.marketDayHeaderText,
    required this.kenteStripe1,
    required this.kenteStripe2,
    required this.kenteStripe3,
    required this.sheetHandle,
    required this.unverifiedBadge,
  });

  /// The gradient background behind the calendar grid.
  final Color calendarBackground;

  /// Default day cell background.
  final Color cellDefault;
  final Color cellDefaultText;

  /// Today's cell.
  final Color cellToday;
  final Color cellTodayBorder;
  final Color cellTodayText;

  /// Rest-day cells (Kiloovəy, ŋgoilum).
  final Color cellRestDay;
  final Color cellRestDayText;

  /// The small crescent/moon badge colour on rest-day cells.
  final Color cellRestDayBadge;

  /// Market-day cells (Kaavi — main market day at Mbvə', Kimbo').
  final Color cellMarketDay;
  final Color cellMarketDayText;

  /// The small basket/market badge colour on market-day cells.
  final Color cellMarketDayBadge;

  /// Weekday header row text colours.
  final Color weekdayHeaderText;
  final Color restDayHeaderText;
  final Color marketDayHeaderText;

  /// Three kente-stripe colours used in decorative elements.
  final Color kenteStripe1; // gold
  final Color kenteStripe2; // terracotta
  final Color kenteStripe3; // forest green

  /// Bottom-sheet drag handle.
  final Color sheetHandle;

  /// Badge for unverified cultural data.
  final Color unverifiedBadge;

  // ---------------------------------------------------------------------------

  static const YansoColors dark = YansoColors(
    calendarBackground: Color(0xFF2C1A0E),
    cellDefault: Color(0xFF3D2512),
    cellDefaultText: Color(0xFFF5ECD7),
    cellToday: Color(0xFF2C1A0E),
    cellTodayBorder: Color(0xFFE8A020),
    cellTodayText: Color(0xFFE8A020),
    cellRestDay: Color(0xFF2A2448),
    cellRestDayText: Color(0xFFB8B0F0),
    cellRestDayBadge: Color(0xFF7B72C8),
    // Kaavi market day — deep forest green, life and gathering
    cellMarketDay: Color(0xFF0F3020),
    cellMarketDayText: Color(0xFF7ECBA4),
    cellMarketDayBadge: Color(0xFF3A9E6E),
    weekdayHeaderText: Color(0xFFBFAE96),
    restDayHeaderText: Color(0xFF9B94D8),
    marketDayHeaderText: Color(0xFF5DBF8A),
    kenteStripe1: Color(0xFFE8A020),
    kenteStripe2: Color(0xFFC4622D),
    kenteStripe3: Color(0xFF2D6A4F),
    sheetHandle: Color(0xFF5A3A20),
    unverifiedBadge: Color(0xFF5A3A20),
  );

  static const YansoColors light = YansoColors(
    calendarBackground: Color(0xFFF5ECD7),
    cellDefault: Color(0xFFFFFFFF),
    cellDefaultText: Color(0xFF2C1A0E),
    cellToday: Color(0xFF2C1A0E),
    cellTodayBorder: Color(0xFFE8A020),
    cellTodayText: Color(0xFFE8A020),
    cellRestDay: Color(0xFFEAE8FF),
    cellRestDayText: Color(0xFF3A3060),
    cellRestDayBadge: Color(0xFF7B72C8),
    // Kaavi market day — fresh green, abundance
    cellMarketDay: Color(0xFFD6F5E6),
    cellMarketDayText: Color(0xFF1A5C3A),
    cellMarketDayBadge: Color(0xFF2D8A5E),
    weekdayHeaderText: Color(0xFF5A3A20),
    restDayHeaderText: Color(0xFF3A3060),
    marketDayHeaderText: Color(0xFF1A5C3A),
    kenteStripe1: Color(0xFFE8A020),
    kenteStripe2: Color(0xFFC4622D),
    kenteStripe3: Color(0xFF2D6A4F),
    sheetHandle: Color(0xFFD4B896),
    unverifiedBadge: Color(0xFFD4B896),
  );

  // ---------------------------------------------------------------------------

  @override
  YansoColors copyWith({
    Color? calendarBackground,
    Color? cellDefault,
    Color? cellDefaultText,
    Color? cellToday,
    Color? cellTodayBorder,
    Color? cellTodayText,
    Color? cellRestDay,
    Color? cellRestDayText,
    Color? cellRestDayBadge,
    Color? cellMarketDay,
    Color? cellMarketDayText,
    Color? cellMarketDayBadge,
    Color? weekdayHeaderText,
    Color? restDayHeaderText,
    Color? marketDayHeaderText,
    Color? kenteStripe1,
    Color? kenteStripe2,
    Color? kenteStripe3,
    Color? sheetHandle,
    Color? unverifiedBadge,
  }) => YansoColors(
    calendarBackground: calendarBackground ?? this.calendarBackground,
    cellDefault: cellDefault ?? this.cellDefault,
    cellDefaultText: cellDefaultText ?? this.cellDefaultText,
    cellToday: cellToday ?? this.cellToday,
    cellTodayBorder: cellTodayBorder ?? this.cellTodayBorder,
    cellTodayText: cellTodayText ?? this.cellTodayText,
    cellRestDay: cellRestDay ?? this.cellRestDay,
    cellRestDayText: cellRestDayText ?? this.cellRestDayText,
    cellRestDayBadge: cellRestDayBadge ?? this.cellRestDayBadge,
    cellMarketDay: cellMarketDay ?? this.cellMarketDay,
    cellMarketDayText: cellMarketDayText ?? this.cellMarketDayText,
    cellMarketDayBadge: cellMarketDayBadge ?? this.cellMarketDayBadge,
    weekdayHeaderText: weekdayHeaderText ?? this.weekdayHeaderText,
    restDayHeaderText: restDayHeaderText ?? this.restDayHeaderText,
    marketDayHeaderText: marketDayHeaderText ?? this.marketDayHeaderText,
    kenteStripe1: kenteStripe1 ?? this.kenteStripe1,
    kenteStripe2: kenteStripe2 ?? this.kenteStripe2,
    kenteStripe3: kenteStripe3 ?? this.kenteStripe3,
    sheetHandle: sheetHandle ?? this.sheetHandle,
    unverifiedBadge: unverifiedBadge ?? this.unverifiedBadge,
  );

  @override
  YansoColors lerp(YansoColors? other, double t) {
    if (other == null) return this;
    return YansoColors(
      calendarBackground: Color.lerp(
        calendarBackground,
        other.calendarBackground,
        t,
      )!,
      cellDefault: Color.lerp(cellDefault, other.cellDefault, t)!,
      cellDefaultText: Color.lerp(cellDefaultText, other.cellDefaultText, t)!,
      cellToday: Color.lerp(cellToday, other.cellToday, t)!,
      cellTodayBorder: Color.lerp(cellTodayBorder, other.cellTodayBorder, t)!,
      cellTodayText: Color.lerp(cellTodayText, other.cellTodayText, t)!,
      cellRestDay: Color.lerp(cellRestDay, other.cellRestDay, t)!,
      cellRestDayText: Color.lerp(cellRestDayText, other.cellRestDayText, t)!,
      cellRestDayBadge: Color.lerp(
        cellRestDayBadge,
        other.cellRestDayBadge,
        t,
      )!,
      cellMarketDay: Color.lerp(cellMarketDay, other.cellMarketDay, t)!,
      cellMarketDayText: Color.lerp(
        cellMarketDayText,
        other.cellMarketDayText,
        t,
      )!,
      cellMarketDayBadge: Color.lerp(
        cellMarketDayBadge,
        other.cellMarketDayBadge,
        t,
      )!,
      weekdayHeaderText: Color.lerp(
        weekdayHeaderText,
        other.weekdayHeaderText,
        t,
      )!,
      restDayHeaderText: Color.lerp(
        restDayHeaderText,
        other.restDayHeaderText,
        t,
      )!,
      marketDayHeaderText: Color.lerp(
        marketDayHeaderText,
        other.marketDayHeaderText,
        t,
      )!,
      kenteStripe1: Color.lerp(kenteStripe1, other.kenteStripe1, t)!,
      kenteStripe2: Color.lerp(kenteStripe2, other.kenteStripe2, t)!,
      kenteStripe3: Color.lerp(kenteStripe3, other.kenteStripe3, t)!,
      sheetHandle: Color.lerp(sheetHandle, other.sheetHandle, t)!,
      unverifiedBadge: Color.lerp(unverifiedBadge, other.unverifiedBadge, t)!,
    );
  }
}
