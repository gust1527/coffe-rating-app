import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:coffe_rating_app_impl/domain/entities/user.dart';
import 'package:coffe_rating_app_impl/core/utils/coffee_logger.dart';

/// Strategy interface for authentication operations
abstract class AuthStrategy extends ChangeNotifier {
  /// Whether there is a valid authenticated session
  bool get isAuthenticated;

  /// The current authenticated user's ID or null if not authenticated
  String? get currentUserId;

  /// The current authenticated user or null if not authenticated
  User? get currentUser;

  /// Whether the auth system is currently processing a request
  bool get isLoading;

  /// Current error message if any
  String? get error;

  /// Authenticates a user with email and password
  Future<User> authenticate({
    required String email,
    required String password,
  });

  /// Logs in a user with a token (for persistent login)
  Future<bool> loginWithToken();

  /// Logs out the current user
  Future<void> logout();

  /// Creates a new user account and authenticates them
  Future<User> createUser({
    required String email,
    required String name,
    required String username,
    required String password,
    String? location,
  });

  /// Updates the current user's profile
  Future<User> updateProfile({
    String? name,
    String? username,
    String? location,
    String? avatarUrl,
    Map<String, dynamic>? preferences,
  });

  /// Checks if a username is available
  Future<bool> isUsernameAvailable(String username);

  /// Refreshes the current user data
  Future<void> refreshUser();

  /// Clears any error state
  void clearError();
}

abstract class _AuthStrategy extends AuthStrategy {
  bool _isLoading = false;
  User? _currentUser;
  String? _error;

  bool get isLoading => _isLoading;
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentUser != null;
  String? get error => _error;
  String? get currentUserId => _currentUser?.id;

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setCurrentUser(User? user) {
    _currentUser = user;
    if (user != null) {
      CoffeeLogger.info('User authenticated: ${user.email}');
    } else {
      CoffeeLogger.info('User signed out');
    }
    notifyListeners();
  }

  void _setError(String? error) {
    _error = error;
    if (error != null) {
      CoffeeLogger.error('Auth error', error);
    }
    notifyListeners();
  }

  @override
  void clearError() {
    _setError(null);
  }

  @override
  Future<bool> loginWithToken() async {
    CoffeeLogger.info('Attempting to login with token');
    _setLoading(true);
    _setError(null);
    try {
      // This should be implemented by concrete classes
      return false;
    } catch (e, stackTrace) {
      CoffeeLogger.error('Token login failed', e, stackTrace);
      _setError(e.toString());
      return false;
    } finally {
      _setLoading(false);
    }
  }

  @override
  Future<void> logout() async {
    await signOut();
  }

  @override
  Future<void> refreshUser() async {
    CoffeeLogger.info('Refreshing user data');
    _setLoading(true);
    _setError(null);
    try {
      // This should be implemented by concrete classes
      _setLoading(false);
    } catch (e, stackTrace) {
      CoffeeLogger.error('User refresh failed', e, stackTrace);
      _setError(e.toString());
      _setLoading(false);
    }
  }

  @override
  Future<bool> isUsernameAvailable(String username) async {
    CoffeeLogger.info('Checking username availability: $username');
    _setLoading(true);
    _setError(null);
    try {
      // This should be implemented by concrete classes
      return true;
    } catch (e, stackTrace) {
      CoffeeLogger.error('Username check failed', e, stackTrace);
      _setError(e.toString());
      return false;
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
    CoffeeLogger.info('Updating user profile');
    _setLoading(true);
    _setError(null);
    try {
      // This should be implemented by concrete classes
      if (_currentUser == null) {
        throw Exception('No user logged in');
      }
      return _currentUser!;
    } catch (e, stackTrace) {
      CoffeeLogger.error('Profile update failed', e, stackTrace);
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<User> authenticate({
    required String email,
    required String password,
  }) async {
    CoffeeLogger.info('Attempting to authenticate user: $email');
    _setLoading(true);
    _setError(null);

    try {
      final user = await signIn(email: email, password: password);
      _setCurrentUser(user);
      CoffeeLogger.info('Successfully authenticated user: $email');
      return user;
    } catch (e, stackTrace) {
      CoffeeLogger.error('Authentication failed', e, stackTrace);
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<User> createUser({
    required String email,
    required String name,
    required String username,
    required String password,
    String? location,
  }) async {
    CoffeeLogger.info('Attempting to create user: $email');
    _setLoading(true);
    _setError(null);

    try {
      final user = await signUp(
        email: email,
        name: name,
        username: username,
        password: password,
        location: location,
      );
      _setCurrentUser(user);
      CoffeeLogger.info('Successfully created user: $email');
      return user;
    } catch (e, stackTrace) {
      CoffeeLogger.error('User creation failed', e, stackTrace);
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    CoffeeLogger.info('Signing out current user');
    _setLoading(true);
    _setError(null);

    try {
      await performSignOut();
      _setCurrentUser(null);
      CoffeeLogger.info('Successfully signed out user');
    } catch (e, stackTrace) {
      CoffeeLogger.error('Sign out failed', e, stackTrace);
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  @protected
  Future<User> signIn({
    required String email,
    required String password,
  });

  @protected
  Future<User> signUp({
    required String email,
    required String name,
    required String username,
    required String password,
    String? location,
  });

  @protected
  Future<void> performSignOut();
} 