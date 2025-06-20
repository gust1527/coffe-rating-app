class CoffeBeanType {
  final String id;
  final String beanMaker;
  final String beanType;
  final List<int> beanRating;
  final bool isInMachine;
  final String? imageUrl;

  CoffeBeanType({
    required this.id,
    required this.beanMaker,
    required this.beanType,
    required this.beanRating,
    required this.isInMachine,
    this.imageUrl,
  });

  CoffeBeanType.fromJson(Map<String, dynamic>? json, this.id)
    : beanMaker = json?['coffe_bean_maker'] as String? ?? '',
      beanType = json?['coffe_bean_type'] as String? ?? '',
      beanRating = (json?['bean_rating'] as List<dynamic>?)
          ?.map((rating) {
            if (rating is int) return rating;
            final parsed = int.tryParse(rating.toString());
            return parsed != null && parsed >= 1 && parsed <= 5 ? parsed : 0;
          })
          .where((rating) => rating > 0)
          .toList() ?? [],
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
    if (beanRating.isEmpty) {
      return 0;
    }

    int sum = beanRating.reduce((a, b) => a + b);
    double mean = sum / beanRating.length;
    return mean;
  }

  bool get hasImage => imageUrl != null && imageUrl!.isNotEmpty;
  String get displayName => '$beanMaker $beanType';
  int get ratingCount => beanRating.length;
}
