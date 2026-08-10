# Open Research Questions

This document tracks unresolved questions about the Nso calendar.

The goal is to make uncertainty explicit and visible rather than hiding it
behind confident-sounding code. Every item here blocks some aspect of
Phase 1 verification.

---

## Priority 1 — Blocks "What is today's Nso date?"

These must be resolved before the calendar engine can be considered correct.

---

### Q1. What is the anchor date for the eight-day cycle?

**Question:** What Gregorian date corresponds to which Nso weekday (confirmed)?

**Why it matters:** The entire weekday calculation in `NsoDateConversion`
is built on an anchor date. The current anchor (2024-01-01 = Ntagrin) is
a placeholder with no source. Until this is verified, the weekday output
is structurally correct but may be offset by 1–7 days from the real cycle.

**What is needed:** One confirmed Gregorian date + its Nso weekday,
from yanso.org, a Nso elder, or a trusted Lamnso speaker.

**Where to update:** `_kAnchorGregorianDate` and `_kAnchorNsoWeekdayOrder`
in `packages/nso_calendar/lib/src/conversion.dart`.

**Status:** ❌ Unresolved

---

### Q2. Do the Nso weekdays published on yanso.org match the eight names in Yanso?

**Question:** Does the yanso.org calendar use the same eight day names
(Ntagrin, Kavi, Reeveiy, Kiloveiy, Nseeri, Geeggee, Ngoilum, Waiylun)?
Are there alternate spellings?

**Why it matters:** The README day names are the starting data, not verified
data. If yanso.org uses different spellings, both should be recorded.

**What is needed:** A review of https://yanso.org/ by a contributor.

**Status:** ❌ Unresolved

---

### Q3. What Gregorian date does the Nso year begin on (and does it vary by year)?

**Question:** When does the Nso year start relative to the Gregorian calendar?
Does it start on a fixed Gregorian date, or does it shift (like a lunar calendar)?

**Why it matters:** The month/year calculation in `NsoDateConversion` uses a
simple 360-day year model (12 × 30 days). This is almost certainly an
approximation. If the Nso year is lunar-influenced, the month boundaries
move relative to the Gregorian calendar each year.

**Status:** ❌ Unresolved

---

## Priority 2 — Needed for accurate month display

---

### Q4. How long is each Nso month?

**Question:** Are all twelve Nso months the same length?
If not, what is the length of each?

**Current assumption:** All months are 30 days. This is a placeholder.

**Status:** ❌ Unresolved

---

### Q5. Is there a leap/intercalation mechanism in the Nso calendar?

**Question:** How does the Nso calendar handle the drift between a 360-day
year and the solar year (~365.25 days)?

**Status:** ❌ Unresolved

---

### Q6. Do the twelve month names map to a consistent seasonal pattern?

**Question:** Does, for example, Mfiilum always fall during the dry season?
Or does the calendar drift over years?

**Status:** ❌ Unresolved

---

## Priority 3 — Needed for cultural accuracy

---

### Q7. Which days are traditional rest days?

**Question:** Which of the eight Nso weekdays are traditional rest days
(no farming, no market, etc.)?

**Current state:** `isRestDay` is `null` for all eight days in `kNsoWeekdays`.

**Status:** ❌ Unresolved

---

### Q8. What is the cultural meaning of each weekday?

**Question:** Do the eight day names carry traditional meanings
(e.g. associated with a deity, ancestor, activity, or seasonal event)?

**Status:** ❌ Unresolved

---

### Q9. What are the correct pronunciations of the day and month names?

**Question:** What are the correct tonal pronunciations of each Lamnso
day and month name? (Lamnso is a tonal language; spelling alone does not
capture pronunciation.)

**Status:** ❌ Unresolved — needed for Phase 3 (audio)

---

## How to contribute

If you have information that resolves any of these questions:

1. Open a **Calendar verification** issue on GitHub (use the issue template).
2. Provide the information and its source.
3. A maintainer will update `calendar_sources.md`, the Dart constants,
   and the relevant tests.

The project will never silently adopt unverified data. Every resolved
question should be traceable to a source in `calendar_sources.md`.
