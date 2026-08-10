# nso_calendar — Changelog

## [0.1.0] — Unreleased

### Added

- `NsoWeekday` — eight-day Nso week with `kNsoWeekdays` constant list.
- `NsoMonth` — twelve Lamnso months with `kNsoMonths` constant list.
- `DataVerificationStatus` enum — tracks cultural data accuracy.
- `NsoDate` — immutable Nso calendar date value type.
- `NsoDateConversion` — Gregorian ↔ Nso conversion engine (Phase 1 working model).
- `NsoCalendar` — high-level static API (`today()`, `fromGregorian()`, range helpers).
- 44 unit tests. Verified reference dates group skipped pending anchor confirmation.

### Notes

- Anchor date (`_kAnchorGregorianDate`) and year epoch (`_kNsoYearEpochGregorian`)
  are placeholders. See `conversion.dart` for details.
