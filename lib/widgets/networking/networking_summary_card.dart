import "package:flutter/material.dart";
import "package:attendee_app/theme/app_colors.dart";

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
        color: AppColors.card,
        borderRadius:
            BorderRadius.circular(
          22,
        ),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius:
                  BorderRadius.circular(
                18,
              ),
            ),
            child: const Icon(
              Icons.auto_awesome,
              color: Colors.white,
              size: 34,
            ),
          ),

          const SizedBox(
            width: 20,
          ),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                const Text(
                  "AI Networking",
                  style: TextStyle(
                    color: AppColors.text,
                    fontSize: 20,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 6,
                ),

                Text(
                  "$totalMatches attendees recommended",
                  style: const TextStyle(
                    color: AppColors
                        .textSecondary,
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
                  color: AppColors
                      .textSecondary,
                ),
              ),

              Text(
                "$highestScore%",
                style: const TextStyle(
                  color:
                      AppColors.primary,
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