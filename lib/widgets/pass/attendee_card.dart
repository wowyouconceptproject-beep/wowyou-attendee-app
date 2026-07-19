import "package:flutter/material.dart";

import "../../models/purchased_ticket.dart";

class AttendeeCard extends StatelessWidget {
  final PurchasedTicket ticket;

  const AttendeeCard({
    super.key,
    required this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    final subtitle = [
      ticket.profession,
      ticket.company,
    ].whereType<String>().join(" • ");

    return Column(
      children: [
        CircleAvatar(
          radius: 42,
          backgroundColor:
              const Color(0xFFD4AF37),
          backgroundImage:
              ticket.attendeeAvatar != null
                  ? NetworkImage(
                      ticket.attendeeAvatar!,
                    )
                  : null,
          child: ticket.attendeeAvatar == null
              ? const Icon(
                  Icons.person,
                  size: 40,
                  color: Colors.black,
                )
              : null,
        ),

        const SizedBox(height: 18),

        Text(
          ticket.attendeeName,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),

        if (subtitle.isNotEmpty)
          Padding(
            padding:
                const EdgeInsets.only(top: 6),
            child: Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white70,
              ),
            ),
          ),
      ],
    );
  }
}