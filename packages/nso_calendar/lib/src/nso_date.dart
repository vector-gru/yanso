import 'nso_month.dart';
import 'nso_weekday.dart';
import 'conversion.dart';

/// An immutable representation of a date in the traditional Nso calendar.
///
/// A Nso date consists of:
/// - A [weekday]   — one of the eight days in the Nso week cycle.
/// - A [month]     — one of the twelve months of the Nso year.
/// - A [dayOfMonth] — the day number within the month (1-indexed).
/// - A [nsoYear]   — the Nso year number.
///
/// ## Creating an NsoDate
///
/// The most common entry point is converting from Gregorian:
///
/// ```dart
/// final today = NsoDate.fromGregorian(DateTime.now());
/// ```
///
/// ## Research status
///
/// The conversion algorithm in [NsoDateConversion] is a working implementation
/// based on Phase 1 research. It must be validated against multiple verified
/// Nso ↔ Gregorian reference dates before it can be considered accurate.
/// See docs/research/calendar_sources.md for the verification checklist.
class NsoDate {
  /// The Nso weekday (position 1..8 in the eight-day cycle).
  final NsoWeekday weekday;

  /// The Nso month (position 1..12 in the Nso year).
  final NsoMonth month;

  /// The day number within the Nso month (1-indexed).
  final int dayOfMonth;

  /// The Nso year number.
  final int nsoYear;

  /// Creates an [NsoDate] with the given [weekday], [month], [dayOfMonth],
  /// and [nsoYear].
  const NsoDate({
    required this.weekday,
    required this.month,
    required this.dayOfMonth,
    required this.nsoYear,
  });

  /// Converts a Gregorian [DateTime] to an [NsoDate].
  ///
  /// Delegates to [NsoDateConversion.fromGregorian].
  factory NsoDate.fromGregorian(DateTime gregorian) =>
      NsoDateConversion.fromGregorian(gregorian);

  /// Returns today's Nso date.
  factory NsoDate.today() => NsoDate.fromGregorian(DateTime.now());

  /// Converts this [NsoDate] back to a Gregorian [DateTime].
  ///
  /// The returned [DateTime] will have time set to midnight UTC.
  DateTime toGregorian() => NsoDateConversion.toGregorian(this);

  /// Returns the next day in the Nso calendar.
  NsoDate get nextDay => NsoDate.fromGregorian(
        toGregorian().add(const Duration(days: 1)),
      );

  /// Returns the previous day in the Nso calendar.
  NsoDate get previousDay => NsoDate.fromGregorian(
        toGregorian().subtract(const Duration(days: 1)),
      );

  /// Human-readable representation of the date in Lamnso.
  ///
  /// Example: "Ntagrin, 3 Mfiilum 1425"
  String toDisplayString() =>
      '${weekday.name}, $dayOfMonth ${month.name} $nsoYear';

  @override
  String toString() =>
      'NsoDate(${weekday.name}, day=$dayOfMonth, month=${month.name}, year=$nsoYear)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NsoDate &&
          runtimeType == other.runtimeType &&
          weekday == other.weekday &&
          month == other.month &&
          dayOfMonth == other.dayOfMonth &&
          nsoYear == other.nsoYear;

  @override
  int get hashCode => Object.hash(weekday, month, dayOfMonth, nsoYear);
}
