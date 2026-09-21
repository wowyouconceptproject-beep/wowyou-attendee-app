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

  /*
  |--------------------------------------------------------------------------
  | Pending Login
  |--------------------------------------------------------------------------
  |
  | After email/password succeeds, the backend sends an OTP.
  | We temporarily retain the email so the OTP screen can complete login.
  |
  */

  String? _pendingLoginEmail;

  /*
  |--------------------------------------------------------------------------
  | Getters
  |--------------------------------------------------------------------------
  */

  User? get user => _user;

  String? get token => _token;

  bool get isLoading => _loading;

  bool get initialized =>
      _initialized;

  bool get isAuthenticated =>
      _token != null &&
      _user != null;

  bool get requiresLoginOtp =>
      _pendingLoginEmail != null;

  String? get pendingLoginEmail =>
      _pendingLoginEmail;

  String get displayName =>
      "${_user?.firstName ?? ""} ${_user?.lastName ?? ""}"
          .trim();

  /*
  |--------------------------------------------------------------------------
  | Register
  |--------------------------------------------------------------------------
  |
  | Registration creates the attendee account.
  |
  | The backend currently returns a token for registration, so we preserve
  | that behavior here. The UI should still direct an unverified attendee
  | through email verification before normal login.
  |
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

      /*
      |--------------------------------------------------------------------------
      | Registration Token
      |--------------------------------------------------------------------------
      */

      if (token == null ||
          token is! String ||
          token.isEmpty) {
        /*
        |----------------------------------------------------------------------
        | Registration may still be successful even if the backend chooses
        | not to authenticate the newly created account.
        |----------------------------------------------------------------------
        */

        debugPrint(
          "REGISTER SUCCESS: No authentication token returned.",
        );

        _user = null;
        _token = null;

        return true;
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

        _user = null;
        _token = null;

        /*
        | Registration itself succeeded. The account simply isn't being
        | treated as an authenticated session.
        */

        return true;
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
  | Login - Step 1
  |--------------------------------------------------------------------------
  |
  | Email + password are submitted.
  |
  | The backend does NOT return a JWT here.
  |
  | Instead:
  |
  | {
  |   success: true,
  |   requiresOtp: true,
  |   email: "..."
  | }
  |
  | The UI should then navigate to the OTP screen.
  |
  */

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    try {
      _loading = true;
      notifyListeners();

      /*
      |--------------------------------------------------------------------------
      | Clear Previous Pending Login
      |--------------------------------------------------------------------------
      */

      _pendingLoginEmail = null;

      final normalizedEmail =
          email.trim().toLowerCase();

      final result =
          await _authService.login(
        email: normalizedEmail,
        password: password,
      );

      if (result["success"] != true) {
        debugPrint(
          "LOGIN FAILED: ${result["message"]}",
        );

        return false;
      }

      /*
      |--------------------------------------------------------------------------
      | Email Verification Required
      |--------------------------------------------------------------------------
      |
      | This means the attendee entered the correct password but has not yet
      | verified their email address.
      |
      */

      if (result["requiresEmailVerification"] ==
          true) {
        debugPrint(
          "LOGIN REQUIRES EMAIL VERIFICATION.",
        );

        return false;
      }

      /*
      |--------------------------------------------------------------------------
      | OTP Required
      |--------------------------------------------------------------------------
      */

      if (result["requiresOtp"] == true) {
        final responseEmail =
            result["email"];

        final pendingEmail =
            responseEmail is String &&
                    responseEmail
                        .trim()
                        .isNotEmpty
                ? responseEmail
                    .trim()
                    .toLowerCase()
                : normalizedEmail;

        _pendingLoginEmail =
            pendingEmail;

        debugPrint(
          "LOGIN SUCCESS: OTP required.",
        );

        debugPrint(
          "OTP EMAIL: $_pendingLoginEmail",
        );

        /*
        |----------------------------------------------------------------------
        | IMPORTANT:
        |
        | No token is stored here.
        | Authentication is not complete until OTP verification succeeds.
        |----------------------------------------------------------------------
        */

        return true;
      }

      /*
      |--------------------------------------------------------------------------
      | Defensive Fallback
      |--------------------------------------------------------------------------
      |
      | If the backend unexpectedly returns a JWT directly, support it rather
      | than silently breaking the client.
      |
      */

      final token =
          result["token"];

      if (token == null ||
          token is! String ||
          token.isEmpty) {
        debugPrint(
          "LOGIN FAILED: Authentication response did not contain OTP or token.",
        );

        return false;
      }

      await _completeAuthenticatedSession(
        token,
      );

      return isAuthenticated;
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
  | Verify Login OTP - Step 2
  |--------------------------------------------------------------------------
  |
  | This is the actual completion of login.
  |
  | Successful OTP verification returns:
  |
  | token + user
  |
  */

  Future<bool> verifyLoginOtp({
    required String otp,
  }) async {
    final email =
        _pendingLoginEmail;

    if (email == null ||
        email.isEmpty) {
      debugPrint(
        "VERIFY OTP FAILED: No pending login.",
      );

      return false;
    }

    try {
      _loading = true;
      notifyListeners();

      final result =
          await _authService.verifyLoginOtp(
        email: email,
        otp: otp,
      );

      if (result["success"] != true) {
        debugPrint(
          "VERIFY OTP FAILED: ${result["message"]}",
        );

        return false;
      }

      final token =
          result["token"];

      if (token == null ||
          token is! String ||
          token.isEmpty) {
        debugPrint(
          "VERIFY OTP FAILED: Token missing.",
        );

        return false;
      }

      /*
      |--------------------------------------------------------------------------
      | Complete Authenticated Session
      |--------------------------------------------------------------------------
      */

      final authenticated =
          await _completeAuthenticatedSession(
        token,
      );

      if (!authenticated) {
        return false;
      }

      /*
      |--------------------------------------------------------------------------
      | Clear Pending Login
      |--------------------------------------------------------------------------
      */

      _pendingLoginEmail = null;

      return true;
    } catch (error, stackTrace) {
      debugPrint(
        "VERIFY OTP ERROR: $error",
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
  | Resend Login OTP
  |--------------------------------------------------------------------------
  */

  Future<bool> resendLoginOtp() async {
    final email =
        _pendingLoginEmail;

    if (email == null ||
        email.isEmpty) {
      debugPrint(
        "RESEND OTP FAILED: No pending login.",
      );

      return false;
    }

    try {
      _loading = true;
      notifyListeners();

      final result =
          await _authService.resendLoginOtp(
        email: email,
      );

      if (result["success"] != true) {
        debugPrint(
          "RESEND OTP FAILED: ${result["message"]}",
        );

        return false;
      }

      return true;
    } catch (error, stackTrace) {
      debugPrint(
        "RESEND OTP ERROR: $error",
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
  | Resend Verification Email
  |--------------------------------------------------------------------------
  |
  | Used before the account email has been verified.
  |
  */

  Future<bool> resendVerificationEmail({
    required String email,
  }) async {
    try {
      _loading = true;
      notifyListeners();

      final result =
          await _authService
              .resendVerificationEmail(
        email: email,
      );

      if (result["success"] != true) {
        debugPrint(
          "RESEND VERIFICATION FAILED: ${result["message"]}",
        );

        return false;
      }

      return true;
    } catch (error, stackTrace) {
      debugPrint(
        "RESEND VERIFICATION ERROR: $error",
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
  | Verify Email
  |--------------------------------------------------------------------------
  |
  | Handles verification tokens opened inside the attendee app.
  |
  */

  Future<bool> verifyEmail({
    required String token,
  }) async {
    try {
      _loading = true;
      notifyListeners();

      final result =
          await _authService.verifyEmail(
        token: token,
      );

      if (result["success"] != true) {
        debugPrint(
          "VERIFY EMAIL FAILED: ${result["message"]}",
        );

        return false;
      }

      return true;
    } catch (error, stackTrace) {
      debugPrint(
        "VERIFY EMAIL ERROR: $error",
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
    | Prevent Duplicate Initialization
    |--------------------------------------------------------------------------
    */

    if (_initialized) {
      return;
    }

    try {
      final savedToken =
          await Storage.getToken();

      /*
      |--------------------------------------------------------------------------
      | No Saved Token
      |--------------------------------------------------------------------------
      */

      if (savedToken == null ||
          savedToken.isEmpty) {
        _user = null;
        _token = null;

        return;
      }

      /*
      |--------------------------------------------------------------------------
      | Validate Token Against Backend
      |--------------------------------------------------------------------------
      */

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
      | Fail Closed
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
      _pendingLoginEmail = null;

      notifyListeners();
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Complete Authenticated Session
  |--------------------------------------------------------------------------
  |
  | Saves the JWT and resolves the authenticated user from /auth/me.
  |
  */

  Future<bool>
      _completeAuthenticatedSession(
    String token,
  ) async {
    try {
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

        _token = null;
        _user = null;

        return false;
      }

      /*
      |--------------------------------------------------------------------------
      | Set Authenticated State
      |--------------------------------------------------------------------------
      */

      _token = token;
      _user = currentUser;

      return true;
    } catch (error, stackTrace) {
      debugPrint(
        "COMPLETE SESSION ERROR: $error",
      );

      debugPrint(
        stackTrace.toString(),
      );

      await Storage.clearToken();

      _token = null;
      _user = null;

      return false;
    }
  }
}