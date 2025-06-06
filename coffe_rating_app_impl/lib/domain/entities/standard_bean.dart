import 'bean.dart';

class StandardBean extends Bean {
  final String officialDescription;
  final List<String> flavorNotes;
  final String origin;
  final String processMethod;
  final String roastLevel;
  final double altitude;
  final String variety;
  final bool isCertified;
  final List<String> certifications;
  final double officialRating;

  const StandardBean({
    required super.id,
    required super.beanMaker,
    required super.beanType,
    required super.beanRating,
    required super.isInMachine,
    super.imageUrl,
    required super.createdAt,
    required super.updatedAt,
    this.officialDescription = '',
    this.flavorNotes = const [],
    this.origin = '',
    this.processMethod = '',
    this.roastLevel = '',
    this.altitude = 0.0,
    this.variety = '',
    this.isCertified = false,
    this.certifications = const [],
    this.officialRating = 0.0,
  });

  factory StandardBean.fromJson(Map<String, dynamic> json, String id) {
    return StandardBean(
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
      officialDescription: json['official_description'] as String? ?? '',
      flavorNotes: (json['flavor_notes'] as List<dynamic>?)
          ?.map((note) => note.toString())
          .toList() ?? [],
      origin: json['origin'] as String? ?? '',
      processMethod: json['process_method'] as String? ?? '',
      roastLevel: json['roast_level'] as String? ?? '',
      altitude: (json['altitude'] as num?)?.toDouble() ?? 0.0,
      variety: json['variety'] as String? ?? '',
      isCertified: json['is_certified'] as bool? ?? false,
      certifications: (json['certifications'] as List<dynamic>?)
          ?.map((cert) => cert.toString())
          .toList() ?? [],
      officialRating: (json['official_rating'] as num?)?.toDouble() ?? 0.0,
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
      'official_description': officialDescription,
      'flavor_notes': flavorNotes,
      'origin': origin,
      'process_method': processMethod,
      'roast_level': roastLevel,
      'altitude': altitude,
      'variety': variety,
      'is_certified': isCertified,
      'certifications': certifications,
      'official_rating': officialRating,
      'bean_type_category': 'standard_bean',
    };
  }

  @override
  StandardBean copyWith({
    String? id,
    String? beanMaker,
    String? beanType,
    List<int>? beanRating,
    bool? isInMachine,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? officialDescription,
    List<String>? flavorNotes,
    String? origin,
    String? processMethod,
    String? roastLevel,
    double? altitude,
    String? variety,
    bool? isCertified,
    List<String>? certifications,
    double? officialRating,
  }) {
    return StandardBean(
      id: id ?? this.id,
      beanMaker: beanMaker ?? this.beanMaker,
      beanType: beanType ?? this.beanType,
      beanRating: beanRating ?? this.beanRating,
      isInMachine: isInMachine ?? this.isInMachine,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      officialDescription: officialDescription ?? this.officialDescription,
      flavorNotes: flavorNotes ?? this.flavorNotes,
      origin: origin ?? this.origin,
      processMethod: processMethod ?? this.processMethod,
      roastLevel: roastLevel ?? this.roastLevel,
      altitude: altitude ?? this.altitude,
      variety: variety ?? this.variety,
      isCertified: isCertified ?? this.isCertified,
      certifications: certifications ?? this.certifications,
      officialRating: officialRating ?? this.officialRating,
    );
  }

  /// Get flavor notes as a formatted string
  String get flavorNotesString => flavorNotes.join(', ');

  /// Get certifications as a formatted string
  String get certificationsString => certifications.join(', ');

  /// Check if the bean has flavor notes
  bool get hasFlavorNotes => flavorNotes.isNotEmpty;

  /// Check if the bean has certifications
  bool get hasCertifications => certifications.isNotEmpty;

  /// Get the effective rating (user rating or official rating)
  double get effectiveRating {
    final userRating = calculateMeanRating();
    return userRating > 0 ? userRating : officialRating;
  }
} 