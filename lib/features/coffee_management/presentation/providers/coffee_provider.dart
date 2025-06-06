import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/coffee_bean.dart';
import '../../domain/entities/standard_coffee_bean.dart';
import '../../data/datasources/firebase_coffee_datasource.dart';

class CoffeeProvider extends ChangeNotifier {
  final CoffeeDatasource _datasource;
  
  List<CoffeeBean> _coffeeBeans = [];
  CoffeeBean? _currentCoffeeBean;
  bool _isLoading = false;
  String? _error;

  CoffeeProvider(this._datasource);

  // Getters
  List<CoffeeBean> get coffeeBeans => List.unmodifiable(_coffeeBeans);
  CoffeeBean? get currentCoffeeBean => _currentCoffeeBean;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load all coffee beans
  Future<void> loadCoffeeBeans() async {
    if (_isLoading) return;

    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Get the stream and convert first snapshot to list
      final stream = _datasource.getCoffeeBeansStream();
      final snapshot = await stream.first;
      
      _coffeeBeans = snapshot.docs.map((doc) {
        return StandardCoffeeBean.fromJson(
          doc.data() as Map<String, dynamic>,
          doc.id,
        );
      }).toList();

      // Update current coffee bean if it exists
      await _updateCurrentCoffeeBean();
      
    } catch (e) {
      _error = e.toString();
      if (kDebugMode) {
        print('Error loading coffee beans: $e');
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a new coffee bean
  Future<String> addCoffeeBean(String beanMaker, String beanType) async {
    try {
      _error = null;
      
      final id = await _datasource.addCoffeeBean(beanMaker, beanType);
      
      // Reload the list to get the updated data
      await loadCoffeeBeans();
      
      return id;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Add rating to a coffee bean
  Future<void> addRating(String id, int rating) async {
    try {
      _error = null;
      
      await _datasource.addRatingToCoffeeBean(id, rating);
      
      // Update local state
      final index = _coffeeBeans.indexWhere((bean) => bean.id == id);
      if (index != -1) {
        final updatedBean = (_coffeeBeans[index] as StandardCoffeeBean).addRating(rating);
        final mutableBeans = List<CoffeeBean>.from(_coffeeBeans);
        mutableBeans[index] = updatedBean;
        _coffeeBeans = mutableBeans;
        
        // Update current bean if it matches
        if (_currentCoffeeBean?.id == id) {
          _currentCoffeeBean = updatedBean;
        }
        
        notifyListeners();
      }
      
      // Also reload in background to ensure consistency
      loadCoffeeBeans();
      
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Set a coffee bean as the one in the machine
  Future<void> setCoffeeBeanInMachine(String id) async {
    try {
      _error = null;
      
      await _datasource.setCoffeeBeanInMachine(id);
      
      // Update local state - remove machine status from all beans
      final mutableBeans = _coffeeBeans.map((bean) {
        if (bean is StandardCoffeeBean) {
          return bean.copyWith(isInMachine: bean.id == id);
        }
        return bean;
      }).toList();
      
      _coffeeBeans = mutableBeans;
      
      // Update current coffee bean
      _currentCoffeeBean = _coffeeBeans.firstWhere(
        (bean) => bean.id == id,
        orElse: () => _currentCoffeeBean!,
      );
      
      notifyListeners();
      
      // Reload to ensure consistency
      loadCoffeeBeans();
      
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      rethrow;
    }
  }

  // Get a specific coffee bean
  Future<CoffeeBean?> getCoffeeBean(String id) async {
    try {
      return await _datasource.getCoffeeBean(id);
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return null;
    }
  }

  // Listen to real-time updates
  void startListening() {
    _datasource.getCoffeeBeansStream().listen(
      (snapshot) {
        _coffeeBeans = snapshot.docs.map((doc) {
          return StandardCoffeeBean.fromJson(
            doc.data() as Map<String, dynamic>,
            doc.id,
          );
        }).toList();
        
        _updateCurrentCoffeeBean();
        notifyListeners();
      },
      onError: (error) {
        _error = error.toString();
        notifyListeners();
      },
    );
  }

  // Private helper to update current coffee bean
  Future<void> _updateCurrentCoffeeBean() async {
    try {
      _currentCoffeeBean = await _datasource.getCoffeeBeanInMachine();
    } catch (e) {
      if (kDebugMode) {
        print('Error updating current coffee bean: $e');
      }
    }
  }

  // Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }
} 