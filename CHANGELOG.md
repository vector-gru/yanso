# Changelog

All notable changes to Yanso are documented here.

The format follows [Keep a Changelog](https://keepachangelog.com/en/1.0.0/).
Versioning follows [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

---

## [Unreleased]

### Added
- Monorepo structure: `apps/yanso` (Flutter app) and `packages/nso_calendar` (Dart domain package).
- `nso_calendar` package: `NsoWeekday`, `NsoMonth`, `NsoDate`, `NsoCalendar`, `NsoDateConversion`.
- Eight-day Nso week cycle (`kNsoWeekdays`) with Lamnso names from Phase 1 research.
- Twelve Lamnso months (`kNsoMonths`) with `DataVerificationStatus` tracking.
- Gregorian → Nso and Nso → Gregorian date conversion engine (Phase 1 working model).
- 44 unit tests covering weekday cycle, month data, conversion structural properties, round-trips, and navigation.
- Verified reference dates test group (skipped pending anchor confirmation).
- Flutter app: `main.dart`, `YansoApp`, Riverpod `ProviderScope`.
- go_router navigation: Calendar, Culture, Settings routes.
- Material 3 theme with Yanso colour extensions (`YansoColors`).
- Calendar feature: `CalendarPage`, `NsoDayCell`, `NsoWeekdayHeader`, `CalendarViewNotifier`.
- GitHub Actions CI: `analyze`, `test` (nso_calendar), Flutter build check.
- Research provenance skeleton: `docs/research/calendar_sources.md`, `docs/research/open_questions.md`.
- `CONTRIBUTING.md` with code and cultural contribution guidelines.

### Notes
- The calendar conversion anchor date and year epoch are **unverified placeholders**.
  The "Verified reference dates" test group must pass before results can be trusted.
  See `docs/research/open_questions.md` for the verification checklist.

---

## How versions work

- **0.x.y** — pre-release, active research and development.
- **1.0.0** — first stable release, requires verified calendar conversion.

Separate `CHANGELOG` entries exist for `packages/nso_calendar` (the Dart package)
because it will eventually be published independently.
