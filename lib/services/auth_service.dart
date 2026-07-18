import "dart:convert";

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
    final response = await http.post(
      Uri.parse(
        "${ApiConfig.baseUrl}/auth/register",
      ),
      headers: {
        "Content-Type":
            "application/json",
      },
      body: jsonEncode({
        "firstName": firstName,
        "lastName": lastName,
        "email": email,
        "password": password,
        "role": "ATTENDEE",
      }),
    );

    return jsonDecode(
      response.body,
    );
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    final response = await http.post(
      Uri.parse(
        "${ApiConfig.baseUrl}/auth/login",
      ),
      headers: {
        "Content-Type":
            "application/json",
      },
      body: jsonEncode({
        "email": email,
        "password": password,
      }),
    );

    return jsonDecode(
      response.body,
    );
  }

  Future<User?> getMe(
    String token,
  ) async {
    final response = await http.get(
      Uri.parse(
        "${ApiConfig.baseUrl}/auth/me",
      ),
      headers: {
        "Authorization":
            "Bearer $token",
        "Content-Type":
            "application/json",
      },
    );

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

  Future<Map<String, dynamic>> authenticatedGet(
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