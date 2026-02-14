import 'package:flutter/foundation.dart';
import '../models/user.dart';

/// AuthProvider manages authentication state and user signup/login logic
/// Using ChangeNotifier to notify listeners when auth state changes
class AuthProvider extends ChangeNotifier {
  // Store the currently logged-in user (null if not logged in)
  User? _currentUser;

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
    required String fullName,
    required String phone,
    required String university,
    required String major,
    required int graduationYear,
  }) async {
    try {
      // TODO: In production, validate email format and call a backend API
      // For now, we'll create the user locally
      
      // Generate a simple ID (in production, backend would do this)
      final id = DateTime.now().millisecondsSinceEpoch.toString();

      _currentUser = Student(
        id: id,
        email: email,
        password: password, // In production, never store plain passwords!
        fullName: fullName,
        phone: phone,
        university: university,
        major: major,
        graduationYear: graduationYear,
      );

      // Notify listeners that user state has changed
      notifyListeners();
      return true;
    } catch (e) {
      print('Signup error: $e');
      return false;
    }
  }

  /// Sign up a landlord
  /// In a real app, this would send data to a backend server
  Future<bool> signupLandlord({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String companyName,
    required String bankAccount,
    required String taxId,
  }) async {
    try {
      // TODO: In production, validate email format and call a backend API
      // For now, we'll create the user locally

      // Generate a simple ID (in production, backend would do this)
      final id = DateTime.now().millisecondsSinceEpoch.toString();

      _currentUser = Landlord(
        id: id,
        email: email,
        password: password, // In production, never store plain passwords!
        fullName: fullName,
        phone: phone,
        companyName: companyName,
        bankAccount: bankAccount,
        taxId: taxId,
      );

      // Notify listeners that user state has changed
      notifyListeners();
      return true;
    } catch (e) {
      print('Signup error: $e');
      return false;
    }
  }

  /// Logout the current user
  void logout() {
    _currentUser = null;
    notifyListeners();
  }
}
