/// Represents one of the twelve months in the traditional Lamnso calendar.
///
/// Each Nso month aligns with a Gregorian month. The mapping confirmed
/// via yanso.org (source: yanso-org-2026-08) is:
///
///   1  Mfiilum       → January
///   2  Kifir          → February
///   3  Kiŋmgbù ke wuu → March
///   4  Vishévti       → April
///   5  Ma'an san      → May
///   6  Ma'an saar     → June
///   7  Ntoòbiŋ        → July
///   8  Tònŋkin        → August
///   9  ŋkivin         → September
///  10  Verə̀mrə̀m       → October
///  11  Sán            → November
///  12  Ntinen Saar    → December
///
/// The [gregorianMonthEquivalent] field (1..12) records this mapping so
/// that the UI can display e.g. "Tònŋkin (August) 2026".
class NsoMonth {
  /// Position in the Nso year. 1-indexed (1..12).
  final int order;

  /// Primary name in Lamnso orthography.
  final String name;

  /// Short display name for compact calendar views.
  final String shortName;

  /// The Gregorian month number (1=January … 12=December) that this
  /// Nso month corresponds to.
  ///
  /// Source: yanso-org-2026-08.
  final int gregorianMonthEquivalent;

  /// Known alternate spellings from other sources.
  final List<String> alternateNames;

  /// English or descriptive label.
  final String? description;

  /// Approximate number of days in this month.
  final int? approximateDays;

  /// Pronunciation guide (will be replaced by audio in Phase 4).
  final String? pronunciation;

  /// Cultural significance of this month.
  final String? culturalSignificance;

  /// Identifiers of sources that support the data in this record.
  final List<String> sourceIds;

  /// Indicates how well this data has been verified.
  final DataVerificationStatus verificationStatus;

  /// Creates an [NsoMonth] with the required [order], [name], [shortName],
  /// and [gregorianMonthEquivalent], plus optional cultural metadata fields.
  const NsoMonth({
    required this.order,
    required this.name,
    required this.shortName,
    required this.gregorianMonthEquivalent,
    this.alternateNames = const [],
    this.description,
    this.approximateDays,
    this.pronunciation,
    this.culturalSignificance,
    this.sourceIds = const [],
    this.verificationStatus = DataVerificationStatus.unverified,
  })  : assert(order >= 1 && order <= 12, 'Nso month order must be 1..12'),
        assert(
          gregorianMonthEquivalent >= 1 && gregorianMonthEquivalent <= 12,
          'gregorianMonthEquivalent must be 1..12',
        );

  @override
  String toString() => 'NsoMonth($order: $name)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NsoMonth &&
          runtimeType == other.runtimeType &&
          order == other.order;

  @override
  int get hashCode => order.hashCode;
}

/// Communicates how well a piece of cultural data has been verified.
enum DataVerificationStatus {
  /// Not yet checked against any trusted source.
  unverified,

  /// Checked against at least one written source, but not yet confirmed
  /// by a Nso elder, speaker, or authoritative cultural body.
  partiallyVerified,

  /// Confirmed through multiple trusted sources or directly by Nso elders
  /// or cultural authorities.
  verified,

  /// Conflicting information exists across sources; under investigation.
  disputed,
}

