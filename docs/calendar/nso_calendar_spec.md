# Nso Calendar Specification

This document describes the Nso calendar as currently understood by the
Yanso project. It is a working specification, not a final authoritative
reference. Every claim is annotated with its verification status.

See `docs/research/calendar_sources.md` for source details.
See `docs/research/open_questions.md` for unresolved questions.

---

## Structure

### The eight-day week

The traditional Nso week has eight days. The cycle repeats continuously
without interruption across months and years.

| Order | Name | Short | Verification |
|---|---|---|---|
| 1 | Ntagrin | Ntg | Unverified |
| 2 | Kavi | Kav | Unverified |
| 3 | Reeveiy | Rev | Unverified |
| 4 | Kiloveiy | Kil | Unverified |
| 5 | Nseeri | Nse | Unverified |
| 6 | Geeggee | Gee | Unverified |
| 7 | Ngoilum | Ngo | Unverified |
| 8 | Waiylun | Wai | Unverified |

Source: `yanso-readme-v0.1` (working data, needs cross-referencing).

---

### The twelve months

The Nso year has twelve named months. The alignment of these months
with the Gregorian calendar is not yet verified.

| Order | Name | Verification |
|---|---|---|
| 1 | Mfiilum | Unverified |
| 2 | Kifir | Unverified |
| 3 | Kiŋmgbù ke wuu | Unverified |
| 4 | Vishévti | Unverified |
| 5 | Ma'an san | Unverified |
| 6 | Ma'an saar | Unverified |
| 7 | Ntoòbiŋ | Unverified |
| 8 | Tònŋkin | Unverified |
| 9 | ŋkivin | Unverified |
| 10 | Verə̀mrə̀m | Unverified |
| 11 | Sán | Unverified |
| 12 | Ntinen Saar | Unverified |

Source: `yanso-readme-v0.1` (working data, needs cross-referencing).

---

## Conversion algorithm (Phase 1 working model)

### Weekday calculation

```
daysDiff    = targetDate − anchorDate   (integer days)
cycleIndex  = ((anchorWeekdayOrder − 1 + daysDiff) mod 8 + 8) mod 8
weekdayOrder = cycleIndex + 1
```

The double-mod pattern handles negative `daysDiff` (dates before the anchor).

**Anchor date:** 2024-01-01 → Ntagrin (order 1)
**Status: UNVERIFIED PLACEHOLDER** — see `open_questions.md` Q1.

### Month and day-of-month calculation

Uses a simplified 360-day year model (12 months × 30 days each):

```
totalDays    = targetDate − epochStart
nsoYear      = totalDays ÷ 360 + 1
dayOfYear    = totalDays mod 360
nsoMonth     = dayOfYear ÷ 30 + 1
dayOfMonth   = dayOfYear mod 30 + 1
```

**Epoch:** Year 1 = 600 CE (Gregorian)
**Status: UNVERIFIED PLACEHOLDER** — see `open_questions.md` Q3, Q4, Q5.

---

## Known limitations of the Phase 1 model

1. The anchor date is unverified — weekday results may be offset.
2. The 30-day equal-month model is almost certainly an approximation.
3. No intercalation is modelled.
4. The year epoch is a guess.
5. Month alignment with the Gregorian calendar is not verified.

These are not bugs — they are documented, tested, and clearly labelled
as `UNVERIFIED PLACEHOLDER` in the source code. The test suite contains
a "Verified reference dates" group that will catch any anchor errors
once real reference dates are available.

---

## Milestone: Phase 1 complete

Phase 1 is complete when:

- [ ] At least one Gregorian ↔ Nso weekday pairing is confirmed
- [ ] The anchor date is updated and sourced in `calendar_sources.md`
- [ ] The "Verified reference dates" test group has at least one passing test
- [ ] The `DataVerificationStatus` of at least the weekday cycle is upgraded
      from `unverified` to `partiallyVerified`
