import "package:flutter/material.dart";

class SectionTitle extends StatelessWidget {
  final String title;

  final String? subtitle;

  const SectionTitle({
    super.key,
    required this.title,
    this.subtitle,
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
          Text(
            title,
            style: const TextStyle(
              fontSize: 22,
              fontWeight:
                  FontWeight.bold,
            ),
          ),

          if (subtitle != null) ...[
            const SizedBox(
              height: 4,
            ),

            Text(
              subtitle!,
              style: const TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ],
      ),
    );
  }
}