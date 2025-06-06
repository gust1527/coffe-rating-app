import 'user.dart';

class StandardUser extends User {
  final Map<String, dynamic>? preferences;
  final List<String> badges;
  final int beansRated;
  final int topBrews;
  final int favoriteRoasters;

  const StandardUser({
    required super.id,
    required super.email,
    required super.name,
    required super.username,
    super.location,
    super.avatarUrl,
    required super.createdAt,
    required super.updatedAt,
    this.preferences,
    this.badges = const [],
    this.beansRated = 0,
    this.topBrews = 0,
    this.favoriteRoasters = 0,
  });

  /// Factory constructor from JSON
  factory StandardUser.fromJson(Map<String, dynamic> json, String id) {
    return StandardUser(
      id: id,
      email: json['email'] as String? ?? '',
      name: json['name'] as String? ?? '',
      username: json['username'] as String? ?? '',
      location: json['location'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] as String? ?? '') ?? DateTime.now(),
      preferences: json['preferences'] as Map<String, dynamic>?,
      badges: (json['badges'] as List<dynamic>?)?.cast<String>() ?? [],
      beansRated: json['beans_rated'] as int? ?? 0,
      topBrews: json['top_brews'] as int? ?? 0,
      favoriteRoasters: json['favorite_roasters'] as int? ?? 0,
    );
  }

  /// Create a demo user for testing
  factory StandardUser.demo() {
    return StandardUser(
      id: 'demo-user-1',
      email: 'mads@nordic-bean.com',
      name: 'Mads Nielsen',
      username: 'madsnielsen',
      location: 'Copenhagen, Denmark',
      avatarUrl: 'https://lh3.googleusercontent.com/aida-public/AB6AXuBAiDC5Ymbl40HtoBXr-ZF_3f3BFbw5AzwyhxeJPiPiaCYIS9WLpcZrROnW_mAyUNIggiod0X33RLY0g4QLIWVf8cDI73lNuSTuq4wvxr1ojlNUeE19oCh7lKGUOiUe8aS8bS9RNQlWMsZ3VJoeWGFbBXvB3I1jJMUu1EcNDSx_xiEl1fcAbuMivO2fYpuyrnKZ-EqXICqO1EoYgglNED_p7BC1gNRujNklVzhRjB58omLkJk5PbglJdsVb7MLmJ_t-0ZcA28QmEkd3',
      createdAt: DateTime.now().subtract(const Duration(days: 365)),
      updatedAt: DateTime.now(),
      badges: ['first-rating', 'coffee-connoisseur', 'nordic-explorer', 'bean-master'],
      beansRated: 120,
      topBrews: 30,
      favoriteRoasters: 15,
      preferences: {
        'dark_mode': false,
        'notifications': true,
        'public_profile': true,
      },
    );
  }

  @override
  StandardUser copyWith({
    String? id,
    String? email,
    String? name,
    String? username,
    String? location,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    Map<String, dynamic>? preferences,
    List<String>? badges,
    int? beansRated,
    int? topBrews,
    int? favoriteRoasters,
  }) {
    return StandardUser(
      id: id ?? this.id,
      email: email ?? this.email,
      name: name ?? this.name,
      username: username ?? this.username,
      location: location ?? this.location,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      preferences: preferences ?? this.preferences,
      badges: badges ?? this.badges,
      beansRated: beansRated ?? this.beansRated,
      topBrews: topBrews ?? this.topBrews,
      favoriteRoasters: favoriteRoasters ?? this.favoriteRoasters,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'name': name,
      'username': username,
      'location': location,
      'avatar_url': avatarUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'preferences': preferences,
      'badges': badges,
      'beans_rated': beansRated,
      'top_brews': topBrews,
      'favorite_roasters': favoriteRoasters,
    };
  }

  /// Get preference value by key
  T? getPreference<T>(String key) {
    return preferences?[key] as T?;
  }

  /// Check if user has a specific badge
  bool hasBadge(String badgeId) {
    return badges.contains(badgeId);
  }

  /// Get user level based on beans rated
  int get userLevel {
    if (beansRated >= 100) return 5; // Master
    if (beansRated >= 50) return 4;  // Expert
    if (beansRated >= 25) return 3;  // Advanced
    if (beansRated >= 10) return 2;  // Intermediate
    return 1; // Beginner
  }

  /// Get user level title
  String get userLevelTitle {
    switch (userLevel) {
      case 5: return 'Bean Master';
      case 4: return 'Coffee Expert';
      case 3: return 'Advanced Taster';
      case 2: return 'Coffee Lover';
      default: return 'Coffee Beginner';
    }
  }
} 