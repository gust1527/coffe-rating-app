import 'package:coffe_rating_app_impl/core/auth/auth_strategy.dart';
import 'package:coffe_rating_app_impl/domain/entities/user.dart';
import 'package:coffe_rating_app_impl/domain/entities/standard_user.dart';

/// Mock authentication strategy for development and testing
class MockAuthStrategy extends AuthStrategy {
  User? _currentUser;
  bool _isLoading = false;
  String? _error;

  @override
  bool get isAuthenticated => _currentUser != null;

  @override
  String? get currentUserId => _currentUser?.id;

  @override
  User? get currentUser => _currentUser;

  @override
  bool get isLoading => _isLoading;

  @override
  String? get error => _error;

  /// Constructor - automatically logs in demo user for development
  MockAuthStrategy() {
    // Auto-login demo user for development
    _loginDemoUser();
  }

  void _loginDemoUser() {
    _currentUser = StandardUser.demo();
    notifyListeners();
  }

  @override
  Future<User> authenticate({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Simulate network delay
      await Future.delayed(const Duration(milliseconds: 1500));

      // Mock authentication logic
      if (email == 'demo@nordic-bean.com' && password == 'password') {
        _currentUser = StandardUser.demo();
        notifyListeners();
        return _currentUser!;
      } else {
        throw Exception('Invalid email or password');
      }
    } catch (e) {
      _setError(e.toString());
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
      // Simulate token validation
      await Future.delayed(const Duration(milliseconds: 1000));
      
      // For mock, always succeed and login demo user
      _currentUser = StandardUser.demo();
      notifyListeners();
      return true;
    } catch (e) {
      _setError(e.toString());
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
      // Simulate logout process
      await Future.delayed(const Duration(milliseconds: 500));
      
      _currentUser = null;
      notifyListeners();
    } catch (e) {
      _setError(e.toString());
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
      // Simulate user creation
      await Future.delayed(const Duration(milliseconds: 2000));

      // Check if username is taken (mock validation)
      if (username == 'madsnielsen') {
        throw Exception('Username already taken');
      }

      // Create new user
      final newUser = StandardUser(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        name: name,
        username: username,
        location: location,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );

      _currentUser = newUser;
      notifyListeners();
      return newUser;
    } catch (e) {
      _setError(e.toString());
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
    if (_currentUser == null) {
      throw Exception('No user logged in');
    }

    _setLoading(true);
    _clearError();

    try {
      // Simulate profile update
      await Future.delayed(const Duration(milliseconds: 1000));

      final updatedUser = (_currentUser as StandardUser).copyWith(
        name: name,
        username: username,
        location: location,
        avatarUrl: avatarUrl,
        preferences: preferences,
        updatedAt: DateTime.now(),
      );

      _currentUser = updatedUser;
      notifyListeners();
      return updatedUser;
    } catch (e) {
      _setError(e.toString());
      rethrow;
    } finally {
      _setLoading(false);
    }
  }

  @override
  Future<bool> isUsernameAvailable(String username) async {
    // Simulate username check
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Mock: some usernames are taken
    final takenUsernames = ['madsnielsen', 'admin', 'coffee', 'nordic'];
    return !takenUsernames.contains(username.toLowerCase());
  }

  @override
  Future<void> refreshUser() async {
    if (_currentUser == null) return;

    _setLoading(true);
    _clearError();

    try {
      // Simulate user data refresh
      await Future.delayed(const Duration(milliseconds: 800));
      
      // In a real app, this would fetch fresh user data from the server
      // For mock, we'll just update the timestamp
      if (_currentUser is StandardUser) {
        _currentUser = (_currentUser as StandardUser).copyWith(
          updatedAt: DateTime.now(),
        );
        notifyListeners();
      }
    } catch (e) {
      _setError(e.toString());
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
} 