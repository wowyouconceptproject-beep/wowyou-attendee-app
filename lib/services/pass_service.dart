
import "dart:convert";

import "package:http/http.dart" as http;

import "../config/api.dart";
import "../utils/storage.dart";

class PassService {
  static const String _baseRoute = "/pass";

  Future<Map<String, String>> _headers() async {
    final token = await Storage.getToken();

    if (token == null || token.isEmpty) {
      throw Exception("Authentication required.");
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
  | Generate Secure Pass
  |--------------------------------------------------------------------------
  |
  | Returns the permanent signed pass credentials.
  | These credentials are retained for the NFC writing flow.
  |
  */

  Future<List<Map<String, dynamic>>> securePass(
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
        data["message"] ?? "Unable to generate secure pass.",
      );
    }

    final passes = data["passes"];

    if (passes is! List) {
      throw Exception(
        "Invalid secure passes returned by server.",
      );
    }

    return List<Map<String, dynamic>>.from(passes);
  }

  /*
  |--------------------------------------------------------------------------
  | Generate Rotating QR Token
  |--------------------------------------------------------------------------
  |
  | Requests a short-lived QR token from the existing backend route.
  | The backend signs the token and sets its expiry to 60 seconds.
  |
  */

  Future<String> rotatingQrToken(
    String purchaseId,
  ) async {
    final response = await http.post(
      Uri.parse(
        "${ApiConfig.baseUrl}$_baseRoute/$purchaseId/rotating-qr",
      ),
      headers: await _headers(),
    );

    final data = _decodeResponse(response);

    if (data["success"] != true) {
      throw Exception(
        data["message"] ?? "Unable to refresh QR code.",
      );
    }

    final passes = data["passes"];

    if (passes is! List || passes.isEmpty) {
      throw Exception(
        "No rotating QR token returned by server.",
      );
    }

    final firstPass = passes.first;

    if (firstPass is! Map ||
        firstPass["token"] is! String ||
        (firstPass["token"] as String).isEmpty) {
      throw Exception(
        "Invalid rotating QR token returned by server.",
      );
    }

    return firstPass["token"] as String;
  }

  /*
  |--------------------------------------------------------------------------
  | Get Issued Passes
  |--------------------------------------------------------------------------
  */

  Future<List<Map<String, dynamic>>> getIssuedPasses(
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
        data["message"] ?? "Unable to load passes.",
      );
    }

    final passes = data["passes"];

    if (passes is! List) {
      throw Exception(
        "Invalid passes returned by server.",
      );
    }

    return List<Map<String, dynamic>>.from(passes);
  }

  /*
  |--------------------------------------------------------------------------
  | Refresh Pass
  |--------------------------------------------------------------------------
  */

  Future<List<Map<String, dynamic>>> refreshPass(
    String purchaseId,
  ) {
    return getIssuedPasses(purchaseId);
  }

  /*
  |--------------------------------------------------------------------------
  | Parse Object Response
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
        data["message"] ?? defaultMessage,
      );
    }

    final object = data[key];

    if (object is! Map<String, dynamic>) {
      throw Exception("Invalid server response.");
    }

    return object;
  }

  /*
  |--------------------------------------------------------------------------
  | Decode Response
  |--------------------------------------------------------------------------
  */

  Map<String, dynamic> _decodeResponse(
    http.Response response,
  ) {
    if (response.body.isEmpty) {
      throw Exception("Empty server response.");
    }

    final decoded = jsonDecode(response.body);

    if (decoded is! Map<String, dynamic>) {
      throw Exception("Unexpected server response.");
    }

    if (response.statusCode >= 400) {
      throw Exception(
        decoded["message"] ?? "Server error.",
      );
    }

    return decoded;
  }
}
