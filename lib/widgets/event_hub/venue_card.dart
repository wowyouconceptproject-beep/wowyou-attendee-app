import "package:flutter/material.dart";

import "../../models/purchased_ticket.dart";

class VenueCard
    extends StatelessWidget {
  final PurchasedTicket ticket;

  const VenueCard({
    super.key,
    required this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color:
            const Color(
          0xFF181818,
        ),
        borderRadius:
            BorderRadius.circular(
          24,
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.map,
                color:
                    Color(
                  0xFFD4AF37,
                ),
              ),
              SizedBox(width: 12),
              Text(
                "Venue",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 18,
          ),

          Text(
            ticket.venue,
            style:
                const TextStyle(
              color:
                  Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}