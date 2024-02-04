class CoffeBeanType {
  final String id;
  final String beanMaker;
  final String beanType;
  final List<int> beanRating; // Change the type to List<int>
  final bool isInMachine;

  CoffeBeanType({
    required this.id,
    required this.beanMaker,
    required this.beanType,
    required this.beanRating,
    required this.isInMachine,
  });

  CoffeBeanType.fromJson(Map<String, dynamic>? json, this.id)
    : beanMaker = json?['coffe_bean_maker'] as String? ?? '',
      beanType = json?['coffe_bean_type'] as String? ?? '',
      beanRating = (json?['bean_rating'] as List<dynamic>?)?.map((rating) => int.parse(rating.toString())).toList() ?? [],
      isInMachine = json?['is_in_machine'] as bool? ?? false;

  Map<String, Object?> toJson() {
    return {
      'coffe_bean_maker' : beanMaker,
      'coffe_bean_type': beanType,
      'bean_rating': beanRating,
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
}
