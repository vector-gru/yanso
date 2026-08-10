import 'package:flutter/material.dart';

/// Culture feature — Phase 2 placeholder.
///
/// Will contain:
/// - Traditional rest days
/// - Cultural events and festivals
/// - Lamnso terminology
/// - Cultural explanations with source citations
class CulturePage extends StatelessWidget {
  const CulturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Culture')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.account_balance_outlined,
              size: 48,
              color: Theme.of(context).colorScheme.outline,
            ),
            const SizedBox(height: 16),
            Text(
              'Cultural content — Phase 2',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 8),
            Text(
              'Traditional events, rest days, and Lamnso terminology\n'
              'will appear here once the calendar engine is verified.',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
