import "dart:convert";

import "package:flutter/foundation.dart";
import "package:http/http.dart" as http;

import "../config/api.dart";
import "../models/match_card.dart";
import "../utils/storage.dart";

class NetworkingService {
  Future<List<MatchCard>> getMatches({
    required String eventId,
    int limit = 20,
  }) async {
    try {
      final token = await Storage.getToken();

      final response = await http.get(
        Uri.parse(
          "${ApiConfig.baseUrl}/events/$eventId/networking?limit=$limit",
        ),
        headers: {
          "Authorization": "Bearer $token",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode != 200) {
        throw Exception(
          "Unable to load networking matches.",
        );
      }

      final json = jsonDecode(response.body);

      final List<dynamic> matches =
          json["matches"] ?? [];

      return matches
          .map(
            (item) => MatchCard.fromJson(item),
          )
          .toList();
    } catch (e) {
      debugPrint(
        "NETWORKING ERROR: $e",
      );

      return [];
    }
  }
}