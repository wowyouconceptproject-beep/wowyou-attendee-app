import "dart:convert";

import "package:flutter/foundation.dart";
import "package:http/http.dart" as http;

import "../config/api.dart";
import "../models/event.dart";

class EventService {
  Future<List<Event>>
      getPublicEvents() async {
    try {
      final response =
          await http.get(
        Uri.parse(
          "${ApiConfig.baseUrl}/events/public",
        ),
      );

      if (response.statusCode !=
          200) {
        return [];
      }

      final data =
          jsonDecode(
        response.body,
      );

      final List<dynamic>
          events =
          data["events"] ?? [];

      return events
          .map(
            (event) =>
                Event.fromJson(
              event,
            ),
          )
          .toList();
    } catch (e) {
      debugPrint(
        "EVENT SERVICE ERROR: $e",
      );

      return [];
    }
  }

  Future<bool> registerForEvent(
    String token,
    String eventId,
  ) async {
    try {
      final response =
          await http.post(
        Uri.parse(
          "${ApiConfig.baseUrl}/events/$eventId/register",
        ),
        headers: {
          "Authorization":
              "Bearer $token",
        },
      );

      final data =
          jsonDecode(
        response.body,
      );

      debugPrint(
        "REGISTER RESPONSE: $data",
      );

      return data["success"] ==
          true;
    } catch (e) {
      debugPrint(
        "REGISTER ERROR: $e",
      );

      return false;
    }
  }

  Future<List<Event>>
      getMyRegistrations(
    String token,
  ) async {
    try {
      final response =
          await http.get(
        Uri.parse(
          "${ApiConfig.baseUrl}/events/my-registrations",
        ),
        headers: {
          "Authorization":
              "Bearer $token",
        },
      );

      if (response.statusCode !=
          200) {
        return [];
      }

      final data =
          jsonDecode(
        response.body,
      );

      final List<dynamic>
          events =
          data["events"] ?? [];

      return events
          .map(
            (event) =>
                Event.fromJson(
              event,
            ),
          )
          .toList();
    } catch (e) {
      debugPrint(
        "MY REGISTRATIONS ERROR: $e",
      );

      return [];
    }
  }
}