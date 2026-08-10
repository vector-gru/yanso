// ignore_for_file: avoid_print
// Example files are console programs — print is appropriate here.

import 'package:nso_calendar/nso_calendar.dart';

void main() {
  // Get today's Nso date.
  final today = NsoCalendar.today();
  print('Today in the Nso calendar:');
  print('  Weekday : ${today.weekday.name}');
  print('  Month   : ${today.month.name}');
  print('  Day     : ${today.dayOfMonth}');
  print('  Year    : ${today.nsoYear}');
  print('  Display : ${today.toDisplayString()}');

  // Show the full eight-day week.
  print('\nThe eight Nso weekdays:');
  for (final day in NsoCalendar.weekdays) {
    print('  ${day.order}. ${day.name} (${day.shortName})');
  }

  // Show the twelve Lamnso months.
  print('\nThe twelve Lamnso months:');
  for (final month in NsoCalendar.months) {
    print('  ${month.order.toString().padLeft(2)}. ${month.name}');
  }

  // Convert a specific Gregorian date.
  final sample = DateTime(2024, 3, 15);
  final nsoSample = NsoCalendar.fromGregorian(sample);
  print('\nGregorian 2024-03-15 → Nso: ${nsoSample.toDisplayString()}');
}
