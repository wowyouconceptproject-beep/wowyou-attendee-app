import "package:flutter/material.dart";

import "../models/event.dart";
import "../utils/storage.dart";
import "../services/event_service.dart";

import "../screens/login_screen.dart";

import "../widgets/event_details/event_hero.dart";
import "../widgets/event_details/event_info_card.dart";
import "../widgets/event_details/event_about.dart";
import "../widgets/event_details/ticket_card.dart";
import "../widgets/event_details/register_button.dart";

class EventDetailsScreen extends StatefulWidget {
  final Event event;

  const EventDetailsScreen({
    super.key,
    required this.event,
  });

  @override
  State<EventDetailsScreen> createState() =>
      _EventDetailsScreenState();
}

class _EventDetailsScreenState
    extends State<EventDetailsScreen> {
  final EventService _eventService =
      EventService();

  bool loading = false;

  Future<void> getTicket() async {
    setState(() {
      loading = true;
    });

    try {
      final token =
          await Storage.getToken();

      if (!mounted) return;

      /*
      |--------------------------------------------------------------------------
      | Login Required
      |--------------------------------------------------------------------------
      */

      if (token == null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) =>
                const LoginScreen(),
          ),
        );

        return;
      }

      /*
      |--------------------------------------------------------------------------
      | Next Phase
      |--------------------------------------------------------------------------
      |
      | We'll replace this with:
      |
      | Ticket Selection
      | Payment
      | Checkout
      |
      */

      final success =
          await _eventService
              .registerForEvent(
        token,
        widget.event.id,
      );

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? "Registration successful."
                : "Unable to continue.",
          ),
        ),
      );
    } finally {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    final event = widget.event;

    return Scaffold(
      backgroundColor:
          const Color(0xFF0B0B0B),

      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: EventHero(
              event: event,
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(
              height: 28,
            ),
          ),

          SliverToBoxAdapter(
            child: EventInfoCard(
              event: event,
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(
              height: 32,
            ),
          ),

          SliverToBoxAdapter(
            child: EventAbout(
              description:
                  event.description,
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(
              height: 32,
            ),
          ),

          const SliverToBoxAdapter(
            child: TicketCard(),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(
              height: 36,
            ),
          ),

          SliverToBoxAdapter(
            child: RegisterButton(
              loading: loading,
              onPressed: getTicket,
            ),
          ),

          const SliverToBoxAdapter(
            child: SizedBox(
              height: 40,
            ),
          ),
        ],
      ),
    );
  }
}