import 'nso_date.dart';
import 'nso_month.dart';
import 'nso_weekday.dart';
import 'conversion.dart';

export 'nso_date.dart';
export 'nso_month.dart';
export 'nso_weekday.dart';
export 'conversion.dart';

/// High-level API for the Nso calendar engine.
///
/// This is the primary class that application code should interact with.
/// It combines weekday cycling, month/year data, and date conversion into
/// a single surface.
///
/// ### Example
/// ```dart
/// final today = NsoCalendar.today();
/// print(today.weekday.name);   // e.g. "Ntagrin"
/// print(today.month.name);     // e.g. "Mfiilum"
/// ```
class NsoCalendar {
  NsoCalendar._(); // static API only

  // ---------------------------------------------------------------------------
  // TODAY
  // ---------------------------------------------------------------------------

  /// Returns today's date as an [NsoDate].
  static NsoDate today() => NsoDate.today();

  // ---------------------------------------------------------------------------
  // CONVERSION
  // ---------------------------------------------------------------------------

  /// Converts a Gregorian [DateTime] to an [NsoDate].
  static NsoDate fromGregorian(DateTime gregorian) =>
      NsoDateConversion.fromGregorian(gregorian);

  /// Converts an [NsoDate] back to a Gregorian [DateTime].
  static DateTime toGregorian(NsoDate date) =>
      NsoDateConversion.toGregorian(date);

  // ---------------------------------------------------------------------------
  // WEEKDAY HELPERS
  // ---------------------------------------------------------------------------

  /// Returns the [NsoWeekday] that corresponds to [gregorian].
  static NsoWeekday weekdayFor(DateTime gregorian) =>
      NsoDateConversion.weekdayForGregorian(gregorian);

  /// Returns the complete ordered list of Nso weekdays.
  static List<NsoWeekday> get weekdays => List.unmodifiable(kNsoWeekdays);

  // ---------------------------------------------------------------------------
  // MONTH HELPERS
  // ---------------------------------------------------------------------------

  /// Returns the complete ordered list of Nso months.
  static List<NsoMonth> get months => List.unmodifiable(kNsoMonths);

  // ---------------------------------------------------------------------------
  // RANGE GENERATION
  // ---------------------------------------------------------------------------

  /// Generates a list of [NsoDate] objects for every day in a given Gregorian
  /// month. Useful for populating a month-view calendar grid.
  ///
  /// [year] and [month] are Gregorian values.
  static List<NsoDate> nsoDateRangeForGregorianMonth(int year, int month) {
    final daysInMonth = DateTimeExtension.daysInMonth(year, month);
    return List.generate(
      daysInMonth,
      (i) => NsoDateConversion.fromGregorian(DateTime.utc(year, month, i + 1)),
    );
  }

  /// Generates a list of [NsoDate] objects for a range of Gregorian dates
  /// (inclusive of both endpoints).
  static List<NsoDate> nsoDateRange(DateTime start, DateTime end) {
    final days = end.difference(start).inDays + 1;
    if (days <= 0) return [];
    return List.generate(
      days,
      (i) => NsoDateConversion.fromGregorian(
        start.add(Duration(days: i)),
      ),
    );
  }
}

/// Internal extension — keeps date arithmetic readable inside the engine.
///
/// Not part of the public API; used only within the nso_calendar package.
extension DateTimeExtension on DateTime {
  /// Returns the number of days in the given Gregorian [month] of [year].
  static int daysInMonth(int year, int month) {
    return DateTime(year, month + 1, 0).day;
  }
}
