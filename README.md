# Yanso

> **The Nso Calendar**

Yanso is an open-source Flutter project created to preserve, document, and promote the traditional calendar and cultural knowledge of the **Nso people of Cameroon**.

The project focuses on the traditional Nso system of timekeeping — the **eight-day week**, Lamnso month names, traditional days, cultural events, and other knowledge connected to the Nso understanding of time.

Yanso is more than a calendar app. It is a small digital effort to help keep Nso culture accessible to younger generations and to Nso people around the world.

**Current status:** Phase 1 — calendar engine development and research verification.

---

## Repository layout

```
yanso/
├── apps/
│   └── yanso/                   # Flutter application (Android, iOS, Web, macOS)
│
├── packages/
│   └── nso_calendar/            # Standalone Dart calendar engine
│                                # (no Flutter dependency — publishable to pub.dev)
│
├── docs/
│   ├── research/
│   │   ├── calendar_sources.md  # Source registry and provenance records
│   │   └── open_questions.md    # Unresolved research questions
│   ├── calendar/
│   │   └── nso_calendar_spec.md # Working calendar specification
│   └── architecture/
│       └── overview.md          # Technical architecture notes
│
├── .github/
│   ├── workflows/ci.yml         # GitHub Actions: analyze, test, build
│   ├── ISSUE_TEMPLATE/          # Bug, cultural correction, calendar verification
│   └── pull_request_template.md
│
├── analysis_options.yaml        # Shared lint rules
├── CHANGELOG.md
├── CONTRIBUTING.md
└── LICENSE
```

---

## The calendar engine

The Nso calendar engine lives in `packages/nso_calendar`.

It is a **pure Dart package** with no Flutter dependency. This means it can eventually be published as a standalone pub.dev package, so any Dart or Flutter project can use it:

```dart
import 'package:nso_calendar/nso_calendar.dart';

final today = NsoCalendar.today();
print(today.weekday.name);   // e.g. "Ntagrin"
print(today.month.name);     // e.g. "Mfiilum"
print(today.toDisplayString()); // e.g. "Ntagrin, 3 Mfiilum 1426"
```

### What is implemented

| Component                  | File                       | Status                                           |
| -------------------------- | -------------------------- | ------------------------------------------------ |
| 8-day Nso weekday cycle    | `lib/src/nso_weekday.dart` | Phase 1 data — needs verification                |
| 12 Lamnso months           | `lib/src/nso_month.dart`   | Phase 1 data — needs verification                |
| `NsoDate` value type       | `lib/src/nso_date.dart`    | Stable                                           |
| Gregorian ↔ Nso conversion | `lib/src/conversion.dart`  | Working model — anchor unverified                |
| High-level API             | `lib/src/calendar.dart`    | Stable                                           |
| Unit tests                 | `test/`                    | 44 passing, 1 skipped (verified reference dates) |

### Important: research status

The conversion algorithm uses a **placeholder anchor date** (2024-01-01 = Ntagrin).
This placeholder makes the weekday cycle structurally correct but potentially offset from the real Nso calendar.

The "Verified reference dates" test group in `test/conversion_test.dart` is intentionally **skipped** until a confirmed Gregorian ↔ Nso date pairing is obtained from a trusted source.

**Phase 1 is complete when that test group has at least one passing test.**

See `docs/research/open_questions.md` for the full checklist.

---

## The Nso eight-day week

| Order | Name     | Short |
| ----- | -------- | ----- |
| 1     | Ntagrin  | Ntg   |
| 2     | Kavi     | Kav   |
| 3     | Reeveiy  | Rev   |
| 4     | Kiloveiy | Kil   |
| 5     | Nseeri   | Nse   |
| 6     | Geeggee  | Gee   |
| 7     | Ngoilum  | Ngo   |
| 8     | Waiylun  | Wai   |

Spelling variations exist across sources. Yanso records alternate spellings rather than silently choosing one version. See `docs/research/calendar_sources.md`.

---

## The twelve Lamnso months

| Order | Name           |
| ----- | -------------- |
| 1     | Mfiilum        |
| 2     | Kifir          |
| 3     | Kiŋmgbù ke wuu |
| 4     | Vishévti       |
| 5     | Ma'an san      |
| 6     | Ma'an saar     |
| 7     | Ntoòbiŋ        |
| 8     | Tònŋkin        |
| 9     | ŋkivin         |
| 10    | Verə̀mrə̀m       |
| 11    | Sán            |
| 12    | Ntinen Saar    |

---

## The Flutter app

The Flutter app lives in `apps/yanso` and consumes `packages/nso_calendar`.

