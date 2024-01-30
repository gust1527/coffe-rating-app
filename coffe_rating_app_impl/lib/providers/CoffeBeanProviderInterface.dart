import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:coffe_rating_app_impl/utility/CoffeBeanType.dart';

abstract class CoffeeBeanProviderInterface {
  Future<String> addCoffeBeanType(String beanType);

  Future<CoffeBeanType> getCoffeBeanType(String id);

  Future<void> addRatingsToCoffeBeanType(String id, int rating);

  Future<CoffeBeanType> getCoffeBeanInMachine(String id);

  Stream<QuerySnapshot> getDBStream();
}