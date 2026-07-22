import "package:flutter/material.dart";

import "../models/purchased_ticket.dart";

import "../services/socket_service.dart";
import "../utils/storage.dart";

import "../widgets/event_hub/agenda_card.dart";
import "../widgets/event_hub/activity_panel.dart";
import "../widgets/event_hub/announcement_panel.dart";
import "../widgets/event_hub/event_banner.dart";
import "../widgets/event_hub/networking_card.dart";
import "../widgets/event_hub/venue_card.dart";

class EventHubScreen extends StatefulWidget {
  final PurchasedTicket ticket;

  const EventHubScreen({
    super.key,
    required this.ticket,
  });

  @override
  State<EventHubScreen> createState() =>
      _EventHubScreenState();
}

class _EventHubScreenState
    extends State<EventHubScreen> {
  @override
  void initState() {
    super.initState();

    _initializeSocket();
  }

  Future<void> _initializeSocket() async {
    final token =
        await Storage.getToken();

    if (token == null) return;

    await SocketService.instance.connect();

    SocketService.instance.joinEvent(
      eventId: widget.ticket.eventId,
      token: token,
    );
  }

  @override
  void dispose() {
    SocketService.instance.leaveEvent(
      widget.ticket.eventId,
    );

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:
          const Color(0xFF0B0B0B),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: EventBanner(
              ticket: widget.ticket,
            ),
          ),

          SliverToBoxAdapter(
            child: Padding(
              padding:
                  const EdgeInsets.fromLTRB(
                24,
                28,
                24,
                40,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Welcome to Event Hub",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 10,
                  ),

                  const Text(
                    "Everything you need for your event is organized in one place. Stay informed, discover opportunities and make valuable connections.",
                    style: TextStyle(
                      color:
                          Colors.white70,
                      height: 1.6,
                      fontSize: 15,
                    ),
                  ),

                  const SizedBox(
                    height: 32,
                  ),

                  const Text(
                    "Announcements",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 14,
                  ),

                  AnnouncementPanel(
                    ticket:
                        widget.ticket,
                  ),

                  const SizedBox(
                    height: 28,
                  ),

                  const Text(
                    "Your Schedule",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 14,
                  ),

                  AgendaCard(
                    ticket:
                        widget.ticket,
                  ),

                  const SizedBox(
                    height: 28,
                  ),

                  const Text(
                    "Activities",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 14,
                  ),

                  ActivityPanel(
                    ticket:
                        widget.ticket,
                  ),

                  const SizedBox(
                    height: 28,
                  ),

                  const Text(
                    "Venue Information",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 14,
                  ),

                  VenueCard(
                    ticket:
                        widget.ticket,
                  ),

                  const SizedBox(
                    height: 28,
                  ),

                  const Text(
                    "Networking",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                    ),
                  ),

                  const SizedBox(
                    height: 14,
                  ),

                  NetworkingCard(
                    ticket:
                        widget.ticket,
                  ),

                  const SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}