**Tech stack:**

- Flutter / Dart
- Riverpod — state management
- go_router — navigation
- intl — Gregorian date formatting
- No database in Phase 1 — pure Dart data and the calendar engine

**Phase 1 app features:**

- Today's Nso date displayed on launch
- Calendar grid with 8-column layout (one column per Nso weekday)
- Month navigation
- Light and dark theme

---

## Getting started

### Prerequisites

- Flutter ≥ 3.0 / Dart ≥ 3.0

### Install dependencies

```bash
# Calendar engine
cd packages/nso_calendar
dart pub get

# Flutter app
cd apps/yanso
flutter pub get
```

### Run the tests

```bash
# Calendar engine tests (the most important ones)
cd packages/nso_calendar
dart test

# App tests
cd apps/yanso
flutter test
```

### Run the app

```bash
cd apps/yanso
flutter run
```

---

## CI

GitHub Actions runs three jobs on every push and pull request:

| Job            | Trigger            | What it does                       |
| -------------- | ------------------ | ---------------------------------- |
| `nso_calendar` | All pushes and PRs | `dart analyze` + `dart test`       |
| `yanso_app`    | All pushes and PRs | `flutter analyze` + `flutter test` |
| `build_check`  | PRs to `main` only | `flutter build apk --debug`        |

---

## Phase 1 milestone

> **Can Yanso correctly answer: What is today's Nso date?**

This requires a verified anchor date — a Gregorian date whose corresponding Nso weekday is confirmed by a trusted Nso source (yanso.org, a Nso elder, or a Lamnso speaker).

Once confirmed:

1. Update `_kAnchorGregorianDate` and `_kAnchorNsoWeekdayOrder` in `packages/nso_calendar/lib/src/conversion.dart`
2. Remove the `skip:` from the "Verified reference dates" group in `packages/nso_calendar/test/conversion_test.dart`
3. Document the source in `docs/research/calendar_sources.md`

If you have this information, please open a **Calendar verification** issue.

---

## Roadmap

### Phase 1 — Calendar engine ← _current_

- [x] Monorepo structure
- [x] `nso_calendar` Dart package
- [x] Eight-day week, twelve months
- [x] Gregorian ↔ Nso conversion engine (working model)
- [x] 44 unit tests
- [x] Flutter app scaffold
- [ ] **Verify anchor date against trusted Nso source**
- [ ] Pass verified reference date tests

### Phase 2 — Calendar UI

- [ ] Month view with Nso + Gregorian dates
- [ ] Year view
- [ ] Day details
- [ ] Navigation

### Phase 3 — Cultural layer

- [ ] Traditional rest days
- [ ] Cultural events and festivals
- [ ] Cultural explanations with source citations

### Phase 4 — Language

- [ ] Lamnso interface
- [ ] Pronunciation guides
- [ ] Audio recordings

### Phase 5 — Community

- [ ] Community contributions
- [ ] Elder/researcher review workflow
- [ ] Cultural archive

---

## Research and sources

Yanso treats cultural accuracy as a core principle. The project will not present uncertain information as established fact.

Every cultural data point carries a `DataVerificationStatus`:

- `unverified` — not yet checked against a trusted source
- `partiallyVerified` — found in a written source, not yet confirmed by community
- `verified` — confirmed through multiple trusted sources or Nso cultural authorities
- `disputed` — conflicting information exists across sources

Research records live in `docs/research/`. The open questions that must be resolved are in `docs/research/open_questions.md`.

---

## Contributing

Code contributions and cultural contributions follow different processes.

Cultural contributions require a source. See `CONTRIBUTING.md` for details.

The most valuable contribution right now is a **verified Gregorian ↔ Nso date pairing** — one confirmed date that proves which Nso weekday falls on a specific Gregorian date. Open a **Calendar verification** issue if you have this.

---

## Acknowledgements

The [Ya Nso' website](https://yanso.org/) has documented the Lamnso calendar since at least 2014. Yanso positions itself as a complementary modern, open-source, mobile-first effort — not as a replacement. We intend to credit existing documentation properly and, where possible, work with people who have already done the hard work of documenting the calendar.

---

## License

Software: MIT — see `LICENSE`.

Cultural content in this repository is subject to separate terms, to be defined before the first public release in consultation with Nso cultural authorities. See `LICENSE` for details.

---

## Goal

> **Preserve the past. Understand the present. Pass it on.**

Yanso is being built so that a young Nso person anywhere in the world can open an app and learn:

**What day is it in the Nso calendar?**
**What does this day mean?**
**What month is it?**
**What happened on this day?**
**And what should I know about my culture?**
