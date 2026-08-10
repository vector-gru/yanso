import 'package:flutter/material.dart';
import 'package:nso_calendar/nso_calendar.dart';

import '../../../../app/theme/app_theme.dart';

/// A single cell in the calendar month grid.
///
/// Shows:
/// - The Gregorian day number (primary, large)
/// - The Nso weekday short name (secondary, small — confirms the 8-day cycle)
///
/// The "today" cell is visually highlighted.
class NsoDayCell extends StatelessWidget {
  const NsoDayCell({
    super.key,
    required this.nsoDate,
    required this.gregorianDay,
    required this.isToday,
  });

  final NsoDate nsoDate;
  final int gregorianDay;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final yansoColors = theme.extension<YansoColors>();

    final backgroundColor = isToday
        ? theme.colorScheme.primary
        : (yansoColors?.nsoWeekdayHighlight ?? Colors.transparent);

    final textColor = isToday
        ? theme.colorScheme.onPrimary
        : theme.colorScheme.onSurface;

    return Container(
      margin: const EdgeInsets.all(1),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '$gregorianDay',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: textColor,
              fontWeight: isToday ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            nsoDate.weekday.shortName,
            style: theme.textTheme.labelSmall?.copyWith(
              color: textColor.withValues(alpha: 0.7),
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}
