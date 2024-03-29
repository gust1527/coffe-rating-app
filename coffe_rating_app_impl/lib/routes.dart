import 'package:coffe_rating_app_impl/ux_elements/AddCoffeBean.dart';
import 'package:coffe_rating_app_impl/pages/coffeBeanInMachine.dart';
import 'package:coffe_rating_app_impl/pages/coffeBeanTypeList.dart';

var AppRoutes = {
  '/': (context) => const CoffeBeanInMachine(),
  '/coffeList': (context) => const CoffeBeanTypeList(),
  '/addCoffeBean': (context) => AddCoffeBean(),
};