# Yanso

> **The Nso Calendar**

Yanso is an open-source Flutter project created to preserve, document, and promote the traditional calendar and cultural knowledge of the **Nso people of Cameroon**.

The project focuses on the traditional Nso system of timekeeping, including its **eight-day week**, Lamnso month names, traditional days, cultural events, and other knowledge connected to the Nso understanding of time.

Yanso is more than a calendar app.

It is a small digital effort to help keep Nso culture accessible to younger generations and to Nso people around the world.

---

## Vision

Nso culture contains knowledge that has traditionally been passed from one generation to another through families, elders, traditional institutions, stories, language, ceremonies, and everyday life.

Some of this knowledge is becoming harder for younger generations to access.

Yanso aims to use technology to help preserve part of that knowledge.

The long-term vision is to build a reliable digital reference for:

* The Nso calendar
* The eight-day Nso week
* Lamnso month names
* Traditional days and their meanings
* Nso cultural events
* Traditional festivals
* Important historical dates
* Lamnso terminology
* Cultural explanations
* Audio pronunciation
* Stories and oral history
* Traditional knowledge contributed by the Nso community

---

## The Nso Week

The traditional Nso week has **eight days**.

The calendar therefore differs from the commonly used Gregorian seven-day week.

The project will preserve the Nso day names and their traditional meanings rather than treating them simply as alternative names for Monday, Tuesday, Wednesday, etc.

The current research data includes the following eight-day cycle:

1. Ntagrin
2. Kavi
3. Reeveiy
4. Kiloveiy
5. Nseeri
6. Geeggee
7. Ngoilum
8. Waiylun

> **Important:** Nso names can have different spellings and representations. Yanso will therefore maintain alternate spellings and source information instead of assuming that one spelling is always the only correct form.

---

## Nso Months

The traditional Lamnso calendar uses its own month names.

The current calendar data includes:

1. Mfiilum
2. Kifir
3. Kiŋmgbù ke wuu
4. Vishévti
5. Ma'an san
6. Ma'an saar
7. Ntoòbiŋ
8. Tònŋkin
9. ŋkivin
10. Verə̀mrə̀m
11. Sán
12. Ntinen Saar

The project will document the meaning, pronunciation, cultural significance, and variations of these names as reliable information becomes available.

---

## Cultural Accuracy

Cultural accuracy is a core principle of Yanso.

The project will not treat information found online as automatically correct.

Where possible, cultural information should be verified through:

* Nso elders
* Traditional authorities
* Cultural organizations
* Lamnso speakers
* Historians
* Researchers
* Existing cultural documentation
* Community contributors

When different versions exist, Yanso should document the variation instead of silently choosing one version.

Every important cultural fact should eventually have a source or provenance record.

---

## Features

### V1 — Calendar

* [ ] Nso eight-day week
* [ ] Nso month names
* [ ] Current Nso date
* [ ] Gregorian date ↔ Nso date conversion
* [ ] Month view
* [ ] Year view
* [ ] Today indicator
* [ ] Navigate between months
* [ ] Navigate between years
* [ ] Display Nso and Gregorian dates together

### V2 — Cultural Calendar

* [ ] Traditional rest days
* [ ] Cultural events
* [ ] Traditional festivals
* [ ] Important Nso dates
* [ ] Cultural explanations
* [ ] Event details

### V3 — Lamnso

* [ ] Lamnso terminology
* [ ] Day pronunciation
* [ ] Month pronunciation
* [ ] Audio recordings
* [ ] English ↔ Lamnso explanations

### V4 — Cultural Archive

* [ ] Stories
* [ ] Historical information
* [ ] Oral history
* [ ] Traditional knowledge
* [ ] Cultural photographs
* [ ] Audio recordings
* [ ] Community contributions

---

## Design Principles

### 1. Culture first

The calendar should represent the Nso system rather than forcing Nso culture into a Gregorian calendar model.

### 2. Accuracy over assumptions

When information is uncertain, the project should mark it as uncertain and seek verification.

### 3. Preserve variations

Different communities, families, elders, researchers, and sources may use different spellings or interpretations.

Yanso should preserve these differences as part of the cultural record.

### 4. Offline first

The basic calendar should work without an internet connection.

Users should be able to view the calendar and cultural information without requiring a network connection.

### 5. Open source

The code should remain open so that Nso developers and contributors can improve it.

### 6. Community ownership

Yanso should grow with contributions from the Nso community.

Technology should support the culture, not replace cultural authorities.

---

## Flutter Architecture

Yanso is built with Flutter.

The project should keep the calendar calculation engine separate from the user interface.

A major goal is to make the calendar logic independently testable.

