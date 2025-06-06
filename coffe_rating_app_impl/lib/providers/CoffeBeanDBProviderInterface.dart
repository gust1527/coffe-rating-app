import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffe_rating_app_impl/utility/CoffeBeanType.dart';

abstract class CoffeeBeanDBProviderInterface {
  Future<String> addCoffeBeanType(String beanMaker, String beanType, {String? imageUrl});

  Future<CoffeBeanType?> getCoffeBeanType(String id);

  Future<void> addRatingsToCoffeBeanType(String id, int rating);

  Future<CoffeBeanType?> getCoffeBeanInMachine();

  Stream<QuerySnapshot> getDBStream();

  Future<void> setCoffeBeanToMachine(String id);

  Future<void> updateCoffeBeanImage(String id, String imageUrl);

  // Future flavor notes and review support (to be implemented when database schema is updated)
  // Future<void> addReviewToCoffeBeanType(String id, int rating, String review, List<String> flavorNotes);
}