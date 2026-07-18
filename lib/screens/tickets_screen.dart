import "package:flutter/material.dart";

import "../models/event.dart";
import "../services/event_service.dart";
import "../utils/storage.dart";
import "event_details_screen.dart";

class TicketsScreen
    extends StatefulWidget {
  const TicketsScreen({
    super.key,
  });

  @override
  State<TicketsScreen>
      createState() =>
          _TicketsScreenState();
}

class _TicketsScreenState
    extends State<TicketsScreen> {
  final EventService
      _eventService =
          EventService();

  List<Event> events = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();

    loadTickets();
  }

  Future<void> loadTickets()
      async {
    final token =
        await Storage.getToken();

    if (token == null) {
      return;
    }

    final result =
        await _eventService
            .getMyRegistrations(
      token,
    );

    setState(() {
      events = result;
      loading = false;
    });
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Tickets",
        ),
      ),
      body: loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : events.isEmpty
              ? const Center(
                  child: Text(
                    "No registrations yet",
                  ),
                )
              : ListView.builder(
                  itemCount:
                      events.length,
                  itemBuilder:
                      (
                    context,
                    index,
                  ) {
                    final event =
                        events[
                            index];

                    return Card(
                      margin:
                          const EdgeInsets
                              .all(
                        12,
                      ),
                      child:
                          ListTile(
                        title:
                            Text(
                          event.title,
                        ),
                        subtitle:
                            Text(
                          event.venue,
                        ),
                        trailing:
                            const Icon(
                          Icons
                              .confirmation_number,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (_) =>
                                      EventDetailsScreen(
                                event:
                                    event,
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
    );
  }
}