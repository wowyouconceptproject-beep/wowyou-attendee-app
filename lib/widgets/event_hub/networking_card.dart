import "package:flutter/material.dart";

import "../../models/purchased_ticket.dart";
import "../../screens/networking/networking_screen.dart";

class NetworkingCard extends StatelessWidget {
  final PurchasedTicket ticket;

  const NetworkingCard({
    super.key,
    required this.ticket,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF181818),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: const Color(0xFFD4AF37).withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: const Color(0xFFD4AF37),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.auto_awesome,
                  color: Colors.black,
                  size: 28,
                ),
              ),

              const SizedBox(width: 16),

              const Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      "AI Networking",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      "Meet the right people at this event",
                      style: TextStyle(
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          const Text(
            "Our AI analyzes attendee profiles and recommends the most valuable people for you to connect with based on your profession, industry, interests and networking goals.",
            style: TextStyle(
              color: Colors.white70,
              height: 1.7,
            ),
          ),

          const SizedBox(height: 28),

          /// Features
          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF222222),
              borderRadius: BorderRadius.circular(18),
            ),
            child: Column(
              children: const [
                _FeatureRow(
                  icon: Icons.groups_rounded,
                  title: "Smart AI Matches",
                ),
                SizedBox(height: 14),
                _FeatureRow(
                  icon: Icons.psychology_alt,
                  title: "Personalized Recommendations",
                ),
                SizedBox(height: 14),
                _FeatureRow(
                  icon: Icons.handshake,
                  title: "Build Valuable Connections",
                ),
              ],
            ),
          ),

          const SizedBox(height: 28),

          /// CTA
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) =>
                        NetworkingScreen(
                      eventId: ticket.eventId,
                    ),
                  ),
                );
              },
              icon: const Icon(
                Icons.auto_awesome,
              ),
              label: const Text(
                "Explore AI Matches",
              ),
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(0xFFD4AF37),
                foregroundColor:
                    Colors.black,
                elevation: 0,
                padding:
                    const EdgeInsets.symmetric(
                  vertical: 18,
                ),
                shape:
                    RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(
                    18,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FeatureRow extends StatelessWidget {
  final IconData icon;
  final String title;

  const _FeatureRow({
    required this.icon,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFFD4AF37)
                .withValues(alpha: 0.15),
            borderRadius:
                BorderRadius.circular(12),
          ),
          child: Icon(
            icon,
            color: const Color(0xFFD4AF37),
            size: 20,
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}