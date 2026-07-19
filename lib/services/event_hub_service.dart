import "dart:convert";

import "package:http/http.dart" as http;

import "../models/purchased_ticket.dart";

class EventHubService {
  // Replace with your NestJS backend URL
  static const String _baseUrl = "wowyou-backend-api-production.up.railway.app";

  Future<PurchasedTicket> getTicket(String ticketId) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/tickets/$ticketId"),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to load ticket");
    }

    return PurchasedTicket.fromJson(
      jsonDecode(response.body),
    );
  }

  Future<void> checkIn(String ticketId) async {
    final response = await http.post(
      Uri.parse("$_baseUrl/tickets/$ticketId/check-in"),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Unable to check in attendee.");
    }
  }

  Future<List<dynamic>> getAgenda(String eventId) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/events/$eventId/agenda"),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to load agenda.");
    }

    return jsonDecode(response.body);
  }

  Future<List<dynamic>> getAnnouncements(String eventId) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/events/$eventId/announcements"),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to load announcements.");
    }

    return jsonDecode(response.body);
  }

  Future<List<dynamic>> getActivities(String eventId) async {
    final response = await http.get(
      Uri.parse("$_baseUrl/events/$eventId/activities"),
    );

    if (response.statusCode != 200) {
      throw Exception("Failed to load activities.");
    }

    return jsonDecode(response.body);
  }
}