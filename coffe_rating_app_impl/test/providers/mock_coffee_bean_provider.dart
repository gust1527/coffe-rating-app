import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffe_rating_app_impl/providers/CoffeBeanDBProviderInterface.dart';
import 'package:coffe_rating_app_impl/utility/CoffeBeanType.dart';
import 'package:flutter/foundation.dart';

class MockCoffeBeanDBProvider with ChangeNotifier implements CoffeeBeanDBProviderInterface {
  // State management
  bool _isLoading = false;
  String? _error;
  List<CoffeBeanType> _coffeeBeans = [];
  CoffeBeanType? _currentCoffeeBean;
  
  // Getters for state
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<CoffeBeanType> get coffeeBeans => List.unmodifiable(_coffeeBeans);
  CoffeBeanType? get currentCoffeeBean => _currentCoffeeBean;

  @override
  Future<String> addCoffeBeanType(String beanMaker, String beanType) async {
    if (beanMaker.trim().isEmpty || beanType.trim().isEmpty) {
      throw ArgumentError('Bean maker and bean type cannot be empty');
    }
    
    // Simulate success
    return 'mock-id';
  }

  @override
  Future<void> addRatingsToCoffeBeanType(String id, int rating) async {
    if (rating < 1 || rating > 5) {
      throw ArgumentError('Rating must be between 1 and 5');
    }
    
    // Simulate success
  }

  @override
  Future<CoffeBeanType?> getCoffeBeanInMachine() async {
    return _currentCoffeeBean;
  }

  @override
  Future<CoffeBeanType?> getCoffeBeanType(String id) async {
    return _coffeeBeans.where((bean) => bean.id == id).firstOrNull;
  }

  @override
  Stream<QuerySnapshot<Object?>> getDBStream() {
    // Return empty stream for testing
    return const Stream.empty();
  }

  @override
  Future<void> setCoffeBeanToMachine(String id) async {
    // Simulate success
  }

  // Helper methods for state management
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  // Method to clear error manually
  void clearError() {
    _clearError();
    notifyListeners();
  }
} 