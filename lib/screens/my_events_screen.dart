import "package:flutter/material.dart";

import "../models/purchased_ticket.dart";
import "../services/purchase_service.dart";

import "home_screen.dart";
import 'eventhubscreen.dart';

import "../widgets/my_events/my_event_card.dart";
import "../widgets/my_events/empty_events.dart";

class MyEventsScreen
    extends StatefulWidget {
  const MyEventsScreen({
    super.key,
  });

  @override
  State<MyEventsScreen>
      createState() =>
          _MyEventsScreenState();
}

class _MyEventsScreenState
    extends State<MyEventsScreen> {
  final PurchaseService
      _purchaseService =
          PurchaseService();

  bool loading = true;

  List<PurchasedTicket>
      tickets = [];

  @override
  void initState() {
    super.initState();

    loadEvents();
  }

  Future<void> loadEvents()
      async {
    final result =
        await _purchaseService
            .getMyTickets();

    if (!mounted) return;

    setState(() {
      tickets = result;
      loading = false;
    });
  }

  List<PurchasedTicket>
      get upcoming {
    final now = DateTime.now();

    return tickets
        .where(
          (ticket) =>
              ticket.startDate
                  .isAfter(now),
        )
        .toList();
  }

  List<PurchasedTicket>
      get past {
    final now = DateTime.now();

    return tickets
        .where(
          (ticket) =>
              ticket.startDate
                  .isBefore(now),
        )
        .toList();
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Scaffold(
      backgroundColor:
          const Color(
        0xFF0B0B0B,
      ),

      appBar: AppBar(
        title: const Text(
          "My Events",
        ),
      ),

      body: loading
          ? const Center(
              child:
                  CircularProgressIndicator(),
            )
          : tickets.isEmpty
              ? EmptyEvents(
                  onDiscover: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (_) =>
                            const HomeScreen(),
                      ),
                    );
                  },
                )
              : RefreshIndicator(
                  onRefresh:
                      loadEvents,
                  child:
                      ListView(
                    children: [
                      if (upcoming
                          .isNotEmpty) ...[
                        const Padding(
                          padding:
                              EdgeInsets.fromLTRB(
                            24,
                            24,
                            24,
                            18,
                          ),
                          child: Text(
                            "Upcoming",
                            style:
                                TextStyle(
                              fontSize:
                                  28,
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),
                        ),

                        ...upcoming.map(
                          (ticket) =>
                              MyEventCard(
                            ticket:
                                ticket,
                            onOpen:
                                () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (_) =>
                                          EventHubScreen(
                                    ticket:
                                        ticket,
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],

                      if (past
                          .isNotEmpty) ...[
                        const Padding(
                          padding:
                              EdgeInsets.fromLTRB(
                            24,
                            18,
                            24,
                            18,
                          ),
                          child: Text(
                            "Past Events",
                            style:
                                TextStyle(
                              fontSize:
                                  28,
                              fontWeight:
                                  FontWeight
                                      .bold,
                            ),
                          ),
                        ),

                        ...past.map(
                          (ticket) =>
                              Opacity(
                            opacity:
                                .75,
                            child:
                                MyEventCard(
                              ticket:
                                  ticket,
                              onOpen:
                                  () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder:
                                        (_) =>
                                            EventHubScreen(
                                      ticket:
                                          ticket,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(
                        height: 40,
                      ),
                    ],
                  ),
                ),
    );
  }
}