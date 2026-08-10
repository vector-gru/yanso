import 'package:nso_calendar/nso_calendar.dart';
import 'package:test/test.dart';

/// Tests for Gregorian ↔ Nso date conversion.
///
/// ## Anchor date (VERIFIED)
///
/// yanso.org confirms 2026-08-01 = ŋgoilum (order 6).
/// The "Verified reference dates" group below tests this directly.
///
/// ## Month mapping (PARTIALLY VERIFIED)
///
/// yanso.org confirms the 1-to-1 Gregorian ↔ Nso month alignment.
void main() {
  // ---------------------------------------------------------------------------
  // Structural / smoke tests
  // ---------------------------------------------------------------------------

  group('NsoDate.fromGregorian — structural properties', () {
    test('returns an NsoDate without throwing', () {
      final date = NsoCalendar.fromGregorian(DateTime(2026, 8, 10));
      expect(date, isA<NsoDate>());
    });

    test('weekday order is always in range 1..8', () {
      final start = DateTime(2026, 6, 1);
      for (var i = 0; i < 30; i++) {
        final nso = NsoCalendar.fromGregorian(start.add(Duration(days: i)));
        expect(nso.weekday.order, inInclusiveRange(1, 8),
            reason: 'Day $i had weekday order ${nso.weekday.order}');
      }
    });

    test('weekday cycles exactly every 8 days', () {
      final anchor = DateTime(2026, 8, 1);
      final anchorDay = NsoCalendar.fromGregorian(anchor);
      for (var cycle = 1; cycle <= 5; cycle++) {
        final later =
            NsoCalendar.fromGregorian(anchor.add(Duration(days: 8 * cycle)));
        expect(later.weekday.order, equals(anchorDay.weekday.order),
            reason: 'After ${cycle * 8} days the weekday should repeat');
      }
    });

    test('consecutive days produce consecutive weekday orders (mod 8)', () {
      final start = DateTime(2026, 8, 1);
      NsoDate? prev;
      for (var i = 0; i < 16; i++) {
        final current = NsoCalendar.fromGregorian(start.add(Duration(days: i)));
        if (prev != null) {
          final expectedOrder = (prev.weekday.order % 8) + 1;
          expect(current.weekday.order, equals(expectedOrder),
              reason: 'Day $i: expected weekday $expectedOrder, '
                  'got ${current.weekday.order}');
        }
        prev = current;
      }
    });

    test('month order is always in range 1..12', () {
      final start = DateTime(2026, 1, 1);
      for (var i = 0; i < 365; i++) {
        final nso = NsoCalendar.fromGregorian(start.add(Duration(days: i)));
        expect(nso.month.order, inInclusiveRange(1, 12));
      }
    });

    test('dayOfMonth matches the Gregorian day', () {
      for (var day = 1; day <= 31; day++) {
        // Use August which has 31 days.
        final nso = NsoCalendar.fromGregorian(DateTime(2026, 8, day));
        expect(nso.dayOfMonth, equals(day));
      }
    });

    test('nsoYear matches the Gregorian year', () {
      final nso = NsoCalendar.fromGregorian(DateTime(2026, 8, 10));
      expect(nso.nsoYear, equals(2026));
    });
  });

  // ---------------------------------------------------------------------------
  // Round-trip: Gregorian → Nso → Gregorian
  // ---------------------------------------------------------------------------

  group('Round-trip conversion', () {
    test('Gregorian → Nso → Gregorian returns the same date', () {
      final testDates = [
        DateTime.utc(2026, 1, 1),
        DateTime.utc(2026, 6, 15),
        DateTime.utc(2026, 8, 1),
        DateTime.utc(2026, 8, 10),
        DateTime.utc(2026, 12, 31),
      ];
      for (final gregorian in testDates) {
        final nso = NsoCalendar.fromGregorian(gregorian);
        final back = NsoCalendar.toGregorian(nso);
        expect(back, equals(gregorian),
            reason: 'Round-trip failed for $gregorian → $nso → $back');
      }
    });
  });

  // ---------------------------------------------------------------------------
  // NsoDate helpers
  // ---------------------------------------------------------------------------

  group('NsoDate navigation', () {
    test('nextDay advances weekday order by 1', () {
      final date = NsoCalendar.fromGregorian(DateTime(2026, 8, 1));
      final next = date.nextDay;
      final expectedOrder = (date.weekday.order % 8) + 1;
      expect(next.weekday.order, equals(expectedOrder));
    });

    test('previousDay moves weekday order back by 1', () {
      final date = NsoCalendar.fromGregorian(DateTime(2026, 8, 1));
      final prev = date.previousDay;
      final expectedOrder =
          date.weekday.order == 1 ? 8 : date.weekday.order - 1;
      expect(prev.weekday.order, equals(expectedOrder));
    });

    test('nextDay then previousDay returns original date', () {
      final date = NsoCalendar.fromGregorian(DateTime(2026, 9, 20));
      expect(date.nextDay.previousDay, equals(date));
    });
  });

  // ---------------------------------------------------------------------------
  // Range generation
  // ---------------------------------------------------------------------------

  group('NsoCalendar range generation', () {
    test('nsoDateRangeForGregorianMonth returns correct number of days', () {
      final range = NsoCalendar.nsoDateRangeForGregorianMonth(2026, 8);
      expect(range.length, equals(31)); // August has 31 days
    });

    test('nsoDateRange from start to end is inclusive on both ends', () {
      final start = DateTime.utc(2026, 8, 1);
      final end = DateTime.utc(2026, 8, 8);
      final range = NsoCalendar.nsoDateRange(start, end);
      expect(range.length, equals(8));
    });

    test('nsoDateRange with same start and end returns one date', () {
      final date = DateTime.utc(2026, 8, 4);
      final range = NsoCalendar.nsoDateRange(date, date);
      expect(range.length, equals(1));
    });

    test('nsoDateRange with end before start returns empty', () {
      final start = DateTime.utc(2026, 8, 10);
      final end = DateTime.utc(2026, 8, 5);
      expect(NsoCalendar.nsoDateRange(start, end), isEmpty);
    });
  });

  // ---------------------------------------------------------------------------
  // daysUntilNextCycleStart
  // ---------------------------------------------------------------------------

  group('daysUntilNextCycleStart', () {
    test('returns 0 when date is already Kaavi (day 1)', () {
      // 2026-08-04 = Kaavi (verified: anchor 2026-08-01=ŋgoilum order 6,
      // so +3 days → order (6+3-1)%8+1 = 8%8+1... let Dart confirm)
      DateTime? kaaviDate;
      for (var i = 0; i < 8; i++) {
        final candidate = DateTime(2026, 8, 1).add(Duration(days: i));
        if (NsoCalendar.fromGregorian(candidate).weekday.order == 1) {
          kaaviDate = candidate;
          break;
        }
      }
      expect(kaaviDate, isNotNull, reason: 'Could not find a Kaavi day');
      expect(NsoDateConversion.daysUntilNextCycleStart(kaaviDate!), equals(0));
    });

    test('returns a value in range 0..7', () {
      final start = DateTime(2026, 8, 1);
      for (var i = 0; i < 8; i++) {
        final result = NsoDateConversion.daysUntilNextCycleStart(
          start.add(Duration(days: i)),
        );
        expect(result, inInclusiveRange(0, 7));
      }
    });
  });

  // ---------------------------------------------------------------------------
  // VERIFIED REFERENCE DATES (source: yanso-org-2026-08)
  // ---------------------------------------------------------------------------

  group('Verified reference dates', () {
    // These are confirmed against yanso.org August 2026 calendar.
    // Source ID: yanso-org-2026-08.

    test('[yanso.org] 2026-08-01 is ŋgoilum', () {
      final nso = NsoCalendar.fromGregorian(DateTime(2026, 8, 1));
      expect(nso.weekday.name, equals('ŋgoilum'));
    });

    test('[yanso.org] 2026-08-04 is Kaavi (first day of cycle)', () {
      final nso = NsoCalendar.fromGregorian(DateTime(2026, 8, 4));
      expect(nso.weekday.name, equals('Kaavi'));
      expect(nso.weekday.order, equals(1));
    });

    test('[yanso.org] 2026-08-10 is Waiylun', () {
      // Today at time of implementation — visible as highlighted in screenshot.
      final nso = NsoCalendar.fromGregorian(DateTime(2026, 8, 10));
      expect(nso.weekday.name, equals('Waiylun'));
    });

    test('[yanso.org] 2026-08-11 is Ntaŋrin (last day of cycle)', () {
      final nso = NsoCalendar.fromGregorian(DateTime(2026, 8, 11));
      expect(nso.weekday.name, equals('Ntaŋrin'));
      expect(nso.weekday.order, equals(8));
    });

    test('[yanso.org] 2026-08-01 month is Tònŋkin (August)', () {
      final nso = NsoCalendar.fromGregorian(DateTime(2026, 8, 1));
      expect(nso.month.name, equals('Tònŋkin'));
      expect(nso.month.gregorianMonthEquivalent, equals(8));
    });

    test('[yanso.org] 2026-10-01 month is Verə̀mrə̀m (October)', () {
      final nso = NsoCalendar.fromGregorian(DateTime(2026, 10, 1));
      expect(nso.month.name, equals('Verə̀mrə̀m'));
    });

    test('[yanso.org] eight consecutive days cover all 8 weekdays', () {
      // Starting from 2026-08-04 (Kaavi), 8 days should yield all 8 names.
      final names = List.generate(8, (i) {
        return NsoCalendar.fromGregorian(
                DateTime(2026, 8, 4).add(Duration(days: i)))
            .weekday
            .name;
      }).toSet();
      expect(
          names,
          containsAll([
            'Kaavi',
            'Rəəveiy',
            'Kiloovəy',
            'Nsəəri',
            'Geegee',
            'ŋgoilum',
            'Waiylun',
            'Ntaŋrin',
          ]));
    });
  });

  // ---------------------------------------------------------------------------
  // Edge cases
  // ---------------------------------------------------------------------------

  group('Edge cases', () {
    test('NsoDate equality works correctly', () {
      final a = NsoCalendar.fromGregorian(DateTime(2026, 8, 10));
      final b = NsoCalendar.fromGregorian(DateTime(2026, 8, 10));
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('different dates are not equal', () {
      final a = NsoCalendar.fromGregorian(DateTime(2026, 8, 10));
      final b = NsoCalendar.fromGregorian(DateTime(2026, 8, 11));
      expect(a, isNot(equals(b)));
    });

    test('toDisplayString contains weekday name and month name', () {
      final nso = NsoCalendar.fromGregorian(DateTime(2026, 8, 1));
      expect(nso.toDisplayString(), contains('ŋgoilum'));
      expect(nso.toDisplayString(), contains('Tònŋkin'));
    });

    test('pre-2000 date still produces valid NsoDate', () {
      final nso = NsoCalendar.fromGregorian(DateTime(1990, 1, 1));
      expect(nso.weekday.order, inInclusiveRange(1, 8));
      expect(nso.month.order, equals(1)); // January = Mfiilum
    });
  });
}
