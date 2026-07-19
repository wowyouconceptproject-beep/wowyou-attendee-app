import "dart:convert";

import "package:flutter/foundation.dart";
import "package:http/http.dart" as http;

import "../config/api.dart";
import "../models/event.dart";

class SearchService {
  Future<List<Event>> searchEvents(
    String query,
  ) async {
    final q = query.trim();

    if (q.isEmpty) {
      return [];
    }

    try {
      final response = await http.get(
        Uri.parse(
          "${ApiConfig.baseUrl}/search/events?q=${Uri.encodeQueryComponent(q)}",
        ),
      );

      if (response.statusCode != 200) {
        return [];
      }

      final data = jsonDecode(
        response.body,
      );

      final List<dynamic> events =
          data["events"] ?? [];

      return events
          .map(
            (event) => Event.fromJson(
              event,
            ),
          )
          .toList();
    } catch (e) {
      debugPrint(
        "SEARCH EVENTS ERROR: $e",
      );

      return [];
    }
  }

  Future<List<String>> getSuggestions(
    String query,
  ) async {
    final q = query.trim();

    if (q.isEmpty) {
      return [];
    }

    try {
      final response = await http.get(
        Uri.parse(
          "${ApiConfig.baseUrl}/search/suggestions?q=${Uri.encodeQueryComponent(q)}",
        ),
      );

      if (response.statusCode != 200) {
        return [];
      }

      final data = jsonDecode(
        response.body,
      );

      final List<dynamic> suggestions =
          data["suggestions"] ?? [];

      return suggestions
          .map(
            (item) => item.toString(),
          )
          .toList();
    } catch (e) {
      debugPrint(
        "SEARCH SUGGESTIONS ERROR: $e",
      );

      return [];
    }
  }
}