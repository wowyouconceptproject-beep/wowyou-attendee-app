import "package:flutter/material.dart";

import "../../models/event.dart";
import "package:attendee_app/theme/app_colors.dart";

class EventHorizontalCard extends StatelessWidget {
  final Event event;

  final VoidCallback onTap;

  const EventHorizontalCard({
    super.key,
    required this.event,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 260,
        margin: const EdgeInsets.only(
          left: 24,
        ),
        decoration: BoxDecoration(
          color: AppColors.card,
          borderRadius: BorderRadius.circular(
            24,
          ),
          border: Border.all(
            color: AppColors.border,
          ),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 150,
              width: double.infinity,
              child: Image.network(
                event.coverImage ??
                    event.featuredImage ??
                    "https://images.unsplash.com/photo-1511578314322-379afb476865?w=1200",
                fit: BoxFit.cover,
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(
                18,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    event.title,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style:
                        const TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.bold,
                      color:
                          AppColors.text,
                    ),
                  ),

                  const SizedBox(
                    height: 12,
                  ),

                  Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        color:
                            AppColors.primary,
                        size: 16,
                      ),

                      const SizedBox(
                        width: 6,
                      ),

                      Expanded(
                        child: Text(
                          event.venue,
                          overflow:
                              TextOverflow
                                  .ellipsis,
                          style:
                              const TextStyle(
                            color: AppColors
                                .textSecondary,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(
                    height: 8,
                  ),

                  Text(
                    "${event.startDate.day}/${event.startDate.month}/${event.startDate.year}",
                    style:
                        const TextStyle(
                      color: AppColors
                          .textSecondary,
                    ),
                  ),

                  const SizedBox(
                    height: 16,
                  ),

                  Row(
                    children: [
                      const Text(
                        "Explore",
                        style: TextStyle(
                          color:
                              AppColors.primary,
                          fontWeight:
                              FontWeight
                                  .bold,
                        ),
                      ),

                      const Spacer(),

                      const Icon(
                        Icons.arrow_forward,
                        color:
                            AppColors.primary,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}