
import "dart:convert";

import "package:flutter/foundation.dart";
import "package:http/http.dart" as http;

import "../config/api.dart";
import "../models/match_card.dart";
import "../utils/storage.dart";

class NetworkingService {
  String get _baseUrl => ApiConfig.baseUrl;

  // ============================================
  // AUTHENTICATED REQUEST HELPER
  // ============================================

  Future<Map<String, String>> _headers() async {
    final token = await Storage.getToken();

    return {
      if (token != null && token.isNotEmpty)
        "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
  }

  Future<Map<String, dynamic>> _request({
    required String method,
    required String endpoint,
    Map<String, dynamic>? body,
  }) async {
    final uri = Uri.parse("$_baseUrl$endpoint");
    final headers = await _headers();

    late http.Response response;

    switch (method.toUpperCase()) {
      case "GET":
        response = await http.get(uri, headers: headers);
        break;

      case "POST":
        response = await http.post(
          uri,
          headers: headers,
          body: jsonEncode(body ?? {}),
        );
        break;

      case "PATCH":
        response = await http.patch(
          uri,
          headers: headers,
          body: jsonEncode(body ?? {}),
        );
        break;

      case "DELETE":
        response = await http.delete(
          uri,
          headers: headers,
        );
        break;

      default:
        throw Exception(
          "Unsupported HTTP method: $method",
        );
    }

    Map<String, dynamic> data = {};

    if (response.body.isNotEmpty) {
      try {
        final decoded = jsonDecode(response.body);

        if (decoded is Map<String, dynamic>) {
          data = decoded;
        }
      } catch (_) {
        data = {};
      }
    }

    if (response.statusCode < 200 ||
        response.statusCode >= 300) {
      throw Exception(
        data["message"] ??
            "Networking request failed "
                "(${response.statusCode}).",
      );
    }

    if (data["success"] == false) {
      throw Exception(
        data["message"] ??
            "Networking request failed.",
      );
    }

    return data;
  }

  String _encode(String value) =>
      Uri.encodeComponent(value);

  // ============================================
  // GET MATCHES
  // ============================================

  Future<List<MatchCard>> getMatches({
    required String eventId,
    int limit = 20,
  }) async {
    try {
      final response = await _request(
        method: "GET",
        endpoint:
            "/networking/events/${_encode(eventId)}"
            "/networking?limit=$limit",
      );

      final matches = response["matches"];

      if (matches is! List) return [];

      return matches
          .whereType<Map>()
          .map(
            (item) => MatchCard.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();
    } catch (e) {
      debugPrint(
        "NETWORKING MATCHES ERROR: $e",
      );
      rethrow;
    }
  }

  // ============================================
  // GET PROFILE
  // ============================================

  Future<Map<String, dynamic>> getProfile() async {
    final response = await _request(
      method: "GET",
      endpoint: "/networking/profile",
    );

    return Map<String, dynamic>.from(
      response["profile"] ?? {},
    );
  }

  // ============================================
  // UPDATE PROFILE
  // ============================================

  Future<Map<String, dynamic>> updateProfile({
    required Map<String, dynamic> profile,
  }) async {
    final response = await _request(
      method: "PATCH",
      endpoint: "/networking/profile",
      body: profile,
    );

    return Map<String, dynamic>.from(
      response["profile"] ?? {},
    );
  }

  // ============================================
  // SEND CONNECTION REQUEST
  // ============================================

  Future<Map<String, dynamic>> sendRequest({
    required String receiverId,
    required String eventId,
    String? message,
  }) async {
    final response = await _request(
      method: "POST",
      endpoint: "/networking/requests",
      body: {
        "receiverId": receiverId,
        "eventId": eventId,
        if (message != null &&
            message.trim().isNotEmpty)
          "message": message.trim(),
      },
    );

    return Map<String, dynamic>.from(
      response["request"] ?? {},
    );
  }

  // ============================================
  // INCOMING REQUESTS
  // ============================================

  Future<List<Map<String, dynamic>>>
      getIncomingRequests() async {
    final response = await _request(
      method: "GET",
      endpoint: "/networking/requests/incoming",
    );

    return _toMapList(response["requests"]);
  }

  // ============================================
  // OUTGOING REQUESTS
  // ============================================

  Future<List<Map<String, dynamic>>>
      getOutgoingRequests() async {
    final response = await _request(
      method: "GET",
      endpoint: "/networking/requests/outgoing",
    );

    return _toMapList(response["requests"]);
  }

  // ============================================
  // ACCEPT REQUEST
  // ============================================

  Future<Map<String, dynamic>> acceptRequest({
    required String requestId,
  }) async {
    final response = await _request(
      method: "POST",
      endpoint:
          "/networking/requests/"
          "${_encode(requestId)}/accept",
    );

    return Map<String, dynamic>.from(
      response["connection"] ?? {},
    );
  }

  // ============================================
  // REJECT REQUEST
  // ============================================

  Future<Map<String, dynamic>> rejectRequest({
    required String requestId,
  }) async {
    final response = await _request(
      method: "POST",
      endpoint:
          "/networking/requests/"
          "${_encode(requestId)}/reject",
    );

    return Map<String, dynamic>.from(
      response["request"] ?? {},
    );
  }

  // ============================================
  // CANCEL REQUEST
  // ============================================

  Future<Map<String, dynamic>> cancelRequest({
    required String requestId,
  }) async {
    final response = await _request(
      method: "POST",
      endpoint:
          "/networking/requests/"
          "${_encode(requestId)}/cancel",
    );

    return Map<String, dynamic>.from(
      response["request"] ?? {},
    );
  }

  // ============================================
  // GET ACCEPTED CONNECTIONS
  // ============================================

  Future<List<Map<String, dynamic>>>
      getConnections() async {
    final response = await _request(
      method: "GET",
      endpoint: "/networking/connections",
    );

    return _toMapList(
      response["connections"],
    );
  }

  // ============================================
  // REMOVE CONNECTION
  // ============================================

  Future<bool> removeConnection({
    required String connectionId,
  }) async {
    final response = await _request(
      method: "DELETE",
      endpoint:
          "/networking/connections/"
          "${_encode(connectionId)}",
    );

    return response["success"] == true;
  }

  // ============================================
  // RESPONSE HELPERS
  // ============================================

  List<Map<String, dynamic>> _toMapList(
    dynamic value,
  ) {
    if (value is! List) return [];

    return value
        .whereType<Map>()
        .map(
          (item) => Map<String, dynamic>.from(item),
        )
        .toList();
  }
}

