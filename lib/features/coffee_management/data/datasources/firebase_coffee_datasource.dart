import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/standard_coffee_bean.dart';
import '../../domain/entities/coffee_bean.dart';

abstract class CoffeeDatasource {
  Future<String> addCoffeeBean(String beanMaker, String beanType);
  Future<CoffeeBean?> getCoffeeBean(String id);
  Future<void> addRatingToCoffeeBean(String id, int rating);
  Future<CoffeeBean?> getCoffeeBeanInMachine();
  Stream<QuerySnapshot> getCoffeeBeansStream();
  Future<void> setCoffeeBeanInMachine(String id);
}

class FirebaseCoffeeDatasource implements CoffeeDatasource {
  final FirebaseFirestore _firestore;
  static const String _collection = 'coffe_bean_types';

  FirebaseCoffeeDatasource(this._firestore);

  @override
  Future<String> addCoffeeBean(String beanMaker, String beanType) async {
    try {
      // First, remove any existing bean from machine
      await _clearMachineStatus();

      // Add the new coffee bean
      final docRef = await _firestore.collection(_collection).add({
        'coffe_bean_maker': beanMaker,
        'coffe_bean_type': beanType,
        'bean_rating': <int>[],
        'is_in_machine': true,
      });

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add coffee bean: $e');
    }
  }

  @override
  Future<CoffeeBean?> getCoffeeBean(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      
      if (doc.exists && doc.data() != null) {
        return StandardCoffeeBean.fromJson(doc.data()!, doc.id);
      }
      
      return null;
    } catch (e) {
      throw Exception('Failed to get coffee bean: $e');
    }
  }

  @override
  Future<void> addRatingToCoffeeBean(String id, int rating) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();
      
      if (!doc.exists) {
        throw Exception('Coffee bean not found');
      }

      final currentRatings = List<int>.from(
        (doc.data()!['bean_rating'] as List<dynamic>? ?? [])
            .map((e) => int.tryParse(e.toString()) ?? 0),
      );

      currentRatings.add(rating);

      await _firestore.collection(_collection).doc(id).update({
        'bean_rating': currentRatings,
      });
    } catch (e) {
      throw Exception('Failed to add rating: $e');
    }
  }

  @override
  Future<CoffeeBean?> getCoffeeBeanInMachine() async {
    try {
      final querySnapshot = await _firestore
          .collection(_collection)
          .where('is_in_machine', isEqualTo: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        final doc = querySnapshot.docs.first;
        return StandardCoffeeBean.fromJson(doc.data(), doc.id);
      }

      return null;
    } catch (e) {
      throw Exception('Failed to get coffee bean in machine: $e');
    }
  }

  @override
  Stream<QuerySnapshot> getCoffeeBeansStream() {
    return _firestore.collection(_collection).snapshots();
  }

  @override
  Future<void> setCoffeeBeanInMachine(String id) async {
    try {
      // First, clear any existing bean from machine
      await _clearMachineStatus();

      // Set the new bean as in machine
      await _firestore.collection(_collection).doc(id).update({
        'is_in_machine': true,
      });
    } catch (e) {
      throw Exception('Failed to set coffee bean in machine: $e');
    }
  }

  // Helper method to clear machine status from all beans
  Future<void> _clearMachineStatus() async {
    final querySnapshot = await _firestore
        .collection(_collection)
        .where('is_in_machine', isEqualTo: true)
        .get();

    final batch = _firestore.batch();
    
    for (final doc in querySnapshot.docs) {
      batch.update(doc.reference, {'is_in_machine': false});
    }

    await batch.commit();
  }
} 