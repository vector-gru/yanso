import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/theme/app_theme.dart';
import '../../domain/calendar_providers.dart';
import 'calendar_page.dart';
import 'year_page.dart';

/// Root shell for the calendar feature.
///
/// Hosts the month view and the year view inside an [IndexedStack] so both
/// pages maintain their scroll/state when switching tabs. A themed
/// [BottomNavigationBar] switches between the two views.
///
/// Culture and Settings are accessed via the AppBar overflow menu, keeping
/// the bottom bar focused on the calendar itself.
class CalendarShell extends ConsumerWidget {
  const CalendarShell({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tabIndex = ref.watch(calendarTabIndexProvider);
    final yc = Theme.of(context).extension<YansoColors>()!;
    final theme = Theme.of(context);

    return Scaffold(
      // IndexedStack keeps both pages alive so state is preserved
      // when toggling between month and year.
      body: IndexedStack(
        index: tabIndex,
        children: const [CalendarPage(), YearPage()],
      ),
      bottomNavigationBar: _CalendarBottomBar(
        currentIndex: tabIndex,
        onTap: (i) => ref.read(calendarTabIndexProvider.notifier).state = i,
        yc: yc,
        theme: theme,
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Themed bottom navigation bar
// ---------------------------------------------------------------------------

class _CalendarBottomBar extends StatelessWidget {
  const _CalendarBottomBar({
    required this.currentIndex,
    required this.onTap,
    required this.yc,
    required this.theme,
  });

  final int currentIndex;
  final ValueChanged<int> onTap;
  final YansoColors yc;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withValues(alpha: 0.25),
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.12),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              _BarItem(
                icon: Icons.calendar_month_rounded,
                label: 'ŋwəə (Month)',
                selected: currentIndex == 0,
                onTap: () => onTap(0),
                yc: yc,
                theme: theme,
              ),
              // Decorative kente-stripe divider between tabs
              SizedBox(
                height: 36,
                width: 2,
                child: Column(
                  children: [
                    Expanded(child: ColoredBox(color: yc.kenteStripe1)),
                    Expanded(child: ColoredBox(color: yc.kenteStripe2)),
                    Expanded(child: ColoredBox(color: yc.kenteStripe3)),
                  ],
                ),
              ),
              _BarItem(
                icon: Icons.calendar_view_month_rounded,
                label: 'Kiya (Year)',
                selected: currentIndex == 1,
                onTap: () => onTap(1),
                yc: yc,
                theme: theme,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BarItem extends StatelessWidget {
  const _BarItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.yc,
    required this.theme,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final YansoColors yc;
  final ThemeData theme;

  @override
  Widget build(BuildContext context) {
    final activeColor = yc.kenteStripe2; // terracotta
    final inactiveColor = theme.colorScheme.onSurfaceVariant;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Pill indicator above the icon when selected
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                height: 3,
                width: selected ? 28 : 0,
                margin: const EdgeInsets.only(bottom: 6),
                decoration: BoxDecoration(
                  color: activeColor,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              Icon(
                icon,
                size: 22,
                color: selected ? activeColor : inactiveColor,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                  color: selected ? activeColor : inactiveColor,
                  letterSpacing: 0.2,
                ),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
