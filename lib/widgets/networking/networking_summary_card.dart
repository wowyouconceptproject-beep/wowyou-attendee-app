import "package:flutter/material.dart";

class NetworkingSummaryCard extends StatelessWidget {
  final int totalMatches;

  final int highestScore;

  const NetworkingSummaryCard({
    super.key,
    required this.totalMatches,
    required this.highestScore,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF181818),
        borderRadius:
            BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color:
                  const Color(0xFFD4AF37),
              borderRadius:
                  BorderRadius.circular(
                18,
              ),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.black,
              size: 34,
            ),
          ),

          const SizedBox(width: 20),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  "AI Networking",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "$totalMatches attendees recommended",
                  style: const TextStyle(
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              const Text(
                "Highest",
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),

              Text(
                "$highestScore%",
                style: const TextStyle(
                  color:
                      Color(0xFFD4AF37),
                  fontWeight:
                      FontWeight.bold,
                  fontSize: 28,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}