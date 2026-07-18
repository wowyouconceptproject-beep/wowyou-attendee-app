import "package:flutter/material.dart";

class EventAbout
    extends StatelessWidget {
  final String description;

  const EventAbout({
    super.key,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            "About Event",
            style: TextStyle(
              fontSize: 24,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          const SizedBox(height: 14),

          Text(
            description,
            style: const TextStyle(
              color: Colors.grey,
              height: 1.7,
            ),
          ),
        ],
      ),
    );
  }
}