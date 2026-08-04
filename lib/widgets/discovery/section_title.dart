import "package:flutter/material.dart";

import "package:attendee_app/theme/app_colors.dart";

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
      padding: const EdgeInsets.symmetric(
        horizontal: 24,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: AppColors.text,
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
                color:
                    AppColors.textSecondary,
              ),
            ),
          ],
        ],
      ),
    );
  }
}