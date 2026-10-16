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

/*
|--------------------------------------------------------------------------
| Purchase Quote
|--------------------------------------------------------------------------
|
| Represents the authoritative checkout breakdown returned by:
|
| POST /purchase/quote
|
| The backend calculates all monetary amounts. The app must not
| independently calculate or override the transaction fee.
|
*/

class PurchaseQuote {
  final String ticketTypeId;

  final String ticketName;

  final String eventId;

  final String eventTitle;

  final int quantity;

  final String currency;

  final double unitPrice;

  final double subtotal;

  final double transactionFee;

  final double amount;

  final double? feeFxRate;

  const PurchaseQuote({
    required this.ticketTypeId,
    required this.ticketName,
    required this.eventId,
    required this.eventTitle,
    required this.quantity,
    required this.currency,
    required this.unitPrice,
    required this.subtotal,
    required this.transactionFee,
    required this.amount,
    this.feeFxRate,
  });

  factory PurchaseQuote.fromJson(
    Map<String, dynamic> json,
  ) {
    double parseDouble(dynamic value) {
      if (value is num) {
        return value.toDouble();
      }

      return double.tryParse(
            value?.toString() ?? "",
          ) ??
          0.0;
    }

    int parseInt(dynamic value) {
      if (value is int) {
        return value;
      }

      return int.tryParse(
            value?.toString() ?? "",
          ) ??
          1;
    }

    return PurchaseQuote(
      ticketTypeId:
          json["ticketTypeId"]?.toString() ?? "",
      ticketName:
          json["ticketName"]?.toString() ?? "",
      eventId:
          json["eventId"]?.toString() ?? "",
      eventTitle:
          json["eventTitle"]?.toString() ?? "",
      quantity: parseInt(json["quantity"]),
      currency:
          json["currency"]?.toString() ?? "EUR",
      unitPrice: parseDouble(json["unitPrice"]),
      subtotal: parseDouble(json["subtotal"]),
      transactionFee:
          parseDouble(json["transactionFee"]),
      amount: parseDouble(json["amount"]),
      feeFxRate: json["feeFxRate"] == null
          ? null
          : parseDouble(json["feeFxRate"]),
    );
  }
}

class PurchaseService {
  static const String _baseRoute = "/purchase";

  /*
  |--------------------------------------------------------------------------
  | Headers
  |--------------------------------------------------------------------------
  */

