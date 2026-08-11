import 'package:flutter/material.dart';
import 'package:nso_calendar/nso_calendar.dart';

import '../../../../app/theme/app_theme.dart';

/// Column headers for the 8-column calendar grid.
///
/// Rest-day columns (Kiloovəy, ŋgoilum) use the indigo-clay text colour
/// so the visual rhythm of the rest days is visible from the header row.
class NsoWeekdayHeader extends StatelessWidget {
  const NsoWeekdayHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final yc = theme.extension<YansoColors>()!;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2, vertical: 2),
      child: Row(
        children: kNsoWeekdays.map((day) {
          final isRestDay = day.isRestDay == true;
          final isMarketDay = day.isMarketDay == true;
          return Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 6),
              alignment: Alignment.center,
              child: Text(
                day.shortName,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: isMarketDay
                      ? yc.marketDayHeaderText
                      : isRestDay
                      ? yc.restDayHeaderText
                      : yc.weekdayHeaderText,
                  fontWeight: (isMarketDay || isRestDay)
                      ? FontWeight.w700
                      : FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
