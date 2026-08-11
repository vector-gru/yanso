/// Central registry of all route paths and named-route identifiers.
abstract final class AppRoutes {
  AppRoutes._();

  /// Calendar shell (month + year tabs). This is the initial route.
  static const String calendar = '/';
  static const String calendarName = 'calendar';

  static const String culture = '/culture';
  static const String cultureName = 'culture';

  static const String settings = '/settings';
  static const String settingsName = 'settings';
}
