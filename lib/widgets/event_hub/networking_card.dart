import "package:flutter/material.dart";

import "../../models/purchased_ticket.dart";

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
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF181818),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(
                Icons.groups_rounded,
                color: Color(0xFFD4AF37),
                size: 28,
              ),

              SizedBox(width: 12),

              Expanded(
                child: Text(
                  "AI Networking",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          const Text(
            "Our AI recommends attendees you should meet based on your profession, industry, skills and networking goals.",
            style: TextStyle(
              color: Colors.grey,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 24),

          Container(
            padding: const EdgeInsets.all(18),
            decoration: BoxDecoration(
              color: const Color(0xFF222222),
              borderRadius:
                  BorderRadius.circular(18),
            ),
            child: Row(
              children: const [
                CircleAvatar(
                  radius: 28,
                  backgroundColor:
                      Color(0xFFD4AF37),
                  child: Icon(
                    Icons.auto_awesome,
                    color: Colors.black,
                  ),
                ),

                SizedBox(width: 18),

                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment
                            .start,
                    children: [
                      Text(
                        "AI Matches",
                        style: TextStyle(
                          fontWeight:
                              FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),

                      SizedBox(height: 4),

                      Text(
                        "Complete your profile to unlock personalized networking recommendations.",
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
          ),

          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () {
                // TODO:
                // Navigate to AI Matches
              },
              icon: const Icon(
                Icons.auto_awesome,
              ),
              label: const Text(
                "View AI Matches",
              ),
              style:
                  ElevatedButton.styleFrom(
                backgroundColor:
                    const Color(
                  0xFFD4AF37,
                ),
                foregroundColor:
                    Colors.black,
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
            ),
          ),
        ],
      ),
    );
  }
}