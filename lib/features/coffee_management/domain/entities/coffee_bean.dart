abstract class CoffeeBean {
  String get id;
  String get beanMaker;
  String get beanType;
  List<int> get ratings;
  bool get isInMachine;
  
  double get averageRating;
  int get totalRatings;
  
  Map<String, dynamic> toJson();
} 