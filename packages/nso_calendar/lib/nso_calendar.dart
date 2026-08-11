/// The Nso calendar engine.
///
/// Provides Gregorian ↔ Nso date conversion, the eight-day Nso week,
/// the twelve Lamnso months, and calendar range utilities.
///
/// ### Quick start
/// ```dart
/// import 'package:nso_calendar/nso_calendar.dart';
///
/// final today = NsoCalendar.today();
/// print(today.weekday.name);   // Nso day name
/// print(today.month.name);     // Lamnso month name
/// ```
///
/// ### Research status
/// The conversion algorithm is a **working Phase 1 implementation**.
/// The anchor date and year epoch constants in [NsoDateConversion] must be
/// verified against trusted Nso calendar sources before results can be
/// considered accurate. See docs/research/calendar_sources.md.
library;

export 'src/calendar.dart';
