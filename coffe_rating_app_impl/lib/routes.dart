import 'package:coffe_rating_app_impl/coffeList/coffeList.dart';
import 'package:coffe_rating_app_impl/currentCoffe/currentCoffe.dart';

var AppRoutes = {
  '/currentCoffe': (context) => const CurrentCoffe(),
  '/coffeList': (context) => const CoffeList(),
};