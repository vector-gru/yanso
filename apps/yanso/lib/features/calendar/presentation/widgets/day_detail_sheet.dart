import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:nso_calendar/nso_calendar.dart';

import '../../../../app/theme/app_theme.dart';

/// Shows the day detail bottom sheet for a tapped calendar cell.
///
/// Call [DayDetailSheet.show] from a cell's tap handler.
/// The sheet animates upward using [DraggableScrollableSheet] and is
/// visually connected to the tapped cell via a shared [Hero] tag.
abstract final class DayDetailSheet {
  static void show({
    required BuildContext context,
    required NsoDate nsoDate,
    required DateTime gregorianDate,
    required String heroTag,
  }) {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.6),
      builder: (_) => _DayDetailSheet(
        nsoDate: nsoDate,
        gregorianDate: gregorianDate,
        heroTag: heroTag,
      ),
    );
  }
}

class _DayDetailSheet extends StatelessWidget {
  const _DayDetailSheet({
    required this.nsoDate,
    required this.gregorianDate,
    required this.heroTag,
  });

  final NsoDate nsoDate;
  final DateTime gregorianDate;
  final String heroTag;

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.55,
      minChildSize: 0.35,
      maxChildSize: 0.92,
      snap: true,
      snapSizes: const [0.55, 0.92],
      builder: (context, scrollController) {
        return Hero(
          tag: heroTag,
          flightShuttleBuilder: (_, animation, _, _, _) => _SheetShell(
            nsoDate: nsoDate,
            gregorianDate: gregorianDate,
            scrollController: scrollController,
            animation: animation,
          ),
          child: _SheetShell(
            nsoDate: nsoDate,
            gregorianDate: gregorianDate,
            scrollController: scrollController,
          ),
        );
      },
    );
  }
}

// ---------------------------------------------------------------------------
// The actual sheet content
// ---------------------------------------------------------------------------

class _SheetShell extends StatelessWidget {
  const _SheetShell({
    required this.nsoDate,
    required this.gregorianDate,
    required this.scrollController,
    this.animation,
  });

  final NsoDate nsoDate;
  final DateTime gregorianDate;
  final ScrollController scrollController;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    final yc = Theme.of(context).extension<YansoColors>()!;
    final theme = Theme.of(context);
    final weekday = nsoDate.weekday;
    final isRestDay = weekday.isRestDay == true;

    return Material(
      color: Colors.transparent,
      child: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.4),
              blurRadius: 24,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: Column(
          children: [
            // Drag handle
            _DragHandle(color: yc.sheetHandle),

            // Kente stripe header
            _KenteHeader(yc: yc, isRestDay: isRestDay),

            // Scrollable body
            Expanded(
              child: ListView(
                controller: scrollController,
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                children: [
                  _DayTitleRow(
                    nsoDate: nsoDate,
                    gregorianDate: gregorianDate,
                    isRestDay: isRestDay,
                    yc: yc,
                  ),
                  const SizedBox(height: 20),
                  _DateInfoCard(nsoDate: nsoDate, gregorianDate: gregorianDate),
                  const SizedBox(height: 16),
                  if (weekday.culturalMeaning != null) ...[
                    _CulturalMeaningCard(weekday: weekday),
                    const SizedBox(height: 16),
                  ],
                  _AudioButton(weekday: weekday),
                  const SizedBox(height: 16),
                  if (weekday.isMarketDay == true &&
                      weekday.marketInfo != null) ...[
                    _MarketInfoCard(marketInfo: weekday.marketInfo!),
                    const SizedBox(height: 16),
                  ],
                  _CulturalEventsCard(
                    nsoDate: nsoDate,
                    gregorianDate: gregorianDate,
                  ),
                  const SizedBox(height: 16),
                  if (weekday.alternateNames.isNotEmpty)
                    _AlternateNamesCard(weekday: weekday),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Sub-widgets
// ---------------------------------------------------------------------------

class _DragHandle extends StatelessWidget {
  const _DragHandle({required this.color});
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 4),
      child: Center(
        child: Container(
          width: 40,
          height: 4,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ),
    );
  }
}

/// Three horizontal kente stripes at the top of the sheet.
class _KenteHeader extends StatelessWidget {
  const _KenteHeader({required this.yc, required this.isRestDay});
  final YansoColors yc;
  final bool isRestDay;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 6,
      child: Row(
        children: [
          Expanded(child: ColoredBox(color: yc.kenteStripe1)),
          Expanded(child: ColoredBox(color: yc.kenteStripe2)),
          Expanded(
            child: ColoredBox(
              color: isRestDay ? yc.cellRestDayBadge : yc.kenteStripe3,
            ),
          ),
        ],
      ),
    );
  }
}

class _DayTitleRow extends StatelessWidget {
  const _DayTitleRow({
    required this.nsoDate,
    required this.gregorianDate,
    required this.isRestDay,
    required this.yc,
  });

  final NsoDate nsoDate;
  final DateTime gregorianDate;
  final bool isRestDay;
  final YansoColors yc;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    // e.g. "Monday"
    final gregWeekdayName = DateFormat('EEEE').format(gregorianDate);

    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full Nso day name + Gregorian weekday in parentheses
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: nsoDate.weekday.name,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: theme.colorScheme.onSurface,
                    letterSpacing: 0.3,
                  ),
                ),
                TextSpan(
                  text: '  ($gregWeekdayName)',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // Badges row
          Wrap(
            spacing: 8,
            runSpacing: 6,
            children: [
              if (isRestDay)
                _Badge(
                  icon: '🌙',
                  label: 'Rest day',
                  backgroundColor: yc.cellRestDay,
                  textColor: yc.cellRestDayText,
                ),
              if (nsoDate.weekday.isMarketDay == true)
                _Badge(
                  icon: '🧺',
                  label: 'Market day',
                  backgroundColor: yc.cellMarketDay,
                  textColor: yc.cellMarketDayText,
                ),
              _Badge(
                icon: '📅',
                label: DateFormat('d MMMM yyyy').format(gregorianDate),
                backgroundColor: theme.colorScheme.surfaceContainerHighest,
                textColor: theme.colorScheme.onSurfaceVariant,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
  });

  final String icon;
  final String label;
  final Color backgroundColor;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(icon, style: const TextStyle(fontSize: 12)),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _DateInfoCard extends StatelessWidget {
  const _DateInfoCard({required this.nsoDate, required this.gregorianDate});

  final NsoDate nsoDate;
  final DateTime gregorianDate;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Date',
      child: Column(
        children: [
          _InfoRow(label: 'Nso date', value: nsoDate.toDisplayString()),
          _InfoRow(
            label: 'Gregorian',
            value: DateFormat('EEEE, d MMMM yyyy').format(gregorianDate),
          ),
          _InfoRow(
            label: 'Nso month',
            value:
                '${nsoDate.month.name} (${DateFormat('MMMM').format(gregorianDate)})',
          ),
          _InfoRow(
            label: 'Nso year',
            value: '${nsoDate.nsoYear}',
            isLast: true,
          ),
        ],
      ),
    );
  }
}

class _CulturalMeaningCard extends StatelessWidget {
  const _CulturalMeaningCard({required this.weekday});
  final NsoWeekday weekday;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Cultural meaning',
      child: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 8),
        child: Text(
          weekday.culturalMeaning!,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

class _AudioButton extends StatelessWidget {
  const _AudioButton({required this.weekday});
  final NsoWeekday weekday;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final yc = theme.extension<YansoColors>()!;

    return InkWell(
      onTap: () {
        // TODO(phase4): play audio pronunciation from assets/audio/
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Audio pronunciation for "${weekday.name}" coming in Phase 4.',
              style: const TextStyle(fontSize: 13),
            ),
            behavior: SnackBarBehavior.floating,
            backgroundColor: theme.colorScheme.surfaceContainerHighest,
            duration: const Duration(seconds: 2),
          ),
        );
      },
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: yc.kenteStripe2.withValues(alpha: 0.4)),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: yc.kenteStripe2,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.volume_up_rounded,
                color: Colors.white,
                size: 22,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Hear the pronunciation',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    weekday.name,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ],
              ),
            ),
            Icon(
              Icons.chevron_right,
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }
}

