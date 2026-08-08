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

  Future<List<Map<String, dynamic>>>
    securePass(
  String purchaseId,
) async {
  final response =
      await http.post(
    Uri.parse(
      "${ApiConfig.baseUrl}$_baseRoute/$purchaseId/secure-pass",
    ),
    headers:
        await _headers(),
  );

  final data =
      _decodeResponse(
    response,
  );

  if (data["success"] !=
      true) {
    throw Exception(
      data["message"] ??
          "Unable to generate secure pass.",
    );
  }

  final passes =
      data["passes"];

  if (passes == null ||
      passes is! List) {
    throw Exception(
      "Invalid secure passes returned by server.",
    );
  }

  return List<Map<String, dynamic>>
      .from(passes);
}



  Future<List<Map<String, dynamic>>>
      getIssuedPasses(
    String purchaseId,
  ) async {
    final response =
        await http.post(
      Uri.parse(
        "${ApiConfig.baseUrl}$_baseRoute/$purchaseId/secure-pass",
      ),
      headers:
          await _headers(),
    );

    final data =
        _decodeResponse(
      response,
    );

    if (data["success"] !=
        true) {
      throw Exception(
        data["message"] ??
            "Unable to load passes.",
      );
    }

    final passes =
        data["passes"];

    if (passes == null ||
        passes is! List) {
      throw Exception(
        "Invalid passes returned by server.",
      );
    }

    return List<Map<String, dynamic>>
        .from(passes);
  }

  

  Future<List<Map<String, dynamic>>>
      refreshPass(
    String purchaseId,
  ) {
    return getIssuedPasses(
      purchaseId,
    );
  }


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