import "package:flutter/foundation.dart";
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

      debugPrint("");
      debugPrint(
          "REGISTER RESULT:");
      debugPrint(result.toString());

      if (result["success"] != true) {
        debugPrint(
          "REGISTER FAILED: ${result["message"]}",
        );
        return false;
      }

      final token =
          result["token"];

      debugPrint(
          "TOKEN RECEIVED:");
      debugPrint(token);

      _token = token;

      await Storage.saveToken(
        token,
      );

      _user =
          await _authService.getMe(
        token,
      );

      debugPrint(
          "USER AFTER REGISTER:");
      debugPrint(_user.toString());

      notifyListeners();

      return _user != null;
    } catch (e, stack) {
      debugPrint(
        "REGISTER EXCEPTION:",
      );
      debugPrint(e.toString());
      debugPrint(stack.toString());

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

      debugPrint("");
      debugPrint(
          "LOGIN RESULT:");
      debugPrint(result.toString());

      if (result["success"] != true) {
        debugPrint(
          "LOGIN FAILED: ${result["message"]}",
        );
        return false;
      }

      final token =
          result["token"];

      debugPrint(
          "TOKEN RECEIVED:");
      debugPrint(token);

      _token = token;

      await Storage.saveToken(
        token,
      );

      _user =
          await _authService.getMe(
        token,
      );

      debugPrint(
          "USER AFTER LOGIN:");
      debugPrint(_user.toString());

      notifyListeners();

      return _user != null;
    } catch (e, stack) {
      debugPrint(
        "LOGIN EXCEPTION:",
      );
      debugPrint(e.toString());
      debugPrint(stack.toString());

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

      debugPrint(
          "SAVED TOKEN:");
      debugPrint(savedToken);

      if (savedToken == null) {
        return;
      }

      final currentUser =
          await _authService.getMe(
        savedToken,
      );

      debugPrint(
          "CURRENT USER:");
      debugPrint(
          currentUser.toString());

      if (currentUser == null) {
        await logout();
        return;
      }

      _token = savedToken;
      _user = currentUser;
    } catch (e, stack) {
      debugPrint(
          "LOAD USER ERROR:");
      debugPrint(e.toString());
      debugPrint(stack.toString());
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