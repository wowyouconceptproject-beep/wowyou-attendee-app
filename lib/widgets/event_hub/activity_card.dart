import "package:flutter/material.dart";

import "../../models/purchased_ticket.dart";

class ActivityCard extends StatelessWidget {
  final PurchasedTicket ticket;

  const ActivityCard({
    super.key,
    required this.ticket,
  });

  Widget activityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 18,
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .15),
              borderRadius:
                  BorderRadius.circular(
                14,
              ),
            ),
            child: Icon(
              icon,
              color: color,
            ),
          ),

          const SizedBox(
            width: 16,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style:
                      const TextStyle(
                    fontWeight:
                        FontWeight.bold,
                    fontSize: 15,
                  ),
                ),

                const SizedBox(
                  height: 4,
                ),

                Text(
                  subtitle,
                  style:
                      const TextStyle(
                    color:
                        Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(
    BuildContext context,
  ) {
    return Container(
      width: double.infinity,
      padding:
          const EdgeInsets.all(
        22,
      ),
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
            CrossAxisAlignment
                .start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.timeline,
                color:
                    Color(
                  0xFFD4AF37,
                ),
              ),

              SizedBox(
                width: 12,
              ),

              Text(
                "Activity",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight:
                      FontWeight.bold,
                ),
              ),
            ],
          ),

          const SizedBox(
            height: 12,
          ),

          const Text(
            "Everything happening around your event participation.",
            style: TextStyle(
              color: Colors.grey,
              height: 1.5,
            ),
          ),

          const SizedBox(
            height: 24,
          ),

          activityItem(
            icon:
                ticket.checkedIn
                    ? Icons.check_circle
                    : Icons.qr_code_scanner,
            title:
                ticket.checkedIn
                    ? "Checked In"
                    : "Ready for Check-in",
            subtitle:
                ticket.checkedIn
                    ? "Your entry has been recorded."
                    : "Present your QR pass at the entrance.",
            color:
                ticket.checkedIn
                    ? Colors.green
                    : const Color(
                        0xFFD4AF37,
                      ),
          ),

          activityItem(
            icon: Icons.people,
            title:
                "AI Networking",
            subtitle:
                "Connect with professionals attending this event.",
            color: Colors.blue,
          ),

          activityItem(
            icon:
                Icons.notifications,
            title:
                "Live Updates",
            subtitle:
                "Receive announcements from organizers instantly.",
            color: Colors.orange,
          ),

          const SizedBox(
            height: 10,
          ),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: () {
                // TODO:
                // Navigator.push(...)
              },
              style:
                  OutlinedButton.styleFrom(
                foregroundColor:
                    const Color(
                  0xFFD4AF37,
                ),
                side:
                    const BorderSide(
                  color: Color(
                    0xFFD4AF37,
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(
                  vertical: 16,
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),
                ),
              ),
              icon: const Icon(
                Icons.timeline,
              ),
              label: const Text(
                "View Full Activity",
              ),
            ),
          ),
        ],
      ),
    );
  }
}