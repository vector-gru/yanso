# Calendar Sources

This document records every source used to define the Nso calendar in Yanso.

Research provenance is a first-class principle of this project.
Every calendar fact should trace back to an entry here.

---

## How to use this file

Each source gets a short **source ID** (e.g. `yanso-readme-v0.1`).
That ID is stored in the `sourceIds` field of `NsoWeekday`, `NsoMonth`,
and any other cultural data class. This makes it possible to audit where
every piece of data came from.

When you add or correct calendar data:

1. Add or find the source entry below.
2. Record its ID in the relevant `sourceIds` list in the Dart code.
3. Update the verification status (`DataVerificationStatus`) accordingly.

---

## Sources

---

### `yanso-readme-v0.1`

| Field | Value |
|---|---|
| **Title** | Yanso project README — Phase 1 data |
| **Type** | Internal project document |
| **Date added** | 2026-08 |
| **URL** | `README.md` in this repository |
| **Information used** | Eight day names, twelve month names |
| **Verification status** | Unverified — working data for Phase 1 |
| **Notes** | The day and month names in the README are the starting point for research, not the endpoint. They need to be cross-checked against the sources below and direct Nso community knowledge. |

---

### `yanso-org-website`

| Field | Value |
|---|---|
| **Title** | Ya Nso' website — Lamnso calendar |
| **Type** | Website |
| **URL** | https://yanso.org/ |
| **Date checked** | Not yet checked |
| **Information used** | Not yet extracted |
| **Verification status** | Pending review |
| **Notes** | The yanso.org website has published a Lamnso calendar dating back to at least 2014. It is a key reference for verifying the eight-day cycle alignment and anchor date. **Priority: review this source before any calendar data is considered verified.** |

---

## Anchor date — status: UNVERIFIED

The conversion engine (`packages/nso_calendar/lib/src/conversion.dart`) requires
a **known Gregorian date whose Nso weekday is confirmed**.

| Field | Value |
|---|---|
| **Current anchor** | 2024-01-01 (placeholder) |
| **Assumed Nso weekday** | Ntagrin (order 1) — unverified |
| **Source** | None — this is a placeholder |
| **Required action** | Replace with a verified anchor date before v1.0 |

Once a real anchor is found, record it here with full source information,
then update `_kAnchorGregorianDate` and `_kAnchorNsoWeekdayOrder` in
`conversion.dart` and remove the skip from the "Verified reference dates"
test group in `conversion_test.dart`.

---

## Nso year epoch — status: UNVERIFIED

| Field | Value |
|---|---|
| **Current epoch** | 600 CE (placeholder) |
| **Source** | None — rough working estimate |
| **Required action** | Verify the Nso year epoch against authoritative sources |

---

## Verified Gregorian ↔ Nso date pairings

This table will hold confirmed cross-reference dates once they are obtained.
Three or more verified pairings spanning different years are needed to
validate the full conversion algorithm.

| Gregorian date | Nso weekday | Nso month | Source ID | Verified by |
|---|---|---|---|---|
| — | — | — | — | Pending |

---

## Sources to investigate

The following sources have been identified but not yet reviewed.
Contributors are encouraged to check them and add findings above.

| Source | URL / reference | Priority |
|---|---|---|
| yanso.org calendar | https://yanso.org/ | High |
| Nso Cultural and Development Association (NOCDEA) | — | High |
| Academic research on Nso culture and calendar | Various | Medium |
| SIL linguistic documentation of Lamnso | — | Medium |
