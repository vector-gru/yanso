import 'package:flutter/material.dart';
import 'package:nso_calendar/nso_calendar.dart';

import '../../../../app/theme/app_theme.dart';
import 'day_detail_sheet.dart';

/// A single cell in the Nso calendar month grid.
///
/// Visual states:
///   • Default       — warm brown card
///   • Rest day      — indigo-clay tint + crescent moon badge
///   • Today         — dark background + kente-gold border and text
///
/// Tapping the cell opens [DayDetailSheet] with an animated Hero transition.
class NsoDayCell extends StatelessWidget {
  const NsoDayCell({
    super.key,
    required this.nsoDate,
    required this.gregorianDate,
    required this.isToday,
  });

  final NsoDate nsoDate;
  final DateTime gregorianDate;
  final bool isToday;

  String get _heroTag =>
      'day-cell-${gregorianDate.year}-${gregorianDate.month}-${gregorianDate.day}';

  @override
  Widget build(BuildContext context) {
    final yc = Theme.of(context).extension<YansoColors>()!;
    final isRestDay = nsoDate.weekday.isRestDay == true;
    final isMarketDay = nsoDate.weekday.isMarketDay == true;

    final bgColor = isToday
        ? yc.cellToday
        : isMarketDay
        ? yc.cellMarketDay
        : isRestDay
        ? yc.cellRestDay
        : yc.cellDefault;

    final textColor = isToday
        ? yc.cellTodayText
        : isMarketDay
        ? yc.cellMarketDayText
        : isRestDay
        ? yc.cellRestDayText
        : yc.cellDefaultText;

    return Hero(
      tag: _heroTag,
      // Keep the Hero child a plain box so the flight animation is clean.
      flightShuttleBuilder: (_, animation, _, _, _) => _CellBox(
        bgColor: bgColor,
        textColor: textColor,
        isToday: isToday,
        isRestDay: isRestDay,
        isMarketDay: isMarketDay,
        nsoDate: nsoDate,
        gregorianDate: gregorianDate,
        yc: yc,
        animation: animation,
      ),
      child: GestureDetector(
        onTap: () => DayDetailSheet.show(
          context: context,
          nsoDate: nsoDate,
          gregorianDate: gregorianDate,
          heroTag: _heroTag,
        ),
        child: _CellBox(
          bgColor: bgColor,
          textColor: textColor,
          isToday: isToday,
          isRestDay: isRestDay,
          isMarketDay: isMarketDay,
          nsoDate: nsoDate,
          gregorianDate: gregorianDate,
          yc: yc,
        ),
      ),
    );
  }
}

class _CellBox extends StatelessWidget {
  const _CellBox({
    required this.bgColor,
    required this.textColor,
    required this.isToday,
    required this.isRestDay,
    required this.isMarketDay,
    required this.nsoDate,
    required this.gregorianDate,
    required this.yc,
    this.animation,
  });

  final Color bgColor;
  final Color textColor;
  final bool isToday;
  final bool isRestDay;
  final bool isMarketDay;
  final NsoDate nsoDate;
  final DateTime gregorianDate;
  final YansoColors yc;
  final Animation<double>? animation;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
        border: isToday
            ? Border.all(color: yc.cellTodayBorder, width: 2)
            : null,
        boxShadow: isToday
            ? [
                BoxShadow(
                  color: yc.cellTodayBorder.withValues(alpha: 0.4),
                  blurRadius: 6,
                  spreadRadius: 1,
                ),
              ]
            : null,
      ),
      child: Stack(
        children: [
          // Main content: day number + Nso weekday short name
          Positioned.fill(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '${gregorianDate.day}',
                  style: TextStyle(
                    color: textColor,
                    fontSize: 14,
                    fontWeight: isToday ? FontWeight.w800 : FontWeight.w600,
                    height: 1.1,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  nsoDate.weekday.shortName,
                  style: TextStyle(
                    color: textColor.withValues(alpha: 0.65),
                    fontSize: 8,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                  ),
                ),
              ],
            ),
          ),
          // Badge: market basket for market days, crescent for rest days
          if (isMarketDay)
            Positioned(
              top: 3,
              right: 3,
              child: Text(
                '🧺',
                style: TextStyle(fontSize: 8, color: yc.cellMarketDayBadge),
              ),
            )
          else if (isRestDay)
            Positioned(
              top: 3,
              right: 3,
              child: Text(
                '🌙',
                style: TextStyle(fontSize: 8, color: yc.cellRestDayBadge),
              ),
            ),
        ],
      ),
    );
  }
}