```text
lib/
├── app/
│   ├── app.dart
│   ├── router/
│   └── theme/
│
├── core/
│   ├── constants/
│   ├── extensions/
│   ├── utils/
│   └── errors/
│
├── features/
│   ├── calendar/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   ├── culture/
│   │   ├── data/
│   │   ├── domain/
│   │   └── presentation/
│   │
│   └── settings/
│       ├── data/
│       ├── domain/
│       └── presentation/
│
├── shared/
│   ├── widgets/
│   └── models/
│
└── main.dart
```

---

## Calendar Domain Model

The calendar engine should not depend on Flutter widgets.

For example:

```text
NsoCalendar
    ├── NsoYear
    ├── NsoMonth
    ├── NsoDay
    ├── NsoWeekday
    └── DateConversion
```

The UI should consume this domain layer.

This makes it possible to eventually create:

* Android app
* iOS app
* Web app
* Desktop app
* Dart calendar package
* API

without rewriting the calendar rules.

---

## Data Model

Cultural data should remain separate from UI code.

Example:

```text
NsoMonth
├── id
├── name
├── alternateNames
├── order
├── description
├── pronunciation
└── sources

NsoWeekday
├── id
├── name
├── shortName
├── alternateNames
├── order
├── description
├── culturalMeaning
├── isRestDay
└── sources

CulturalEvent
├── id
├── name
├── description
├── dateRule
├── location
├── culturalSignificance
└── sources
```

---

## Project Structure

The repository should eventually contain:

```text
yanso/
├── android/
├── ios/
├── web/
├── macos/
├── linux/
├── windows/
│
├── lib/
├── test/
├── integration_test/
│
├── assets/
│   ├── audio/
│   ├── images/
│   ├── icons/
│   └── data/
│
├── docs/
│   ├── calendar/
│   ├── culture/
│   ├── research/
│   └── architecture/
│
├── .github/
│   ├── workflows/
│   ├── ISSUE_TEMPLATE/
│   └── pull_request_template.md
│
├── analysis_options.yaml
├── pubspec.yaml
├── CHANGELOG.md
├── CONTRIBUTING.md
├── LICENSE
└── README.md
```

---

## Research and Sources

Yanso should keep a record of the sources used to define the calendar.

This is important because cultural information can have different versions.

Research should record:

* Source title
* Author
* Publication date
* URL or publication reference
* Information obtained
* Date added to Yanso
* Verification status

The project should never present an uncertain cultural claim as established fact.

---

## Roadmap

### Phase 1 — Foundation

* [ ] Create Flutter project
* [ ] Define Nso calendar domain models
* [ ] Define eight-day week
* [ ] Define month data
* [ ] Build calendar calculation engine
* [ ] Add Gregorian ↔ Nso conversion
* [ ] Write unit tests

### Phase 2 — Calendar UI

* [ ] Month view
* [ ] Year view
* [ ] Day details
* [ ] Current date
* [ ] Nso/Gregorian date display
* [ ] Navigation

### Phase 3 — Cultural Layer

* [ ] Traditional rest days
* [ ] Cultural events
* [ ] Explanations
* [ ] Sources and references

### Phase 4 — Language

* [ ] Lamnso interface
* [ ] English interface
* [ ] Pronunciation
* [ ] Audio

### Phase 5 — Community

* [ ] Community contribution system
* [ ] Cultural verification workflow
* [ ] Elder/researcher review
* [ ] Cultural archive

---

## Contributing

Contributions are welcome.

However, cultural contributions should follow a careful verification process.

For code contributions:

1. Fork the repository.
2. Create a feature branch.
3. Make your changes.
4. Add tests where appropriate.
5. Run formatting and analysis.
6. Open a pull request.

For cultural information, contributors should provide the source or explain where the information came from.

---

## Cultural Responsibility

Yanso is intended to support the preservation and education of Nso culture.

Some cultural knowledge may be sensitive, sacred, restricted, or intended only for specific traditional institutions.

The project will not assume that all cultural knowledge should be published publicly.

Information should only be included when it is appropriate to share.

---

## License

The software license and cultural-content license may be different.

The project should clearly distinguish between:

* Source code
* Original documentation
* Cultural content
* Photographs
* Audio recordings
* Historical material
* Third-party material

The final licensing model will be defined before the first public release.

---

## Name

**Yanso**

The name is inspired by the Nso calendar and the Lamnso cultural context of the project.

---

## Status

**Early development**

The calendar rules and cultural data are still being researched and verified.

The project welcomes contributions from Nso people, Lamnso speakers, researchers, historians, developers, and cultural custodians.

---

## Goal

> **Preserve the past. Understand the present. Pass it on.**

Yanso is being built so that a young Nso person anywhere in the world can open an app and learn:

**What day is it in the Nso calendar?**

**What does this day mean?**

**What month is it?**

**What happened on this day?**

**And what should I know about my culture?**
