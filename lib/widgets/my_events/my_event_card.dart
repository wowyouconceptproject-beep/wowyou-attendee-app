import "package:flutter/material.dart";
import "package:intl/intl.dart";

import "../../models/purchased_ticket.dart";
import "package:attendee_app/theme/app_colors.dart";

class MyEventCard extends StatelessWidget {
  final PurchasedTicket ticket;

  final VoidCallback onOpen;

  const MyEventCard({
    super.key,
    required this.ticket,
    required this.onOpen,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        left: 24,
        right: 24,
        bottom: 20,
      ),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(
          28,
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
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              ticket.coverImage ?? "",
              fit: BoxFit.cover,
              errorBuilder: (
                context,
                error,
                stackTrace,
              ) {
                return Container(
                  color: AppColors.surface,
                  child: const Center(
                    child: Icon(
                      Icons.image,
                      color:
                          AppColors
                              .textSecondary,
                      size: 60,
                    ),
                  ),
                );
              },
            ),
          ),

          Padding(
            padding:
                const EdgeInsets.all(
              22,
            ),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment
                      .start,
              children: [
                Text(
                  ticket.eventTitle,
                  style:
                      const TextStyle(
                    color:
                        AppColors.text,
                    fontSize: 24,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),

                const SizedBox(
                  height: 18,
                ),

                Row(
                  children: [
                    const Icon(
                      Icons.location_on,
                      size: 18,
                      color:
                          AppColors
                              .primary,
                    ),

                    const SizedBox(
                      width: 8,
                    ),

                    Expanded(
                      child: Text(
                        ticket.venue,
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
                  height: 10,
                ),

                Row(
                  children: [
                    const Icon(
                      Icons.calendar_today,
                      size: 18,
                      color:
                          AppColors
                              .primary,
                    ),

                    const SizedBox(
                      width: 8,
                    ),

                    Expanded(
                      child: Text(
                        DateFormat(
                          "EEE, d MMM yyyy",
                        ).format(
                          ticket.startDate,
                        ),
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
                  height: 24,
                ),

                SizedBox(
                  width:
                      double.infinity,
                  child:
                      ElevatedButton(
                    onPressed:
                        onOpen,
                    style:
                        ElevatedButton.styleFrom(
                      backgroundColor:
                          AppColors
                              .primary,
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
                          18,
                        ),
                      ),
                    ),
                    child:
                        const Text(
                      "Open Event Hub",
                      style:
                          TextStyle(
                        fontWeight:
                            FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}