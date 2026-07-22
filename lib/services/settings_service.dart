import "dart:convert";

import "package:flutter/foundation.dart";
import "package:http/http.dart" as http;

import "../config/api.dart";
import "../models/user_settings.dart";
import "../utils/storage.dart";

class SettingsService {
  Future<UserSettings?> getSettings() async {
    try {
      final token = await Storage.getToken();

      if (token == null) {
        return null;
      }

      final response = await http.get(
        Uri.parse(
          "${ApiConfig.baseUrl}/settings/attendee",
        ),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode != 200) {
        return null;
      }

      final data = jsonDecode(response.body);

      if (data["success"] != true) {
        return null;
      }

      return UserSettings.fromJson(
        data["settings"],
      );
    } catch (e) {
      debugPrint(
        "SETTINGS ERROR: $e",
      );

      return null;
    }
  }

  Future<bool> updateSettings({
    required UserSettings settings,
  }) async {
    try {
      final token = await Storage.getToken();

      if (token == null) {
        return false;
      }

      final response = await http.put(
        Uri.parse(
          "${ApiConfig.baseUrl}/settings/attendee",
        ),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
        body: jsonEncode(
          settings.toJson(),
        ),
      );

      if (response.statusCode != 200) {
        return false;
      }

      final data = jsonDecode(response.body);

      return data["success"] == true;
    } catch (e) {
      debugPrint(
        "UPDATE SETTINGS ERROR: $e",
      );

      return false;
    }
  }
}