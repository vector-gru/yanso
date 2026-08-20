import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../features/calendar/presentation/pages/calendar_shell.dart';
import '../../features/culture/presentation/pages/culture_page.dart';
import '../../features/settings/presentation/pages/settings_page.dart';

import 'app_routes.dart';

export 'app_routes.dart';

/// Riverpod provider for the app's [GoRouter] instance.
final appRouterProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    initialLocation: AppRoutes.calendar,
    debugLogDiagnostics: false,
    routes: [
      GoRoute(
        path: AppRoutes.calendar,
        name: AppRoutes.calendarName,
        // CalendarShell hosts both month and year views via IndexedStack.
        builder: (context, state) => const CalendarShell(),
        routes: [
          // Culture and Settings are sub-routes of the calendar so that
          // go_router places them on top of CalendarShell in the navigation
          // stack. This gives them a proper back arrow that pops to the
          // calendar rather than exiting the app.
          GoRoute(
            path: AppRoutes.culturePath,
            name: AppRoutes.cultureName,
            builder: (context, state) => const CulturePage(),
          ),
          GoRoute(
            path: AppRoutes.settingsPath,
            name: AppRoutes.settingsName,
            builder: (context, state) => const SettingsPage(),
          ),
        ],
      ),
    ],
  );
});