  Future<Map<String, String>> _headers() async {
    final token = await Storage.getToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        "User is not authenticated.",
      );
    }

    return {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
      "Accept": "application/json",
    };
  }

  /*
  |--------------------------------------------------------------------------
  | Decode JSON Response
  |--------------------------------------------------------------------------
  */

  Map<String, dynamic> _decodeResponse(
    http.Response response,
  ) {
    if (response.body.isEmpty) {
      return {};
    }

    final decoded = jsonDecode(response.body);

    if (decoded is Map<String, dynamic>) {
      return decoded;
    }

    return {};
  }

  /*
  |--------------------------------------------------------------------------
  | Get Purchase Quote
  |--------------------------------------------------------------------------
  |
  | Retrieves the authoritative checkout breakdown.
  |
  | Transaction fee:
  | 3% of the ticket subtotal + €0.50 per order.
  |
  | The backend handles the currency conversion where applicable.
  | Free tickets do not attract a transaction fee.
  |
  | This endpoint does not create a purchase or payment session.
  |
  */

  Future<PurchaseQuote> getPurchaseQuote({
    required String ticketTypeId,
    required int quantity,
  }) async {
    if (ticketTypeId.trim().isEmpty) {
      throw Exception(
        "Ticket type is required.",
      );
    }

    if (quantity < 1) {
      throw Exception(
        "Quantity must be at least 1.",
      );
    }

    try {
      final response = await http.post(
        Uri.parse(
          "${ApiConfig.baseUrl}$_baseRoute/quote",
        ),
        headers: await _headers(),
        body: jsonEncode({
          "ticketTypeId": ticketTypeId,
          "quantity": quantity,
        }),
      );

      final data = _decodeResponse(response);

      if (response.statusCode != 200 ||
          data["success"] != true ||
          data["quote"] is! Map) {
        final message =
            data["message"]?.toString();

        throw Exception(
          message ??
              "Unable to calculate checkout total.",
        );
      }

      final quote = PurchaseQuote.fromJson(
        Map<String, dynamic>.from(
          data["quote"] as Map,
        ),
      );

      // Protect the UI from displaying a quote for another
      // ticket or quantity.
      if (quote.ticketTypeId != ticketTypeId ||
          quote.quantity != quantity) {
        throw Exception(
          "The checkout quote does not match your selection.",
        );
      }

      return quote;
    } catch (e) {
      debugPrint(
        "GET PURCHASE QUOTE ERROR: $e",
      );

      rethrow;
    }
  }

  /*
  |--------------------------------------------------------------------------
  | Create Purchase
  |--------------------------------------------------------------------------
  |
  | The backend recalculates the final checkout amount.
  | Never send a client-calculated transaction fee as authoritative.
  |
  */

  Future<PurchaseResult> createPurchase({
    required String ticketTypeId,
    required int quantity,
  }) async {
    try {
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

      final data = _decodeResponse(response);

      if (response.statusCode != 201 ||
          data["success"] != true) {
        return PurchaseResult(
          success: false,
          paymentRequired: false,
          message: data["message"]?.toString() ??
              "Unable to create purchase.",
        );
      }

      final purchase = data["purchase"];

      String? purchaseId;

      if (purchase is Map) {
        purchaseId = purchase["id"]?.toString();
      }

      final checkoutUrl =
          data["checkoutUrl"]?.toString();

      /*
      |--------------------------------------------------------------------------
      | Backend Compatibility
      |--------------------------------------------------------------------------
      |
      | An explicit paymentRequired boolean takes precedence.
      |
      | For older controller responses:
      | checkout URL exists = paid ticket
      | no checkout URL     = free ticket
      |
      */

      final explicitPaymentRequired =
          data["paymentRequired"];

      final bool paymentRequired =
          explicitPaymentRequired is bool
              ? explicitPaymentRequired
              : checkoutUrl != null &&
                  checkoutUrl.isNotEmpty;

      return PurchaseResult(
        success: true,
        paymentRequired: paymentRequired,
        checkoutUrl: checkoutUrl,
        purchaseId: purchaseId,
        message: data["message"]?.toString(),
      );
    } catch (e) {
      debugPrint(
        "CREATE PURCHASE ERROR: $e",
      );

      return PurchaseResult(
        success: false,
        paymentRequired: false,
        message: e.toString(),
      );
    }
  }

  /*
  |--------------------------------------------------------------------------
  | My Tickets
  |--------------------------------------------------------------------------
  */

  Future<List<PurchasedTicket>> getMyTickets() async {
    final response = await http.get(
      Uri.parse(
        "${ApiConfig.baseUrl}$_baseRoute/my",
      ),
      headers: await _headers(),
    );

    final data = _decodeResponse(response);

    if (response.statusCode != 200 ||
        data["success"] != true) {
      throw Exception(
        data["message"]?.toString() ??
            "Unable to load tickets.",
      );
    }

    final List<dynamic> tickets =
        data["tickets"] as List<dynamic>? ?? [];

    return tickets
        .map(
          (ticket) => PurchasedTicket.fromJson(
            ticket,
          ),
        )
        .toList();
  }

  /*
  |--------------------------------------------------------------------------
  | My Events
  |--------------------------------------------------------------------------
  */

  Future<List<Map<String, dynamic>>> getMyEvents() async {
    final response = await http.get(
      Uri.parse(
        "${ApiConfig.baseUrl}$_baseRoute/my-events",
      ),
      headers: await _headers(),
    );

    final data = _decodeResponse(response);

    if (response.statusCode != 200 ||
        data["success"] != true) {
      throw Exception(
        data["message"]?.toString() ??
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

  Future<Map<String, dynamic>> getMyEvent(
    String purchaseId,
  ) async {
    final response = await http.get(
      Uri.parse(
        "${ApiConfig.baseUrl}$_baseRoute/my-events/$purchaseId",
      ),
      headers: await _headers(),
    );

    final data = _decodeResponse(response);

    if (response.statusCode != 200 ||
        data["success"] != true) {
      throw Exception(
        data["message"]?.toString() ??
            "Unable to load event.",
      );
    }

    final event = data["event"];

    if (event is! Map) {
      throw Exception(
        "Invalid event response.",
      );
    }

    return Map<String, dynamic>.from(event);
  }
}