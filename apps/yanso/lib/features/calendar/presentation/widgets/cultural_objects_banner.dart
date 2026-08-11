import 'package:flutter/material.dart';

import '../../../../app/theme/app_theme.dart';

/// A decorative banner shown just below the calendar grid.
///
/// Displays the two iconic Nso cultural objects side-by-side:
///   • A traditional iron double-gong (nkap) with its striking stick.
///   • A handful of pink kola nuts (gifting, welcome, ceremony).
///
/// Images are real photographs with transparent backgrounds,
/// sourced from the project owner.
class CulturalObjectsBanner extends StatelessWidget {
  const CulturalObjectsBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final yc = Theme.of(context).extension<YansoColors>()!;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF241408) : const Color(0xFFF0E4CC);

    return Container(
      height: 130,
      color: bg,
      child: Row(
        children: [
          // ── Gong ──────────────────────────────────────────────────────────
          Expanded(
            child: _CulturalItem(
              imagePath: 'assets/images/gong.png',
              label: 'Nso double-gong',
              yc: yc,
            ),
          ),

          // ── Divider ───────────────────────────────────────────────────────
          Container(
            width: 1,
            margin: const EdgeInsets.symmetric(vertical: 20),
            color: yc.kenteStripe2.withValues(alpha: 0.35),
          ),

          // ── Kola nuts ─────────────────────────────────────────────────────
          Expanded(
            child: _CulturalItem(
              imagePath: 'assets/images/cola_nut.png',
              label: 'Kola nuts',
              yc: yc,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Single item cell
// ---------------------------------------------------------------------------

class _CulturalItem extends StatelessWidget {
  const _CulturalItem({
    required this.imagePath,
    required this.label,
    required this.yc,
  });

  final String imagePath;
  final String label;
  final YansoColors yc;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final labelColor = isDark
        ? const Color(0xFFBFAE96)
        : const Color(0xFF5A3A20);

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 4),
            child: Image.asset(
              imagePath,
              fit: BoxFit.contain,
              filterQuality: FilterQuality.medium,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Text(
            label,
            style: TextStyle(
              color: labelColor,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
      ],
    );
  }
}
