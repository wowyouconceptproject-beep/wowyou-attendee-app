import "package:flutter/material.dart";

import "../../models/purchased_ticket.dart";

class EventCard extends StatelessWidget {
  final PurchasedTicket ticket;

  const EventCard({
    super.key,
    required this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          ticket.eventTitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 21,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 18),

        Container(
          padding:
              const EdgeInsets.symmetric(
            horizontal: 22,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFD4AF37),
            borderRadius:
                BorderRadius.circular(30),
          ),
          child: Text(
            ticket.ticketName.toUpperCase(),
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 24),

        Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_on_outlined,
              color: Colors.white70,
              size: 18,
            ),

            const SizedBox(width: 6),

            Flexible(
              child: Text(
                ticket.venue,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: Colors.white70,
                ),
              ),
            ),
          ],
        ),

        const SizedBox(height: 8),

        Text(
          "${ticket.startDate.day}/${ticket.startDate.month}/${ticket.startDate.year}",
          style: const TextStyle(
            color: Colors.white54,
          ),
        ),
      ],
    );
  }
}