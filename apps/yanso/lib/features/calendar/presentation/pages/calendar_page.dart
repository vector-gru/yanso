import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:nso_calendar/nso_calendar.dart';

// nso_calendar re-exports nsoMonthForGregorianMonth — no extra import needed.

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_theme.dart';
import '../../domain/calendar_providers.dart';
import '../widgets/cultural_objects_banner.dart';
import '../widgets/nso_day_cell.dart';
import '../widgets/nso_weekday_header.dart';

/// The main calendar screen — Phase 1.
///
/// Layout (top → bottom):
///   1. AppBar  — "Ya Nso'" title
///   2. Today banner — current Nso date
///   3. Month navigation — "Tònŋkin (August) 2026"
///   4. Weekday header row (8 columns)
///   5. Calendar grid (8-column, scrollable)
class CalendarPage extends ConsumerWidget {
  const CalendarPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final today = ref.watch(todayNsoDateProvider);
    final viewMonth = ref.watch(calendarViewMonthProvider);
    final notifier = ref.read(calendarViewMonthProvider.notifier);
    final yc = Theme.of(context).extension<YansoColors>()!;

    return Scaffold(
      // Kente-stripe bottom navigation hint
      appBar: AppBar(
        title: const Text("Ya Nso'"),
        actions: [
          IconButton(
            icon: const Icon(Icons.today_rounded),
            tooltip: 'Go to today',
            onPressed: notifier.goToToday,
          ),
          _OverflowMenu(),
        ],
      ),
      body: Column(
        children: [
          _TodayBanner(today: today, yc: yc),
          _MonthNavigationBar(
            viewMonth: viewMonth,
            onPrevious: notifier.goToPreviousMonth,
            onNext: notifier.goToNextMonth,
          ),
          // Thin kente accent line above the header
          _KenteRuler(yc: yc),
          const NsoWeekdayHeader(),
          Expanded(
            child: _CalendarGrid(viewMonth: viewMonth, today: today),
          ),
          // Cultural objects decorative strip
          const CulturalObjectsBanner(),
          // Legend
          _RestDayLegend(yc: yc),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Today banner
// ---------------------------------------------------------------------------

class _TodayBanner extends StatelessWidget {
  const _TodayBanner({required this.today, required this.yc});

  final NsoDate today;
  final YansoColors yc;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [yc.kenteStripe2, yc.kenteStripe2.withValues(alpha: 0.85)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Lán ei nsài Nso' (Today in Nso')",
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: Colors.white.withValues(alpha: 0.8),
                    letterSpacing: 1,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  today.toDisplayString(),
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          // Rest-day badge on today's banner if applicable
          if (today.weekday.isRestDay == true)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('🌙', style: TextStyle(fontSize: 12)),
                  SizedBox(width: 4),
                  Text(
                    'Rest day',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Kente ruler
// ---------------------------------------------------------------------------

class _KenteRuler extends StatelessWidget {
  const _KenteRuler({required this.yc});
  final YansoColors yc;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 4,
      child: Row(
        children: [
          Expanded(child: ColoredBox(color: yc.kenteStripe1)),
          Expanded(child: ColoredBox(color: yc.kenteStripe2)),
          Expanded(child: ColoredBox(color: yc.kenteStripe3)),
          Expanded(child: ColoredBox(color: yc.kenteStripe1)),
          Expanded(child: ColoredBox(color: yc.kenteStripe2)),
          Expanded(child: ColoredBox(color: yc.kenteStripe3)),
          Expanded(child: ColoredBox(color: yc.kenteStripe1)),
          Expanded(child: ColoredBox(color: yc.kenteStripe2)),
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
    final theme = Theme.of(context);
    // Show the Nso month name first, then the Gregorian month in parentheses.
    // e.g. "Tònŋkin (August) 2026"
    final nsoMonth = nsoMonthForGregorianMonth(viewMonth.month);
    final gregorianMonthName = DateFormat('MMMM').format(viewMonth);
    final label = '${nsoMonth.name} ($gregorianMonthName) ${viewMonth.year}';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded),
            onPressed: onPrevious,
            tooltip: 'Previous month',
          ),
          Flexible(
            child: Text(
              label,
              style: theme.textTheme.titleSmall?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 0.2,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded),
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

class _CalendarGrid extends ConsumerWidget {
  const _CalendarGrid({required this.viewMonth, required this.today});

  final DateTime viewMonth;
  final NsoDate today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dates = ref.watch(calendarDatesForMonthProvider);
    final yc = Theme.of(context).extension<YansoColors>()!;

    // The first column offset is determined by the Nso weekday of the 1st.
    final firstDayOfMonth = DateTime(viewMonth.year, viewMonth.month, 1);
    final firstNsoDay = NsoCalendar.fromGregorian(firstDayOfMonth);
    final startOffset = firstNsoDay.weekday.order - 1;

    return Container(
      // Subtle radial gradient background
      decoration: BoxDecoration(
        gradient: RadialGradient(
          center: Alignment.topCenter,
          radius: 1.4,
          colors: [
            yc.calendarBackground.withValues(alpha: 0.95),
            yc.calendarBackground,
          ],
        ),
      ),
      child: GridView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 8,
          childAspectRatio: 0.82,
        ),
        itemCount: startOffset + dates.length,
        itemBuilder: (context, index) {
          if (index < startOffset) {
            return const SizedBox.shrink();
          }
          final dateIndex = index - startOffset;
          final nsoDate = dates[dateIndex];
          final gregorianDate = DateTime(
            viewMonth.year,
            viewMonth.month,
            dateIndex + 1,
          );
          final isToday = nsoDate == today;

          return NsoDayCell(
            nsoDate: nsoDate,
            gregorianDate: gregorianDate,
            isToday: isToday,
          );
        },
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Rest-day legend
// ---------------------------------------------------------------------------

class _RestDayLegend extends StatelessWidget {
  const _RestDayLegend({required this.yc});
  final YansoColors yc;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _LegendItem(
            color: yc.cellMarketDay,
            label: 'Market day  (Kaavi)',
            icon: '🧺',
            textColor: yc.marketDayHeaderText,
          ),
          const SizedBox(width: 16),
          _LegendItem(
            color: yc.cellRestDay,
            label: 'Rest day  (Kiloovəy, ŋgoilum)',
            icon: '🌙',
            textColor: yc.restDayHeaderText,
          ),
          const SizedBox(width: 16),
          _LegendItem(
            color: yc.cellTodayBorder,
            label: 'Today',
            icon: '◉',
            textColor: yc.cellTodayBorder,
          ),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  const _LegendItem({
    required this.color,
    required this.label,
    required this.icon,
    required this.textColor,
  });

  final Color color;
  final String label;
  final String icon;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(icon, style: TextStyle(fontSize: 11, color: color)),
        const SizedBox(width: 5),
        Text(
          label,
          style: Theme.of(
            context,
          ).textTheme.labelSmall?.copyWith(color: textColor, fontSize: 10),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Shared overflow menu (Culture, Settings)
// ---------------------------------------------------------------------------

class _OverflowMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      icon: const Icon(Icons.more_vert),
      onSelected: (value) => context.goNamed(value),
      itemBuilder: (_) => const [
        PopupMenuItem(
          value: AppRoutes.cultureName,
          child: Row(
            children: [
              Icon(Icons.account_balance_outlined, size: 18),
              SizedBox(width: 10),
              Text('Culture'),
            ],
          ),
        ),
        PopupMenuItem(
          value: AppRoutes.settingsName,
          child: Row(
            children: [
              Icon(Icons.settings_outlined, size: 18),
              SizedBox(width: 10),
              Text('Settings'),
            ],
          ),
        ),
      ],
    );
  }
}
