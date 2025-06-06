import 'package:coffe_rating_app_impl/core/auth/auth_strategy.dart';
import 'package:coffe_rating_app_impl/domain/entities/user.dart';
import 'package:coffe_rating_app_impl/domain/entities/standard_user.dart';
import 'package:coffe_rating_app_impl/core/clients/pocketbase_client.dart';
import 'package:pocketbase/pocketbase.dart';
import 'package:flutter/foundation.dart';

/// PocketBase authentication strategy implementation
class PocketBaseAuthStrategy extends AuthStrategy {
  late final PocketBase _pb;
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  PocketBaseAuthStrategy() {
    _pb = PocketBaseClient.shared.instance;
    _initializeAuthState();
  }

  @override
  bool get isAuthenticated => _pb.authStore.isValid && _currentUser != null;

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
      
      if (authData.record == null) {
        throw Exception('Authentication failed: No user record returned');
      }

      _currentUser = _createUserFromRecord(authData.record!);
      notifyListeners();
      return _currentUser!;
    } catch (e) {
      _setError('Authentication failed: ${e.toString()}');
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  @override
  Future<bool> loginWithToken() async {
    _setLoading(true);
    _clearError();

    try {
      // PocketBase automatically handles token validation
      if (_pb.authStore.isValid && _pb.authStore.model != null) {
        // Refresh the auth state to ensure token is still valid
        await _pb.collection('users').authRefresh();
        _currentUser = _createUserFromRecord(_pb.authStore.model!);
        notifyListeners();
        return true;
      }
      return false;
    } catch (e) {
      _setError('Token validation failed: ${e.toString()}');
      _pb.authStore.clear();
      return false;
    } finally {
      _setLoading(false);
    }
  }

  @override
  Future<void> logout() async {
    _setLoading(true);
    _clearError();

    try {
      _pb.authStore.clear();
      _currentUser = null;
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
      // Check if username is available first
      final isAvailable = await isUsernameAvailable(username);
      if (!isAvailable) {
        throw Exception('Username is already taken');
      }

      // Create the user record
      final body = <String, dynamic>{
        'email': email,
        'name': name,
        'username': username,
        'password': password,
        'passwordConfirm': password,
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