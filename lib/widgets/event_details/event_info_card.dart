import "package:flutter/material.dart";

import "../../models/event.dart";

class EventInfoCard
    extends StatelessWidget {
  final Event event;

  const EventInfoCard({
    super.key,
    required this.event,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:
          const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(
          0xFF181818,
        ),
        borderRadius:
            BorderRadius.circular(
          24,
        ),
      ),
      child: Column(
        children: [
          _row(
            Icons.calendar_today,
            event.startDate.toString(),
          ),

          const SizedBox(height: 18),

          _row(
            Icons.people,
            "${event.capacity} Attendees",
          ),

          const SizedBox(height: 18),

          _row(
            Icons.location_on,
            event.venue,
          ),
        ],
      ),
    );
  }

  Widget _row(
    IconData icon,
    String text,
  ) {
    return Row(
      children: [
        const Icon(
          Icons.circle,
          size: 0,
        ),

        Icon(
          icon,
          color:
              const Color(
            0xFFD4AF37,
          ),
        ),

        const SizedBox(width: 14),

        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}