import "package:flutter/material.dart";

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
            color: Colors.white70,
          ),
        ),

        const SizedBox(height: 8),

        Text(
          "${secondsRemaining}s",
          style: const TextStyle(
            color: Color(0xFFD4AF37),
            fontSize: 34,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}