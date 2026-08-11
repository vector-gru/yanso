import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nso_calendar/nso_calendar.dart';

/// Provides today's [NsoDate].
///
/// Simple synchronous provider for Phase 1. Could become a [StreamProvider]
/// that ticks at midnight to keep "today" current without a restart.
final todayNsoDateProvider = Provider<NsoDate>((ref) {
  return NsoCalendar.today();
});

/// Provides the [NsoDate] for a specific Gregorian [DateTime].
final nsoDateForGregorianProvider = Provider.family<NsoDate, DateTime>((
  ref,
  gregorian,
) {
  return NsoCalendar.fromGregorian(gregorian);
});

/// Provides the full list of [NsoWeekday] objects in cycle order.
final nsoWeekdaysProvider = Provider<List<NsoWeekday>>((ref) {
  return NsoCalendar.weekdays;
});

/// Provides the full list of [NsoMonth] objects in year order.
final nsoMonthsProvider = Provider<List<NsoMonth>>((ref) {
  return NsoCalendar.months;
});

// ---------------------------------------------------------------------------
// Month view
// ---------------------------------------------------------------------------

/// The Gregorian month currently displayed in the month-view calendar.
///
/// State: first day of the displayed month (day always = 1).
final calendarViewMonthProvider =
    StateNotifierProvider<CalendarViewNotifier, DateTime>((ref) {
      final now = DateTime.now();
      return CalendarViewNotifier(DateTime(now.year, now.month, 1));
    });

/// Controls which Gregorian month the month view is showing.
class CalendarViewNotifier extends StateNotifier<DateTime> {
  CalendarViewNotifier(super.initial);

  void goToNextMonth() => state = DateTime(state.year, state.month + 1, 1);

  void goToPreviousMonth() => state = DateTime(state.year, state.month - 1, 1);

  void goToMonth(int year, int month) => state = DateTime(year, month, 1);

  void goToToday() {
    final now = DateTime.now();
    state = DateTime(now.year, now.month, 1);
  }
}

/// All [NsoDate] objects for the currently viewed Gregorian month.
final calendarDatesForMonthProvider = Provider<List<NsoDate>>((ref) {
  final viewMonth = ref.watch(calendarViewMonthProvider);
  return NsoCalendar.nsoDateRangeForGregorianMonth(
    viewMonth.year,
    viewMonth.month,
  );
});

// ---------------------------------------------------------------------------
// Year view
// ---------------------------------------------------------------------------

/// The Gregorian year currently displayed in the year view.
final calendarViewYearProvider = StateNotifierProvider<YearViewNotifier, int>((
  ref,
) {
  return YearViewNotifier(DateTime.now().year);
});

/// Controls which year the year view is showing.
class YearViewNotifier extends StateNotifier<int> {
  YearViewNotifier(super.initial);

  void goToNextYear() => state = state + 1;
  void goToPreviousYear() => state = state - 1;
  void goToYear(int year) => state = year;
  void goToCurrentYear() => state = DateTime.now().year;
}

/// Pre-computed month summaries for every month in the viewed year.
///
/// Each entry holds the [NsoMonth], the Gregorian month number, the
/// first-day weekday offset (for grid alignment), and all the [NsoDate]
/// objects for that month.
final yearMonthSummariesProvider = Provider<List<MonthSummary>>((ref) {
  final year = ref.watch(calendarViewYearProvider);
  return List.generate(12, (i) {
    final gregorianMonth = i + 1;
    final dates = NsoCalendar.nsoDateRangeForGregorianMonth(
      year,
      gregorianMonth,
    );
    final firstDayOffset =
        NsoCalendar.fromGregorian(
          DateTime(year, gregorianMonth, 1),
        ).weekday.order -
        1;
    return MonthSummary(
      gregorianYear: year,
      gregorianMonth: gregorianMonth,
      nsoMonth: nsoMonthForGregorianMonth(gregorianMonth),
      dates: dates,
      firstDayOffset: firstDayOffset,
    );
  });
});

/// Holds pre-computed data for one month, used by the year-view grid.
class MonthSummary {
  const MonthSummary({
    required this.gregorianYear,
    required this.gregorianMonth,
    required this.nsoMonth,
    required this.dates,
    required this.firstDayOffset,
  });

  final int gregorianYear;
  final int gregorianMonth;
  final NsoMonth nsoMonth;

  /// All [NsoDate] objects for this month, in day order.
  final List<NsoDate> dates;

  /// How many empty leading cells appear before day 1 in the 8-column grid.
  final int firstDayOffset;
}

// ---------------------------------------------------------------------------
// Shared: active calendar tab index (0 = month, 1 = year)
// ---------------------------------------------------------------------------

final calendarTabIndexProvider = StateProvider<int>((ref) => 0);
