import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api.dart';
import '../models/activity.dart';
import '../utils/storage.dart';

class ActivityService {
  ActivityService._();

  static final ActivityService instance =
      ActivityService._();

  Future<List<Activity>> getActivity({
    required String eventId,
  }) async {
    final token =
        await Storage.getToken();

    final response = await http.get(
      Uri.parse(
        "${ApiConfig.baseUrl}/events/$eventId/activity",
      ),
      headers: {
        "Content-Type":
            "application/json",
        "Authorization":
            "Bearer $token",
      },
    );

    final body =
        jsonDecode(response.body);

    if (response.statusCode != 200 ||
        body["success"] != true) {
      throw Exception(
        body["message"] ??
            "Failed to load activity.",
      );
    }

    final List<dynamic> items =
        body["activity"] ?? [];

    return items
        .map(
          (e) => Activity.fromJson(e),
        )
        .toList();
  }
}