import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'storage_service.dart';

class AuthService extends ChangeNotifier {
  final SupabaseClient _supabase = Supabase.instance.client;
  User? _user;

  User? get user => _user;
  bool get isAuthenticated => _user != null;

  AuthService() {
    _user = _supabase.auth.currentUser;
  }

  Future<String?> signUp(String email, String password) async {
    try {
      final response = await _supabase.auth.signUp(
        email: email,
        password: password,
      );

      if (response.user != null) {
        _user = response.user;
        StorageService.isLoggedIn = true;
        StorageService.userEmail = email;
        notifyListeners();
        return null;
      }
      return 'Sign up failed';
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> signIn(String email, String password) async {
    try {
      final response = await _supabase.auth.signInWithPassword(
        email: email,
        password: password,
      );

      if (response.user != null) {
        _user = response.user;
        StorageService.isLoggedIn = true;
        StorageService.userEmail = email;
        notifyListeners();
        return null;
      }
      return 'Sign in failed';
    } catch (e) {
      return e.toString();
    }
  }

  Future<void> signOut() async {
    await _supabase.auth.signOut();
    _user = null;
    await StorageService.clearAll();
    notifyListeners();
  }
}
