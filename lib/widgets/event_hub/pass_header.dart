import "package:flutter/material.dart";
import "../../models/purchased_ticket.dart";

class PassHeader extends StatelessWidget {
  final PurchasedTicket ticket;

  const PassHeader({
    super.key,
    required this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "EVENT PASS",
          style: TextStyle(
            letterSpacing: 2,
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w600,
          ),
        ),

        const SizedBox(height: 20),

        Text(
          ticket.eventTitle,
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),

        const SizedBox(height: 16),

        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8,
          ),
          decoration: BoxDecoration(
            color: const Color(
              0xFFD4AF37,
            ),
            borderRadius:
                BorderRadius.circular(
              30,
            ),
          ),
          child: Text(
            ticket.ticketName.toUpperCase(),
            style: const TextStyle(
              color: Colors.black,
              fontWeight:
                  FontWeight.bold,
            ),
          ),
        ),

        const SizedBox(height: 24),

        CircleAvatar(
          radius: 42,
          backgroundColor:
              Colors.grey.shade800,
          backgroundImage:
              ticket.attendeeAvatar !=
                      null &&
                  ticket.attendeeAvatar!
                      .isNotEmpty
              ? NetworkImage(
                  ticket.attendeeAvatar!,
                )
              : null,
          child:
              ticket.attendeeAvatar ==
                          null ||
                      ticket
                          .attendeeAvatar!
                          .isEmpty
                  ? const Icon(
                      Icons.person,
                      size: 40,
                      color:
                          Colors.white,
                    )
                  : null,
        ),

        const SizedBox(height: 16),

        Text(
          ticket.attendeeName,
          style: const TextStyle(
            fontSize: 22,
            fontWeight:
                FontWeight.bold,
          ),
        ),

        if (ticket.jobTitle !=
                null &&
            ticket.jobTitle!
                .isNotEmpty)
          Padding(
            padding:
                const EdgeInsets.only(
              top: 6,
            ),
            child: Text(
              ticket.company !=
                          null &&
                      ticket.company!
                          .isNotEmpty
                  ? "${ticket.jobTitle} • ${ticket.company}"
                  : ticket.jobTitle!,
              style:
                  const TextStyle(
                color:
                    Colors.grey,
              ),
            ),
          ),

        const SizedBox(height: 14),

        Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.location_on,
              size: 18,
              color: Color(
                0xFFD4AF37,
              ),
            ),

            const SizedBox(width: 6),

            Flexible(
              child: Text(
                ticket.venue,
                style:
                    const TextStyle(
                  color:
                      Colors.grey,
                ),
                textAlign:
                    TextAlign.center,
              ),
            ),
          ],
        ),

        const SizedBox(height: 6),

        Text(
          "${ticket.startDate.day}/${ticket.startDate.month}/${ticket.startDate.year}",
          style: const TextStyle(
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}