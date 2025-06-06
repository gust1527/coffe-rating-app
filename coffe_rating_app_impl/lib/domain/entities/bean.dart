abstract class Bean {
  final String id;
  final String beanMaker;
  final String beanType;
  final List<int> beanRating;
  final bool isInMachine;
  final String? imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Bean({
    required this.id,
    required this.beanMaker,
    required this.beanType,
    required this.beanRating,
    required this.isInMachine,
    this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
  });

  /// Calculate the mean rating for this bean
  double calculateMeanRating() {
    if (beanRating.isEmpty) {
      return 0.0;
    }
    int sum = beanRating.reduce((a, b) => a + b);
    return sum / beanRating.length;
  }

  /// Get the number of ratings
  int get ratingCount => beanRating.length;

  /// Check if the bean has an image
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  /// Get a display name for the bean
  String get displayName => '$beanMaker $beanType';

  /// Create a copy of this bean with updated values
  Bean copyWith({
    String? id,
    String? beanMaker,
    String? beanType,
    List<int>? beanRating,
    bool? isInMachine,
    String? imageUrl,
    DateTime? createdAt,
    DateTime? updatedAt,
  });

  /// Convert to JSON representation
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Bean &&
          runtimeType == other.runtimeType &&
          id == other.id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() {
    return 'Bean{id: $id, displayName: $displayName, rating: ${calculateMeanRating().toStringAsFixed(1)}}';
  }
} 