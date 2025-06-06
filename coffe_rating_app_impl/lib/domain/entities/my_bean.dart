import 'bean.dart';

class MyBean extends Bean {
  final String userId;
  final List<String> personalNotes;
  final Map<String, dynamic> brewingPreferences;
  final bool isFavorite;

  const MyBean({
    required super.id,
    required super.beanMaker,
    required super.beanType,
    required super.beanRating,
    required super.isInMachine,
    super.imageUrl,
    required super.createdAt,
    required super.updatedAt,
    required this.userId,
    this.personalNotes = const [],
    this.brewingPreferences = const {},
    this.isFavorite = false,
  });

  factory MyBean.fromJson(Map<String, dynamic> json, String id) {
    return MyBean(
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
      userId: json['user_id'] as String? ?? '',
      personalNotes: (json['personal_notes'] as List<dynamic>?)
          ?.map((note) => note.toString())
          .toList() ?? [],
      brewingPreferences: json['brewing_preferences'] as Map<String, dynamic>? ?? {},
      isFavorite: json['is_favorite'] as bool? ?? false,
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
      'user_id': userId,
      'personal_notes': personalNotes,
      'brewing_preferences': brewingPreferences,
      'is_favorite': isFavorite,
      'bean_type_category': 'my_bean',
    };
  }

  @override
  MyBean copyWith({
    String? id,
    String? beanMaker,
    String? beanType,
    List<int>? beanRating,
    bool? isInMachine,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? userId,
    List<String>? personalNotes,
    Map<String, dynamic>? brewingPreferences,
    bool? isFavorite,
  }) {
    return MyBean(
      id: id ?? this.id,
      beanMaker: beanMaker ?? this.beanMaker,
      beanType: beanType ?? this.beanType,
      beanRating: beanRating ?? this.beanRating,
      isInMachine: isInMachine ?? this.isInMachine,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      userId: userId ?? this.userId,
      personalNotes: personalNotes ?? this.personalNotes,
      brewingPreferences: brewingPreferences ?? this.brewingPreferences,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }

  /// Add a personal note
  MyBean addNote(String note) {
    final newNotes = List<String>.from(personalNotes)..add(note);
    return copyWith(personalNotes: newNotes, updatedAt: DateTime.now());
  }

  /// Toggle favorite status
  MyBean toggleFavorite() {
    return copyWith(isFavorite: !isFavorite, updatedAt: DateTime.now());
  }

  /// Update brewing preferences
  MyBean updateBrewingPreferences(Map<String, dynamic> preferences) {
    final newPreferences = Map<String, dynamic>.from(brewingPreferences);
    newPreferences.addAll(preferences);
    return copyWith(brewingPreferences: newPreferences, updatedAt: DateTime.now());
  }
} 