import "dart:convert";

import "package:http/http.dart" as http;

import "../config/api.dart";
import "../models/purchased_ticket.dart";
import "../utils/storage.dart";

class PurchaseService {
  Future<List<PurchasedTicket>>
      getMyTickets() async {
    try {
      final token =
          await Storage.getToken();

      if (token == null) {
        return [];
      }

      final response =
          await http.get(
        Uri.parse(
          "${ApiConfig.baseUrl}/purchases/my",
        ),
        headers: {
          "Authorization":
              "Bearer $token",
          "Content-Type":
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
          tickets =
          data["tickets"] ?? [];

      return tickets
          .map(
            (ticket) =>
                PurchasedTicket
                    .fromJson(
              ticket,
            ),
          )
          .toList();
    } catch (e) {
      return [];
    }
  }
}