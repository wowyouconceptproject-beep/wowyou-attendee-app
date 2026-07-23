import "package:flutter/material.dart";
import "package:provider/provider.dart";

import "../models/event.dart";
import "../providers/auth_provider.dart";
import "../services/event_service.dart";
import "../utils/storage.dart";
import "../widgets/auth/protected_feature_view.dart";

import "event_details_screen.dart";
import "login_screen.dart";
import "register_screen.dart";

class TicketsScreen extends StatefulWidget {
  const TicketsScreen({
    super.key,
  });

  @override
  State<TicketsScreen> createState() =>
      _TicketsScreenState();
}

class _TicketsScreenState
    extends State<TicketsScreen> {
  final EventService _eventService =
      EventService();

  List<Event> events = [];

  bool loading = true;

  @override
  void initState() {
    super.initState();

    loadTickets();
  }

  Future<void> loadTickets() async {
    final token = await Storage.getToken();

    if (token == null) {
      if (mounted) {
        setState(() {
          loading = false;
        });
      }
      return;
    }

    try {
      final result =
          await _eventService.getMyRegistrations(
        token,
      );

      if (!mounted) return;

      setState(() {
        events = result;
        loading = false;
      });
    } catch (_) {
      if (!mounted) return;

      setState(() {
        loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final auth =
        context.watch<AuthProvider>();

    if (!auth.isAuthenticated) {
      return ProtectedFeatureView(
        icon: Icons.confirmation_number,
        title: "Your Tickets",
        description:
            "Sign in to access your tickets and event passes.",
        benefits: const [
          "View QR event passes",
          "Transfer tickets",
          "Purchase history",
          "Receive event updates",
        ],
        onSignIn: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const LoginScreen(),
            ),
          );
        },
        onCreateAccount: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) =>
                  const RegisterScreen(),
            ),
          );
        },
      );
    }

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
                    "You haven't acquired any tickets yet.",
                  ),
                )
              : ListView.builder(
                  itemCount: events.length,
                  itemBuilder:
                      (context, index) {
                    final event =
                        events[index];

                    return Card(
                      margin:
                          const EdgeInsets.all(
                        12,
                      ),
                      child: ListTile(
                        title: Text(
                          event.title,
                        ),
                        subtitle: Text(
                          event.venue,
                        ),
                        trailing: const Icon(
                          Icons
                              .confirmation_number,
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) =>
                                  EventDetailsScreen(
                                event: event,
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