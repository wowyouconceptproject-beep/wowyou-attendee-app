import "dart:convert";

import "package:flutter/foundation.dart";
import "package:http/http.dart" as http;

import "../config/api.dart";
import "../models/user.dart";

class AuthService {
  Future<Map<String, dynamic>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final url =
        "${ApiConfig.baseUrl}/auth/register";

    final body = {
      "firstName": firstName,
      "lastName": lastName,
      "email": email,
      "password": password,
      "role": "ATTENDEE",
    };

    debugPrint("");
    debugPrint("========== REGISTER ==========");
    debugPrint("URL: $url");
    debugPrint("REQUEST:");
    debugPrint(jsonEncode(body));

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    debugPrint("STATUS: ${response.statusCode}");
    debugPrint("RESPONSE:");
    debugPrint(response.body);

    try {
      return jsonDecode(response.body);
    } catch (e) {
      debugPrint("REGISTER JSON ERROR: $e");

      return {
        "success": false,
        "message": "Invalid server response",
      };
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final url =
        "${ApiConfig.baseUrl}/auth/login";

    final body = {
      "email": email,
      "password": password,
    };

    debugPrint("");
    debugPrint("========== LOGIN ==========");
    debugPrint("URL: $url");
    debugPrint("REQUEST:");
    debugPrint(jsonEncode(body));

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    debugPrint("STATUS: ${response.statusCode}");
    debugPrint("RESPONSE:");
    debugPrint(response.body);

    try {
      return jsonDecode(response.body);
    } catch (e) {
      debugPrint("LOGIN JSON ERROR: $e");

      return {
        "success": false,
        "message": "Invalid server response",
      };
    }
  }

  Future<User?> getMe(
    String token,
  ) async {
    final url =
        "${ApiConfig.baseUrl}/auth/me";

    debugPrint("");
    debugPrint("========== GET ME ==========");
    debugPrint("URL: $url");
    debugPrint("TOKEN:");
    debugPrint(token);

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    debugPrint("STATUS: ${response.statusCode}");
    debugPrint("RESPONSE:");
    debugPrint(response.body);

    if (response.statusCode != 200) {
      return null;
    }

    final data =
        jsonDecode(response.body);

    if (data["success"] != true) {
      return null;
    }

    return User.fromJson(
      data["user"],
    );
  }

  Future<Map<String, dynamic>>
      authenticatedGet(
    String endpoint,
    String token,
  ) async {
    final response = await http.get(
      Uri.parse(
        "${ApiConfig.baseUrl}$endpoint",
      ),
      headers: {
        "Authorization":
            "Bearer $token",
        "Content-Type":
            "application/json",
      },
    );

    return jsonDecode(
      response.body,
    );
  }
}