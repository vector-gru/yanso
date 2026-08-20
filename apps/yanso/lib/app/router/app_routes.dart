/// Central registry of all route paths and named-route identifiers.
abstract final class AppRoutes {
  AppRoutes._();

  /// Calendar shell (month + year tabs). This is the initial route.
  static const String calendar = '/';
  static const String calendarName = 'calendar';

  /// Full absolute paths (used with context.go / GoRouter.of).
  static const String culture = '/culture';
  static const String settings = '/settings';

  /// Relative path segments — used when declaring sub-routes under [calendar].
  static const String culturePath = 'culture';
  static const String settingsPath = 'settings';

  /// Named route identifiers — used with context.goNamed / context.pushNamed.
  static const String cultureName = 'culture';
  static const String settingsName = 'settings';
}
