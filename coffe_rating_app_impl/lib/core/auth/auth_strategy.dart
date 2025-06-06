import 'package:flutter/foundation.dart';
import 'package:coffe_rating_app_impl/domain/entities/user.dart';

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