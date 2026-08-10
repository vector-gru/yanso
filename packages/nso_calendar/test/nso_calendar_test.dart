// This file is intentionally minimal.
// The calendar engine is tested in:
//   - nso_weekday_test.dart
//   - nso_month_test.dart
//   - conversion_test.dart
//
// Add integration-level tests here that exercise NsoCalendar as a whole
// (i.e. combining multiple sub-systems in one scenario).

import 'package:nso_calendar/nso_calendar.dart';
import 'package:test/test.dart';

void main() {
  group('NsoCalendar integration', () {
    test('today() returns a valid NsoDate', () {
      final today = NsoCalendar.today();
      expect(today, isA<NsoDate>());
      expect(today.weekday.order, inInclusiveRange(1, 8));
      expect(today.month.order, inInclusiveRange(1, 12));
      expect(today.dayOfMonth, greaterThanOrEqualTo(1));
      expect(today.nsoYear, greaterThan(0));
    });

    test('weekdays and months lists are non-empty', () {
      expect(NsoCalendar.weekdays, hasLength(8));
      expect(NsoCalendar.months, hasLength(12));
    });

    test('weekdayFor is consistent with fromGregorian', () {
      final date = DateTime(2025, 3, 21);
      final fromCalendar = NsoCalendar.weekdayFor(date);
      final fromFull = NsoCalendar.fromGregorian(date).weekday;
      expect(fromCalendar, equals(fromFull));
    });
  });
}
