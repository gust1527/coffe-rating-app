// This code defines a class called CoffeBeanProvider that extends ChangeNotifier.
// It provides functionality to add and retrieve coffee bean types from a Firestore database.

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffe_rating_app_impl/providers/CoffeBeanProviderInterface.dart';
import 'package:coffe_rating_app_impl/utility/CoffeBeanType.dart';
import 'package:flutter/material.dart';

class CoffeBeanProvider with ChangeNotifier implements CoffeeBeanProviderInterface {
  // Get firebaseFirestore instance
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // This method adds a new coffee bean type to the Firestore collection.
  // It takes a beanType as input and returns a Future<String> indicating the result.
  @override
  Future<String> addCoffeBeanType(String beanType) async {
    // Get the bean types collection
    final beanRef = _db.collection('coffe_bean_types');

    // Query the collection for the beanType to be added
    final snapshot = await beanRef.where('beanType', isEqualTo: beanType).get();

    // If the beanType doesn't exist, add it to the collection
    if (snapshot.docs.isEmpty) {
      // Generate a unique ID for the beanType
      String uniqeID = UniqueKey().hashCode.toString();
      // Add the beanType to the collection
      await beanRef.add(CoffeBeanType(id: uniqeID, beanType: beanType, beanRating: [], isInMachine: true).toJson());
      return 'Bean added';
    } else {
      // If the beanType already exists, return an error message
      return 'Bean already exists';
    }
  }

  // This method retrieves a coffee bean type from the Firestore collection.
  // It takes a beanType as input and returns a Future<CoffeBeanType>.
  @override
  Future<CoffeBeanType> getCoffeBeanType(String id) async {
    // Get the bean types collection
    final beanRef = getDBStream();

    // Query the collection for the beanType
    QuerySnapshot<Map<String, dynamic>> snapshot = await beanRef.firstWhere((element) => element.docs.first.id == id);

    // Get the corresponding data for the bean object
    final Map<String, dynamic> data = snapshot.docs.first.data();

    if (snapshot.docs.isEmpty) {
      // If no beanType is found, throw an exception
      throw Exception('No Beantype found with name ${data["coffe_bean_type"]}');
    } else {
      // If a beanType is found, create it and return it
      return CoffeBeanType.fromJson(data, data['id']);
    }
  }

  // This method adds ratings to a coffee bean type in the Firestore collection.
  // It takes a beanType and a rating as input and returns a Future.
  @override
  Future<void> addRatingsToCoffeBeanType(String id, int rating) async {
    CoffeBeanType coffeBean = await getCoffeBeanType(id);

    // Add the ratings to the beanType
    coffeBean.beanRating.add(rating);

    // Update the beanType in the database
    await _db.collection('coffe_bean_types').doc(id).update(coffeBean.toJson());
  }

  @override
  Future<CoffeBeanType> getCoffeBeanInMachine(String id) async {
    // Get the bean types collection
    final beanRef = _db.collection('coffe_bean_types');

    final Future<List<Map<String, dynamic>>> beansLists =
        beanRef.get().then((value) => value.docs.map((e) => e.data()).toList());

    await beansLists.then((beans) {
      for (var beanData in beans) {
        if (beanData['is_in_machine'] == true) {
          return CoffeBeanType.fromJson(beanData, beanRef.id);
        }
      }
    });

    // If no beanType is found, throw an exception
    throw Exception('No Beantype is in the machine');
  }

  @override
  Stream<QuerySnapshot<Map<String, dynamic>>> getDBStream() {
    return _db.collection('coffe_bean_types').snapshots();
  }
}
