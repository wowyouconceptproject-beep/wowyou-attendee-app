import "dart:convert";

import "package:http/http.dart" as http;

import "../config/api.dart";
import "../models/purchased_ticket.dart";
import "../utils/storage.dart";

class EventHubService {
  String get _baseUrl => ApiConfig.baseUrl;

  /// Retrieves the stored attendee JWT and builds authenticated headers.
  Future<Map<String, String>> _headers() async {
    final token = await Storage.getToken();

    if (token == null || token.isEmpty) {
      throw Exception("Authentication required.");
    }

    return {
      "Content-Type": "application/json",
      "Authorization": "Bearer $token",
    };
  }

  /// Retrieves a purchased ticket.
  Future<PurchasedTicket> getTicket(String ticketId) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/tickets/$ticketId"),
      headers: await _headers(),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to load ticket.");
    }

    return PurchasedTicket.fromJson(jsonDecode(response.body));
  }

  /// Checks in an attendee using their ticket.
  Future<void> checkIn(String ticketId) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/tickets/$ticketId/check-in"),
      headers: await _headers(),
    );

    if (response.statusCode != 200) {
      throw Exception("Unable to check in attendee.");
    }
  }

  /// Retrieves an event agenda.
  Future<List<dynamic>> getAgenda(String eventId) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/events/$eventId/agenda"),
      headers: await _headers(),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to load agenda.");
    }

    final decoded = jsonDecode(response.body);

    if (decoded is List) {
      return decoded;
    }

    if (decoded is Map<String, dynamic>) {
      final agenda = decoded["agenda"];

      if (agenda is List) {
        return agenda;
      }

      final data = decoded["data"];

      if (data is List) {
        return data;
      }
    }

    throw Exception("Invalid agenda response.");
  }

  /// Retrieves event announcements.
  Future<List<dynamic>> getAnnouncements(String eventId) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/events/$eventId/announcements"),
      headers: await _headers(),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to load announcements.");
    }

    final decoded = jsonDecode(response.body);

    if (decoded is List) {
      return decoded;
    }

    if (decoded is Map<String, dynamic>) {
      final announcements = decoded["announcements"];

      if (announcements is List) {
        return announcements;
      }

      final data = decoded["data"];

      if (data is List) {
        return data;
      }
    }

    throw Exception("Invalid announcements response.");
  }

  /// Retrieves event activities.
  ///
  /// Backend endpoint:
  /// GET /events/:eventId/activity
  Future<List<dynamic>> getActivities(String eventId) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/events/$eventId/activity"),
      headers: await _headers(),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to load activities.");
    }

    final decoded = jsonDecode(response.body);

    if (decoded is List) {
      return decoded;
    }

    if (decoded is Map<String, dynamic>) {
      final activities = decoded["activities"];

      if (activities is List) {
        return activities;
      }

      final data = decoded["data"];

      if (data is List) {
        return data;
      }
    }

    throw Exception("Invalid activities response.");
  }
}
