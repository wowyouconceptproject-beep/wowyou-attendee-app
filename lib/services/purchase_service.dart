import "dart:convert";

import "package:http/http.dart" as http;

import "../config/api.dart";
import "../models/purchased_ticket.dart";
import "../utils/storage.dart";

class PurchaseService {
  static const String _baseRoute = "/purchase";

  Future<Map<String, String>> _headers() async {
    final token = await Storage.getToken();

    if (token == null) {
      throw Exception("User is not authenticated.");
    }

    return {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };
  }

  /*
  |--------------------------------------------------------------------------
  | Create Purchase
  |--------------------------------------------------------------------------
  */

  Future<Map<String, dynamic>> createPurchase({
    required String ticketTypeId,
    required int quantity,
  }) async {
    final response = await http.post(
      Uri.parse(
        "${ApiConfig.baseUrl}$_baseRoute/create",
      ),
      headers: await _headers(),
      body: jsonEncode({
        "ticketTypeId": ticketTypeId,
        "quantity": quantity,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode != 201 ||
        data["success"] != true) {
      throw Exception(
        data["message"] ??
            "Unable to create purchase.",
      );
    }

    return Map<String, dynamic>.from(data);
  }

  /*
  |--------------------------------------------------------------------------
  | Legacy My Tickets
  |--------------------------------------------------------------------------
  */

  Future<List<PurchasedTicket>>
      getMyTickets() async {
    final response = await http.get(
      Uri.parse(
        "${ApiConfig.baseUrl}$_baseRoute/my",
      ),
      headers: await _headers(),
    );

    final data =
        jsonDecode(response.body);

    if (response.statusCode != 200 ||
        data["success"] != true) {
      throw Exception(
        data["message"] ??
            "Unable to load tickets.",
      );
    }

    final List<dynamic> tickets =
        data["tickets"] ?? [];

    return tickets
        .map(
          (e) => PurchasedTicket.fromJson(e),
        )
        .toList();
  }

  /*
  |--------------------------------------------------------------------------
  | My Events
  |--------------------------------------------------------------------------
  */

  Future<List<Map<String, dynamic>>>
      getMyEvents() async {
    final response = await http.get(
      Uri.parse(
        "${ApiConfig.baseUrl}$_baseRoute/my-events",
      ),
      headers: await _headers(),
    );

    final data =
        jsonDecode(response.body);

    if (response.statusCode != 200 ||
        data["success"] != true) {
      throw Exception(
        data["message"] ??
            "Unable to load events.",
      );
    }

    return List<Map<String, dynamic>>.from(
      data["events"] ?? [],
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Event Hub
  |--------------------------------------------------------------------------
  */

  Future<Map<String, dynamic>>
      getMyEvent(
    String purchaseId,
  ) async {
    final response = await http.get(
      Uri.parse(
        "${ApiConfig.baseUrl}$_baseRoute/my-events/$purchaseId",
      ),
      headers: await _headers(),
    );

    final data =
        jsonDecode(response.body);

    if (response.statusCode != 200 ||
        data["success"] != true) {
      throw Exception(
        data["message"] ??
            "Unable to load event.",
      );
    }

    return Map<String, dynamic>.from(
      data["event"],
    );
  }
}