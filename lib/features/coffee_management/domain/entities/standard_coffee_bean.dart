import 'coffee_bean.dart';

class StandardCoffeeBean implements CoffeeBean {
  final String _id;
  final String _beanMaker;
  final String _beanType;
  final List<int> _ratings;
  final bool _isInMachine;

  StandardCoffeeBean({
    required String id,
    required String beanMaker,
    required String beanType,
    required List<int> ratings,
    required bool isInMachine,
  })  : _id = id,
        _beanMaker = beanMaker,
        _beanType = beanType,
        _ratings = List.from(ratings),
        _isInMachine = isInMachine;

  // Factory constructor from JSON
  factory StandardCoffeeBean.fromJson(Map<String, dynamic> json, String id) {
    return StandardCoffeeBean(
      id: id,
      beanMaker: json['coffe_bean_maker'] as String? ?? '',
      beanType: json['coffe_bean_type'] as String? ?? '',
      ratings: (json['bean_rating'] as List<dynamic>?)
              ?.map((rating) => int.tryParse(rating.toString()) ?? 0)
              .toList() ??
          [],
      isInMachine: json['is_in_machine'] as bool? ?? false,
    );
  }

  @override
  String get id => _id;

  @override
  String get beanMaker => _beanMaker;

  @override
  String get beanType => _beanType;

  @override
  List<int> get ratings => List.unmodifiable(_ratings);

  @override
  bool get isInMachine => _isInMachine;

  @override
  double get averageRating {
    if (_ratings.isEmpty) return 0.0;
    
    final sum = _ratings.reduce((a, b) => a + b);
    return sum / _ratings.length;
  }

  @override
  int get totalRatings => _ratings.length;

  @override
  Map<String, dynamic> toJson() {
    return {
      'coffe_bean_maker': _beanMaker,
      'coffe_bean_type': _beanType,
      'bean_rating': _ratings,
      'is_in_machine': _isInMachine,
    };
  }

  // Create a copy with updated values
  StandardCoffeeBean copyWith({
    String? id,
    String? beanMaker,
    String? beanType,
    List<int>? ratings,
    bool? isInMachine,
  }) {
    return StandardCoffeeBean(
      id: id ?? _id,
      beanMaker: beanMaker ?? _beanMaker,
      beanType: beanType ?? _beanType,
      ratings: ratings ?? _ratings,
      isInMachine: isInMachine ?? _isInMachine,
    );
  }

  // Add a rating to this bean
  StandardCoffeeBean addRating(int rating) {
    final newRatings = List<int>.from(_ratings)..add(rating);
    return copyWith(ratings: newRatings);
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is StandardCoffeeBean && other._id == _id;
  }

  @override
  int get hashCode => _id.hashCode;

  @override
  String toString() {
    return 'StandardCoffeeBean(id: $_id, beanMaker: $_beanMaker, beanType: $_beanType, avgRating: ${averageRating.toStringAsFixed(1)}, isInMachine: $_isInMachine)';
  }
} 