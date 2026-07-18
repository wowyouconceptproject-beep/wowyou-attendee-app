import "../models/event.dart";
import "event_service.dart";

class SearchService {
  final EventService _events =
      EventService();

  Future<List<Event>>
      search(
    String query,
  ) async {
    final events =
        await _events
            .getPublicEvents();

    if (query.isEmpty) {
      return events;
    }

    return events.where(
      (event) {
        return event.title
                .toLowerCase()
                .contains(
                  query
                      .toLowerCase(),
                ) ||
            event.venue
                .toLowerCase()
                .contains(
                  query
                      .toLowerCase(),
                );
      },
    ).toList();
  }
}