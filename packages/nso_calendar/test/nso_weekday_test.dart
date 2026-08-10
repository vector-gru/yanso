import 'package:nso_calendar/nso_calendar.dart';
import 'package:test/test.dart';

void main() {
  group('NsoWeekday data', () {
    test('there are exactly 8 weekdays', () {
      expect(kNsoWeekdays.length, equals(8));
    });

    test('weekdays are ordered 1 through 8', () {
      for (var i = 0; i < kNsoWeekdays.length; i++) {
        expect(kNsoWeekdays[i].order, equals(i + 1));
      }
    });

    test('no two weekdays share the same order', () {
      final orders = kNsoWeekdays.map((d) => d.order).toSet();
      expect(orders.length, equals(8));
    });

    test('no two weekdays share the same name', () {
      final names = kNsoWeekdays.map((d) => d.name).toSet();
      expect(names.length, equals(8));
    });

    test('all weekday names are non-empty', () {
      for (final day in kNsoWeekdays) {
        expect(day.name.trim(), isNotEmpty,
            reason: 'Weekday ${day.order} has an empty name');
      }
    });

    test('all short names are non-empty and at most 4 characters', () {
      for (final day in kNsoWeekdays) {
        expect(day.shortName.trim(), isNotEmpty,
            reason: 'Weekday ${day.order} has an empty shortName');
        expect(day.shortName.length, lessThanOrEqualTo(4),
            reason: 'Short name "${day.shortName}" for day ${day.order} '
                'is longer than 4 characters');
      }
    });

    test('day names match correct Lamnso spellings (verified via yanso.org)',
        () {
      // Cycle starts at Kaavi (order 1).
      // ŋ replaces ng; ə replaces e where appropriate.
      // Source: yanso-org-2026-08.
      // If any name changes here, document the source in calendar_sources.md.
      final expectedNames = [
        'Kaavi',
        'Rəəveiy',
        'Kiloovəy',
        'Nsəəri',
        'Geegee',
        'ŋgoilum',
        'Waiylun',
        'Ntaŋrin',
      ];
      for (var i = 0; i < expectedNames.length; i++) {
        expect(
          kNsoWeekdays[i].name,
          equals(expectedNames[i]),
          reason: 'Day ${i + 1} should be "${expectedNames[i]}" — '
              'update this test only with a documented source.',
        );
      }
    });

    test('Kaavi is the first day of the cycle (order 1)', () {
      expect(kNsoWeekdays.first.name, equals('Kaavi'));
      expect(kNsoWeekdays.first.order, equals(1));
    });

    test('ŋgoilum is order 6', () {
      expect(kNsoWeekdays[5].name, equals('ŋgoilum'));
      expect(kNsoWeekdays[5].order, equals(6));
    });

    test('Ntaŋrin is the last day of the cycle (order 8)', () {
      expect(kNsoWeekdays.last.name, equals('Ntaŋrin'));
      expect(kNsoWeekdays.last.order, equals(8));
    });

    test('equality is based on order, not reference', () {
      const a = NsoWeekday(order: 1, name: 'Kaavi', shortName: 'Ka');
      const b = NsoWeekday(order: 1, name: 'Kaavi', shortName: 'Ka');
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('weekdays with different orders are not equal', () {
      expect(kNsoWeekdays[0], isNot(equals(kNsoWeekdays[1])));
    });

    test('NsoCalendar.weekdays returns an unmodifiable list', () {
      final list = NsoCalendar.weekdays;
      expect(() => list.add(kNsoWeekdays[0]), throwsUnsupportedError);
    });
  });
}
