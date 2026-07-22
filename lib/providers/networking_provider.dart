import "package:flutter/foundation.dart";

import "../models/match_card.dart";
import "../services/networking_service.dart";

class NetworkingProvider extends ChangeNotifier {
  final NetworkingService _service =
      NetworkingService();

  bool isLoading = false;

  List<MatchCard> matches = [];

  Future<void> loadMatches({
    required String eventId,
  }) async {
    isLoading = true;
    notifyListeners();

    try {
      matches =
          await _service.getMatches(
        eventId: eventId,
      );
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh({
    required String eventId,
  }) async {
    await loadMatches(
      eventId: eventId,
    );
  }
}