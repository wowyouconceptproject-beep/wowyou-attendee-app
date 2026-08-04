import "package:flutter/material.dart";
import "package:attendee_app/theme/app_colors.dart";

class CountdownCard extends StatelessWidget {
  final int secondsRemaining;

  const CountdownCard({
    super.key,
    required this.secondsRemaining,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text(
          "Refreshing Secure Pass",
          style: TextStyle(
            color:
                AppColors.textSecondary,
          ),
        ),

        const SizedBox(
          height: 8,
        ),

        Text(
          "${secondsRemaining}s",
          style: const TextStyle(
            color:
                AppColors.primary,
            fontSize: 34,
            fontWeight:
                FontWeight.bold,
          ),
        ),
      ],
    );
  }
}