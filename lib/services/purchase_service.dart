import "dart:convert";

import "package:flutter/foundation.dart";
import "package:http/http.dart" as http;

import "../config/api.dart";
import "../models/purchased_ticket.dart";
import "../utils/storage.dart";

class PurchaseResult {
  final bool success;

  final bool paymentRequired;

  final String? checkoutUrl;

  final String? purchaseId;

  final String? message;

  const PurchaseResult({
    required this.success,
    required this.paymentRequired,
    this.checkoutUrl,
    this.purchaseId,
    this.message,
  });
}

class PurchaseService {
  static const String _baseRoute =
      "/purchase";

  Future<Map<String, String>>
      _headers() async {
    final token =
        await Storage.getToken();

    if (token == null) {
      throw Exception(
        "User is not authenticated.",
      );
    }

    return {
      "Authorization":
          "Bearer $token",
      "Content-Type":
          "application/json",
      "Accept":
          "application/json",
    };
  }

  /*
  |--------------------------------------------------------------------------
  | Create Purchase
  |--------------------------------------------------------------------------
  */

  Future<PurchaseResult>
      createPurchase({
    required String ticketTypeId,
    required int quantity,
  }) async {
    try {
      final response =
          await http.post(
        Uri.parse(
          "${ApiConfig.baseUrl}$_baseRoute/create",
        ),
        headers:
            await _headers(),
        body:
            jsonEncode({
          "ticketTypeId":
              ticketTypeId,
          "quantity":
              quantity,
        }),
      );

      Map<String, dynamic>
          data = {};

      if (response
          .body.isNotEmpty) {
        final decoded =
            jsonDecode(
          response.body,
        );

        if (decoded
            is Map<String, dynamic>) {
          data = decoded;
        }
      }

      if (
        response.statusCode !=
                201 ||
            data["success"] !=
                true
      ) {
        return PurchaseResult(
          success: false,
          paymentRequired:
              false,
          message:
              data["message"]
                      ?.toString() ??
                  "Unable to create purchase.",
        );
      }

      final purchase =
          data["purchase"];

      String? purchaseId;

      if (purchase is Map) {
        purchaseId =
            purchase["id"]
                ?.toString();
      }

      final checkoutUrl =
          data["checkoutUrl"]
              ?.toString();

      /*
      |--------------------------------------------------------------------------
      | Backend Compatibility
      |--------------------------------------------------------------------------
      |
      | Current controller does not necessarily return paymentRequired.
      |
      | Therefore:
      |
      | checkout URL exists = paid ticket
      | no checkout URL     = free ticket
      |
      */

      final explicitPaymentRequired =
          data[
              "paymentRequired"];

      final bool
          paymentRequired =
          explicitPaymentRequired
                  is bool
              ? explicitPaymentRequired
              : checkoutUrl !=
                      null &&
                  checkoutUrl
                      .isNotEmpty;

      return PurchaseResult(
        success: true,
        paymentRequired:
            paymentRequired,
        checkoutUrl:
            checkoutUrl,
        purchaseId:
            purchaseId,
        message:
            data["message"]
                ?.toString(),
      );
    } catch (e) {
      debugPrint(
        "CREATE PURCHASE ERROR: $e",
      );

      return PurchaseResult(
        success: false,
        paymentRequired:
            false,
        message:
            e.toString(),
      );
    }
  }

  /*
  |--------------------------------------------------------------------------
  | My Tickets
  |--------------------------------------------------------------------------
  */

  Future<List<PurchasedTicket>>
      getMyTickets() async {
    final response =
        await http.get(
      Uri.parse(
        "${ApiConfig.baseUrl}$_baseRoute/my",
      ),
      headers:
          await _headers(),
    );

    final data =
        jsonDecode(
      response.body,
    );

    if (
      response.statusCode !=
              200 ||
          data["success"] !=
              true
    ) {
      throw Exception(
        data["message"] ??
            "Unable to load tickets.",
      );
    }

    final List<dynamic>
        tickets =
        data["tickets"] ?? [];

    return tickets
        .map(
          (e) =>
              PurchasedTicket
                  .fromJson(
            e,
          ),
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
    final response =
        await http.get(
      Uri.parse(
        "${ApiConfig.baseUrl}$_baseRoute/my-events",
      ),
      headers:
          await _headers(),
    );

    final data =
        jsonDecode(
      response.body,
    );

    if (
      response.statusCode !=
              200 ||
          data["success"] !=
              true
    ) {
      throw Exception(
        data["message"] ??
            "Unable to load events.",
      );
    }

    return List<
        Map<String, dynamic>>.from(
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
    final response =
        await http.get(
      Uri.parse(
        "${ApiConfig.baseUrl}$_baseRoute/my-events/$purchaseId",
      ),
      headers:
          await _headers(),
    );

    final data =
        jsonDecode(
      response.body,
    );

    if (
      response.statusCode !=
              200 ||
          data["success"] !=
              true
    ) {
      throw Exception(
        data["message"] ??
            "Unable to load event.",
      );
    }

    return Map<
        String, dynamic>.from(
      data["event"],
    );
  }
}