class _MarketInfoCard extends StatelessWidget {
  const _MarketInfoCard({required this.marketInfo});
  final NsoMarketInfo marketInfo;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final yc = theme.extension<YansoColors>()!;

    return Container(
      decoration: BoxDecoration(
        color: yc.cellMarketDay,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: yc.cellMarketDayBadge.withValues(alpha: 0.4)),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text('🧺', style: TextStyle(fontSize: 18)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        marketInfo.marketName,
                        style: theme.textTheme.titleMedium?.copyWith(
                          color: yc.cellMarketDayText,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      Text(
                        '${marketInfo.locationNso} · ${marketInfo.locationEnglish}',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: yc.cellMarketDayText.withValues(alpha: 0.75),
                        ),
                      ),
                    ],
                  ),
                ),
                if (marketInfo.isMainMarket)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: yc.cellMarketDayBadge,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Text(
                      'Main market',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              marketInfo.description,
              style: theme.textTheme.bodySmall?.copyWith(
                color: yc.cellMarketDayText.withValues(alpha: 0.85),
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CulturalEventsCard extends StatelessWidget {
  const _CulturalEventsCard({
    required this.nsoDate,
    required this.gregorianDate,
  });

  final NsoDate nsoDate;
  final DateTime gregorianDate;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final yc = theme.extension<YansoColors>()!;

    // Phase 1: no event data yet. Shown as a clearly-labelled placeholder.
    return _SectionCard(
      title: 'Cultural events',
      trailing: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: yc.unverifiedBadge,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Text(
          'Phase 2',
          style: theme.textTheme.labelSmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 8),
        child: Text(
          'Traditional events, festivals, and cultural observances for this '
          'day will appear here in Phase 2 once the cultural dataset '
          'has been verified.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
            fontStyle: FontStyle.italic,
            height: 1.5,
          ),
        ),
      ),
    );
  }
}

class _AlternateNamesCard extends StatelessWidget {
  const _AlternateNamesCard({required this.weekday});
  final NsoWeekday weekday;

  @override
  Widget build(BuildContext context) {
    return _SectionCard(
      title: 'Also known as',
      child: Padding(
        padding: const EdgeInsets.only(top: 4, bottom: 8),
        child: Wrap(
          spacing: 8,
          runSpacing: 6,
          children: weekday.alternateNames
              .map(
                (name) => Chip(
                  label: Text(name),
                  labelStyle: TextStyle(
                    fontSize: 12,
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
                  backgroundColor: Theme.of(
                    context,
                  ).colorScheme.surfaceContainerHighest,
                  side: BorderSide.none,
                  padding: EdgeInsets.zero,
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Shared card + row components
// ---------------------------------------------------------------------------

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.child, this.trailing});

  final String title;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  title.toUpperCase(),
                  style: theme.textTheme.labelSmall?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.2,
                  ),
                ),
                if (trailing != null) ...[const Spacer(), trailing!],
              ],
            ),
            const SizedBox(height: 4),
            child,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                child: Text(
                  label,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              Expanded(
                child: Text(
                  value,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            height: 1,
            color: theme.colorScheme.outline.withValues(alpha: 0.3),
          ),
      ],
    );
  }
}
