import "package:flutter/material.dart";

import "../models/user.dart";
import "../services/auth_service.dart";
import "../utils/storage.dart";

class AuthProvider extends ChangeNotifier {
  final AuthService _authService =
      AuthService();

  User? _user;

  String? _token;

  bool _loading = false;

  bool _initialized = false;

  User? get user => _user;

  String? get token => _token;

  bool get isLoading => _loading;

  bool get initialized =>
      _initialized;

  bool get isAuthenticated =>
      _token != null &&
      _user != null;

  String get displayName =>
      "${_user?.firstName ?? ""} ${_user?.lastName ?? ""}"
          .trim();

  Future<bool> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      _loading = true;
      notifyListeners();

      final result =
          await _authService.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      );

      if (result["success"] != true) {
        return false;
      }

      final token =
          result["token"];

      _token = token;

      await Storage.saveToken(
        token,
      );

      _user =
          await _authService.getMe(
        token,
      );

      notifyListeners();

      return true;
    } catch (e) {
      debugPrint(
        "REGISTER ERROR: $e",
      );

      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      _loading = true;
      notifyListeners();

      final result =
          await _authService.login(
        email: email,
        password: password,
      );

      if (result["success"] != true) {
        return false;
      }

      final token =
          result["token"];

      _token = token;

      await Storage.saveToken(
        token,
      );

      _user =
          await _authService.getMe(
        token,
      );

      notifyListeners();

      return true;
    } catch (e) {
      debugPrint(
        "LOGIN ERROR: $e",
      );

      return false;
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> loadUser() async {
    try {
      final savedToken =
          await Storage.getToken();

      if (savedToken == null) {
        return;
      }

      final currentUser =
          await _authService.getMe(
        savedToken,
      );

      if (currentUser == null) {
        await logout();
        return;
      }

      _token = savedToken;
      _user = currentUser;
    } catch (e) {
      debugPrint(
        "LOAD USER ERROR: $e",
      );
    } finally {
      _initialized = true;
      notifyListeners();
    }
  }

  Future<void> logout() async {
    _user = null;
    _token = null;

    await Storage.clearToken();

    notifyListeners();
  }
}