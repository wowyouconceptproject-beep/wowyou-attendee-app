import "package:flutter/material.dart";

class StatusBadge extends StatelessWidget {
  final bool checkedIn;

  const StatusBadge({
    super.key,
    required this.checkedIn,
  });

  @override
  Widget build(BuildContext context) {
    final backgroundColor = checkedIn
        ? Colors.green.shade700
        : const Color(0xFFD4AF37);

    final foregroundColor =
        checkedIn ? Colors.white : Colors.black;

    final label = checkedIn
        ? "CHECKED IN"
        : "READY FOR ENTRY";

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: foregroundColor,
          fontWeight: FontWeight.bold,
          letterSpacing: 1,
        ),
      ),
    );
  }
}