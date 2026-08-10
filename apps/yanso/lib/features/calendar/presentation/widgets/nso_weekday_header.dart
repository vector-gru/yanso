import 'package:flutter/material.dart';
import 'package:nso_calendar/nso_calendar.dart';

/// A row of eight cells showing the abbreviated Nso weekday names.
///
/// This is the column header for the calendar grid. It intentionally uses
/// the Lamnso short names (e.g. "Ntg", "Kav") rather than Gregorian
/// day abbreviations, keeping the Nso calendar as the primary frame.
class NsoWeekdayHeader extends StatelessWidget {
  const NsoWeekdayHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: kNsoWeekdays.map((day) {
        return Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 6),
            alignment: Alignment.center,
            child: Text(
              day.shortName,
              style: theme.textTheme.labelSmall?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}
