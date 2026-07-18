import "package:flutter/material.dart";

import "../../models/purchased_ticket.dart";

class AnnouncementCard
    extends StatelessWidget {
  final PurchasedTicket ticket;

  const AnnouncementCard({
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
      child: const Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.campaign,
                color: Color(
                  0xFFD4AF37,
                ),
              ),
              SizedBox(width: 12),
              Text(
                "Announcements",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),

          SizedBox(height: 18),

          Text(
            "Receive live updates from organizers throughout the event.",
            style: TextStyle(
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}