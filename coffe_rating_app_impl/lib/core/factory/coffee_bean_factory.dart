import 'package:firebase_core/firebase_core.dart';
import 'package:coffe_rating_app_impl/core/enums.dart';
import 'package:coffe_rating_app_impl/core/clients/pocketbase_client.dart';
import 'package:coffe_rating_app_impl/core/auth/auth_strategy.dart';
import 'package:coffe_rating_app_impl/core/auth/pocketbase_auth_strategy.dart';
import 'package:coffe_rating_app_impl/core/auth/mock_auth_strategy.dart';
import 'package:coffe_rating_app_impl/core/database/firebase_db_strategy.dart';
import 'package:coffe_rating_app_impl/providers/CoffeBeanDBProviderInterface.dart';
import 'package:flutter/foundation.dart';

class CoffeeBeanFactory {
  late final BackendType _backend;
  late final AuthStrategy _authStrategy;
  late final CoffeeBeanDBProviderInterface _dbStrategy;

  BackendType get backend => _backend;
  AuthStrategy get authStrategy => _authStrategy;
  CoffeeBeanDBProviderInterface get dbStrategy => _dbStrategy;

  // Constructor ensures factory is immutable after creation
  CoffeeBeanFactory(BackendType initialBackend, {bool isProduction = false}) {
    _initialize(initialBackend, isProduction: isProduction);
  }

  void _initialize(BackendType backend, {required bool isProduction}) {
    _backend = backend;

    switch (backend) {
      case BackendType.pocketBase:
        const baseUrl = 'https://coffe-bean-backend.gearloose.dk'; // Replace with your actual URL
        PocketBaseClient.initialize(baseUrl: baseUrl);
        _authStrategy = PocketBaseAuthStrategy();
        // For now, we'll still use Firebase for coffee bean data
        // You can create a PocketBase DB strategy later if needed
        _dbStrategy = FirebaseDBStrategy();
        break;

      case BackendType.firebase:
        // Firebase Auth strategy would be implemented here
        // For now, using Mock strategy as placeholder
        _authStrategy = MockAuthStrategy();
        _dbStrategy = FirebaseDBStrategy();
        if (kDebugMode) {
          print('Firebase auth strategy not yet implemented, using Mock');
        }
        break;
    }

    if (kDebugMode) {
      print('CoffeeBeanFactory initialized with backend: ${backend.name}');
    }
  }

  /// Helper method to get user identification
  String? getCurrentUserId() {
    return _authStrategy.currentUserId;
  }

  /// Helper method to check if user is authenticated
  bool get isAuthenticated {
    return _authStrategy.isAuthenticated;
  }

  /// Initialize database strategy - should be called during app startup
  Future<void> initializeDatabase() async {
    try {
      // The Firebase DB strategy doesn't have an initialize method in the interface
      // but we can call it directly if it's a FirebaseDBStrategy
      if (_dbStrategy is FirebaseDBStrategy) {
        await (_dbStrategy as FirebaseDBStrategy).initialize();
      }
      if (kDebugMode) {
        print('Database strategy initialized successfully');
      }
    } catch (e) {
      if (kDebugMode) {
        print('Failed to initialize database strategy: $e');
      }
      rethrow;
    }
  }
} 