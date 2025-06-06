abstract class User {
  final String id;
  final String email;
  final String name;
  final String username;
  final String? location;
  final String? avatarUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const User({
    required this.id,
    required this.email,
    required this.name,
    required this.username,
    this.location,
    this.avatarUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Get display name for the user
  String get displayName => name.isNotEmpty ? name : username;

  /// Check if user has an avatar
  bool get hasAvatar => avatarUrl != null && avatarUrl!.isNotEmpty;

  /// Get user initials for avatar fallback
  String get initials {
    final nameParts = name.split(' ');
    if (nameParts.length >= 2) {
      return '${nameParts[0][0]}${nameParts[1][0]}'.toUpperCase();
    }
    return name.isNotEmpty ? name[0].toUpperCase() : username[0].toUpperCase();
  }

  /// Create a copy of this user with updated values
  User copyWith({
    String? id,
    String? email,
    String? name,
    String? username,
    String? location,
    String? avatarUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  /// Convert to JSON representation
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is User &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'User{id: $id, name: $name, username: $username}';
  }
} 