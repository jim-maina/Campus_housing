import 'package:flutter/foundation.dart';
import '../models/user.dart';

/// AuthProvider manages authentication state and user signup/login logic
/// Using ChangeNotifier to notify listeners when auth state changes
class AuthProvider extends ChangeNotifier {
  // Store the currently logged-in user (null if not logged in)
  User? _currentUser;

  /// In-memory store of registered users keyed by email.
  final Map<String, User> _users = {};

  User? get currentUser => _currentUser;

  // Check if user is logged in
  bool get isLoggedIn => _currentUser != null;

  // Get the user type: 'student' or 'landlord'
  String? get userType {
    if (_currentUser is Student) return 'student';
    if (_currentUser is Landlord) return 'landlord';
    return null;
  }

  /// Sign up a student
  /// In a real app, this would send data to a backend server
  Future<bool> signupStudent({
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      // TODO: In production, validate email format and call a backend API
      // For now, we'll create the user locally

      // Generate a simple ID (in production, backend would do this)
      final id = DateTime.now().millisecondsSinceEpoch.toString();

      final student = Student(
        id: id,
        email: email,
        password: password, // In production, never store plain passwords!
        phone: phone,
      );
      _currentUser = student;
      _users[email] = student;

      // Notify listeners that user state has changed
      notifyListeners();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('Signup error: $e');
      }
      return false;
    }
  }

  /// Sign up a landlord
  /// In a real app, this would send data to a backend server
  Future<bool> signupLandlord({
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      // TODO: In production, validate email format and call a backend API
      // For now, we'll create the user locally

      // Generate a simple ID (in production, backend would do this)
      final id = DateTime.now().millisecondsSinceEpoch.toString();

      final landlord = Landlord(
        id: id,
        email: email,
        password: password, // In production, never store plain passwords!
        phone: phone,
      );
      _currentUser = landlord;
      _users[email] = landlord;

      // Notify listeners that user state has changed
      notifyListeners();
      return true;
    } catch (e) {
      print('Signup error: $e');
      return false;
    }
  }

  /// Login an existing user
  /// In a real app, this would verify against a backend database
  Future<bool> login({required String email, required String password}) async {
    try {
      // lookup user in our simple store
      final user = _users[email];
      if (user == null) {
        // no account for this email
        return false;
      }
      if (user.password != password) {
        return false;
      }
      _currentUser = user;

      notifyListeners();
      return true;
    } catch (e) {
      print('Login error: $e');
      return false;
    }
  }

  /// Logout the current user
  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
