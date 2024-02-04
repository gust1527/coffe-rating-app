import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffe_rating_app_impl/utility/CoffeBeanType.dart';

abstract class CoffeeBeanDBProviderInterface {
  Future<String> addCoffeBeanType(String beanType);

  Future<CoffeBeanType?> getCoffeBeanType(String id);

  Future<void> addRatingsToCoffeBeanType(String id, int rating);

  Future<CoffeBeanType?> getCoffeBeanInMachine();

  Stream<QuerySnapshot> getDBStream();

  Future<void> setCoffeBeanToMachine(String id);
}