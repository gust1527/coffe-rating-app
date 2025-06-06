import 'package:coffe_rating_app_impl/core/auth/auth_strategy.dart';
import 'package:coffe_rating_app_impl/domain/entities/user.dart';
import 'package:coffe_rating_app_impl/domain/entities/standard_user.dart';
import 'package:coffe_rating_app_impl/core/clients/pocketbase_client.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Custom exception for authentication operations
class AuthException implements Exception {
  final String message;
  final dynamic originalError;

  AuthException(this.message, [this.originalError]);

  @override
  String toString() => 'AuthException: $message${originalError != null ? '\nOriginal error: $originalError' : ''}';
}

/// PocketBase authentication strategy implementation
class PocketBaseAuthStrategy extends AuthStrategy {
  late final PocketBase _pb;
  User? _currentUser;
  bool _isLoading = false;
  String? _error;
  
  static const String _tokenKey = 'pocketbase_auth_token';
  static const String _modelKey = 'pocketbase_auth_model';

  PocketBaseAuthStrategy() {
    _pb = PocketBaseClient.shared.instance;
    _initializeAuthState();
  }

  @override
  bool get isAuthenticated => _pb.authStore.isValid;

  @override
  String? get currentUserId => _pb.authStore.model?.id;

  @override
  User? get currentUser => _currentUser;

  @override
  bool get isLoading => _isLoading;

  @override
  String? get error => _error;

  /// Initialize auth state from existing token
  void _initializeAuthState() {
    if (_pb.authStore.isValid && _pb.authStore.model != null) {
      try {
        _currentUser = _createUserFromRecord(_pb.authStore.model!);
        notifyListeners();
      } catch (e) {
        if (kDebugMode) {
          print('Error initializing auth state: $e');
        }
        _pb.authStore.clear();
      }
    }
  }

