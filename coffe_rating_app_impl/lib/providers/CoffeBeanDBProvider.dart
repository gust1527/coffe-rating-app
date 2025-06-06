import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffe_rating_app_impl/providers/CoffeBeanDBProviderInterface.dart';
import 'package:coffe_rating_app_impl/utility/CoffeBeanType.dart';
import 'package:flutter/foundation.dart';

/// Coffee Bean Database Provider following clean architecture principles
/// This provider manages coffee bean data and machine state
class CoffeBeanDBProvider with ChangeNotifier implements CoffeeBeanDBProviderInterface {
  // Get Firestore instance via dependency injection
  final FirebaseFirestore _db;
  
  // State management
  bool _isLoading = false;
  String? _error;
  List<CoffeBeanType> _coffeeBeans = [];
  CoffeBeanType? _currentCoffeeBean;

  // Constructor
  CoffeBeanDBProvider({FirebaseFirestore? firestore}) 
    : _db = firestore ?? FirebaseFirestore.instance;
  
  // Getters for state
  bool get isLoading => _isLoading;
  String? get error => _error;
  List<CoffeBeanType> get coffeeBeans => List.unmodifiable(_coffeeBeans);
  CoffeBeanType? get currentCoffeeBean => _currentCoffeeBean;
  
  // Collection name as constant
  static const String _collectionName = 'coffe_bean_types';

  @override
  Future<String> addCoffeBeanType(String beanMaker, String beanType, {String? imageUrl}) async {
    if (beanMaker.trim().isEmpty || beanType.trim().isEmpty) {
      throw ArgumentError('Bean maker and bean type cannot be empty');
    }

    try {
      _setLoading(true);
      _clearError();

      // First clear any existing bean from machine
      await _clearMachineStatus();

      // Add the new coffee bean
      final docRef = await _db.collection(_collectionName).add({
        'coffe_bean_maker': beanMaker.trim(),
        'coffe_bean_type': beanType.trim(),
        'bean_rating': <int>[],
        'is_in_machine': true,
        'image_url': imageUrl,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      });

      // Update local state
      await _refreshCoffeeBeans();
      
      return docRef.id;
    } catch (e) {
      _setError('Failed to add coffee bean: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  @override
  Future<void> addRatingsToCoffeBeanType(String id, int rating) async {
    if (rating < 1 || rating > 5) {
      throw ArgumentError('Rating must be between 1 and 5');
    }

    try {
      _setLoading(true);
      _clearError();

      // Retrieve the current ratings list
      final docSnapshot = await _db.collection(_collectionName).doc(id).get();
      
      if (!docSnapshot.exists) {
        throw Exception('Coffee bean not found');
      }

      final data = docSnapshot.data() as Map<String, dynamic>;
      final currentRatings = List<int>.from(
        (data['bean_rating'] as List<dynamic>? ?? [])
            .map((e) => int.tryParse(e.toString()) ?? 0),
      );

      // Add the new rating
      currentRatings.add(rating);

      // Update the ratings field
      await _db.collection(_collectionName).doc(id).update({
        'bean_rating': currentRatings,
      });

      // Update local state
      await _refreshCoffeeBeans();
      
    } catch (e) {
      _setError('Failed to add rating: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  @override
  Future<CoffeBeanType?> getCoffeBeanInMachine() async {
    try {
      final querySnapshot = await _db
          .collection(_collectionName)
          .where('is_in_machine', isEqualTo: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return CoffeBeanType.fromJson(doc.data(), doc.id);
      }

      return null;
    } catch (e) {
      _setError('Failed to get coffee bean in machine: $e');
      return null;
    }
  }

  @override
  Future<CoffeBeanType?> getCoffeBeanType(String id) async {
    try {
      // Get the coffee bean type document
      DocumentSnapshot docSnapshot = await _db.collection('coffe_bean_types').doc(id).get();
      if (docSnapshot.exists) {
        // Convert the document data to CoffeBeanType object
        CoffeBeanType coffeeBeanType = CoffeBeanType.fromJson(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
        return coffeeBeanType;
      } else {
        return null; // Return null if coffee bean type is not found
      }
    } catch (e) {
      // Handle any errors
      throw Exception('Error getting coffee bean type: $e');
    }
  }

  @override
  Stream<QuerySnapshot<Object?>> getDBStream() {
    return _db.collection(_collectionName).snapshots();
  }
  
  @override
  Future<void> setCoffeBeanToMachine(String id) async {
    try {
      _setLoading(true);
      _clearError();

      // First clear any existing bean from machine
      await _clearMachineStatus();

      // Set the new bean as in machine
      await _db.collection(_collectionName).doc(id).update({
        'is_in_machine': true,
      });

      // Update local state
      await _refreshCoffeeBeans();
      
    } catch (error) {
      _setError('Failed to set coffee bean in machine: $error');
      rethrow;
    } finally {
      _setLoading(false);
    }
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

  // Helper method to clear machine status from all beans
  Future<void> _clearMachineStatus() async {
    final querySnapshot = await _db
        .collection(_collectionName)
        .where('is_in_machine', isEqualTo: true)
        .get();

    final batch = _db.batch();
    
    for (final doc in querySnapshot.docs) {
      batch.update(doc.reference, {'is_in_machine': false});
    }

    await batch.commit();
  }

  // Helper method to refresh coffee beans list
  Future<void> _refreshCoffeeBeans() async {
    try {
      final snapshot = await _db.collection(_collectionName).get();
      _coffeeBeans = snapshot.docs
          .map((doc) => CoffeBeanType.fromJson(doc.data(), doc.id))
          .toList();
      
      // Update current coffee bean
      _currentCoffeeBean = await getCoffeBeanInMachine();
      
      notifyListeners();
    } catch (e) {
      if (kDebugMode) {
        print('Error refreshing coffee beans: $e');
      }
    }
  }

  // Method to initialize and load data
  Future<void> initialize() async {
    await _refreshCoffeeBeans();
  }

  // Method to clear error manually
  void clearError() {
    _clearError();
    notifyListeners();
  }

  @override
  Future<void> updateCoffeBeanImage(String id, String imageUrl) async {
    try {
      _setLoading(true);
      _clearError();

      await _db.collection(_collectionName).doc(id).update({
        'image_url': imageUrl,
        'updated_at': DateTime.now().toIso8601String(),
      });

      // Update local state
      await _refreshCoffeeBeans();
      
    } catch (e) {
      _setError('Failed to update coffee bean image: $e');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }
}