/// Represents a single day in the traditional Nso eight-day week.
///
/// The Nso week consists of eight days. The cycle order, starting from
/// day 1, is:
///
///   1 → Kaavi
///   2 → Rəəveiy
///   3 → Kiloovəy
///   4 → Nsəəri
///   5 → Geegee
///   6 → ŋgoilum
///   7 → Waiylun
///   8 → Ntaŋrin
///
/// Source: yanso.org (verified August 2026 — see docs/research/calendar_sources.md).
///
/// Notes on Lamnso orthography used here:
/// - 'ə' (schwa) replaces the 'e' used in some older romanisations.
/// - 'ŋ' replaces 'ng' following standard Lamnso orthographic convention.
class NsoWeekday {
  /// Position in the eight-day cycle. 1-indexed (1..8).
  final int order;

  /// The primary name in Lamnso orthography.
  ///
  /// Alternate spellings from other sources are recorded in [alternateNames].
  final String name;

  /// Short form suitable for calendar grid headers (3–4 characters).
  final String shortName;

  /// Known alternate spellings or representations from other sources.
  ///
  /// Yanso preserves these rather than silently discarding them, because
  /// spelling variation is part of the cultural record.
  final List<String> alternateNames;

  /// English description of the day.
  final String? description;

  /// Cultural significance, traditional role, or meaning of this day.
  final String? culturalMeaning;

  /// Whether this is a traditional rest day (no farming, no market, etc.).
  ///
  /// [null] means the rest-day status has not yet been verified.
  final bool? isRestDay;

  /// Whether a traditional market is held on this day.
  ///
  /// [null] means the market-day status has not yet been verified.
  final bool? isMarketDay;

  /// Information about the market held on this day, if [isMarketDay] is true.
  ///
  /// Includes market name, location, and cultural context.
  final NsoMarketInfo? marketInfo;

  /// Identifiers of sources that support the data in this record.
  /// Cross-references docs/research/calendar_sources.md.
  final List<String> sourceIds;

  const NsoWeekday({
    required this.order,
    required this.name,
    required this.shortName,
    this.alternateNames = const [],
    this.description,
    this.culturalMeaning,
    this.isRestDay,
    this.isMarketDay,
    this.marketInfo,
    this.sourceIds = const [],
  }) : assert(order >= 1 && order <= 8, 'Nso weekday order must be 1..8');

  @override
  String toString() => 'NsoWeekday($order: $name)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is NsoWeekday &&
          runtimeType == other.runtimeType &&
          order == other.order;

  @override
  int get hashCode => order.hashCode;
}

/// The canonical list of the eight Nso weekdays in cycle order.
///
/// Spelling follows standard Lamnso orthography:
///   ŋ for the velar nasal (formerly written 'ng')
///   ə for the mid central vowel (formerly written 'e' in some sources)
///
/// Verified via yanso.org August 2026 calendar — source ID: yanso-org-2026-08.
const List<NsoWeekday> kNsoWeekdays = [
  NsoWeekday(
    order: 1,
    name: 'Kaavi',
    shortName: 'Ka',
    alternateNames: ['Kavi'],
    description: 'First day of the Nso eight-day week. The main market day.',
    culturalMeaning:
        'The principal market day of the Nso people. Everyone gathers at '
        "the Mbvə' market in Kimbo' (Kumbo) for trade, socialising, and "
        'community life. It is one of the most important recurring events '
        'in the Nso calendar.',
    isRestDay: null,
    isMarketDay: true,
    marketInfo: NsoMarketInfo(
      marketName: "Mbvə'",
      locationNso: "Kimbo'",
      locationEnglish: 'Kumbo',
      description: "The main Nso market, held every Kaavi at Kimbo' (Kumbo). "
          'It draws traders and community members from across Nso land '
          'and is a central part of economic and social life.',
      isMainMarket: true,
      sourceIds: ['yanso-contributor-2026-08'],
    ),
    sourceIds: ['yanso-org-2026-08', 'yanso-contributor-2026-08'],
  ),
  NsoWeekday(
    order: 2,
    name: 'Rəəveiy',
    shortName: 'Rə',
    alternateNames: ['Reeveiy'],
    description: 'Second day of the Nso eight-day week.',
    culturalMeaning: null,
    isRestDay: null,
    sourceIds: ['yanso-org-2026-08'],
  ),
  NsoWeekday(
    order: 3,
    name: 'Kiloovəy',
    shortName: 'Ki',
    alternateNames: ['Kiloveiy'],
    description: 'Third day of the Nso eight-day week. A traditional rest day.',
    culturalMeaning:
        'A traditional rest day on which farming and certain activities are '
        'observed to cease.',
    isRestDay: true,
    sourceIds: ['yanso-org-2026-08'],
  ),
  NsoWeekday(
    order: 4,
    name: 'Nsəəri',
    shortName: 'Ns',
    alternateNames: ['Nseeri'],
    description: 'Fourth day of the Nso eight-day week.',
    culturalMeaning: null,
    isRestDay: null,
    sourceIds: ['yanso-org-2026-08'],
  ),
  NsoWeekday(
    order: 5,
    name: 'Geegee',
    shortName: 'Ge',
    alternateNames: ['Geeggee'],
    description: 'Fifth day of the Nso eight-day week.',
    culturalMeaning: null,
    isRestDay: null,
    sourceIds: ['yanso-org-2026-08'],
  ),
  NsoWeekday(
    order: 6,
    name: 'ŋgoilum',
    shortName: 'ŋg',
    alternateNames: ['Ngoilum'],
    description: 'Sixth day of the Nso eight-day week. A traditional rest day.',
    culturalMeaning:
        'A traditional rest day. Widely observed across Nso communities '
        'as a day of rest from farm work and certain activities.',
    isRestDay: true,
    sourceIds: ['yanso-org-2026-08'],
  ),
  NsoWeekday(
    order: 7,
    name: 'Waiylun',
    shortName: 'Wa',
    alternateNames: [],
    description: 'Seventh day of the Nso eight-day week.',
    culturalMeaning: null,
    isRestDay: null,
    sourceIds: ['yanso-org-2026-08'],
  ),
  NsoWeekday(
    order: 8,
    name: 'Ntaŋrin',
    shortName: 'Nt',
    alternateNames: ['Ntagrin'],
    description: 'Eighth day of the Nso eight-day week.',
    culturalMeaning: null,
    isRestDay: null,
    sourceIds: ['yanso-org-2026-08'],
  ),
];

/// Holds information about a traditional Nso market associated with a weekday.
///
/// Markets are a central feature of Nso social and economic life.
/// The main market is Mbvə' at Kimbo' (Kumbo), held every Kaavi.
/// Other smaller markets on different days will be added as they are verified.
class NsoMarketInfo {
  /// The Lamnso name of the market.
  final String marketName;

  /// The location name in Lamnso.
  final String locationNso;

  /// The location name in English or as commonly known outside Nso.
  final String locationEnglish;

  /// Description of the market and its cultural significance.
  final String description;

  /// Whether this is the principal Nso market (Mbvə' at Kimbo').
  final bool isMainMarket;

  /// Identifiers of sources for this market information.
  final List<String> sourceIds;

  const NsoMarketInfo({
    required this.marketName,
    required this.locationNso,
    required this.locationEnglish,
    required this.description,
    this.isMainMarket = false,
    this.sourceIds = const [],
  });
}
