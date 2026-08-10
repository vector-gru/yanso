# Architecture Overview

## Repository layout

```
yanso/
├── apps/
│   └── yanso/                  # Flutter application
│       ├── lib/
│       │   ├── app/            # App shell, router, theme
│       │   ├── core/           # Constants, extensions, utils, errors
│       │   ├── features/       # Feature modules (calendar, culture, settings)
│       │   └── shared/         # Shared widgets and models
│       └── test/
│
├── packages/
│   └── nso_calendar/           # Standalone Dart calendar engine
│       ├── lib/src/
│       │   ├── nso_weekday.dart
│       │   ├── nso_month.dart
│       │   ├── nso_date.dart
│       │   ├── conversion.dart
│       │   └── calendar.dart
│       └── test/
│
├── docs/
│   ├── research/               # Sources and open questions
│   ├── calendar/               # Calendar specification
│   └── architecture/           # This document
│
└── .github/
    ├── workflows/ci.yml
    ├── ISSUE_TEMPLATE/
    └── pull_request_template.md
```

## Dependency rule

```
apps/yanso  →  packages/nso_calendar  →  (no dependencies)
```

`nso_calendar` has zero runtime dependencies. It is pure Dart and must
stay that way so it can be published independently to pub.dev.

`apps/yanso` depends on `nso_calendar` via a local path reference.
It also depends on `flutter_riverpod`, `go_router`, and `intl`.

## Data flow

```
DateTime (Gregorian)
    │
    ▼
NsoDateConversion.fromGregorian()   [packages/nso_calendar]
    │
    ▼
NsoDate { weekday, month, dayOfMonth, nsoYear }
    │
    ▼
Riverpod providers                  [apps/yanso/features/calendar/domain]
    │
    ▼
CalendarPage / NsoDayCell           [apps/yanso/features/calendar/presentation]
```

## State management

Riverpod is used for all state. The calendar feature uses:

- `todayNsoDateProvider` — today's Nso date (simple sync provider)
- `calendarViewMonthProvider` — which Gregorian month is displayed
- `calendarDatesForMonthProvider` — derived: all Nso dates for the viewed month
- `nsoWeekdaysProvider` / `nsoMonthsProvider` — static data providers

No async providers or databases are used in Phase 1.

## Navigation

go_router manages all navigation. Routes are defined in `app/router/app_router.dart`
and named constants live in `app/router/app_routes.dart`.

Phase 1 routes: `/` (Calendar), `/culture`, `/settings`.
