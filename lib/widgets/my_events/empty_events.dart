import "package:flutter/material.dart";
import "package:attendee_app/theme/app_colors.dart";

class EmptyEvents extends StatelessWidget {
  final VoidCallback onDiscover;

  const EmptyEvents({
    super.key,
    required this.onDiscover,
  });

  @override
  Widget build(
    BuildContext context,
  ) {
    return Center(
      child: Padding(
        padding:
            const EdgeInsets.all(
          32,
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                color: AppColors.primary
                    .withValues(
                  alpha: 0.12,
                ),
                shape: BoxShape.circle,
                border: Border.all(
                  color: AppColors.border,
                ),
              ),
              child: const Icon(
                Icons.event,
                size: 56,
                color:
                    AppColors.primary,
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            const Text(
              "No Events Yet",
              style: TextStyle(
                color: AppColors.text,
                fontSize: 28,
                fontWeight:
                    FontWeight.bold,
              ),
            ),

            const SizedBox(
              height: 12,
            ),

            const Text(
              "Discover amazing experiences happening around you.",
              textAlign:
                  TextAlign.center,
              style: TextStyle(
                color: AppColors
                    .textSecondary,
                height: 1.6,
              ),
            ),

            const SizedBox(
              height: 30,
            ),

            SizedBox(
              width: 220,
              child: ElevatedButton(
                onPressed:
                    onDiscover,
                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      AppColors.primary,
                  foregroundColor:
                      Colors.white,
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 16,
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(
                      16,
                    ),
                  ),
                ),
                child: const Text(
                  "Discover Events",
                  style: TextStyle(
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}