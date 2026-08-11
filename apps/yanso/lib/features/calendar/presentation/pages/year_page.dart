import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:nso_calendar/nso_calendar.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/theme/app_theme.dart';
import '../../domain/calendar_providers.dart';
import '../widgets/mini_month_grid.dart';

/// The yearly calendar view.
///
/// Displays all 12 Nso months for the selected Gregorian year as a 2-column
/// grid of mini-month calendars. Each mini-month is tap-navigable: tapping
/// any month jumps the month view to that month and switches the tab back.
class YearPage extends ConsumerWidget {
  const YearPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final year = ref.watch(calendarViewYearProvider);
    final summaries = ref.watch(yearMonthSummariesProvider);
    final today = ref.watch(todayNsoDateProvider);
    final yearNotifier = ref.read(calendarViewYearProvider.notifier);
    final yc = Theme.of(context).extension<YansoColors>()!;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Ya Nso'"),
        actions: [
          IconButton(
            icon: const Icon(Icons.today_rounded),
            tooltip: 'Go to current year',
            onPressed: () {
              yearNotifier.goToCurrentYear();
              ref.read(calendarViewMonthProvider.notifier).goToToday();
            },
          ),
          _OverflowMenu(),
        ],
      ),
      body: Column(
        children: [
          // Year navigation bar
          _YearNavigationBar(
            year: year,
            onPrevious: yearNotifier.goToPreviousYear,
            onNext: yearNotifier.goToNextYear,
            yc: yc,
          ),
          // Kente ruler
          _KenteRuler(yc: yc),
          // 12 mini-months grid
          Expanded(
            child: _YearGrid(
              summaries: summaries,
              today: today,
              year: year,
              ref: ref,
            ),
          ),
          // Legend
          _YearLegend(yc: yc),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Year navigation bar
// ---------------------------------------------------------------------------

class _YearNavigationBar extends StatelessWidget {
  const _YearNavigationBar({
    required this.year,
    required this.onPrevious,
    required this.onNext,
    required this.yc,
  });

  final int year;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final YansoColors yc;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // Display the Gregorian year with the Nso calendar label.
    // e.g.  "2026  ·  Year of Ya Nso'"
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded),
            onPressed: onPrevious,
            tooltip: 'Previous year',
          ),
          Column(
            children: [
              Text(
                '$year',
                style: theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                ),
              ),
              Text(
                "Ya Nso' Calendar",
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded),
            onPressed: onNext,
            tooltip: 'Next year',
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Kente ruler (reused pattern from month view)
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
// 12-month grid
// ---------------------------------------------------------------------------

class _YearGrid extends StatelessWidget {
  const _YearGrid({
    required this.summaries,
    required this.today,
    required this.year,
    required this.ref,
  });

  final List<MonthSummary> summaries;
  final NsoDate today;
  final int year;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    final yc = Theme.of(context).extension<YansoColors>()!;

    return Container(
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
        padding: const EdgeInsets.fromLTRB(10, 10, 10, 4),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          // Aspect ratio tuned so 6 rows of tiny cells + header fit nicely.
          childAspectRatio: 1.05,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          final summary = summaries[index];
          return MiniMonthGrid(
            summary: summary,
            today: today,
            onMonthTap: () => _navigateToMonth(context, summary),
          );
        },
      ),
    );
  }

  void _navigateToMonth(BuildContext context, MonthSummary summary) {
    // Jump the month view to this month.
    ref
        .read(calendarViewMonthProvider.notifier)
        .goToMonth(summary.gregorianYear, summary.gregorianMonth);
    // Switch to the month tab.
    ref.read(calendarTabIndexProvider.notifier).state = 0;
  }
}

// ---------------------------------------------------------------------------
// Legend
// ---------------------------------------------------------------------------

class _YearLegend extends StatelessWidget {
  const _YearLegend({required this.yc});
  final YansoColors yc;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
          _LegendDot(color: yc.cellTodayBorder, label: 'Today'),
          const SizedBox(width: 14),
          _LegendDot(color: yc.cellMarketDay, label: 'Market (Kaavi)'),
          const SizedBox(width: 14),
          _LegendDot(color: yc.cellRestDay, label: 'Rest day'),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: theme.textTheme.labelSmall?.copyWith(
            fontSize: 10,
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// Overflow menu (Culture, Settings)
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
