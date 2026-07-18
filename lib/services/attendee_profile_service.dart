import "dart:convert";

import "package:flutter/foundation.dart";
import "package:http/http.dart" as http;

import "../config/api.dart";
import "../models/attendee_profile.dart";

class AttendeeProfileService {
  Future<AttendeeProfile?> getMyProfile(
    String token,
  ) async {
    try {
      final response = await http.get(
        Uri.parse(
          "${ApiConfig.baseUrl}/attendee-profile/me",
        ),
        headers: {
          "Authorization":
              "Bearer $token",
        },
      );

      if (response.statusCode !=
          200) {
        return null;
      }

      final data = jsonDecode(
        response.body,
      );

      if (data["profile"] ==
          null) {
        return null;
      }

      return AttendeeProfile.fromJson(
        data["profile"],
      );
    } catch (e) {
      debugPrint(
        "PROFILE ERROR: $e",
      );

      return null;
    }
  }

  Future<bool> createProfile({
    required String token,
    required String profession,
    required String industry,

    String? company,
    String? jobTitle,
    String? linkedin,

    List<dynamic>? goals,
    List<dynamic>? skills,

    required String bio,
  }) async {
    try {
      final response =
          await http.post(
        Uri.parse(
          "${ApiConfig.baseUrl}/attendee-profile",
        ),
        headers: {
          "Content-Type":
              "application/json",
          "Authorization":
              "Bearer $token",
        },
        body: jsonEncode({
          "profession":
              profession,

          "industry":
              industry,

          "company":
              company,

          "jobTitle":
              jobTitle,

          "linkedin":
              linkedin,

          "bio":
              bio,

          "goals":
              goals ?? [],

          "skills":
              skills ?? [],
        }),
      );

      final data = jsonDecode(
        response.body,
      );

      return data["success"] ==
          true;
    } catch (e) {
      debugPrint(
        "CREATE PROFILE ERROR: $e",
      );

      return false;
    }
  }
}