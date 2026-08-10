import 'package:nso_calendar/nso_calendar.dart';
import 'package:test/test.dart';

void main() {
  group('NsoMonth data', () {
    test('there are exactly 12 months', () {
      expect(kNsoMonths.length, equals(12));
    });

    test('months are ordered 1 through 12', () {
      for (var i = 0; i < kNsoMonths.length; i++) {
        expect(kNsoMonths[i].order, equals(i + 1));
      }
    });

    test('no two months share the same order', () {
      final orders = kNsoMonths.map((m) => m.order).toSet();
      expect(orders.length, equals(12));
    });

    test('no two months share the same name', () {
      final names = kNsoMonths.map((m) => m.name).toSet();
      expect(names.length, equals(12));
    });

    test('all month names are non-empty', () {
      for (final month in kNsoMonths) {
        expect(month.name.trim(), isNotEmpty,
            reason: 'Month ${month.order} has an empty name');
      }
    });

    test('month names match correct Lamnso spellings (verified via yanso.org)',
        () {
      // Source: yanso-org-2026-08.
      // Update only with a documented source in calendar_sources.md.
      final expectedNames = [
        'Mfiilum',
        'Kifir',
        'Kiŋmgbù ke wuu',
        'Vishévti',
        "Ma'an san",
        "Ma'an saar",
        'Ntoòbiŋ',
        'Tònŋkin',
        'ŋkivin',
        'Verə̀mrə̀m',
        'Sán',
        'Ntinen Saar',
      ];
      for (var i = 0; i < expectedNames.length; i++) {
        expect(
          kNsoMonths[i].name,
          equals(expectedNames[i]),
          reason: 'Month ${i + 1} should be "${expectedNames[i]}".',
        );
      }
    });

    test('Gregorian month equivalents are 1..12 with no duplicates', () {
      final gregs = kNsoMonths.map((m) => m.gregorianMonthEquivalent).toList();
      expect(gregs.toSet().length, equals(12),
          reason: 'Each Nso month must map to a unique Gregorian month');
      for (final g in gregs) {
        expect(g, inInclusiveRange(1, 12));
      }
    });

    test('Nso months map 1-to-1 with Gregorian months in order', () {
      // Jan=Mfiilum, Feb=Kifir, … Dec=Ntinen Saar.
      // Source: yanso-org-2026-08.
      final expectedMapping = {
        1: 'Mfiilum',
        2: 'Kifir',
        3: 'Kiŋmgbù ke wuu',
        4: 'Vishévti',
        5: "Ma'an san",
        6: "Ma'an saar",
        7: 'Ntoòbiŋ',
        8: 'Tònŋkin',
        9: 'ŋkivin',
        10: 'Verə̀mrə̀m',
        11: 'Sán',
        12: 'Ntinen Saar',
      };
      for (final entry in expectedMapping.entries) {
        final month = nsoMonthForGregorianMonth(entry.key);
        expect(month.name, equals(entry.value),
            reason:
                'Gregorian month ${entry.key} should map to "${entry.value}"');
      }
    });

    test('nsoMonthForGregorianMonth(8) returns Tònŋkin (August)', () {
      final month = nsoMonthForGregorianMonth(8);
      expect(month.name, equals('Tònŋkin'));
      expect(month.order, equals(8));
    });

    test('equality is based on order, not reference', () {
      const a = NsoMonth(
        order: 1,
        name: 'Mfiilum',
        shortName: 'Mfi',
        gregorianMonthEquivalent: 1,
      );
      const b = NsoMonth(
        order: 1,
        name: 'Mfiilum',
        shortName: 'Mfi',
        gregorianMonthEquivalent: 1,
      );
      expect(a, equals(b));
      expect(a.hashCode, equals(b.hashCode));
    });

    test('months with different orders are not equal', () {
      expect(kNsoMonths[0], isNot(equals(kNsoMonths[1])));
    });

    test('NsoCalendar.months returns an unmodifiable list', () {
      final list = NsoCalendar.months;
      expect(() => list.add(kNsoMonths[0]), throwsUnsupportedError);
    });

    test('all months have partiallyVerified status (yanso.org source)', () {
      for (final month in kNsoMonths) {
        expect(
          month.verificationStatus,
          equals(DataVerificationStatus.partiallyVerified),
          reason: 'Month "${month.name}" should be partiallyVerified '
              '(sourced from yanso.org).',
        );
      }
    });
  });
}
