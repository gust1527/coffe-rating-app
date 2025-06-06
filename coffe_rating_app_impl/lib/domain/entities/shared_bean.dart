import 'bean.dart';

class SharedBean extends Bean {
  final String sharedByUserId;
  final String sharedByUsername;
  final int communityRatingCount;
  final double communityAverageRating;
  final List<String> tags;
  final String description;
  final bool isVerified;
  final int shareCount;

  const SharedBean({
    required super.id,
    required super.beanMaker,
    required super.beanType,
    required super.beanRating,
    required super.isInMachine,
    super.imageUrl,
    required super.createdAt,
    required super.updatedAt,
    required this.sharedByUserId,
    required this.sharedByUsername,
    this.communityRatingCount = 0,
    this.communityAverageRating = 0.0,
    this.tags = const [],
    this.description = '',
    this.isVerified = false,
    this.shareCount = 0,
  });

  factory SharedBean.fromJson(Map<String, dynamic> json, String id) {
    return SharedBean(
      id: id,
      beanMaker: json['coffe_bean_maker'] as String? ?? '',
      beanType: json['coffe_bean_type'] as String? ?? '',
      beanRating: (json['bean_rating'] as List<dynamic>?)
          ?.map((rating) => int.tryParse(rating.toString()) ?? 0)
          .toList() ?? [],
      isInMachine: json['is_in_machine'] as bool? ?? false,
      imageUrl: json['image_url'] as String?,
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
      updatedAt: DateTime.tryParse(json['updated_at'] as String? ?? '') ?? DateTime.now(),
      sharedByUserId: json['shared_by_user_id'] as String? ?? '',
      sharedByUsername: json['shared_by_username'] as String? ?? 'Unknown',
      communityRatingCount: json['community_rating_count'] as int? ?? 0,
      communityAverageRating: (json['community_average_rating'] as num?)?.toDouble() ?? 0.0,
      tags: (json['tags'] as List<dynamic>?)
          ?.map((tag) => tag.toString())
          .toList() ?? [],
      description: json['description'] as String? ?? '',
      isVerified: json['is_verified'] as bool? ?? false,
      shareCount: json['share_count'] as int? ?? 0,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'coffe_bean_maker': beanMaker,
      'coffe_bean_type': beanType,
      'bean_rating': beanRating,
      'is_in_machine': isInMachine,
      'image_url': imageUrl,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'shared_by_user_id': sharedByUserId,
      'shared_by_username': sharedByUsername,
      'community_rating_count': communityRatingCount,
      'community_average_rating': communityAverageRating,
      'tags': tags,
      'description': description,
      'is_verified': isVerified,
      'share_count': shareCount,
      'bean_type_category': 'shared_bean',
    };
  }

  @override
  SharedBean copyWith({
    String? id,
    String? beanMaker,
    String? beanType,
    List<int>? beanRating,
    bool? isInMachine,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? sharedByUserId,
    String? sharedByUsername,
    int? communityRatingCount,
    double? communityAverageRating,
    List<String>? tags,
    String? description,
    bool? isVerified,
    int? shareCount,
  }) {
    return SharedBean(
      id: id ?? this.id,
      beanMaker: beanMaker ?? this.beanMaker,
      beanType: beanType ?? this.beanType,
      beanRating: beanRating ?? this.beanRating,
      isInMachine: isInMachine ?? this.isInMachine,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      sharedByUserId: sharedByUserId ?? this.sharedByUserId,
      sharedByUsername: sharedByUsername ?? this.sharedByUsername,
      communityRatingCount: communityRatingCount ?? this.communityRatingCount,
      communityAverageRating: communityAverageRating ?? this.communityAverageRating,
      tags: tags ?? this.tags,
      description: description ?? this.description,
      isVerified: isVerified ?? this.isVerified,
      shareCount: shareCount ?? this.shareCount,
    );
  }

  /// Add a tag to this shared bean
  SharedBean addTag(String tag) {
    if (tags.contains(tag)) return this;
    final newTags = List<String>.from(tags)..add(tag);
    return copyWith(tags: newTags, updatedAt: DateTime.now());
  }

  /// Increment share count
  SharedBean incrementShareCount() {
    return copyWith(shareCount: shareCount + 1, updatedAt: DateTime.now());
  }

  /// Update community rating
  SharedBean updateCommunityRating(int newRatingCount, double newAverageRating) {
    return copyWith(
      communityRatingCount: newRatingCount,
      communityAverageRating: newAverageRating,
      updatedAt: DateTime.now(),
    );
  }

  /// Verify this shared bean
  SharedBean verify() {
    return copyWith(isVerified: true, updatedAt: DateTime.now());
  }
} 