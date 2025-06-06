class Badge {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final BadgeCategory category;
  final int? requiredCount;
  final BadgeRarity rarity;

  const Badge({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    required this.category,
    this.requiredCount,
    this.rarity = BadgeRarity.common,
  });

  /// Factory for creating predefined badges
  factory Badge.predefined(String badgeId) {
    switch (badgeId) {
      case 'first-rating':
        return const Badge(
          id: 'first-rating',
          name: 'First Sip',
          description: 'Rated your first coffee bean',
          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuA4sQiDx9slHSPzZKeOiRfK1jOn9LrYWkGYOpvFzejbFOmVYWDkf7xfGWQytxNXH6hK-0Bcso67iX2K76nacWGhJIgVe3iw7v2b67IWIpxArmAb0VAKc9QpKzU-N9TVr3UcmswHmG1o5RsFPvon6dMbElsnhjmsBhqb9J73FRj-yMlH4ZxbuJJTvgsnHHc671P3OrZgwRYFpn0gKuZRqw3PCyipz-txKEAtL8Mz9UTpiPsOGty9D8-Om5OTTq5uKL55pdTY9f1g9tg3',
          category: BadgeCategory.achievement,
          requiredCount: 1,
          rarity: BadgeRarity.common,
        );
        
      case 'coffee-connoisseur':
        return const Badge(
          id: 'coffee-connoisseur',
          name: 'Coffee Connoisseur',
          description: 'Rated 50 different coffee beans',
          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDKQuMfibTE621I9RG2K-CgaWMgeriH3VzGLiLiNDJSguiseSiJbvsjmClC4UBQFWz867wTyUHY6Z1ykC7eE4lON2jM6e38QagZVSS5jU8mPCxmHH5-zx1KVnIOYJ-7QzuirJBMPe3Tkl2uDatEuzK-iMPIc5wAK7pB3jo_sGI_8DsnQgso8Bdt8C8lRsaaj7jUzpL8ju0bF2VwThzyUbCBl1eWlStwE--IrWZ0jBaJ7gH0lwmkMFGzyABd7NY4E2iapVQLraYnn7lo',
          category: BadgeCategory.achievement,
          requiredCount: 50,
          rarity: BadgeRarity.rare,
        );
        
      case 'nordic-explorer':
        return const Badge(
          id: 'nordic-explorer',
          name: 'Nordic Explorer',
          description: 'Tried coffee from all Nordic countries',
          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuAeuU-ck1SKNouw85s01UWbIZyR4YpUAfVkonR8xoCTBNZX2Jsw8G-zbiwhQnba_jzB-iZDOP90U_hDJvYdc_-KnhpmRZRqyL6yq6_QJQXhrE_f0NU4QOJHwkhjx_yu2OrknkEkgBmZs7-DbMbuFMTJ3WOc_QJh9MGtSCoi_DOXZqmKvediVlAlyUgNdIVOlACYL7p6bbGUpQfSFyEXHQyZFKMk6pTaMsyFDwozEAnICc7KRw5Mi_mzILWlalTQMlOju-tUWqXRlUT5',
          category: BadgeCategory.special,
          rarity: BadgeRarity.epic,
        );
        
      case 'bean-master':
        return const Badge(
          id: 'bean-master',
          name: 'Bean Master',
          description: 'Achieved the highest level of coffee expertise',
          imageUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuDwo2At5CSKc1JvE2SXyVC9xXsdHh9bkSeANOsTgBKyipIpbNTB1GErNSjOjeCN0ZSwrORg7cueEqMOUuRvsuJer25KvPHMiEavGgjX-gPdxn94a1FVr913siLqdrPHuot_oCvVgMYq9pnqbuvV-oG3iPn0LwB_mmPXSizGAdK0aV3VsBSIXBFT99X60troR5wJuwFmvhhwX-G_Qd1Ex-gsoNGyNrXoRJR3aocMJVtHXlR-weJh2MV8sGjIy5BH4alH4cnAkR8cnMTe',
          category: BadgeCategory.special,
          requiredCount: 100,
          rarity: BadgeRarity.legendary,
        );
        
      default:
        throw ArgumentError('Unknown badge ID: $badgeId');
    }
  }

  /// Get all available badges
  static List<Badge> getAllBadges() {
    return [
      Badge.predefined('first-rating'),
      Badge.predefined('coffee-connoisseur'),
      Badge.predefined('nordic-explorer'),
      Badge.predefined('bean-master'),
    ];
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Badge &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'Badge{id: $id, name: $name}';
}

enum BadgeCategory {
  achievement,
  special,
  seasonal,
  community,
}

enum BadgeRarity {
  common,
  uncommon,
  rare,
  epic,
  legendary,
} 