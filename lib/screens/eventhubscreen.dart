import "package:flutter/material.dart";

import "../models/purchased_ticket.dart";

import "../widgets/event_hub/activity_card.dart";
import "../widgets/event_hub/agenda_card.dart";
import "../widgets/event_hub/announcement_card.dart";
import "../widgets/event_hub/event_banner.dart";
import "../widgets/event_hub/networking_card.dart";
import "../widgets/event_hub/venue_card.dart";

class EventHubScreen extends StatelessWidget {
  final PurchasedTicket ticket;

  const EventHubScreen({
    super.key,
    required this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0B0B),
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: EventBanner(
              ticket: ticket,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AnnouncementCard(
                    ticket: ticket,
                  ),

                  const SizedBox(height: 24),

                  AgendaCard(
                    ticket: ticket,
                  ),

                  const SizedBox(height: 24),

                  ActivityCard(
                    ticket: ticket,
                  ),

                  const SizedBox(height: 24),

                  VenueCard(
                    ticket: ticket,
                  ),

                  const SizedBox(height: 24),

                  NetworkingCard(
                    ticket: ticket,
                  ),

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}