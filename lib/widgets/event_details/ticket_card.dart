import "package:flutter/material.dart";

class TicketCard
    extends StatelessWidget {
  const TicketCard({
    super.key,
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
      child: Row(
        children: [
          const Icon(
            Icons.confirmation_num,
            color: Color(
              0xFFD4AF37,
            ),
            size: 42,
          ),

          const SizedBox(width: 18),

          const Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  "Tickets",
                  style: TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  "Purchase your event ticket to unlock AI networking, announcements and your digital pass.",
                  style: TextStyle(
                    color:
                        Colors.grey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}