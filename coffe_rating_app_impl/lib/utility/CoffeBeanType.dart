class CoffeBeanType {
  final String id;
  final String beanMaker;
  final String beanType;
  final List<int> beanRating; // Change the type to List<int>
  final bool isInMachine;
  final String? imageUrl; // Add image URL support

  CoffeBeanType({
    required this.id,
    required this.beanMaker,
    required this.beanType,
    required this.beanRating,
    required this.isInMachine,
    this.imageUrl, // Optional image URL
  });

  CoffeBeanType.fromJson(Map<String, dynamic>? json, this.id)
    : beanMaker = json?['coffe_bean_maker'] as String? ?? '',
      beanType = json?['coffe_bean_type'] as String? ?? '',
      beanRating = (json?['bean_rating'] as List<dynamic>?)?.map((rating) => int.parse(rating.toString())).toList() ?? [],
      isInMachine = json?['is_in_machine'] as bool? ?? false,
      imageUrl = json?['image_url'] as String?;

  Map<String, Object?> toJson() {
    return {
      'coffe_bean_maker' : beanMaker,
      'coffe_bean_type': beanType,
      'bean_rating': beanRating,
      'is_in_machine': isInMachine,
      'image_url': imageUrl,
    };
  }

  double calculateMeanRating() {
    // If the bean rating is empty, then return 0
    if (beanRating.isEmpty) {
      return 0;
    }

    // Calculate the sum of the ratings
    int sum = beanRating.reduce((a, b) => a + b);

    // Calculate the mean rating
    double mean = sum / beanRating.length;

    // Return the mean value as regular value
    return mean;
  }

  /// Check if the bean has an image URL
  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;

  /// Get display name for the bean
  String get displayName => '$beanMaker $beanType';

  /// Get the number of ratings
  int get ratingCount => beanRating.length;
}
