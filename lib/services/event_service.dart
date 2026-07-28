import "dart:convert";

import "package:flutter/foundation.dart";
import "package:http/http.dart" as http;

import "../config/api.dart";
import "../models/event.dart";

class EventService {
  /*
  |--------------------------------------------------------------------------
  | Public Events
  |--------------------------------------------------------------------------
  */

  Future<List<Event>>
      getPublicEvents() async {
    try {
      final response =
          await http.get(
        Uri.parse(
          "${ApiConfig.baseUrl}/events/public",
        ),
        headers: {
          "Accept":
              "application/json",
        },
      );

      if (response.statusCode !=
          200) {
        debugPrint(
          "PUBLIC EVENTS ERROR ${response.statusCode}: ${response.body}",
        );

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
          .whereType<
              Map<String, dynamic>>()
          .map(
            Event.fromJson,
          )
          .toList();
    } catch (e) {
      debugPrint(
        "EVENT SERVICE ERROR: $e",
      );

      return [];
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Public Event Details
  |--------------------------------------------------------------------------
  |
  | This is the authoritative event fetch.
  |
  | EventDetailsScreen should use this rather than trusting the lightweight
  | Event object received from Home/Search/Discovery.
  |
  */

  Future<Event?>
      getPublicEvent(
    String eventId,
  ) async {
    try {
      final response =
          await http.get(
        Uri.parse(
          "${ApiConfig.baseUrl}/events/public/$eventId",
        ),
        headers: {
          "Accept":
              "application/json",
        },
      );

      if (response.statusCode !=
          200) {
        debugPrint(
          "EVENT DETAILS ERROR ${response.statusCode}: ${response.body}",
        );

        return null;
      }

      final data =
          jsonDecode(
        response.body,
      );

      if (data["success"] !=
          true) {
        return null;
      }

      final dynamic rawEvent =
          data["event"];

      if (rawEvent
          is! Map<String, dynamic>) {
        return null;
      }

      return Event.fromJson(
        rawEvent,
      );
    } catch (e) {
      debugPrint(
        "EVENT DETAILS ERROR: $e",
      );

      return null;
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Legacy Registration
  |--------------------------------------------------------------------------
  |
  | Keep temporarily if another part of the application still calls it.
  |
  | Ticket checkout should NOT use this method anymore.
  |
  */

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
          "Accept":
              "application/json",
        },
      );

      if (response.body.isEmpty) {
        return false;
      }

      final data =
          jsonDecode(
        response.body,
      );

      debugPrint(
        "REGISTER RESPONSE: $data",
      );

      return response.statusCode >=
              200 &&
          response.statusCode <
              300 &&
          data["success"] ==
              true;
    } catch (e) {
      debugPrint(
        "REGISTER ERROR: $e",
      );

      return false;
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Legacy My Registrations
  |--------------------------------------------------------------------------
  |
  | Keep temporarily because TicketsScreen currently uses it.
  | We'll move TicketsScreen entirely to PurchaseService separately.
  |
  */

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
          "Accept":
              "application/json",
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
          .whereType<
              Map<String, dynamic>>()
          .map(
            Event.fromJson,
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