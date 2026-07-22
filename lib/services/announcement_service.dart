import 'dart:convert';

import 'package:http/http.dart' as http;

import '../config/api.dart';
import '../models/announcement.dart';
import '../utils/storage.dart';

class AnnouncementService {
  AnnouncementService._();

  static final AnnouncementService instance =
      AnnouncementService._();

  Future<List<Announcement>> getAnnouncements({
    required String eventId,
  }) async {
    final token =
        await Storage.getToken();

    final response = await http.get(
      Uri.parse(
        "${ApiConfig.baseUrl}/events/$eventId/announcements",
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
            "Failed to load announcements.",
      );
    }

    final List<dynamic> items =
        body["announcements"] ?? [];

    return items
        .map(
          (e) => Announcement.fromJson(e),
        )
        .toList();
  }
}