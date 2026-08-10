import 'package:flutter/material.dart';

/// Settings feature — Phase 1 placeholder.
///
/// Will eventually contain:
/// - Language selection (Lamnso / English)
/// - Calendar display preferences
/// - About / credits / source attribution
/// - Contribution information
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        children: [
          const _SettingsSection(title: 'About'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text("Ya Nso'"),
            subtitle: Text('Version 0.1.0 — Phase 1'),
          ),
          const ListTile(
            leading: Icon(Icons.source_outlined),
            title: Text('Research sources'),
            subtitle: Text(
              'Calendar data is being verified against Nso sources.',
            ),
          ),
          const _SettingsSection(title: 'Language'),
          const ListTile(
            leading: Icon(Icons.language),
            title: Text('Interface language'),
            subtitle: Text('English — Lamnso coming in Phase 4'),
            enabled: false,
          ),
        ],
      ),
    );
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(
        title.toUpperCase(),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
