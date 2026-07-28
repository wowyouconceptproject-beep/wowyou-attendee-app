import "package:flutter/foundation.dart";

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

  /*
  |--------------------------------------------------------------------------
  | Register
  |--------------------------------------------------------------------------
  */

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
        debugPrint(
          "REGISTER FAILED: ${result["message"]}",
        );

        return false;
      }

      final token =
          result["token"];

      if (token == null ||
          token is! String ||
          token.isEmpty) {
        debugPrint(
          "REGISTER FAILED: Token missing.",
        );

        return false;
      }

      /*
      |--------------------------------------------------------------------------
      | Persist Token
      |--------------------------------------------------------------------------
      */

      await Storage.saveToken(
        token,
      );

      /*
      |--------------------------------------------------------------------------
      | Resolve Current User
      |--------------------------------------------------------------------------
      */

      final currentUser =
          await _authService.getMe(
        token,
      );

      if (currentUser == null) {
        await Storage.clearToken();

        return false;
      }

      _token = token;
      _user = currentUser;

      return true;
    } catch (error, stackTrace) {
      debugPrint(
        "REGISTER ERROR: $error",
      );

      debugPrint(
        stackTrace.toString(),
      );

      return false;
    } finally {
      _loading = false;

      notifyListeners();
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Login
  |--------------------------------------------------------------------------
  */

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
        debugPrint(
          "LOGIN FAILED: ${result["message"]}",
        );

        return false;
      }

      final token =
          result["token"];

      if (token == null ||
          token is! String ||
          token.isEmpty) {
        debugPrint(
          "LOGIN FAILED: Token missing.",
        );

        return false;
      }

      /*
      |--------------------------------------------------------------------------
      | Persist Token
      |--------------------------------------------------------------------------
      */

      await Storage.saveToken(
        token,
      );

      /*
      |--------------------------------------------------------------------------
      | Resolve Current User
      |--------------------------------------------------------------------------
      */

      final currentUser =
          await _authService.getMe(
        token,
      );

      if (currentUser == null) {
        await Storage.clearToken();

        return false;
      }

      _token = token;
      _user = currentUser;

      return true;
    } catch (error, stackTrace) {
      debugPrint(
        "LOGIN ERROR: $error",
      );

      debugPrint(
        stackTrace.toString(),
      );

      return false;
    } finally {
      _loading = false;

      notifyListeners();
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Restore Session
  |--------------------------------------------------------------------------
  */

  Future<void> loadUser() async {
    /*
    |--------------------------------------------------------------------------
    | Prevent duplicate initialization
    |--------------------------------------------------------------------------
    */

    if (_initialized) {
      return;
    }

    try {
      final savedToken =
          await Storage.getToken();

      if (savedToken == null ||
          savedToken.isEmpty) {
        _user = null;
        _token = null;

        return;
      }

      final currentUser =
          await _authService.getMe(
        savedToken,
      );

      /*
      |--------------------------------------------------------------------------
      | Expired / Invalid Session
      |--------------------------------------------------------------------------
      */

      if (currentUser == null) {
        await Storage.clearToken();

        _user = null;
        _token = null;

        return;
      }

      /*
      |--------------------------------------------------------------------------
      | Restore Session
      |--------------------------------------------------------------------------
      */

      _token = savedToken;
      _user = currentUser;
    } catch (error, stackTrace) {
      debugPrint(
        "LOAD USER ERROR: $error",
      );

      debugPrint(
        stackTrace.toString(),
      );

      /*
      |--------------------------------------------------------------------------
      | Fail closed
      |--------------------------------------------------------------------------
      */

      _user = null;
      _token = null;
    } finally {
      _initialized = true;

      notifyListeners();
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Logout
  |--------------------------------------------------------------------------
  */

  Future<void> logout() async {
    try {
      await Storage.clearToken();
    } catch (error) {
      debugPrint(
        "LOGOUT STORAGE ERROR: $error",
      );
    } finally {
      _user = null;
      _token = null;

      notifyListeners();
    }
  }
}