/// The canonical list of the twelve Nso months.
///
/// Gregorian month equivalents are sourced from yanso.org (yanso-org-2026-08).
const List<NsoMonth> kNsoMonths = [
  NsoMonth(
    order: 1,
    name: 'Mfiilum',
    shortName: 'Mfi',
    gregorianMonthEquivalent: 1,
    description: 'First month of the Nso year. Corresponds to January.',
    sourceIds: ['yanso-org-2026-08'],
    verificationStatus: DataVerificationStatus.partiallyVerified,
  ),
  NsoMonth(
    order: 2,
    name: 'Kifir',
    shortName: 'Kif',
    gregorianMonthEquivalent: 2,
    description: 'Second month of the Nso year. Corresponds to February.',
    sourceIds: ['yanso-org-2026-08'],
    verificationStatus: DataVerificationStatus.partiallyVerified,
  ),
  NsoMonth(
    order: 3,
    name: 'Kiŋmgbù ke wuu',
    shortName: 'Kiŋ',
    gregorianMonthEquivalent: 3,
    description: 'Third month of the Nso year. Corresponds to March.',
    sourceIds: ['yanso-org-2026-08'],
    verificationStatus: DataVerificationStatus.partiallyVerified,
  ),
  NsoMonth(
    order: 4,
    name: 'Vishévti',
    shortName: 'Vis',
    gregorianMonthEquivalent: 4,
    description: 'Fourth month of the Nso year. Corresponds to April.',
    sourceIds: ['yanso-org-2026-08'],
    verificationStatus: DataVerificationStatus.partiallyVerified,
  ),
  NsoMonth(
    order: 5,
    name: "Ma'an san",
    shortName: 'Msa',
    gregorianMonthEquivalent: 5,
    description: 'Fifth month of the Nso year. Corresponds to May.',
    sourceIds: ['yanso-org-2026-08'],
    verificationStatus: DataVerificationStatus.partiallyVerified,
  ),
  NsoMonth(
    order: 6,
    name: "Ma'an saar",
    shortName: 'Msr',
    gregorianMonthEquivalent: 6,
    description: 'Sixth month of the Nso year. Corresponds to June.',
    sourceIds: ['yanso-org-2026-08'],
    verificationStatus: DataVerificationStatus.partiallyVerified,
  ),
  NsoMonth(
    order: 7,
    name: 'Ntoòbiŋ',
    shortName: 'Nto',
    gregorianMonthEquivalent: 7,
    description: 'Seventh month of the Nso year. Corresponds to July.',
    sourceIds: ['yanso-org-2026-08'],
    verificationStatus: DataVerificationStatus.partiallyVerified,
  ),
  NsoMonth(
    order: 8,
    name: 'Tònŋkin',
    shortName: 'Tòŋ',
    gregorianMonthEquivalent: 8,
    description: 'Eighth month of the Nso year. Corresponds to August.',
    sourceIds: ['yanso-org-2026-08'],
    verificationStatus: DataVerificationStatus.partiallyVerified,
  ),
  NsoMonth(
    order: 9,
    name: 'ŋkivin',
    shortName: 'ŋki',
    gregorianMonthEquivalent: 9,
    description: 'Ninth month of the Nso year. Corresponds to September.',
    sourceIds: ['yanso-org-2026-08'],
    verificationStatus: DataVerificationStatus.partiallyVerified,
  ),
  NsoMonth(
    order: 10,
    name: 'Verə̀mrə̀m',
    shortName: 'Ver',
    gregorianMonthEquivalent: 10,
    description: 'Tenth month of the Nso year. Corresponds to October.',
    sourceIds: ['yanso-org-2026-08'],
    verificationStatus: DataVerificationStatus.partiallyVerified,
  ),
  NsoMonth(
    order: 11,
    name: 'Sán',
    shortName: 'Sán',
    gregorianMonthEquivalent: 11,
    description: 'Eleventh month of the Nso year. Corresponds to November.',
    sourceIds: ['yanso-org-2026-08'],
    verificationStatus: DataVerificationStatus.partiallyVerified,
  ),
  NsoMonth(
    order: 12,
    name: 'Ntinen Saar',
    shortName: 'Nti',
    gregorianMonthEquivalent: 12,
    description: 'Twelfth month of the Nso year. Corresponds to December.',
    sourceIds: ['yanso-org-2026-08'],
    verificationStatus: DataVerificationStatus.partiallyVerified,
  ),
];

/// Returns the [NsoMonth] for a given Gregorian month number (1..12).
NsoMonth nsoMonthForGregorianMonth(int gregorianMonth) {
  assert(gregorianMonth >= 1 && gregorianMonth <= 12);
  return kNsoMonths.firstWhere(
    (m) => m.gregorianMonthEquivalent == gregorianMonth,
  );
}
