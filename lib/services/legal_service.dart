import "dart:convert";

import "package:http/http.dart" as http;

import "../config/api.dart";
import "../utils/storage.dart";

class LegalService {
  static const String _baseRoute =
      "/api/legal";

  Future<Map<String, String>> _headers() async {
    final token =
        await Storage.getToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        "Authentication required.",
      );
    }

    return {
      "Authorization":
          "Bearer $token",
      "Content-Type":
          "application/json",
      "Accept":
          "application/json",
    };
  }

  /*
  |--------------------------------------------------------------------------
  | Accept Policies
  |--------------------------------------------------------------------------
  */

  Future<void> acceptPolicies({
    required String fullName,
    required String email,
    required String role,
    String? deviceVersion,
  }) async {
    final response = await http.post(
      Uri.parse(
        "${ApiConfig.baseUrl}$_baseRoute/consent",
      ),
      headers: await _headers(),
      body: jsonEncode({
        "fullName": fullName,
        "email": email,
        "role": role,
        "deviceVersion": deviceVersion,
      }),
    );

    /*
    |--------------------------------------------------------------------------
    | HTTP Status
    |--------------------------------------------------------------------------
    */

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      String message =
          "Unable to record policy acceptance.";

      if (response.body.isNotEmpty) {
        try {
          final data =
              jsonDecode(response.body);

          if (data is Map &&
              data["message"] != null) {
            message =
                data["message"].toString();
          }
        } catch (_) {
          // Keep default error message.
        }
      }

      throw Exception(message);
    }

    /*
    |--------------------------------------------------------------------------
    | Successful Response
    |--------------------------------------------------------------------------
    */

    if (response.body.isEmpty) {
      return;
    }

    try {
      final data =
          jsonDecode(response.body);

      if (data is Map &&
          data["success"] == false) {
        throw Exception(
          data["message"]?.toString() ??
              "Unable to record policy acceptance.",
        );
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }

      throw Exception(
        "Invalid server response.",
      );
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Check Current Consent
  |--------------------------------------------------------------------------
  */

  Future<bool> hasCurrentConsent() async {
    final response = await http.get(
      Uri.parse(
        "${ApiConfig.baseUrl}$_baseRoute/consent",
      ),
      headers: await _headers(),
    );

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      String message =
          "Unable to check policy consent.";

      if (response.body.isNotEmpty) {
        try {
          final data =
              jsonDecode(response.body);

          if (data is Map &&
              data["message"] != null) {
            message =
                data["message"].toString();
          }
        } catch (_) {}
      }

      throw Exception(message);
    }

    if (response.body.isEmpty) {
      return false;
    }

    final data =
        jsonDecode(response.body);

    if (data is! Map) {
      return false;
    }

    return data["accepted"] == true;
  }
}