import "dart:convert";

import "package:http/http.dart" as http;

import "../config/api.dart";
import "../utils/storage.dart";

class LegalService {
  static const String _baseRoute =
      "/api/legal";

  Future<Map<String, String>>
      _headers() async {
    final token =
        await Storage.getToken();

    if (token == null ||
        token.isEmpty) {
      throw Exception(
        "Authentication required.",
      );
    }

    return {
      "Authorization":
          "Bearer $token",
      "Content-Type":
          "application/json",
    };
  }

  Future<void> acceptPolicies({
    required String fullName,
    required String email,
    required String role,
    String? deviceVersion,
  }) async {
    final response =
        await http.post(
      Uri.parse(
        "${ApiConfig.baseUrl}$_baseRoute/consent",
      ),
      headers:
          await _headers(),
      body: jsonEncode({
        "fullName":
            fullName,

        "email":
            email,

        "role":
            role,

        "deviceVersion":
            deviceVersion,
      }),
    );

    if (response.body.isEmpty) {
      throw Exception(
        "Empty server response.",
      );
    }

    final data =
        jsonDecode(
      response.body,
    );

    if (response.statusCode >=
        400) {
      throw Exception(
        data["message"] ??
            "Unable to record policy acceptance.",
      );
    }

    if (data["success"] !=
        true) {
      throw Exception(
        data["message"] ??
            "Unable to record policy acceptance.",
      );
    }
  }

  Future<bool>
      hasCurrentConsent() async {
    final response =
        await http.get(
      Uri.parse(
        "${ApiConfig.baseUrl}$_baseRoute/consent",
      ),
      headers:
          await _headers(),
    );

    if (response.body.isEmpty) {
      return false;
    }

    final data =
        jsonDecode(
      response.body,
    );

    if (response.statusCode >=
        400) {
      throw Exception(
        data["message"] ??
            "Unable to check policy consent.",
      );
    }

    return data["accepted"] ==
        true;
  }
}