import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nso_calendar/nso_calendar.dart';

import '../../../../app/theme/app_theme.dart';
import '../../domain/calendar_providers.dart';

/// A compact calendar grid showing a single month.
///
/// Used inside the year view — 2 columns of 6 mini-months.
///
/// Layout:
///   • Month name header (Nso name + Gregorian in brackets)
///   • 8-column weekday initial row  (K  R  Ki  N  G  ŋ  W  Nt)
///   • Day cells: number only, colour-coded by type
///
/// Tapping the month header or any day calls [onMonthTap] so the
/// parent can jump the month view to that month.
class MiniMonthGrid extends StatelessWidget {
  const MiniMonthGrid({
    super.key,
    required this.summary,
    required this.today,
    required this.onMonthTap,
  });

  final MonthSummary summary;
  final NsoDate today;

  /// Called when the user taps the month header or a day cell.
  /// The parent uses this to navigate the month view.
  final VoidCallback onMonthTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final yc = theme.extension<YansoColors>()!;
    final gregMonthName = DateFormat('MMM').format(
      DateTime(summary.gregorianYear, summary.gregorianMonth),
    );

    // Does this mini-month contain today?
    final containsToday = today.nsoYear == summary.gregorianYear &&
        today.month.gregorianMonthEquivalent == summary.gregorianMonth;

    return GestureDetector(
      onTap: onMonthTap,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(14),
          border: containsToday
              ? Border.all(
                  color: yc.cellTodayBorder,
                  width: 1.5,
                )
              : Border.all(
                  color: theme.colorScheme.outline.withValues(alpha: 0.15),
                ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Month header
            _MiniMonthHeader(
              nsoMonthName: summary.nsoMonth.name,
              gregMonthName: gregMonthName,
              year: summary.gregorianYear,
              containsToday: containsToday,
              yc: yc,
              theme: theme,
            ),
            const SizedBox(height: 4),
            // Weekday initials row
            _MiniWeekdayRow(yc: yc, theme: theme),
            // Day cells
            _MiniDayGrid(
              summary: summary,
              today: today,
              yc: yc,
            ),
            const SizedBox(height: 4),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Month header
// ---------------------------------------------------------------------------

class _MiniMonthHeader extends StatelessWidget {
  const _MiniMonthHeader({
    required this.nsoMonthName,
    required this.gregMonthName,
    required this.year,
    required this.containsToday,
    required this.yc,
    required this.theme,
  });

  final String nsoMonthName;
  final String gregMonthName;
  final int year;
  final bool containsToday;
  final YansoColors yc;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: containsToday
            ? yc.kenteStripe2.withValues(alpha: 0.18)
            : Colors.transparent,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(13)),
      ),
      padding: const EdgeInsets.fromLTRB(8, 7, 8, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            nsoMonthName,
            style: theme.textTheme.labelMedium?.copyWith(
              fontWeight: FontWeight.w800,
              color: containsToday
                  ? yc.kenteStripe2
                  : theme.colorScheme.onSurface,
              fontSize: 11,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          Text(
            gregMonthName,
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontSize: 9,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Weekday initials row
// ---------------------------------------------------------------------------

class _MiniWeekdayRow extends StatelessWidget {
  const _MiniWeekdayRow({required this.yc, required this.theme});

  final YansoColors yc;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Row(
        children: kNsoWeekdays.map((day) {
          final isRestDay = day.isRestDay == true;
          final isMarketDay = day.isMarketDay == true;
          // Use just the first letter of the short name
          final initial = day.shortName[0];
          return Expanded(
            child: Center(
              child: Text(
                initial,
                style: TextStyle(
                  fontSize: 7,
                  fontWeight: FontWeight.w700,
                  color: isMarketDay
                      ? yc.marketDayHeaderText
                      : isRestDay
                          ? yc.restDayHeaderText
                          : yc.weekdayHeaderText,
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Day grid
// ---------------------------------------------------------------------------

class _MiniDayGrid extends StatelessWidget {
  const _MiniDayGrid({
    required this.summary,
    required this.today,
    required this.yc,
  });

  final MonthSummary summary;
  final NsoDate today;
  final YansoColors yc;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final totalCells = summary.firstDayOffset + summary.dates.length;
    // How many full rows of 8 we need (round up)
    final rows = (totalCells / 8).ceil();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Column(
        children: List.generate(rows, (row) {
          return Row(
            children: List.generate(8, (col) {
              final cellIndex = row * 8 + col;
              final dateIndex = cellIndex - summary.firstDayOffset;

              // Empty leading/trailing cell
              if (dateIndex < 0 || dateIndex >= summary.dates.length) {
                return const Expanded(child: SizedBox(height: 14));
              }

              final nsoDate = summary.dates[dateIndex];
              final gregDay = dateIndex + 1;
              final isToday = nsoDate == today;
              final isRestDay = nsoDate.weekday.isRestDay == true;
              final isMarketDay = nsoDate.weekday.isMarketDay == true;

              Color bg;
              Color fg;

              if (isToday) {
                bg = yc.cellTodayBorder;
                fg = theme.colorScheme.surface;
              } else if (isMarketDay) {
                bg = yc.cellMarketDay;
                fg = yc.cellMarketDayText;
              } else if (isRestDay) {
                bg = yc.cellRestDay;
                fg = yc.cellRestDayText;
              } else {
                bg = Colors.transparent;
                fg = theme.colorScheme.onSurface;
              }

              return Expanded(
                child: Container(
                  height: 14,
                  margin: const EdgeInsets.all(0.5),
                  decoration: BoxDecoration(
                    color: bg,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  child: Center(
                    child: Text(
                      '$gregDay',
                      style: TextStyle(
                        fontSize: 7,
                        fontWeight: isToday
                            ? FontWeight.w800
                            : FontWeight.w400,
                        color: fg,
                        height: 1,
                      ),
                    ),
                  ),
                ),
              );
            }),
          );
        }),
      ),
    );
  }
}
