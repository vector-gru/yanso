## Summary

<!-- What does this PR do? One or two sentences. -->

## Type of change

- [ ] Bug fix
- [ ] New feature (code)
- [ ] Calendar engine change
- [ ] Cultural data addition or correction
- [ ] Documentation
- [ ] CI / tooling

## Cultural data changes

<!-- Complete this section only if this PR adds or modifies cultural data. -->

If this PR adds or modifies Nso calendar data, day/month names, cultural events,
or any other cultural information:

**Source of the information:**
<!-- e.g. "Nso elder, Kumbo, verified March 2025" or "yanso.org, accessed 2025-03-10" -->

**Verification status:**
- [ ] Verified by a Nso elder or cultural authority
- [ ] Found in a written source (cite below)
- [ ] Unverified — marking as `DataVerificationStatus.unverified`

**Known alternate versions or spellings:**
<!-- Document any variations you are aware of, even if not including them in this PR -->

## Calendar engine changes

<!-- Complete this section only if this PR modifies packages/nso_calendar -->

If this PR changes the conversion algorithm, anchor date, or epoch:

- [ ] The anchor date change is supported by a source (documented in `docs/research/calendar_sources.md`)
- [ ] Existing tests still pass
- [ ] New tests cover the change
- [ ] The verified reference dates test group has been updated or remains correctly skipped

## Checklist

- [ ] `dart analyze` / `flutter analyze` passes with no issues
- [ ] Tests pass (`dart test` / `flutter test`)
- [ ] New code follows `analysis_options.yaml`
- [ ] Cultural sources documented where applicable
