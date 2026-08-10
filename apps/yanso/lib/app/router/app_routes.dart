/// Central registry of all route paths and named-route identifiers.
///
/// Using string constants avoids typos and makes it easy to find every
/// navigation call-site via IDE references.
abstract final class AppRoutes {
  AppRoutes._();

  static const String calendar = '/';
  static const String calendarName = 'calendar';

  static const String culture = '/culture';
  static const String cultureName = 'culture';

  static const String settings = '/settings';
  static const String settingsName = 'settings';
}
