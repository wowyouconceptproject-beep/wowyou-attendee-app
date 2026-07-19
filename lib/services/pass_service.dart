import "dart:convert";

import "package:http/http.dart" as http;

import "../config/api.dart";
import "../utils/storage.dart";

class PassService {
  static const String _baseRoute = "/pass";

  Future<Map<String, String>> _headers() async {
    final token = await Storage.getToken();

    if (token == null || token.isEmpty) {
      throw Exception(
        "Authentication required.",
      );
    }

    return {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    };
  }

  /*
  |--------------------------------------------------------------------------
  | Get Event Pass
  |--------------------------------------------------------------------------
  |
  | Returns the attendee's pass information.
  | The current QR screen does not require this yet,
  | but the endpoint is exposed for future Event Pass
  | details and check-in status refresh.
  |
  */

  Future<Map<String, dynamic>> getPass(
    String purchaseId,
  ) async {
    final response = await http.get(
      Uri.parse(
        "${ApiConfig.baseUrl}$_baseRoute/$purchaseId",
      ),
      headers: await _headers(),
    );

    return _parseObjectResponse(
      response,
      "pass",
      "Unable to load event pass.",
    );
  }

  /*
  |--------------------------------------------------------------------------
  | Secure Pass
  |--------------------------------------------------------------------------
  |
  | Generates a signed JWT used by the QR code.
  | This token should never be stored permanently.
  |
  */

  Future<String> securePass(
    String purchaseId,
  ) async {
    final response = await http.post(
      Uri.parse(
        "${ApiConfig.baseUrl}$_baseRoute/$purchaseId/secure-pass",
      ),
      headers: await _headers(),
    );

    final data = _decodeResponse(response);

    if (data["success"] != true) {
      throw Exception(
        data["message"] ??
            "Unable to generate secure pass.",
      );
    }

    final token = data["token"];

    if (token == null || token is! String) {
      throw Exception(
        "Invalid secure pass returned by server.",
      );
    }

    return token;
  }

  /*
  |--------------------------------------------------------------------------
  | Helpers
  |--------------------------------------------------------------------------
  */

  Map<String, dynamic> _parseObjectResponse(
    http.Response response,
    String key,
    String defaultMessage,
  ) {
    final data = _decodeResponse(response);

    if (data["success"] != true) {
      throw Exception(
        data["message"] ??
            defaultMessage,
      );
    }

    final object = data[key];

    if (object == null ||
        object is! Map<String, dynamic>) {
      throw Exception(
        "Invalid server response.",
      );
    }

    return object;
  }

  Map<String, dynamic> _decodeResponse(
    http.Response response,
  ) {
    if (response.body.isEmpty) {
      throw Exception(
        "Empty server response.",
      );
    }

    final decoded =
        jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception(
        "Unexpected server response.",
      );
    }

    if (response.statusCode >= 400) {
      throw Exception(
        decoded["message"] ??
            "Server error.",
      );
    }

    return decoded;
  }
}