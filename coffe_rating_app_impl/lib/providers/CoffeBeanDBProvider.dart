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
      // First set the old coffee bean type to false, by calling the getCoffeBeanInMachine method
      CoffeBeanType? currentBeanInMachine = await getCoffeBeanInMachine();

      if(currentBeanInMachine != null) {

      // Get the coffee bean type document using the id
      DocumentSnapshot docSnapshot = await _db.collection('coffe_bean_types').doc(currentBeanInMachine.id).get();

      // If there is a coffee bean type in the machine, then set it to false
      if (docSnapshot.exists) {
        await _db.collection('coffe_bean_types').doc(currentBeanInMachine.id).update({
          'is_in_machine': false,
        });
      }
      }


      // Add the coffee bean type to the collection
      DocumentReference docRef = await _db.collection('coffe_bean_types').add({
        'coffe_bean_type': beanType,
        'bean_rating': [],
        'is_in_machine': true,
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
  Future<CoffeBeanType?> getCoffeBeanInMachine() async {
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
    return _db.collection('coffe_bean_types').snapshots();
  }
  
  @override
  Future<void> setCoffeBeanToMachine(String id) async {
    try {
      // First set the old coffee bean type to false, by calling the getCoffeBeanInMachine method
      CoffeBeanType? currentBeanInMachine = await getCoffeBeanInMachine();

      if(currentBeanInMachine != null) {

        // Get the coffee bean type document using the id
        DocumentSnapshot docSnapshot = await _db.collection('coffe_bean_types').doc(currentBeanInMachine.id).get();

        // If there is a coffee bean type in the machine, then set it to false
        if (docSnapshot.exists) {
          await _db.collection('coffe_bean_types').doc(currentBeanInMachine.id).update({
            'is_in_machine': false,
          });
        }

        DocumentSnapshot newDocSnapshot = await _db.collection('coffe_bean_types').doc(id).get();
        if (newDocSnapshot.exists) {
          // Update the 'is_in_machine' field to true
          await newDocSnapshot.reference.update({
            'is_in_machine': true,
          });
        }
      }
    } catch (error) {
      // Handle any errors
      throw Exception('Error adding coffee bean to machine: $error');
    }
  }
}