import 'nso_date.dart';
import 'nso_month.dart';
import 'nso_weekday.dart';

/// Converts dates between the Gregorian calendar and the traditional Nso
/// (Lamnso) calendar.
///
/// ---
/// ## Verified anchor date (source: yanso-org-2026-08)
///
/// yanso.org confirms that **2026-08-01 (August 1, 2026) = ŋgoilum**.
/// ŋgoilum is order 6 in the corrected eight-day cycle:
///   1=Kaavi, 2=Rəəveiy, 3=Kiloovəy, 4=Nsəəri, 5=Geegee,
///   6=ŋgoilum, 7=Waiylun, 8=Ntaŋrin.
///
/// This anchor is now used for all weekday calculations. The cycle has been
/// manually cross-checked for the full month of August 2026 against the
/// yanso.org calendar.
///
/// ---
/// ## Month mapping
///
/// Nso months map 1-to-1 with Gregorian months (also from yanso.org):
///   Mfiilum=Jan, Kifir=Feb, Kiŋmgbù ke wuu=Mar, Vishévti=Apr,
///   Ma'an san=May, Ma'an saar=Jun, Ntoòbiŋ=Jul, Tònŋkin=Aug,
///   ŋkivin=Sep, Verə̀mrə̀m=Oct, Sán=Nov, Ntinen Saar=Dec.
///
/// The Nso year therefore aligns with the Gregorian year (same year number).
///
/// ---
/// ## Research status
///
/// Weekday cycle: VERIFIED via yanso.org August 2026.
/// Month mapping: PARTIALLY VERIFIED via yanso.org.
/// Year epoch: uses Gregorian year directly — no separate Nso year numbering yet.
/// Day-of-month: uses Gregorian day-of-month directly — correct as long as the
///   1-to-1 month alignment holds.
///
/// See docs/research/calendar_sources.md and docs/research/open_questions.md.
class NsoDateConversion {
  NsoDateConversion._();

  // ---------------------------------------------------------------------------
  // ANCHOR DATE — VERIFIED via yanso.org (source: yanso-org-2026-08)
  // ---------------------------------------------------------------------------

  /// A confirmed Gregorian date used as the reference for all weekday
  /// calculations.
  ///
  /// Source: yanso.org August 2026 calendar.
  /// Confirmed: 2026-08-01 = ŋgoilum (order 6).
  static final DateTime _kAnchorGregorianDate = DateTime.utc(2026, 8, 1);

  /// The Nso weekday order (1..8) on [_kAnchorGregorianDate].
  ///
  /// ŋgoilum = order 6 in the cycle starting Kaavi=1.
  static const int _kAnchorNsoWeekdayOrder = 6;

  // ---------------------------------------------------------------------------
  // GREGORIAN → NSO
  // ---------------------------------------------------------------------------

  /// Converts a Gregorian [DateTime] to an [NsoDate].
  ///
  /// - Weekday: calculated from the verified anchor via modulo-8 arithmetic.
  /// - Month:   the Nso month that corresponds to the Gregorian month.
  /// - Day:     the Gregorian day-of-month (same value).
  /// - Year:    the Gregorian year (same value).
  static NsoDate fromGregorian(DateTime gregorian) {
    final utc = DateTime.utc(gregorian.year, gregorian.month, gregorian.day);

    final weekday = _calculateWeekday(utc);
    final month = nsoMonthForGregorianMonth(utc.month);
    final dayOfMonth = utc.day;
    final nsoYear = utc.year;

    return NsoDate(
      weekday: weekday,
      month: month,
      dayOfMonth: dayOfMonth,
      nsoYear: nsoYear,
    );
  }

  /// Converts an [NsoDate] back to a Gregorian [DateTime] (midnight UTC).
  ///
  /// This is the direct inverse of [fromGregorian]: Gregorian year, month
  /// and day are read directly from the NsoDate fields.
  static DateTime toGregorian(NsoDate nsoDate) {
    return DateTime.utc(
      nsoDate.nsoYear,
      nsoDate.month.gregorianMonthEquivalent,
      nsoDate.dayOfMonth,
    );
  }

  // ---------------------------------------------------------------------------
  // WEEKDAY CALCULATION
  // ---------------------------------------------------------------------------

  /// Returns the [NsoWeekday] for the given UTC Gregorian date.
  ///
  /// Algorithm:
  ///   daysDiff    = target − anchor  (signed integer, negative = before anchor)
  ///   cyclicIndex = ((anchorOrder − 1 + daysDiff) mod 8 + 8) mod 8
  ///   order       = cyclicIndex + 1
  ///
  /// The double-mod correctly handles negative daysDiff values.
  static NsoWeekday _calculateWeekday(DateTime utcDate) {
    final daysDiff = utcDate.difference(_kAnchorGregorianDate).inDays;
    final cyclicIndex = ((_kAnchorNsoWeekdayOrder - 1 + daysDiff) % 8 + 8) % 8;
    return kNsoWeekdays[cyclicIndex];
  }

  // ---------------------------------------------------------------------------
  // UTILITY
  // ---------------------------------------------------------------------------

  /// Returns the [NsoWeekday] for a Gregorian date without building a full
  /// [NsoDate]. Useful for quickly labelling calendar grid cells.
  static NsoWeekday weekdayForGregorian(DateTime gregorian) {
    final utc = DateTime.utc(gregorian.year, gregorian.month, gregorian.day);
    return _calculateWeekday(utc);
  }

  /// Returns how many days remain until the next Kaavi (day 1) from
  /// [fromDate] inclusive. Returns 0 if [fromDate] is already Kaavi.
  static int daysUntilNextCycleStart(DateTime fromDate) {
    final weekday = weekdayForGregorian(fromDate);
    return (8 - weekday.order + 1) % 8;
  }
}
