import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:nso_calendar/nso_calendar.dart';

// nso_calendar re-exports nsoMonthForGregorianMonth — no extra import needed.

import '../../domain/calendar_providers.dart';
import '../widgets/nso_day_cell.dart';
import '../widgets/nso_weekday_header.dart';

/// The main calendar screen — Phase 1.
///
/// Displays:
/// - Today's Nso date at the top
/// - A month grid showing both Gregorian day numbers and Nso weekday names
/// - Previous / next month navigation
///
/// The grid uses the 8-day Nso week as column headers, not the Gregorian
/// 7-day week, because the Nso calendar is the primary system here.
class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = ref.watch(todayNsoDateProvider);
    final viewMonth = ref.watch(calendarViewMonthProvider);
    final dates = ref.watch(calendarDatesForMonthProvider);
    final notifier = ref.read(calendarViewMonthProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ya Nso'"),
        actions: [
          IconButton(
            icon: const Icon(Icons.today),
            tooltip: 'Go to today',
            onPressed: notifier.goToToday,
          ),
        ],
      ),
      body: Column(
        children: [
          _TodayBanner(today: today),
          _MonthNavigationBar(
            viewMonth: viewMonth,
            onPrevious: notifier.goToPreviousMonth,
            onNext: notifier.goToNextMonth,
          ),
          const NsoWeekdayHeader(),
          Expanded(
            child: _CalendarGrid(
              viewMonth: viewMonth,
              dates: dates,
              today: today,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Today banner
// ---------------------------------------------------------------------------

class _TodayBanner extends StatelessWidget {
  const _TodayBanner({required this.today});

  final NsoDate today;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: theme.colorScheme.primaryContainer,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Today',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            today.toDisplayString(),
            style: theme.textTheme.titleMedium?.copyWith(
              color: theme.colorScheme.onPrimaryContainer,
              fontWeight: FontWeight.bold,
            ),
          ),
          // Research status notice — important for Phase 1 transparency.
          const SizedBox(height: 4),
          Text(
            'Conversion not yet verified — see research notes',
            style: theme.textTheme.labelSmall?.copyWith(
              color: theme.colorScheme.onPrimaryContainer.withValues(
                alpha: 0.7,
              ),
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Month navigation
// ---------------------------------------------------------------------------

class _MonthNavigationBar extends StatelessWidget {
  const _MonthNavigationBar({
    required this.viewMonth,
    required this.onPrevious,
    required this.onNext,
  });

  final DateTime viewMonth;
  final VoidCallback onPrevious;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    // Show the Nso month name first, then the Gregorian month in parentheses.
    // e.g. "Tònŋkin (August) 2026"
    final nsoMonth = nsoMonthForGregorianMonth(viewMonth.month);
    final gregorianMonthName = DateFormat('MMMM').format(viewMonth);
    final label = '${nsoMonth.name} ($gregorianMonthName) ${viewMonth.year}';
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: onPrevious,
            tooltip: 'Previous month',
          ),
          Text(label, style: Theme.of(context).textTheme.titleSmall),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: onNext,
            tooltip: 'Next month',
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Calendar grid
// ---------------------------------------------------------------------------

class _CalendarGrid extends StatelessWidget {
  const _CalendarGrid({
    required this.viewMonth,
    required this.dates,
    required this.today,
  });

  final DateTime viewMonth;
  final List<NsoDate> dates;
  final NsoDate today;

  @override
  Widget build(BuildContext context) {
    // The grid uses 8 columns — one per Nso weekday.
    // The first cell of the month starts at the column corresponding to the
    // Nso weekday of the 1st of the Gregorian month.
    final firstDayOfMonth = DateTime(viewMonth.year, viewMonth.month, 1);
    final firstNsoDay = NsoCalendar.fromGregorian(firstDayOfMonth);
    // Convert 1-indexed weekday order to 0-indexed grid column.
    final startOffset = firstNsoDay.weekday.order - 1;

    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 8,
        childAspectRatio: 0.9,
      ),
      itemCount: startOffset + dates.length,
      itemBuilder: (context, index) {
        if (index < startOffset) {
          // Empty leading cells before the month starts.
          return const SizedBox.shrink();
        }
        final nsoDate = dates[index - startOffset];
        final gregorianDay = index - startOffset + 1;
        final isToday = nsoDate == today;
        return NsoDayCell(
          nsoDate: nsoDate,
          gregorianDay: gregorianDay,
          isToday: isToday,
        );
      },
    );
  }
}
