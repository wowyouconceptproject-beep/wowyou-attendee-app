import "dart:convert";

import "package:http/http.dart" as http;

import "../models/purchased_ticket.dart";

class TicketService {
  // TODO: Replace with your production API URL
  static const String _baseUrl =
      "http://YOUR_BACKEND_URL/api";

  final http.Client _client;

  TicketService({
    http.Client? client,
  }) : _client = client ?? http.Client();

  /// Get all tickets belonging to the authenticated attendee.
  Future<List<PurchasedTicket>> getMyTickets({
    required String accessToken,
  }) async {
    final response = await _client.get(
      Uri.parse("$_baseUrl/tickets/my"),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Unable to fetch tickets.");
    }

    final List<dynamic> json =
        jsonDecode(response.body);

    return json
        .map(
          (e) => PurchasedTicket.fromJson(e),
        )
        .toList();
  }

  /// Fetch a single ticket.
  Future<PurchasedTicket> getTicket({
    required String ticketId,
    required String accessToken,
  }) async {
    final response = await _client.get(
      Uri.parse("$_baseUrl/tickets/$ticketId"),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception("Unable to fetch ticket.");
    }

    return PurchasedTicket.fromJson(
      jsonDecode(response.body),
    );
  }

  /// Get the latest QR payload.
  Future<Map<String, dynamic>> getTicketQr({
    required String ticketId,
    required String accessToken,
  }) async {
    final response = await _client.get(
      Uri.parse(
        "$_baseUrl/tickets/$ticketId/qr",
      ),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Unable to load ticket QR.",
      );
    }

    return jsonDecode(response.body);
  }

  /// Refresh a rotating QR code.
  Future<Map<String, dynamic>> refreshQr({
    required String ticketId,
    required String accessToken,
  }) async {
    final response = await _client.post(
      Uri.parse(
        "$_baseUrl/tickets/$ticketId/refresh-qr",
      ),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Unable to refresh QR.",
      );
    }

    return jsonDecode(response.body);
  }

  /// Retrieve ticket authentication status.
  Future<Map<String, dynamic>> getTicketStatus({
    required String ticketId,
    required String accessToken,
  }) async {
    final response = await _client.get(
      Uri.parse(
        "$_baseUrl/tickets/$ticketId/status",
      ),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
        "Unable to retrieve ticket status.",
      );
    }

    return jsonDecode(response.body);
  }

  void dispose() {
    _client.close();
  }
}