# Contributing to Yanso

Thank you for your interest in contributing to Yanso.

This document covers both **code contributions** and **cultural contributions**.
They follow different processes because they carry different responsibilities.

---

## Table of contents

1. [Code contributions](#code-contributions)
2. [Cultural contributions](#cultural-contributions)
3. [Calendar accuracy](#calendar-accuracy)
4. [Issue reporting](#issue-reporting)
5. [Pull request process](#pull-request-process)
6. [Development setup](#development-setup)
7. [Running tests](#running-tests)

---

## Code contributions

### Prerequisites

- Flutter SDK ≥ 3.0 / Dart SDK ≥ 3.0
- A basic understanding of the project structure (see `README.md`)

### Workflow

1. Fork the repository.
2. Create a feature branch: `git checkout -b feature/your-feature-name`
3. Make your changes.
4. Run analysis and tests (see [Running tests](#running-tests)).
5. Open a pull request against `main`.

### Code standards

- Follow the `analysis_options.yaml` rules at the repository root.
- All calendar engine changes in `packages/nso_calendar` require corresponding
  tests in `packages/nso_calendar/test/`.
- Keep the calendar engine (`packages/nso_calendar`) free of Flutter dependencies.
  It is a pure Dart package and must remain publishable independently.
- Do not silence lint warnings with `// ignore:` without an explanation comment.

---

## Cultural contributions

Cultural contributions require extra care.

The Nso calendar and Lamnso cultural data are not just code. They represent
the knowledge of a living culture. Contributing incorrect information,
even accidentally, could mislead Nso people about their own heritage.

### What counts as a cultural contribution

- Adding or correcting Nso day names, month names, or their spellings
- Adding meanings, descriptions, or cultural context for days or months
- Providing Gregorian ↔ Nso date correspondences
- Adding cultural events, traditional festivals, or rest days
- Providing pronunciation guides or audio recordings
- Sharing historical or oral history material

### Requirements for cultural contributions

Every cultural contribution must include:

1. **A source** — where did this information come from?
   - Name and role of the person (e.g. "Nso elder from Kumbo")
   - Or: publication title, author, date, and URL/reference
   - Or: name of the cultural organisation
2. **A verification status** — is this confirmed, or is it one version among several?
3. **Known variations** — if other sources use different spellings or say something
   different, document that variation instead of silently choosing one.

### What not to contribute

- Information copied from the internet without verification
- Personal assumptions presented as cultural facts
- Content that a trusted Nso elder or cultural authority has indicated is
  restricted, sacred, or not for public sharing

### Uncertain information

If you are not sure whether something is correct, say so clearly.
The `DataVerificationStatus.unverified` status exists precisely for this.
An honest "unverified" label is more useful than a confident wrong answer.

---

## Calendar accuracy

The Phase 1 milestone is:

> **Can Yanso correctly answer: What is today's Nso date?**

This requires a verified anchor date — a Gregorian date whose corresponding
Nso weekday is confirmed by a trusted Nso source.

If you have access to verified Nso ↔ Gregorian date pairings, please open
an issue or pull request with the following information:

- The Gregorian date
- The corresponding Nso weekday name
- The source (person, publication, or website) that confirms it

See `docs/research/open_questions.md` for the full verification checklist.

---

## Issue reporting

For bugs: describe the expected behaviour, the actual behaviour, and steps
to reproduce.

For cultural inaccuracies: describe what is wrong, what the correct information
is, and your source.

For feature requests: describe the use case before proposing a solution.

---

## Pull request process

1. PRs should be focused — one concern per PR.
2. Describe what changed and why in the PR description.
3. Link any related issues.
4. Cultural PRs should describe the source of the information.
5. CI must pass before merge.

---

## Development setup

```bash
# Clone the repo
git clone https://github.com/yanso-project/yanso.git
cd yanso

# Install nso_calendar dependencies
cd packages/nso_calendar
dart pub get

# Install app dependencies
cd ../../apps/yanso
flutter pub get
```

---

## Running tests

```bash
# Calendar engine tests (the most important ones)
cd packages/nso_calendar
dart test

# App analysis
cd apps/yanso
flutter analyze

# App tests
cd apps/yanso
flutter test
```

CI runs all three on every pull request.
