import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/calendar/presentation/pages/calendar_page.dart';
import '../../features/culture/presentation/pages/culture_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

import 'app_routes.dart';

export 'app_routes.dart';

/// Riverpod provider for the app's [GoRouter] instance.
///
/// Centralising the router in a provider makes it easy to watch auth state,
/// locale changes, or other conditions that should trigger redirects.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.calendar,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: AppRoutes.calendar,
        name: AppRoutes.calendarName,
        builder: (context, state) => const CalendarPage(),
      ),
      GoRoute(
        path: AppRoutes.culture,
        name: AppRoutes.cultureName,
        builder: (context, state) => const CulturePage(),
      ),
      GoRoute(
        path: AppRoutes.settings,
        name: AppRoutes.settingsName,
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );
});
