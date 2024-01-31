import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffe_rating_app_impl/providers/CoffeBeanDBProviderInterface.dart';
import 'package:coffe_rating_app_impl/utility/CoffeBeanType.dart';
import 'package:flutter/foundation.dart';

class CoffeBeanDBProvider with ChangeNotifier implements CoffeeBeanDBProviderInterface  {
  // Get Firestore instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  @override
  Future<String> addCoffeBeanType(String beanType) async {
    try {
      // Add the coffee bean type to the collection
      DocumentReference docRef = await _db.collection('coffe_bean_types').add({
        'coffe_bean_type': beanType,
        'bean_rating': [],
        'is_in_machine': false,
      });
      return docRef.id;
    } catch (e) {
      // Handle any errors
      print('Error adding coffee bean type: $e');
      return '';
    }
  }

  @override
  Future<void> addRatingsToCoffeBeanType(String id, int rating) async {
    try {
      // Retrieve the current ratings list
      DocumentSnapshot docSnapshot = await _db.collection('coffe_bean_types').doc(id).get();
      List<dynamic> currentRatings = (docSnapshot.data() as Map<String, dynamic>)['bean_rating'] ?? [];

      // Append the new rating to the current list
      currentRatings.add(rating);

      // Update the ratings field of the coffee bean type document
      await _db.collection('coffe_bean_types').doc(id).update({
        'bean_rating': currentRatings,
      });
    } catch (e) {
      // Handle any errors
      throw Exception('Error updating ratings: $e');
    }
  }

  @override
  Future<CoffeBeanType> getCoffeBeanInMachine() async {
    try {
      // Get the coffee bean type document
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await _db.collection('coffe_bean_types').where('is_in_machine', isEqualTo: true).get();

      DocumentSnapshot<Object?> docSnapshot = querySnapshot.docs.first;
      if (docSnapshot.exists) {
        // Convert the document data to CoffeBeanType object
        CoffeBeanType coffeeBeanType = CoffeBeanType.fromJson(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
        return coffeeBeanType;
      } else {
        throw Exception('No coffee bean in machine');
      }
    } catch (e) {
      // Handle any errors
      throw Exception('Error getting coffee bean in machine: $e');
    }
  }

  @override
  Future<CoffeBeanType> getCoffeBeanType(String id) async {
    try {
      // Get the coffee bean type document
      DocumentSnapshot docSnapshot = await _db.collection('coffe_bean_types').doc(id).get();
      if (docSnapshot.exists) {
        // Convert the document data to CoffeBeanType object
        CoffeBeanType coffeeBeanType = CoffeBeanType.fromJson(docSnapshot.data() as Map<String, dynamic>, docSnapshot.id);
        return coffeeBeanType;
      } else {
        throw Exception('No coffee bean type found');
      }
    } catch (e) {
      // Handle any errors
      throw Exception('Error getting coffee bean type: $e');
    }
  }

  @override
  Stream<QuerySnapshot<Object?>> getDBStream() {
    return _db.collection('coffe_bean_types').snapshots();
  }
}