import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  bool _isLoading = false;
  bool _isLoggedIn = false;

  User? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _isLoggedIn;

  AuthProvider() {
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userData = prefs.getString('user_data');
      if (userData != null) {
        // In a real app, you would decode and validate the user data
        _isLoggedIn = true;
        // Mock user for demo
        _user = User(
          id: '1',
          name: 'John Doe',
          email: 'john@example.com',
          phone: '+1234567890',
        );
      }
    } catch (e) {
      print('Error checking login status: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Mock login - in a real app, you would call your API
      await Future.delayed(Duration(seconds: 2));

      if (email.isNotEmpty && password.isNotEmpty) {
        _user = User(
          id: '1',
          name: 'John Doe',
          email: email,
          phone: '+1234567890',
        );
        _isLoggedIn = true;

        // Save login status
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_data', 'logged_in');

        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Login error: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register(String name, String email, String phone, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Mock registration - in a real app, you would call your API
      await Future.delayed(Duration(seconds: 2));

      if (name.isNotEmpty && email.isNotEmpty && phone.isNotEmpty && password.isNotEmpty) {
        _user = User(
          id: '1',
          name: name,
          email: email,
          phone: phone,
        );
        _isLoggedIn = true;

        // Save login status
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('user_data', 'logged_in');

        _isLoading = false;
        notifyListeners();
        return true;
      }
    } catch (e) {
      print('Registration error: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('user_data');
      
      _user = null;
      _isLoggedIn = false;
    } catch (e) {
      print('Logout error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> updateProfile(User updatedUser) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Mock update - in a real app, you would call your API
      await Future.delayed(Duration(seconds: 1));
      _user = updatedUser;
    } catch (e) {
      print('Update profile error: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}
