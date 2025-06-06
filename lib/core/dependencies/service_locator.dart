import 'package:get_it/get_it.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../features/coffee_management/data/datasources/firebase_coffee_datasource.dart';
import '../../features/coffee_management/presentation/providers/coffee_provider.dart';

final GetIt serviceLocator = GetIt.instance;

Future<void> setupServiceLocator() async {
  // External dependencies
  serviceLocator.registerLazySingleton(() => FirebaseFirestore.instance);

  // Data sources
  serviceLocator.registerLazySingleton<CoffeeDatasource>(
    () => FirebaseCoffeeDatasource(serviceLocator()),
  );

  // Providers
  serviceLocator.registerFactory(
    () => CoffeeProvider(serviceLocator()),
  );
} 