import "dart:convert";

import "package:flutter/foundation.dart";
import "package:http/http.dart" as http;

import "../config/api.dart";
import "../models/user.dart";

class AuthService {
  /*
  |--------------------------------------------------------------------------
  | Register
  |--------------------------------------------------------------------------
  |
  | Creates an ATTENDEE account.
  |
  | The backend sends the email verification email after registration.
  |
  */

  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final url =
        "${ApiConfig.baseUrl}/auth/register";

    final body = {
      "firstName": firstName.trim(),
      "lastName": lastName.trim(),
      "email": email.trim().toLowerCase(),
      "password": password,
      "role": "ATTENDEE",
    };

    debugPrint("");
    debugPrint("========== REGISTER ==========");
    debugPrint("URL: $url");
    debugPrint("REQUEST:");
    debugPrint(
      jsonEncode({
        "firstName": firstName.trim(),
        "lastName": lastName.trim(),
        "email": email.trim().toLowerCase(),
        "role": "ATTENDEE",
      }),
    );

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      debugPrint(
        "STATUS: ${response.statusCode}",
      );
      debugPrint("RESPONSE:");
      debugPrint(response.body);

      return _decodeResponse(
        response,
        fallbackMessage:
            "Registration failed",
      );
    } catch (error) {
      debugPrint(
        "REGISTER NETWORK ERROR: $error",
      );

      return {
        "success": false,
        "message":
            "Unable to connect to the server. Please check your internet connection.",
      };
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Login
  |--------------------------------------------------------------------------
  |
  | Step 1:
  |
  | Email + password are verified by the backend.
  |
  | If the account is verified, the backend sends a login OTP and returns:
  |
  | {
  |   success: true,
  |   requiresOtp: true,
  |   email: "..."
  | }
  |
  | No JWT is returned at this stage.
  |
  */

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url =
        "${ApiConfig.baseUrl}/auth/login";

    final body = {
      "email": email.trim().toLowerCase(),
      "password": password,
    };

    debugPrint("");
    debugPrint("========== LOGIN ==========");
    debugPrint("URL: $url");
    debugPrint("REQUEST:");
    debugPrint(
      jsonEncode({
        "email": email.trim().toLowerCase(),
      }),
    );

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      debugPrint(
        "STATUS: ${response.statusCode}",
      );
      debugPrint("RESPONSE:");
      debugPrint(response.body);

      return _decodeResponse(
        response,
        fallbackMessage:
            "Login failed",
      );
    } catch (error) {
      debugPrint(
        "LOGIN NETWORK ERROR: $error",
      );

      return {
        "success": false,
        "message":
            "Unable to connect to the server. Please check your internet connection.",
      };
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Verify Login OTP
  |--------------------------------------------------------------------------
  |
  | Step 2 of login.
  |
  | The backend verifies the 6-digit OTP.
  |
  | Successful response:
  |
  | {
  |   success: true,
  |   token: "...",
  |   user: {...}
  | }
  |
  */

  Future<Map<String, dynamic>> verifyLoginOtp({
    required String email,
    required String otp,
  }) async {
    final url =
        "${ApiConfig.baseUrl}/auth/verify-login-otp";

    final body = {
      "email": email.trim().toLowerCase(),
      "otp": otp.trim(),
    };

    debugPrint("");
    debugPrint(
      "========== VERIFY LOGIN OTP ==========",
    );
    debugPrint("URL: $url");
    debugPrint("EMAIL: ${email.trim().toLowerCase()}");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      debugPrint(
        "STATUS: ${response.statusCode}",
      );
      debugPrint("RESPONSE:");
      debugPrint(response.body);

      return _decodeResponse(
        response,
        fallbackMessage:
            "Verification code could not be verified",
      );
    } catch (error) {
      debugPrint(
        "VERIFY OTP NETWORK ERROR: $error",
      );

      return {
        "success": false,
        "message":
            "Unable to connect to the server. Please check your internet connection.",
      };
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Resend Login OTP
  |--------------------------------------------------------------------------
  |
  | Sends a fresh 6-digit login code.
  |
  */

  Future<Map<String, dynamic>> resendLoginOtp({
    required String email,
  }) async {
    final url =
        "${ApiConfig.baseUrl}/auth/resend-login-otp";

    final body = {
      "email": email.trim().toLowerCase(),
    };

    debugPrint("");
    debugPrint(
      "========== RESEND LOGIN OTP ==========",
    );
    debugPrint("URL: $url");
    debugPrint(
      "EMAIL: ${email.trim().toLowerCase()}",
    );

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      debugPrint(
        "STATUS: ${response.statusCode}",
      );
      debugPrint("RESPONSE:");
      debugPrint(response.body);

      return _decodeResponse(
        response,
        fallbackMessage:
            "Unable to resend login code",
      );
    } catch (error) {
      debugPrint(
        "RESEND OTP NETWORK ERROR: $error",
      );

      return {
        "success": false,
        "message":
            "Unable to connect to the server. Please check your internet connection.",
      };
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Resend Verification Email
  |--------------------------------------------------------------------------
  |
  | Used when an attendee has created an account but has not yet verified
  | their email address.
  |
  */

  Future<Map<String, dynamic>>
      resendVerificationEmail({
    required String email,
  }) async {
    final url =
        "${ApiConfig.baseUrl}/auth/resend-verification";

    final body = {
      "email": email.trim().toLowerCase(),
    };

    debugPrint("");
    debugPrint(
      "========== RESEND VERIFICATION EMAIL ==========",
    );
    debugPrint("URL: $url");
    debugPrint(
      "EMAIL: ${email.trim().toLowerCase()}",
    );

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
        body: jsonEncode(body),
      );

      debugPrint(
        "STATUS: ${response.statusCode}",
      );
      debugPrint("RESPONSE:");
      debugPrint(response.body);

      return _decodeResponse(
        response,
        fallbackMessage:
            "Unable to resend verification email",
      );
    } catch (error) {
      debugPrint(
        "RESEND VERIFICATION NETWORK ERROR: $error",
      );

      return {
        "success": false,
        "message":
            "Unable to connect to the server. Please check your internet connection.",
      };
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Verify Email
  |--------------------------------------------------------------------------
  |
  | Called when the attendee opens the verification link.
  |
  | Backend:
  |
  | GET /auth/verify-email?token=...
  |
  */

  Future<Map<String, dynamic>> verifyEmail({
    required String token,
  }) async {
    final encodedToken =
        Uri.encodeQueryComponent(
      token.trim(),
    );

    final url =
        "${ApiConfig.baseUrl}/auth/verify-email?token=$encodedToken";

    debugPrint("");
    debugPrint(
      "========== VERIFY EMAIL ==========",
    );
    debugPrint("URL: $url");

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
        },
      );

      debugPrint(
        "STATUS: ${response.statusCode}",
      );
      debugPrint("RESPONSE:");
      debugPrint(response.body);

      return _decodeResponse(
        response,
        fallbackMessage:
            "Email verification failed",
      );
    } catch (error) {
      debugPrint(
        "VERIFY EMAIL NETWORK ERROR: $error",
      );

      return {
        "success": false,
        "message":
            "Unable to connect to the server. Please check your internet connection.",
      };
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Current User
  |--------------------------------------------------------------------------
  |
  | Restores the authenticated attendee session.
  |
  | GET /auth/me
  |
  */

  Future<User?> getMe(
    String token,
  ) async {
    final url =
        "${ApiConfig.baseUrl}/auth/me";

    debugPrint("");
    debugPrint(
      "========== GET CURRENT USER ==========",
    );
    debugPrint("URL: $url");

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization":
              "Bearer $token",
          "Content-Type":
              "application/json",
        },
      );

      debugPrint(
        "STATUS: ${response.statusCode}",
      );
      debugPrint("RESPONSE:");
      debugPrint(response.body);

      if (response.statusCode != 200) {
        return null;
      }

      final data =
          jsonDecode(response.body);

      if (data is! Map<String, dynamic>) {
        return null;
      }

      if (data["success"] != true) {
        return null;
      }

      final userData =
          data["user"];

      if (userData is! Map<String, dynamic>) {
        return null;
      }

      return User.fromJson(
        userData,
      );
    } catch (error) {
      debugPrint(
        "GET ME ERROR: $error",
      );

      return null;
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Authenticated GET
  |--------------------------------------------------------------------------
  |
  | Generic authenticated GET helper used by attendee services.
  |
  */

  Future<Map<String, dynamic>>
      authenticatedGet(
    String endpoint,
    String token,
  ) async {
    final url =
        "${ApiConfig.baseUrl}$endpoint";

    debugPrint("");
    debugPrint(
      "========== AUTHENTICATED GET ==========",
    );
    debugPrint("URL: $url");

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {
          "Authorization":
              "Bearer $token",
          "Content-Type":
              "application/json",
        },
      );

      debugPrint(
        "STATUS: ${response.statusCode}",
      );
      debugPrint("RESPONSE:");
      debugPrint(response.body);

      return _decodeResponse(
        response,
        fallbackMessage:
            "Request failed",
      );
    } catch (error) {
      debugPrint(
        "AUTHENTICATED GET ERROR: $error",
      );

      return {
        "success": false,
        "message":
            "Unable to connect to the server. Please check your internet connection.",
      };
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Response Decoder
  |--------------------------------------------------------------------------
  */

  Map<String, dynamic> _decodeResponse(
    http.Response response, {
    required String fallbackMessage,
  }) {
    try {
      final decoded =
          jsonDecode(response.body);

      if (decoded
          is Map<String, dynamic>) {
        return decoded;
      }

      return {
        "success": false,
        "message": fallbackMessage,
      };
    } catch (error) {
      debugPrint(
        "AUTH JSON ERROR: $error",
      );

      return {
        "success": false,
        "message": fallbackMessage,
      };
    }
  }
}