  @override
  Future<User> authenticate({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final authData = await _pb.collection('users').authWithPassword(email, password);
      
      if (!_pb.authStore.isValid || authData.record == null) {
        throw AuthException('Authentication failed: Invalid auth store state');
      }

      _currentUser = _createUserFromRecord(authData.record!);

      // Save auth token and model
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, _pb.authStore.token);
      await prefs.setString(_modelKey, authData.record!.id);

      notifyListeners();
      return _currentUser!;
    } catch (e) {
      _pb.authStore.clear();
      _setError('Authentication failed: ${e.toString()}');
      throw AuthException('Failed to authenticate user', e);
    } finally {
      _setLoading(false);
    }
  }

  @override
  Future<bool> loginWithToken() async {
    _setLoading(true);
    _clearError();

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString(_tokenKey);
      final modelId = prefs.getString(_modelKey);

      if (token == null || modelId == null) {
        return false;
      }

      // Create a basic record model with the saved ID
      final recordModel = RecordModel.fromJson({
        'id': modelId,
        'collectionId': '_pb_users_auth_',
        'collectionName': 'users',
        'created': DateTime.now().toIso8601String(),
        'updated': DateTime.now().toIso8601String(),
        'expand': <String, dynamic>{},
        'data': <String, dynamic>{},
      });

      // Set the token and basic model in the auth store
      _pb.authStore.save(token, recordModel);
      
      // Verify if the token is still valid
      if (!_pb.authStore.isValid) {
        await _clearAuth(prefs);
        return false;
      }

      try {
        // Try to refresh the user data
        final record = await _pb.collection('users').getOne(modelId);
        _pb.authStore.save(token, record); // Update with full record
        
        _currentUser = _createUserFromRecord(record);

        notifyListeners();
        return true;
      } catch (e) {
        // If we get a 404, the user doesn't exist anymore
        if (e.toString().contains('404')) {
          await _clearAuth(prefs);
          return false;
        }
        // For other errors, we can still proceed with the basic record
        _currentUser = _createUserFromRecord(recordModel);
        notifyListeners();
        return true;
      }
    } catch (e) {
      // Clear invalid token
      final prefs = await SharedPreferences.getInstance();
      await _clearAuth(prefs);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> _clearAuth(SharedPreferences prefs) async {
    _pb.authStore.clear();
    await prefs.remove(_tokenKey);
    await prefs.remove(_modelKey);
    _currentUser = null;
  }

  @override
  Future<void> logout() async {
    _setLoading(true);
    _clearError();

    try {
      _pb.authStore.clear();
      _currentUser = null;
      
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_modelKey);
      
      notifyListeners();
    } catch (e) {
      _setError('Logout failed: ${e.toString()}');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  @override
  Future<User> createUser({
    required String email,
    required String name,
    required String username,
    required String password,
    String? location,
  }) async {
    _setLoading(true);
    _clearError();

    try {

      // Create the user record
      final body = <String, dynamic>{
        'email': email,
        'name': name,
        'password': password,
        'location': location,
        'beans_rated': 0,
        'top_brews': 0,
        'favorite_roasters': 0,
        'badges': <String>[],
        'preferences': {
          'notifications': true,
          'public_profile': true,
        },
      };

      await _pb.collection('users').create(body: body);

      // Authenticate the newly created user
      await authenticate(email: email, password: password);
      
      return _currentUser!;
    } catch (e) {
      _setError('Account creation failed: ${e.toString()}');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  @override
  Future<User> updateProfile({
    String? name,
    String? username,
    String? location,
    String? avatarUrl,
    Map<String, dynamic>? preferences,
  }) async {
    if (!isAuthenticated || _currentUser == null) {
      throw Exception('No user logged in');
    }

    _setLoading(true);
    _clearError();

    try {
      final body = <String, dynamic>{};
      
      if (name != null) body['name'] = name;
      if (username != null) {
        // Check username availability if changing
        if (username != _currentUser!.username) {
          final isAvailable = await isUsernameAvailable(username);
          if (!isAvailable) {
            throw Exception('Username is already taken');
          }
        }
        body['username'] = username;
      }
      if (location != null) body['location'] = location;
      if (avatarUrl != null) body['avatar_url'] = avatarUrl;
      if (preferences != null) body['preferences'] = preferences;

      final record = await _pb.collection('users').update(
        _currentUser!.id,
        body: body,
      );

      _currentUser = _createUserFromRecord(record);
      notifyListeners();
      return _currentUser!;
    } catch (e) {
      _setError('Profile update failed: ${e.toString()}');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  @override
  Future<bool> isUsernameAvailable(String username) async {
    try {
      final records = await _pb.collection('users').getList(
        filter: 'username = "$username"',
        perPage: 1,
      );
      return records.items.isEmpty;
    } catch (e) {
      if (kDebugMode) {
        print('Error checking username availability: $e');
      }
      return false;
    }
  }

  @override
  Future<void> refreshUser() async {
    if (!isAuthenticated) return;

    _setLoading(true);
    _clearError();

    try {
      await _pb.collection('users').authRefresh();
      
      if (_pb.authStore.model != null) {
        _currentUser = _createUserFromRecord(_pb.authStore.model!);
        notifyListeners();
      }
    } catch (e) {
      _setError('Failed to refresh user: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  @override
  void clearError() {
    _error = null;
    notifyListeners();
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }

  /// Create a StandardUser from PocketBase record
  StandardUser _createUserFromRecord(dynamic record) {
    return StandardUser(
      id: record.id,
      email: record.getStringValue('email'),
      name: record.getStringValue('name'),
      username: record.getStringValue('username'),
      location: record.getStringValue('location').isEmpty ? null : record.getStringValue('location'),
      avatarUrl: record.getStringValue('avatar_url').isEmpty ? null : record.getStringValue('avatar_url'),
      createdAt: DateTime.tryParse(record.getStringValue('created')) ?? DateTime.now(),
      updatedAt: DateTime.tryParse(record.getStringValue('updated')) ?? DateTime.now(),
      preferences: record.data['preferences'] as Map<String, dynamic>? ?? {},
      badges: (record.data['badges'] as List<dynamic>?)?.cast<String>() ?? [],
      beansRated: record.getIntValue('beans_rated'),
      topBrews: record.getIntValue('top_brews'),
      favoriteRoasters: record.getIntValue('favorite_roasters'),
    );
  }
} 