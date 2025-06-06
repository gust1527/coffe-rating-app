import 'package:pocketbase/pocketbase.dart';
import 'package:flutter/foundation.dart';

/// Singleton class to manage a single PocketBase instance across the app
class PocketBaseClient {
  static PocketBaseClient? _instance;
  late final PocketBase _pb;

  // Private constructor
  PocketBaseClient._({required String baseUrl}) {
    _pb = PocketBase(baseUrl);
    if (kDebugMode) {
      print('PocketBaseClient initialized with baseUrl: $baseUrl');
    }
  }

  // Getter for the PocketBase instance
  PocketBase get instance => _pb;

  // Factory constructor to get or create the singleton instance
  static PocketBaseClient initialize({required String baseUrl}) {
    _instance ??= PocketBaseClient._(baseUrl: baseUrl);
    return _instance!;
  }

  // Getter to access the singleton instance
  static PocketBaseClient get shared {
    if (_instance == null) {
      throw StateError('PocketBaseClient not initialized. Call initialize() first.');
    }
    return _instance!;
  }
} 