import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nso_calendar/nso_calendar.dart';

/// Provides today's [NsoDate].
///
/// This is a simple synchronous provider for Phase 1.
/// In a later phase this could become a [StreamProvider] that ticks over
/// at midnight to keep "today" current without a restart.
final todayNsoDateProvider = Provider<NsoDate>((ref) {
  return NsoCalendar.today();
});

/// Provides the [NsoDate] for a specific Gregorian [DateTime].
///
/// Use this in calendar grid cells where you need a date other than today.
final nsoDateForGregorianProvider =
    Provider.family<NsoDate, DateTime>((ref, gregorian) {
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

/// Provides the Gregorian month currently displayed in the calendar view.
///
/// State: (year, month) as a [DateTime] with day set to 1.
/// Navigation buttons will update this via [CalendarViewNotifier].
final calendarViewMonthProvider =
    StateNotifierProvider<CalendarViewNotifier, DateTime>((ref) {
  final now = DateTime.now();
  return CalendarViewNotifier(DateTime(now.year, now.month, 1));
});

/// Notifier that controls which Gregorian month is displayed.
class CalendarViewNotifier extends StateNotifier<DateTime> {
  CalendarViewNotifier(super.initial);

  void goToNextMonth() {
    state = DateTime(state.year, state.month + 1, 1);
  }

  void goToPreviousMonth() {
    state = DateTime(state.year, state.month - 1, 1);
  }

  void goToMonth(int year, int month) {
    state = DateTime(year, month, 1);
  }

  void goToToday() {
    final now = DateTime.now();
    state = DateTime(now.year, now.month, 1);
  }
}

/// Provides all [NsoDate] objects for the currently viewed Gregorian month.
///
/// The calendar grid consumes this to render each cell.
final calendarDatesForMonthProvider = Provider<List<NsoDate>>((ref) {
  final viewMonth = ref.watch(calendarViewMonthProvider);
  return NsoCalendar.nsoDateRangeForGregorianMonth(
    viewMonth.year,
    viewMonth.month,
  );
});
